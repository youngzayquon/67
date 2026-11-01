local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local configKey = "youngzayquon_67_gui_config"

local defaultSettings = {
    autoLeft = false,
    autoRight = false,
    tpDown = false,
    batAimbot = false,
    batTp = false,
    batCounter = false,
    batMedCounter = false,
    carrySpeed = 100,
    normalSpeed = 100,
    laggerSpeed = 120,
    laggerCarry = 80,
    dropBrainrot = false,
    instantReset = false,
    antiKick = false,
    antiSummerBase = false,
    antiLag = false,
    unwalk = false,
    vampire = false,
    zombie = false,
    amazon = false,
    safeMode = false,
    autoCarry = false,
    autoTurn = false,
    antiDie = false,
    autoResetOnDeath = false,
    autoSwing = false,
    medReset = false,
    enemyBaseRange = 0,
    carryMode = "auto",
    customBackground = "galaxy",
    mobileButtons = true,
    buttonSize = 42,
    uiScale = 1,
    theme = "galaxy",
    customFont = "Gotham",
    shape = "normal",
    mobileButtonPosX = 20,
    mobileButtonPosY = 120,
    textScale = 0.9,
    keybinds = {},
}

local settings = {}
for key, value in pairs(defaultSettings) do
    settings[key] = value
end

local function clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value))
end

local function saveConfig()
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(settings)
    end)

    if ok then
        player:SetAttribute(configKey, encoded)
    end
end

local function loadConfig()
    local savedData = player:GetAttribute(configKey)
    if typeof(savedData) == "string" then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(savedData)
        end)

        if ok and type(decoded) == "table" then
            for key, value in pairs(defaultSettings) do
                if decoded[key] ~= nil then
                    settings[key] = decoded[key]
                end
            end
        end
    end
end

local function setTheme(themeName)
    settings.theme = themeName

    local palettes = {
        sky = {
            bg = Color3.fromRGB(10, 20, 38),
            panel = Color3.fromRGB(22, 35, 58),
            accent = Color3.fromRGB(82, 190, 255),
            text = Color3.fromRGB(236, 244, 255),
            button = Color3.fromRGB(44, 66, 95),
            on = Color3.fromRGB(86, 255, 150),
            off = Color3.fromRGB(255, 90, 90),
        },
        galaxy = {
            bg = Color3.fromRGB(12, 10, 26),
            panel = Color3.fromRGB(22, 19, 42),
            accent = Color3.fromRGB(145, 80, 255),
            text = Color3.fromRGB(245, 239, 255),
            button = Color3.fromRGB(48, 38, 74),
            on = Color3.fromRGB(84, 255, 177),
            off = Color3.fromRGB(255, 104, 104),
        },
        cyber = {
            bg = Color3.fromRGB(12, 12, 14),
            panel = Color3.fromRGB(18, 22, 26),
            accent = Color3.fromRGB(34, 255, 220),
            text = Color3.fromRGB(225, 250, 255),
            button = Color3.fromRGB(28, 36, 40),
            on = Color3.fromRGB(100, 255, 145),
            off = Color3.fromRGB(255, 110, 110),
        },
        sakura = {
            bg = Color3.fromRGB(38, 19, 31),
            panel = Color3.fromRGB(59, 29, 46),
            accent = Color3.fromRGB(255, 148, 201),
            text = Color3.fromRGB(255, 242, 248),
            button = Color3.fromRGB(79, 40, 62),
            on = Color3.fromRGB(120, 255, 187),
            off = Color3.fromRGB(255, 116, 138),
        },
        night = {
            bg = Color3.fromRGB(18, 18, 24),
            panel = Color3.fromRGB(29, 31, 41),
            accent = Color3.fromRGB(118, 134, 255),
            text = Color3.fromRGB(243, 246, 255),
            button = Color3.fromRGB(42, 46, 62),
            on = Color3.fromRGB(112, 255, 160),
            off = Color3.fromRGB(255, 129, 129),
        },
        blood = {
            bg = Color3.fromRGB(24, 8, 10),
            panel = Color3.fromRGB(42, 12, 16),
            accent = Color3.fromRGB(255, 61, 61),
            text = Color3.fromRGB(255, 235, 235),
            button = Color3.fromRGB(61, 17, 21),
            on = Color3.fromRGB(110, 255, 170),
            off = Color3.fromRGB(255, 98, 98),
        },
    }

    local palette = palettes[themeName] or palettes.galaxy
    if _G.CupcakeGui then
        _G.CupcakeGui.palette = palette
    end
