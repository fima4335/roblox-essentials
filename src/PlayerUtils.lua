--[[
	PlayerUtils - полезные функции для работы с игроками
]]

local Players = game:GetService("Players")

local PlayerUtils = {}

function PlayerUtils.GetCharacter(player)
	return player and player.Character
end

function PlayerUtils.GetHumanoid(player)
	local char = PlayerUtils.GetCharacter(player)
	return char and char:FindFirstChildOfClass("Humanoid")
end

function PlayerUtils.GetRootPart(player)
	local char = PlayerUtils.GetCharacter(player)
	return char and char:FindFirstChild("HumanoidRootPart")
end

function PlayerUtils.IsAlive(player)
	local humanoid = PlayerUtils.GetHumanoid(player)
	return humanoid and humanoid.Health > 0
end

function PlayerUtils.Teleport(player, positionOrCFrame)
	local root = PlayerUtils.GetRootPart(player)
	if not root then return false end

	if typeof(positionOrCFrame) == "CFrame" then
		root.CFrame = positionOrCFrame
	else
		root.CFrame = CFrame.new(positionOrCFrame)
	end
	return true
end

function PlayerUtils.Heal(player, amount)
	local humanoid = PlayerUtils.GetHumanoid(player)
	if not humanoid then return false end
	humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + (amount or humanoid.MaxHealth))
	return true
end

function PlayerUtils.Damage(player, amount)
	local humanoid = PlayerUtils.GetHumanoid(player)
	if not humanoid then return false end
	humanoid:TakeDamage(amount or 10)
	return true
end

function PlayerUtils.SetSpeed(player, speed)
	local humanoid = PlayerUtils.GetHumanoid(player)
	if not humanoid then return false end
	humanoid.WalkSpeed = speed or 16
	return true
end

function PlayerUtils.SetJumpPower(player, power)
	local humanoid = PlayerUtils.GetHumanoid(player)
	if not humanoid then return false end
	humanoid.JumpPower = power or 50
	return true
end

function PlayerUtils.GetPlayersInRadius(position, radius, ignorePlayer)
	local result = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= ignorePlayer then
			local root = PlayerUtils.GetRootPart(player)
			if root and (root.Position - position).Magnitude <= radius then
				table.insert(result, player)
			end
		end
	end
	return result
end

function PlayerUtils.FindByName(name, partial)
	name = string.lower(name)
	for _, player in ipairs(Players:GetPlayers()) do
		local pname = string.lower(player.Name)
		if partial then
			if string.find(pname, name, 1, true) then
				return player
			end
		else
			if pname == name then
				return player
			end
		end
	end
	return nil
end

return PlayerUtils
