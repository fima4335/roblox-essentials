--[[
	DataStore - надёжный wrapper для DataStoreService
	С кэшем, повторными попытками и защитой от ошибок
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DataStore = {}
DataStore.__index = DataStore

local DEFAULT_RETRIES = 3
local RETRY_DELAY = 1

function DataStore.new(name, scope)
	local self = setmetatable({
		_store = DataStoreService:GetDataStore(name, scope),
		_cache = {},
		_name = name,
	}, DataStore)
	return self
end

local function retry(fn, retries)
	retries = retries or DEFAULT_RETRIES
	local lastError
	for i = 1, retries do
		local ok, result = pcall(fn)
		if ok then
			return true, result
		end
		lastError = result
		if i < retries then
			task.wait(RETRY_DELAY * i)
		end
	end
	return false, lastError
end

function DataStore:Get(key, defaultValue)
	if self._cache[key] ~= nil then
		return self._cache[key]
	end

	local success, result = retry(function()
		return self._store:GetAsync(key)
	end)

	if success then
		local value = result
		if value == nil then
			value = defaultValue
		end
		self._cache[key] = value
		return value
	else
		warn("[DataStore] Get failed for key", key, ":", result)
		return defaultValue
	end
end

function DataStore:Set(key, value)
	local success, err = retry(function()
		self._store:SetAsync(key, value)
	end)

	if success then
		self._cache[key] = value
		return true
	else
		warn("[DataStore] Set failed for key", key, ":", err)
		return false
	end
end

function DataStore:Update(key, transformFunction)
	local success, result = retry(function()
		return self._store:UpdateAsync(key, transformFunction)
	end)

	if success then
		self._cache[key] = result
		return true, result
	else
		warn("[DataStore] Update failed for key", key, ":", result)
		return false, result
	end
end

function DataStore:Remove(key)
	local success, err = retry(function()
		self._store:RemoveAsync(key)
	end)

	if success then
		self._cache[key] = nil
		return true
	else
		warn("[DataStore] Remove failed for key", key, ":", err)
		return false
	end
end

function DataStore:GetCached(key)
	return self._cache[key]
end

function DataStore:ClearCache()
	table.clear(self._cache)
end

-- Удобный хелпер для данных игрока
function DataStore:GetPlayerData(player, defaultData)
	local key = "Player_" .. player.UserId
	return self:Get(key, defaultData or {})
end

function DataStore:SavePlayerData(player, data)
	local key = "Player_" .. player.UserId
	return self:Set(key, data)
end

return DataStore