end

local function makeRounded(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function makeShadow(parent, color, transparency, size)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, size)
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.BackgroundColor3 = color
    shadow.BorderSizePixel = 0
    shadow.BackgroundTransparency = transparency
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    makeRounded(shadow, 18)
end

local function createToggle(parent, labelText, settingName)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 34)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 90, 0, 22)
    toggle.Position = UDim2.new(1, -90, 0.5, -11)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 11
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.AutoButtonColor = false
    toggle.BackgroundColor3 = settings[settingName] and Color3.fromRGB(90, 255, 140) or Color3.fromRGB(255, 85, 85)
    toggle.Text = settings[settingName] and "ON" or "OFF"
    toggle.Parent = row
    makeRounded(toggle, 8)

    toggle.MouseButton1Click:Connect(function()
        settings[settingName] = not settings[settingName]
        toggle.Text = settings[settingName] and "ON" or "OFF"
        toggle.BackgroundColor3 = settings[settingName] and Color3.fromRGB(90, 255, 140) or Color3.fromRGB(255, 85, 85)
        saveConfig()
    end)

    return row
end

local function createNumberInput(parent, labelText, settingName, minValue, maxValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 36)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 120, 0, 26)
    box.Position = UDim2.new(1, -120, 0.5, -13)
    box.Text = tostring(settings[settingName])
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(180, 180, 220)
    box.BackgroundColor3 = Color3.fromRGB(32, 40, 60)
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.Parent = row
    makeRounded(box, 8)

    box.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            return
        end

        local value = tonumber(box.Text)
        if value == nil then
            box.Text = tostring(settings[settingName])
            return
        end

        value = clamp(value, minValue, maxValue)
        settings[settingName] = value
        box.Text = tostring(value)
        saveConfig()
    end)

    return row
end

local function createActionButton(parent, text, callback, size)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, size or settings.buttonSize, 0, size or settings.buttonSize)
    btn.Text = text
    btn.TextWrapped = true
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(64, 92, 150)
    btn.AutoButtonColor = false
    btn.Parent = parent
    makeRounded(btn, 10)

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return btn
end

local function createThemeButton(parent, labelName, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 78, 0, 28)
    button.Text = labelName
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(70, 82, 110)
    button.AutoButtonColor = false
    button.Parent = parent
    makeRounded(button, 8)

    button.MouseButton1Click:Connect(function()
        callback(labelName)
    end)

    return button
end

