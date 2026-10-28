--[[
	NumberFormat - красивое форматирование больших чисел
	1.5K, 2.3M, 4.7B, 1.2T и т.д.
]]

local suffixes = {"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc"}

local function NumberFormat(number, precision)
	precision = precision or 1
	if type(number) ~= "number" then
		return tostring(number)
	end

	local abs = math.abs(number)
	if abs < 1000 then
		return string.format("%d", number)
	end

	local exp = math.floor(math.log10(abs) / 3)
	exp = math.min(exp, #suffixes - 1)

	local scaled = number / (10 ^ (exp * 3))
	local formatStr = "%." .. precision .. "f%s"
	return string.format(formatStr, scaled, suffixes[exp + 1])
end

return NumberFormat
