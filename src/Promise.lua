--[[
	Promise - простая реализация Promise для асинхронного кода
	Облегчённая версия для повседневного использования
]]

local Promise = {}
Promise.__index = Promise

local STATUS = {
	Pending = "Pending",
	Resolved = "Resolved",
	Rejected = "Rejected",
}

function Promise.new(executor)
	local self = setmetatable({
		_status = STATUS.Pending,
		_value = nil,
		_waiting = {},
	}, Promise)

	local function resolve(...)
		if self._status ~= STATUS.Pending then return end
		self._status = STATUS.Resolved
		self._value = {...}
		for _, thread in ipairs(self._waiting) do
			task.spawn(thread, true, ...)
		end
		self._waiting = {}
	end

	local function reject(err)
		if self._status ~= STATUS.Pending then return end
		self._status = STATUS.Rejected
		self._value = err
		for _, thread in ipairs(self._waiting) do
			task.spawn(thread, false, err)
		end
		self._waiting = {}
	end

	task.spawn(function()
		local ok, err = pcall(executor, resolve, reject)
		if not ok then
			reject(err)
		end
	end)

	return self
end

function Promise:andThen(onResolved, onRejected)
	return Promise.new(function(resolve, reject)
		local function handle(success, ...)
			if success then
				if onResolved then
					local ok, result = pcall(onResolved, ...)
					if ok then
						resolve(result)
					else
						reject(result)
					end
				else
					resolve(...)
				end
			else
				if onRejected then
					local ok, result = pcall(onRejected, ...)
					if ok then
						resolve(result)
					else
						reject(result)
					end
				else
					reject(...)
				end
			end
		end

		if self._status == STATUS.Pending then
			table.insert(self._waiting, handle)
		else
			task.spawn(handle, self._status == STATUS.Resolved, table.unpack(self._value or {}))
		end
	end)
end

function Promise:catch(onRejected)
	return self:andThen(nil, onRejected)
end

function Promise:await()
	if self._status == STATUS.Resolved then
		return table.unpack(self._value)
	elseif self._status == STATUS.Rejected then
		error(self._value)
	end

	local thread = coroutine.running()
	table.insert(self._waiting, function(success, ...)
		if success then
			task.spawn(thread, ...)
		else
			task.spawn(function()
				error(...)
			end)
		end
	end)
	return coroutine.yield()
end

function Promise.resolve(...)
	return Promise.new(function(resolve)
		resolve(...)
	end)
end

function Promise.reject(err)
	return Promise.new(function(_, reject)
		reject(err)
	end)
end

function Promise.all(promises)
	return Promise.new(function(resolve, reject)
		local results = {}
		local remaining = #promises

		if remaining == 0 then
			resolve(results)
			return
		end

		for i, p in ipairs(promises) do
			p:andThen(function(...)
				results[i] = {...}
				remaining -= 1
				if remaining == 0 then
					resolve(results)
				end
			end, reject)
		end
	end)
end

return Promise