local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CupcakeDuelsGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    _G.CupcakeGui = {
        palette = {
            bg = Color3.fromRGB(12, 10, 26),
            panel = Color3.fromRGB(22, 19, 42),
            accent = Color3.fromRGB(145, 80, 255),
            text = Color3.fromRGB(245, 239, 255),
            button = Color3.fromRGB(48, 38, 74),
            on = Color3.fromRGB(84, 255, 177),
            off = Color3.fromRGB(255, 104, 104),
        }
    }

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 700, 0, 510)
    mainFrame.BackgroundColor3 = Color3.fromRGB(17, 20, 34)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    makeRounded(mainFrame, 18)
    makeShadow(mainFrame, Color3.fromRGB(0, 0, 0), 0.4, 10)

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -20, 0, 40)
    tabBar.Position = UDim2.new(0, 10, 0, 46)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = mainFrame

    local dragRegion = Instance.new("Frame")
    dragRegion.Size = UDim2.new(1, 0, 0, 42)
    dragRegion.BackgroundColor3 = Color3.fromRGB(25, 28, 46)
    dragRegion.BorderSizePixel = 0
    dragRegion.Parent = mainFrame
    makeRounded(dragRegion, 18)

    local title = Instance.new("TextLabel")
    title.Text = "CUPCAKE DUELS GUI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 18, 0, 0)
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = dragRegion

    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 15
    closeBtn.Parent = dragRegion
    makeRounded(closeBtn, 10)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -96)
    content.Position = UDim2.new(0, 10, 0, 86)
    content.BackgroundColor3 = Color3.fromRGB(22, 25, 38)
    content.BorderSizePixel = 0
    content.Parent = mainFrame
    makeRounded(content, 14)

    local pageNames = {"Main", "Combat", "Visuals", "Mobile", "Config"}
    local tabButtons = {}
    local pages = {}
    local activePage = "Main"

    local function addPage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 5
        page.Visible = false
        page.Parent = content

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = page

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = page

        pages[name] = page
        return page
    end

    local function setActivePage(name)
        activePage = name
        for pageName, page in pairs(pages) do
            page.Visible = (pageName == name)
        end

        for _, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = (btn.Text == name) and Color3.fromRGB(100, 120, 230) or Color3.fromRGB(40, 46, 65)
        end
    end

    for _, name in ipairs(pageNames) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 104, 1, 0)
        button.Text = name
        button.Font = Enum.Font.GothamBold
        button.TextSize = 12
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundColor3 = Color3.fromRGB(40, 46, 65)
        button.AutoButtonColor = false
        button.Parent = tabBar
        makeRounded(button, 10)

        button.MouseButton1Click:Connect(function()
            setActivePage(name)
        end)

        table.insert(tabButtons, button)
    end

    local mainPage = addPage("Main")
    local combatPage = addPage("Combat")
    local visualsPage = addPage("Visuals")
    local mobilePage = addPage("Mobile")
    local configPage = addPage("Config")

    local function addSection(page, titleText)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, -8, 0, 42)
        section.BackgroundColor3 = Color3.fromRGB(34, 39, 58)
        section.BorderSizePixel = 0
        section.Parent = page
        makeRounded(section, 10)

        local label = Instance.new("TextLabel")
        label.Text = titleText
        label.Size = UDim2.new(1, -16, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(240, 240, 255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = section

        return section
    end

    do
        local section = addSection(mainPage, "Movement")
        section.Size = UDim2.new(1, -8, 0, 90)

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -16, 1, -16)
        wrap.Position = UDim2.new(0, 8, 0, 8)
        wrap.BackgroundTransparency = 1
        wrap.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Parent = wrap

        local left = createActionButton(wrap, "AUTO LEFT", function() settings.autoLeft = not settings.autoLeft; saveConfig() end, 90)
        left.Size = UDim2.new(0, 90, 0, 28)

        local right = createActionButton(wrap, "AUTO RIGHT", function() settings.autoRight = not settings.autoRight; saveConfig() end, 90)
        right.Size = UDim2.new(0, 90, 0, 28)

        local tp = createActionButton(wrap, "TP DOWN", function() settings.tpDown = not settings.tpDown; saveConfig() end, 90)
        tp.Size = UDim2.new(0, 90, 0, 28)

        local brain = createActionButton(wrap, "DROP BRAINROT", function() settings.dropBrainrot = not settings.dropBrainrot; saveConfig() end, 90)
        brain.Size = UDim2.new(0, 90, 0, 28)
    end

    do
        local section = addSection(mainPage, "Speed")
        section.Size = UDim2.new(1, -8, 0, 150)

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -16, 1, -16)
        wrap.Position = UDim2.new(0, 8, 0, 8)
        wrap.BackgroundTransparency = 1
        wrap.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.Parent = wrap

        createNumberInput(wrap, "Normal Speed", "normalSpeed", 1, 500)
        createNumberInput(wrap, "Carry Speed", "carrySpeed", 1, 500)
        createNumberInput(wrap, "Lagger Speed", "laggerSpeed", 1, 500)
        createNumberInput(wrap, "Lagger Carry", "laggerCarry", 1, 500)
    end

    do
        local section = addSection(combatPage, "Combat")
        section.Size = UDim2.new(1, -8, 0, 220)

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -16, 1, -16)
        wrap.Position = UDim2.new(0, 8, 0, 8)
        wrap.BackgroundTransparency = 1
        wrap.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = wrap

        createToggle(wrap, "Bat Aimbot", "batAimbot")
        createToggle(wrap, "Bat TP Lagger", "batTp")
        createToggle(wrap, "Carry Mode Auto", "autoCarry")
        createToggle(wrap, "Turn Speed", "autoTurn")
        createToggle(wrap, "Anti Die", "antiDie")
        createToggle(wrap, "Auto Reset", "autoResetOnDeath")
        createToggle(wrap, "Med Reset", "medReset")
        createToggle(wrap, "Bat Counter", "batCounter")
    end

    do
        local section = addSection(visualsPage, "Visuals")
        section.Size = UDim2.new(1, -8, 0, 180)

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -16, 1, -16)
        wrap.Position = UDim2.new(0, 8, 0, 8)
        wrap.BackgroundTransparency = 1
        wrap.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.Parent = wrap

        createToggle(wrap, "Anti Kick", "antiKick")
        createToggle(wrap, "Anti Summer Base", "antiSummerBase")
        createToggle(wrap, "Anti Lag", "antiLag")
        createToggle(wrap, "Unwalk", "unwalk")
        createToggle(wrap, "Vampire", "vampire")
        createToggle(wrap, "Zombie", "zombie")
        createToggle(wrap, "Amazon", "amazon")
        createToggle(wrap, "Safe Mode", "safeMode")
    end

    do
        local section = addSection(mobilePage, "Mobile")
        section.Size = UDim2.new(1, -8, 0, 180)

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -16, 1, -16)
        wrap.Position = UDim2.new(0, 8, 0, 8)
        wrap.BackgroundTransparency = 1
        wrap.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = wrap

        createToggle(wrap, "Mobile Buttons", "mobileButtons")
        createNumberInput(wrap, "Button Size", "buttonSize", 30, 100)
        createNumberInput(wrap, "UI Scale", "uiScale", 0.1, 2.9)
        createNumberInput(wrap, "X Position", "mobileButtonPosX", 0, 500)
        createNumberInput(wrap, "Y Position", "mobileButtonPosY", 0, 500)
    end

    do
        local section = addSection(configPage, "Config")
        section.Size = UDim2.new(1, -8, 0, 220)

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, -16, 1, -16)
        wrap.Position = UDim2.new(0, 8, 0, 8)
        wrap.BackgroundTransparency = 1
        wrap.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = wrap

        local saveBtn = Instance.new("TextButton")
        saveBtn.Size = UDim2.new(1, -8, 0, 30)
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 12
        saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        saveBtn.BackgroundColor3 = Color3.fromRGB(72, 162, 94)
        saveBtn.Parent = wrap
        makeRounded(saveBtn, 8)
        saveBtn.MouseButton1Click:Connect(function()
            saveConfig()
        end)

        local resetBtn = Instance.new("TextButton")
        resetBtn.Size = UDim2.new(1, -8, 0, 30)
        resetBtn.Text = "RESET ALL SETTINGS"
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 12
        resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetBtn.BackgroundColor3 = Color3.fromRGB(252, 92, 92)
        resetBtn.Parent = wrap
        makeRounded(resetBtn, 8)
        resetBtn.MouseButton1Click:Connect(function()
            for key, value in pairs(defaultSettings) do
                settings[key] = value
            end
            saveConfig()
        end)

        local themeRow = Instance.new("Frame")
        themeRow.Size = UDim2.new(1, 0, 0, 60)
        themeRow.BackgroundTransparency = 1
        themeRow.Parent = wrap

        local themeLabel = Instance.new("TextLabel")
        themeLabel.Size = UDim2.new(1, 0, 0, 18)
        themeLabel.Text = "Theme"
        themeLabel.Font = Enum.Font.GothamSemibold
        themeLabel.TextSize = 12
        themeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        themeLabel.BackgroundTransparency = 1
        themeLabel.TextXAlignment = Enum.TextXAlignment.Left
        themeLabel.Parent = themeRow

        local themeButtons = Instance.new("Frame")
        themeButtons.Size = UDim2.new(1, 0, 0, 35)
        themeButtons.Position = UDim2.new(0, 0, 0, 22)
        themeButtons.BackgroundTransparency = 1
        themeButtons.Parent = themeRow

        local themeLayout = Instance.new("UIListLayout")
        themeLayout.FillDirection = Enum.FillDirection.Horizontal
        themeLayout.Padding = UDim.new(0, 6)
        themeLayout.Parent = themeButtons

        createThemeButton(themeButtons, "sky", function(name) setTheme(name) end)
        createThemeButton(themeButtons, "galaxy", function(name) setTheme(name) end)
        createThemeButton(themeButtons, "cyber", function(name) setTheme(name) end)
        createThemeButton(themeButtons, "sakura", function(name) setTheme(name) end)
        createThemeButton(themeButtons, "night", function(name) setTheme(name) end)
        createThemeButton(themeButtons, "blood", function(name) setTheme(name) end)
    end

    local mobilePanel = Instance.new("Frame")
    mobilePanel.Name = "MobilePanel"
    mobilePanel.AnchorPoint = Vector2.new(1, 0)
    mobilePanel.Position = UDim2.new(1, -((settings.buttonSize * 2) + 24), 0, settings.mobileButtonPosY)
    mobilePanel.Size = UDim2.new(0, settings.buttonSize * 2 + 18, 0, 0)
    mobilePanel.BackgroundTransparency = 1
    mobilePanel.Parent = mainFrame

    local mobileButtons = {}

    local function rebuildMobileButtons()
        for _, child in ipairs(mobilePanel:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        table.clear(mobileButtons)

        local actions = {
            {txt = "LFT", callback = function() settings.autoLeft = not settings.autoLeft; saveConfig() end},
            {txt = "RGT", callback = function() settings.autoRight = not settings.autoRight; saveConfig() end},
            {txt = "BAT", callback = function() settings.batAimbot = not settings.batAimbot; saveConfig() end},
            {txt = "TP", callback = function() settings.tpDown = not settings.tpDown; saveConfig() end},
            {txt = "DROP", callback = function() settings.dropBrainrot = not settings.dropBrainrot; saveConfig() end},
            {txt = "RST", callback = function() settings.instantReset = not settings.instantReset; saveConfig() end},
            {txt = "CARRY", callback = function() settings.carrySpeed = settings.carrySpeed + 5; saveConfig() end},
            {txt = "LGSP", callback = function() settings.laggerSpeed = settings.laggerSpeed + 5; saveConfig() end},
            {txt = "LGCR", callback = function() settings.laggerCarry = settings.laggerCarry + 5; saveConfig() end},
            {txt = "DOWN", callback = function() settings.tpDown = not settings.tpDown; saveConfig() end},
        }

        for _, info in ipairs(actions) do
            local btn = createActionButton(mobilePanel, info.txt, info.callback, settings.buttonSize)
            table.insert(mobileButtons, btn)
        end

        local count = 0
        for _, button in ipairs(mobileButtons) do
            local row = math.floor(count / 2)
            local col = count % 2
            button.Position = UDim2.new(0, col * (settings.buttonSize + 10), 0, row * (settings.buttonSize + 10))
            count += 1
        end

        mobilePanel.Size = UDim2.new(0, settings.buttonSize * 2 + 18, 0, math.ceil(#mobileButtons / 2) * (settings.buttonSize + 10))
    end

    rebuildMobileButtons()

    local dragging = false
    local dragStart = nil
    local startPos = nil

    dragRegion.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    dragRegion.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local function updateThemeVisuals()
        local palette = _G.CupcakeGui and _G.CupcakeGui.palette or {
            bg = Color3.fromRGB(12, 10, 26),
            panel = Color3.fromRGB(22, 19, 42),
            accent = Color3.fromRGB(145, 80, 255),
            text = Color3.fromRGB(245, 239, 255),
            button = Color3.fromRGB(48, 38, 74),
            on = Color3.fromRGB(84, 255, 177),
            off = Color3.fromRGB(255, 104, 104),
        }

        mainFrame.BackgroundColor3 = palette.bg
        dragRegion.BackgroundColor3 = palette.panel
        content.BackgroundColor3 = palette.panel
        title.TextColor3 = palette.text
    end

    local function refresh()
        setTheme(settings.theme)
        updateThemeVisuals()

        mainFrame.Size = UDim2.new(0, 700 * settings.uiScale, 0, 510 * settings.uiScale)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

        if settings.mobileButtons then
            mobilePanel.Visible = true
        else
            mobilePanel.Visible = false
        end

        mobilePanel.Position = UDim2.new(1, -(settings.buttonSize * 2 + 24), 0, settings.mobileButtonPosY)
        rebuildMobileButtons()
    end

    refresh()
    setActivePage(activePage)

    return {
        screenGui = screenGui,
        refresh = refresh,
    }
end

loadConfig()
setTheme(settings.theme)
local gui = createGui()

player:GetAttributeChangedSignal(configKey):Connect(function()
    if gui and gui.refresh then
        gui.refresh()
    end
end)

saveConfig()

return gui
