-- shared/logger.lua
-- Logger class definition and logger service.

---@class Logger
local Logger = {}
Logger.__index = Logger

function Logger:new()
	return setmetatable({}, Logger)
end

---@param msg string
---@param type string|nil
function Logger:log(msg, type)
	-- print(message)
	os.execute('notify-send "[DEBUG] ' .. msg .. '"')
	if type == "error" then
		error(msg)
	end
end

function Logger:error(msg)
	os.execute('notify-send "[ERROR] ' .. msg .. '"')
	error(msg)
end

local default_logger = Logger:new()
local logger_single = nil

-- return mod
---@class logger_mod
---@field LoggerClass Logger the class of logger, you can extends if you want.
---@field set_logger fun(logger: Logger):Logger set the single logger instance.
---@field get_logger fun():Logger get the single logger instance.
local M = {}
M.LoggerClass = Logger

M.set_logger = function(logger)
	logger_single = logger
	return logger_single
end

M.get_logger = function()
	logger_single = logger_single or default_logger
	return logger_single
end

return M
