--[[
	Maid - автоматическая очистка ресурсов
	Очень полезный модуль, который есть почти в каждой серьёзной игре
]]

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid:GiveTask(task)
	local n = #self._tasks + 1
	self._tasks[n] = task
	return function()
		self._tasks[n] = nil
	end
end

function Maid:DoCleaning()
	local tasks = self._tasks
	self._tasks = {}

	for _, task in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif typeof(task) == "Instance" then
			task:Destroy()
		elseif type(task) == "function" then
			task()
		elseif type(task) == "table" and task.Destroy then
			task:Destroy()
		end
	end
end

Maid.Destroy = Maid.DoCleaning

return Maid
