--[[
	Notifications - красивые уведомления игрокам
	Работает на клиенте. Можно вызывать с сервера через RemoteEvent.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local Notifications = {}

local function createNotificationGui()
	local player = Players.LocalPlayer
	if not player then return end

	local gui = Instance.new("ScreenGui")
	gui.Name = "EssentialsNotifications"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 320, 1, 0)
	container.Position = UDim2.new(1, -340, 0, 20)
	container.BackgroundTransparency = 1
	container.Parent = gui

	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 8)
	list.VerticalAlignment = Enum.VerticalAlignment.Top
	list.Parent = container

	return container
end

local container

local function ensureContainer()
	if not container or not container.Parent then
		container = createNotificationGui()
	end
	return container
end

local function show(text, color, duration)
	duration = duration or 4
	color = color or Color3.fromRGB(40, 40, 45)

	local cont = ensureContainer()
	if not cont then return end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.BackgroundColor3 = color
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = cont

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 14)
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 16
	label.Font = Enum.Font.GothamMedium
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	frame.Size = UDim2.new(1, 0, 0, label.TextBounds.Y + 24)

	-- Анимация появления
	frame.Position = UDim2.new(1, 0, 0, 0)
	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
		Position = UDim2.new(0, 0, 0, 0)
	})
	tweenIn:Play()

	task.delay(duration, function()
		local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
			Position = UDim2.new(1, 20, 0, 0),
			BackgroundTransparency = 1
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		frame:Destroy()
	end)
end

function Notifications.Notify(playerOrText, text, color)
	-- Если вызвали с сервера — нужен RemoteEvent (пользователь сам добавит)
	-- Здесь клиентская версия
	if typeof(playerOrText) == "Instance" and playerOrText:IsA("Player") then
		-- Серверный вызов — просто игнорируем или предупреждаем
		warn("[Notifications] Для серверных уведомлений создай RemoteEvent и вызывай с клиента")
		return
	end

	show(playerOrText, text, color)
end

function Notifications.Success(text)
	show(text, Color3.fromRGB(30, 140, 70))
end

function Notifications.Error(text)
	show(text, Color3.fromRGB(180, 40, 40))
end

function Notifications.Info(text)
	show(text, Color3.fromRGB(40, 100, 180))
end

function Notifications.Warning(text)
	show(text, Color3.fromRGB(180, 120, 30))
end

return Notifications
