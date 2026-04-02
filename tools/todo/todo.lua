local M = {}

-- Utility to get absolute path to current directory
local function get_script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)") or "./"
end

local BASE_PATH = get_script_path()
local DATA_PATH = BASE_PATH .. "data/"
local TODAY_FILE = DATA_PATH .. "today.md"
local ARCHIVE_PATH = DATA_PATH .. "archive/"
local STATE_FILE = DATA_PATH .. "state.lua"

local function get_date(format)
  return os.date(format or "%Y-%m-%d")
end

local function load_state()
  local f = loadfile(STATE_FILE)
  if f then
    return f()
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

function M.ls()
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

function M.done(id)
  id = tonumber(id)
  if not id then
    print("Usage: todo done <task_id>")
    return
  end

  local lines = read_file(TODAY_FILE)
  if id < 1 or id > #lines then
    print("Invalid task ID!")
    return
  end

  local task_line = table.remove(lines, id)
  write_file(TODAY_FILE, lines)

  -- Prepare archive entry
  local current_month = get_date("%Y-%m")
  local completed_date = get_date()
  local archive_file = ARCHIVE_PATH .. current_month .. ".md"

  -- Update [ ] to [x] and add completed date
  task_line = task_line:gsub("%[ %]", "[x]")
  task_line = task_line .. string.format(" (completed: %s)", completed_date)

  local f = io.open(archive_file, "a")
  if f then
    f:write(task_line .. "\n")
    f:close()
    print("Completed and archived: " .. task_line)
  end
end

function M.sync()
  local state = load_state()
  local today = get_date()

  if state.last_run_date ~= today then
    -- Check for old tasks in today.md
    local lines = read_file(TODAY_FILE)
    local has_old_tasks = false
    for _, line in ipairs(lines) do
      if not line:find(today) then
        has_old_tasks = true
        break
      end
    end

    if has_old_tasks then
      print("Found tasks from previous days. Carrying them over to today...")
      -- Optionally: Prompt user or just update state
      -- For now, we update state to today.
    end
    state.last_run_date = today
    save_state(state)
  end
end

-- CLI Entry Point
local args = {...}
local command = table.remove(args, 1)

M.sync() -- Always sync on start

if command == "add" then
  M.add(table.concat(args, " "))
elseif command == "ls" then
  M.ls()
elseif command == "done" then
  M.done(args[1])
else
  print("Available commands: add, ls, done")
end

return M
