--[[
	TableUtils - полезные функции для работы с таблицами
]]

local TableUtils = {}

function TableUtils.DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			copy[k] = TableUtils.DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function TableUtils.Merge(t1, t2)
	local result = TableUtils.DeepCopy(t1)
	for k, v in pairs(t2) do
		if type(v) == "table" and type(result[k]) == "table" then
			result[k] = TableUtils.Merge(result[k], v)
		else
			result[k] = v
		end
	end
	return result
end

function TableUtils.Find(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

function TableUtils.Contains(tbl, value)
	return TableUtils.Find(tbl, value) ~= nil
end

function TableUtils.Shuffle(tbl)
	local result = TableUtils.DeepCopy(tbl)
	for i = #result, 2, -1 do
		local j = math.random(i)
		result[i], result[j] = result[j], result[i]
	end
	return result
end

function TableUtils.Keys(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	return keys
end

function TableUtils.Values(tbl)
	local values = {}
	for _, v in pairs(tbl) do
		table.insert(values, v)
	end
	return values
end

function TableUtils.Count(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count += 1
	end
	return count
end

function TableUtils.IsEmpty(tbl)
	return next(tbl) == nil
end

return TableUtils
