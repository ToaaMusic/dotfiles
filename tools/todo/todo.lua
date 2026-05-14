local M = {}

--paths
local home = os.getenv("HOME")
local DATA_PATH = home .. "/.local/share/toaam-dotfiles/todo/"
local TODAY_FILE = DATA_PATH .. "today.md"
local ARCHIVE_PATH = DATA_PATH .. "archive/"
local STATE_FILE = DATA_PATH .. "state.lua"

-- helpers

local function ensure_dir(path)
  os.execute(string.format('mkdir -p "%s"', path))
end

local function get_date(format)
  return os.date(format or "%Y-%m-%d")
end

local function load_state()
  local f = loadfile(STATE_FILE)
  if f then
    local s = f()
    if s then return s end
  end
  return { last_run_date = "1970-01-01" }
end

local function save_state(state)
  local f = io.open(STATE_FILE, "w")
  if f then
    f:write("return {\n")
    f:write(string.format('  last_run_date = "%s"\n', state.last_run_date))
    f:write("}\n")
    f:close()
  end
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return {} end
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end

local function write_file(path, lines)
  local f = io.open(path, "w")
  if f then
    for _, line in ipairs(lines) do
      f:write(line .. "\n")
    end
    f:close()
  end
end

-- commands

function M.add(task)
  if not task or task == "" then
    print("Usage: todo add <task description>")
    return
  end
  local date = get_date()
  local line = string.format("- [ ] %s (created: %s)", task, date)
  local f = io.open(TODAY_FILE, "a")
  if f then
    f:write(line .. "\n")
    f:close()
    print("Added: " .. task)
  end
end

function M.ls(filter)
  if filter == "done" then
    local any = false

    -- today
    local lines = read_file(TODAY_FILE)
    local today_printed = false
    for _, line in ipairs(lines) do
      if line:find("%[x%]") then
        if not today_printed then
          print("=== Today ===")
          today_printed = true
          any = true
        end
        print(line)
      end
    end

    -- archive months, newest first
    local months = {}
    local f = io.popen(string.format('ls -1 "%s" 2>/dev/null', ARCHIVE_PATH))
    if f then
      for file in f:lines() do
        if file:match("%.md$") then
          months[#months + 1] = file:gsub("%.md$", "")
        end
      end
      f:close()
    end
    table.sort(months, function(a, b) return a > b end)

    for _, month in ipairs(months) do
      local archive_file = ARCHIVE_PATH .. month .. ".md"
      local archive_lines = read_file(archive_file)
      local first = true
      for _, line in ipairs(archive_lines) do
        if line:find("%[x%]") then
          if first then
            print(string.format("\n=== %s ===", month))
            first = false
          end
          print(line)
          any = true
        end
      end
    end

    if not any then
      print("No completed tasks found.")
    end
    return
  end

  local lines = read_file(TODAY_FILE)
  if #lines == 0 then
    print("No tasks for today!")
    return
  end
  print("Today's Tasks:")
  for i, line in ipairs(lines) do
    print(string.format("[%d] %s", i, line))
  end
end

function M.done(id, percentage)
  id = tonumber(id)
  local lines = read_file(TODAY_FILE)
  if not id or id < 1 or id > #lines then
    print("Invalid task ID!")
    return
  end

  local line = lines[id]
  if line:find("%[x%]") then
    print("Task already marked as done.")
    return
  end
  -- 处理完成度参数
  local completion_text = ""
  if percentage then
    -- 确保是数字且在 0-100 范围内
    percentage = tonumber(percentage)
    if percentage and percentage >= 0 and percentage <= 100 then
      completion_text = string.format(" (completion: %d%%)", percentage)
    else
      print("Warning: Invalid percentage, using 100%")
      completion_text = " (completion: 100%)"
    end
  end

  lines[id] = line:gsub("%[ %]", "[x]") ..
              string.format(" (completed: %s)", get_date()) ..
              completion_text
  write_file(TODAY_FILE, lines)
  print("Marked as done: " .. lines[id])
end

function M.rm(id)
  id = tonumber(id)
  local lines = read_file(TODAY_FILE)
  if not id or id < 1 or id > #lines then
    print("Invalid task ID!")
    return
  end

  local removed = table.remove(lines, id)
  write_file(TODAY_FILE, lines)
  print("Deleted: " .. removed)
end

function M.archive()
  local lines = read_file(TODAY_FILE)
  local today_remaining = {}
  local archived_count = 0
  local current_month = get_date("%Y-%m")
  local archive_file = ARCHIVE_PATH .. current_month .. ".md"

  local f_archive = io.open(archive_file, "a")

  for _, line in ipairs(lines) do
    if line:find("%[x%]") then
      if f_archive then
        f_archive:write(line .. "\n")
        archived_count = archived_count + 1
      end
    else
      table.insert(today_remaining, line)
    end
  end

  if f_archive then f_archive:close() end
  write_file(TODAY_FILE, today_remaining)
  print(string.format("Archived %d completed tasks to %s.", archived_count, archive_file))
end

function M.sync()
  local state = load_state()
  local today = get_date()

  if state.last_run_date ~= today then
    local lines = read_file(TODAY_FILE)
    if #lines > 0 then
      print("\n--- New Day Detected! ---")
      local completed = {}
      local pending = {}

      for _, line in ipairs(lines) do
        if line:find("%[x%]") then
          table.insert(completed, line)
        else
          table.insert(pending, line)
        end
      end

      -- 1. Handle Pending Tasks (Carry Over)
      if #pending > 0 then
        print(string.format("Found %d pending tasks from yesterday. They are automatically carried over.", #pending))
        -- Update the 'created' date if you want, or just keep it.
        -- We'll keep them as they are to show when they were originally created.
      end

      -- 2. Handle Completed Tasks (Ask to Archive)
      if #completed > 0 then
        print(string.format("\nFound %d completed tasks from yesterday:", #completed))
        for _, line in ipairs(completed) do
          print("  " .. line)
        end
        io.write("\nArchive these completed tasks now? [Y/n]: ")
        local answer = io.read()
        if answer == "" or answer:lower() == "y" then
          M.archive()
        else
          print("Skipping archival. They will remain in today.md.")
        end
      end
      print("--------------------------\n")
    end

    state.last_run_date = today
    save_state(state)
  end
end

-- entry

local args = {...}
local command = table.remove(args, 1)

ensure_dir(DATA_PATH)
ensure_dir(ARCHIVE_PATH)

M.sync()

if command == "add" then
  M.add(table.concat(args, " "))
elseif command == "ls" then
  M.ls(args[1])
elseif command == "done" then
  M.done(args[1], args[2])
elseif command == "rm" then
  M.rm(args[1])
elseif command == "arch" then
  M.archive()
else
  print("Available commands: add, ls, done, rm, arch\n\nIf you mean ls: \n")
  M.ls()
end

return M
