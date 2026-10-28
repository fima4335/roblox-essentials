--[[
	Signal - лёгкие и быстрые события
	Лучше чем BindableEvent по производительности и удобству
]]

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_bindings = {},
		_bindingCount = 0
	}, Signal)
end

function Signal:Connect(func)
	local id = self._bindingCount + 1
	self._bindingCount = id
	self._bindings[id] = func

	return {
		Disconnect = function()
			self._bindings[id] = nil
		end
	}
end

function Signal:Fire(...)
	for _, func in pairs(self._bindings) do
		task.spawn(func, ...)
	end
end

function Signal:Wait()
	local thread = coroutine.running()
	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		task.spawn(thread, ...)
	end)
	return coroutine.yield()
end

function Signal:Destroy()
	self._bindings = {}
end

return Signal
