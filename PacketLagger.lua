local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local settings = {
    enabled = false,
    power = 100,
}

local originalStates = {}

local function clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value))
end

local function createRounded(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function applyPacketLagger()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if settings.enabled then
        if humanoid then
            local speedBoost = 1 + (settings.power / 100)
            humanoid.WalkSpeed = clamp((humanoid.WalkSpeed or 16) * speedBoost, 16, 500)
        end

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local otherChar = otherPlayer.Character
                if otherChar then
                    local otherHum = otherChar:FindFirstChildOfClass("Humanoid")
                    if otherHum then
                        local key = otherPlayer.UserId
                        if originalStates[key] == nil then
                            originalStates[key] = {
                                walkSpeed = otherHum.WalkSpeed,
                                jumpPower = otherHum.JumpPower,
                            }
                        end

                        local reduction = 1 - (settings.power / 200)
                        local newSpeed = math.max(16, (originalStates[key].walkSpeed or 16) * reduction)
                        local newJump = math.max(25, (originalStates[key].jumpPower or 50) * (1 - settings.power / 300))

                        otherHum.WalkSpeed = newSpeed
                        otherHum.JumpPower = newJump
                    end
                end
            end
        end
    else
        if humanoid then
            humanoid.WalkSpeed = clamp(humanoid.WalkSpeed or 16, 16, 500)
        end

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local key = otherPlayer.UserId
                local saved = originalStates[key]
                if saved then
                    local otherChar = otherPlayer.Character
                    if otherChar then
                        local otherHum = otherChar:FindFirstChildOfClass("Humanoid")
                        if otherHum then
                            otherHum.WalkSpeed = saved.walkSpeed
                            otherHum.JumpPower = saved.jumpPower
                        end
                    end
                    originalStates[key] = nil
                end
            end
        end
    end
end

local function buildUi()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PacketLaggerGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 280, 0, 160)
    main.Position = UDim2.new(0.5, -140, 0.5, -80)
    main.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
    main.BorderSizePixel = 0
    main.Parent = screenGui
    createRounded(main, 18)

    local shadow = Instance.new("Frame")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    shadow.Size = UDim2.new(1, 18, 1, 18)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.45
    shadow.BorderSizePixel = 0
    shadow.Parent = main
    createRounded(shadow, 18)
    shadow.ZIndex = 0
    main.ZIndex = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 28)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = "PACKET LAGGER"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = main

    local powerLabel = Instance.new("TextLabel")
    powerLabel.Size = UDim2.new(0, 80, 0, 20)
    powerLabel.Position = UDim2.new(0, 16, 0, 52)
    powerLabel.Text = "Power"
    powerLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    powerLabel.Font = Enum.Font.GothamSemibold
    powerLabel.TextSize = 14
    powerLabel.BackgroundTransparency = 1
    powerLabel.Parent = main

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 120, 0, 28)
    input.Position = UDim2.new(1, -136, 0, 48)
    input.Text = tostring(settings.power)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderColor3 = Color3.fromRGB(180, 180, 220)
    input.BackgroundColor3 = Color3.fromRGB(36, 42, 57)
    input.BorderSizePixel = 0
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = main
    createRounded(input, 10)

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 170, 0, 38)
    toggle.Position = UDim2.new(0.5, -85, 1, -54)
    toggle.Text = "OFF"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 16
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.AutoButtonColor = false
    toggle.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
    toggle.Parent = main
    createRounded(toggle, 12)

    local function updateToggleVisual()
        toggle.Text = settings.enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = settings.enabled and Color3.fromRGB(88, 255, 145) or Color3.fromRGB(255, 90, 90)
    end

    input.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            return
        end

        local value = tonumber(input.Text)
        if value == nil then
            input.Text = tostring(settings.power)
            return
        end

        settings.power = clamp(value, 0, 500)
        input.Text = tostring(settings.power)
        applyPacketLagger()
    end)

    toggle.MouseButton1Click:Connect(function()
        settings.enabled = not settings.enabled
        updateToggleVisual()
        applyPacketLagger()
    end)

    updateToggleVisual()
    return screenGui
end

local gui = buildUi()

player.CharacterAdded:Connect(function()
    task.wait(0.2)
    applyPacketLagger()
end)

Players.PlayerAdded:Connect(function(otherPlayer)
    if settings.enabled then
        task.wait(0.2)
        applyPacketLagger()
    end
end)

RunService.Heartbeat:Connect(function()
    if settings.enabled then
        applyPacketLagger()
    end
end)

return gui
