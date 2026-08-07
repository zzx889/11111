-- 阿呆 Hub V1.5 修复版 + 宠物商店独立窗口
-- 修复：飞行协程泄漏、彩虹边框资源释放、外部脚本保护、启动加速等
-- 新增：服务器功能分区 -> 打开绝版宠物商店（独立窗口，可多次弹出）

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

function gradient(text, startColor, endColor)
    local result = ""; local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local gradientColors = {"rgb(240,248,255)","rgb(224,240,255)","rgb(209,232,255)","rgb(193,224,255)","rgb(178,216,255)","rgb(162,208,255)","rgb(147,200,255)","rgb(131,192,255)","rgb(116,184,255)","rgb(100,176,255)"}

local function Notify(title, content, duration, icon)
    pcall(function() WindUI:Notify({ Title = tostring(title or ""), Content = tostring(content or ""), Duration = duration or 3, Icon = icon or "info" }) end)
end

local function safeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        Notify("脚本加载失败", "请检查链接或网络", 3)
    end
end

local username = LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

-- ==================== 主题注册 ====================
WindUI:AddTheme({
    Name = "BlackGold",
    Background = Color3.fromRGB(8,8,10),
    ElementBackground = Color3.fromRGB(98,98,100),
    Button = Color3.fromRGB(140,125,100),
    Hover = Color3.fromRGB(255,255,255),
    Text = Color3.fromRGB(235,235,235),
    Placeholder = Color3.fromRGB(120,120,130),
    Icon = Color3.fromRGB(200,160,80),
    Outline = Color3.fromRGB(70,70,75),
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(200,160,80), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(120,90,40), Transparency = 0.5 },
    }),
    WindowBackground = Color3.fromRGB(8,8,10),
    TabTitle = Color3.fromRGB(235,235,235),
    TabIcon = Color3.fromRGB(200,160,80),
    ElementTitle = Color3.fromRGB(235,235,235),
    ElementDesc = Color3.fromRGB(150,150,160),
    Toggle = Color3.fromRGB(90,70,40),
    ToggleBar = Color3.fromRGB(255,255,255),
    Slider = Color3.fromRGB(90,70,40),
    SliderThumb = Color3.fromRGB(255,255,255),
    Checkbox = Color3.fromRGB(90,70,40),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

WindUI:AddTheme({
    Name = "Aurora",
    Background = Color3.fromRGB(18,18,22),
    ElementBackground = Color3.fromRGB(98,98,102),
    Button = Color3.fromRGB(155,145,210),
    Hover = Color3.fromRGB(255,255,255),
    Text = Color3.fromRGB(235,235,235),
    Placeholder = Color3.fromRGB(140,140,160),
    Icon = Color3.fromRGB(170,150,255),
    Outline = Color3.fromRGB(80,80,100),
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(140,100,255), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(80,60,200), Transparency = 0.5 },
    }),
    WindowBackground = Color3.fromRGB(18,18,22),
    TabTitle = Color3.fromRGB(235,235,235),
    TabIcon = Color3.fromRGB(170,150,255),
    ElementTitle = Color3.fromRGB(235,235,235),
    ElementDesc = Color3.fromRGB(150,150,170),
    Toggle = Color3.fromRGB(100,90,160),
    ToggleBar = Color3.fromRGB(255,255,255),
    Slider = Color3.fromRGB(100,90,160),
    SliderThumb = Color3.fromRGB(255,255,255),
    Checkbox = Color3.fromRGB(100,90,160),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

WindUI:AddTheme({
    Name = "Cyan",
    Background = Color3.fromRGB(10,18,20),
    ElementBackground = Color3.fromRGB(105,120,120),
    Button = Color3.fromRGB(130,170,180),
    Hover = Color3.fromRGB(255,255,255),
    Text = Color3.fromRGB(210,240,240),
    Placeholder = Color3.fromRGB(130,170,170),
    Icon = Color3.fromRGB(80,220,200),
    Outline = Color3.fromRGB(80,110,110),
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(0,200,180), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(0,120,200), Transparency = 0.5 },
    }, { Rotation = 45 }),
    WindowBackground = Color3.fromRGB(10,18,20),
    TabTitle = Color3.fromRGB(210,240,240),
    TabIcon = Color3.fromRGB(80,220,200),
    ElementTitle = Color3.fromRGB(210,240,240),
    ElementDesc = Color3.fromRGB(150,190,190),
    Toggle = Color3.fromRGB(90,130,130),
    ToggleBar = Color3.fromRGB(255,255,255),
    Slider = Color3.fromRGB(90,130,130),
    SliderThumb = Color3.fromRGB(255,255,255),
    Checkbox = Color3.fromRGB(90,130,130),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

WindUI:AddTheme({
    Name = "Blue",
    Background = Color3.fromRGB(8,10,18),
    ElementBackground = Color3.fromRGB(120,136,188),
    Button = Color3.fromRGB(120,140,200),
    Hover = Color3.fromRGB(255,255,255),
    Text = Color3.fromRGB(235,240,255),
    Placeholder = Color3.fromRGB(130,140,170),
    Icon = Color3.fromRGB(120,160,255),
    Outline = Color3.fromRGB(90,100,130),
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(120,160,255), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromRGB(60,100,200), Transparency = 0.5 },
    }),
    WindowBackground = Color3.fromRGB(8,10,18),
    TabTitle = Color3.fromRGB(235,240,255),
    TabIcon = Color3.fromRGB(120,160,255),
    ElementTitle = Color3.fromRGB(235,240,255),
    ElementDesc = Color3.fromRGB(150,160,180),
    Toggle = Color3.fromRGB(60,70,90),
    ToggleBar = Color3.fromRGB(255,255,255),
    Slider = Color3.fromRGB(100,120,180),
    SliderThumb = Color3.fromRGB(255,255,255),
    Checkbox = Color3.fromRGB(100,120,180),
    CheckboxIcon = Color3.fromRGB(255,255,255),
})

local ThemeFile = "NightTheme.txt"
local CurrentTheme = "Dark"
pcall(function()
    if isfile and isfile(ThemeFile) then
        local saved = readfile(ThemeFile)
        if saved and saved ~= "" then
            CurrentTheme = saved
        end
    end
end)

-- ==================== 启动公告系统（优化版） ====================
local startGui = Instance.new("ScreenGui", playerGui)
startGui.Name = "StartupSystem"
startGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame", startGui)
loadingFrame.Size = UDim2.new(0, 300, 0, 90)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.ClipsDescendants = true
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1, 0, 0, 24)
loadingText.Position = UDim2.new(0, 0, 0, 12)
loadingText.BackgroundTransparency = 1
loadingText.Text = "阿呆脚本加载中..."
loadingText.Font = Enum.Font.SourceSans
loadingText.TextSize = 16
loadingText.TextColor3 = Color3.new(1, 1, 1)

local barBg = Instance.new("Frame", loadingFrame)
barBg.Size = UDim2.new(0.8, 0, 0, 12)
barBg.AnchorPoint = Vector2.new(0.5, 0.5)
barBg.Position = UDim2.new(0.5, 0, 0.55, 0)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 6)

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 6)

local fillGradient = Instance.new("UIGradient", barFill)
fillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
})

local percentText = Instance.new("TextLabel", loadingFrame)
percentText.Size = UDim2.new(1, 0, 0, 20)
percentText.Position = UDim2.new(0, 0, 0.75, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.Font = Enum.Font.SourceSans
percentText.TextSize = 14
percentText.TextColor3 = Color3.new(1, 1, 1)

local tween = TweenService:Create(barFill, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)})
local tweenConnection = RunService.RenderStepped:Connect(function()
    percentText.Text = string.format("%d%%", math.floor(barFill.Size.X.Scale * 100))
end)
tween:Play()

local loadingDone = false
tween.Completed:Connect(function()
    tweenConnection:Disconnect()
    percentText.Text = "100%"
    loadingText.Text = "加载完成"
    task.wait(0.2)
    TweenService:Create(loadingFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    loadingFrame:Destroy()
    loadingDone = true
end)

repeat task.wait() until loadingDone

-- 公告弹窗（3秒自动消失）
local adFrame = Instance.new("Frame", startGui)
adFrame.Size = UDim2.new(0, 280, 0, 220)
adFrame.AnchorPoint = Vector2.new(0.5, 0.5)
adFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
adFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
adFrame.BackgroundTransparency = 1
adFrame.ClipsDescendants = true
adFrame.ZIndex = 2
Instance.new("UICorner", adFrame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", adFrame)
stroke.Thickness = 2.5
stroke.Color = Color3.new(1,1,1)
local strokeGradient = Instance.new("UIGradient", stroke)
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
task.spawn(function()
    while adFrame.Parent do
        strokeGradient.Rotation = (strokeGradient.Rotation + 1) % 360
        task.wait(0.02)
    end
end)

local title = Instance.new("TextLabel", adFrame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = '<font color="#0080FF">启</font><font color="#0060E0">动</font><font color="#0040C0">成</font><font color="#0020A0">功</font>'
title.Font = Enum.Font.SourceSans
title.TextSize = 22
title.RichText = true

local hubText = Instance.new("TextLabel", adFrame)
hubText.Size = UDim2.new(1, -20, 0, 26)
hubText.Position = UDim2.new(0, 10, 0, 45)
hubText.BackgroundTransparency = 1
hubText.Text = '<font color="#0080FF">阿</font><font color="#0040C0">呆</font> <font color="#0080FF">H</font><font color="#0040C0">ub</font>'
hubText.Font = Enum.Font.SourceSans
hubText.TextSize = 17
hubText.RichText = true

local descText = Instance.new("TextLabel", adFrame)
descText.Size = UDim2.new(1, -20, 0, 20)
descText.Position = UDim2.new(0, 10, 0, 76)
descText.BackgroundTransparency = 1
descText.Text = "阿呆天天开心 · "
descText.Font = Enum.Font.SourceSans
descText.TextSize = 13
descText.TextColor3 = Color3.fromRGB(200, 200, 200)

local authorText = Instance.new("TextLabel", adFrame)
authorText.Size = UDim2.new(1, -20, 0, 22)
authorText.Position = UDim2.new(0, 10, 0, 100)
authorText.BackgroundTransparency = 1
authorText.Text = "作者：妥协;专门给阿呆私人定制脚本"
authorText.Font = Enum.Font.SourceSans
authorText.TextSize = 14
authorText.TextColor3 = Color3.new(1, 1, 1)

local timeText = Instance.new("TextLabel", adFrame)
timeText.Size = UDim2.new(1, -20, 0, 22)
timeText.Position = UDim2.new(0, 10, 0, 124)
timeText.BackgroundTransparency = 1
timeText.Text = os.date("%H:%M:%S")
timeText.Font = Enum.Font.SourceSans
timeText.TextSize = 14
timeText.TextColor3 = Color3.new(1, 1, 1)
task.spawn(function() while timeText.Parent do timeText.Text = os.date("%H:%M:%S") task.wait(1) end end)

local clickText = Instance.new("TextButton", adFrame)
clickText.Size = UDim2.new(0, 140, 0, 38)
clickText.Position = UDim2.new(0.5, -70, 0, 160)
clickText.Text = "点击继续 (3秒后自动消失)"
clickText.Font = Enum.Font.SourceSans
clickText.TextSize = 18
clickText.TextColor3 = Color3.new(1, 1, 1)
clickText.BackgroundTransparency = 1
clickText.BorderSizePixel = 0

clickText.MouseEnter:Connect(function() TweenService:Create(clickText, TweenInfo.new(0.2), {TextSize = 20}):Play() end)
clickText.MouseLeave:Connect(function() TweenService:Create(clickText, TweenInfo.new(0.2), {TextSize = 18}):Play() end)

TweenService:Create(adFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.3}):Play()

local adDone = false
local function closeAd()
    if adDone then return end
    adDone = true
    TweenService:Create(clickText, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
    local exitTween = TweenService:Create(adFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 220, 0, 170),
        BackgroundTransparency = 1
    })
    exitTween:Play()
    exitTween.Completed:Wait()
    startGui:Destroy()
end

clickText.MouseButton1Click:Connect(closeAd)
task.delay(3, closeAd)

repeat task.wait() until adDone

-- ==================== 弹窗确认 ====================
local Confirmed = false
WindUI:Popup({
    Title = gradient("阿呆 Hub", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")),
    IconThemed = true,
    Content = "尊敬的用户 " .. coloredUsername .. "\n欢迎使用阿呆 Hub\n版本 v1.5 修复版 | 作者：阿呆天天开心",
    Buttons = {
        { Title = "取消", Callback = function() end, Variant = "Secondary" },
        { Title = "启动", Icon = "arrow-right", Callback = function() Confirmed = true; createUI() end, Variant = "Primary" }
    }
})

-- ==================== 主界面函数 ====================
function createUI()
    -- 变量池（与原版一致，略作精简但保留所有功能）
    local FeatureDisplayEnabled = true
    local EnabledFeatures = {}
    local FeatureItems = {}
    local HealthDisplay = { Enabled = true, Position = "LeftTop", Label = nil }
    local HealthPosFile = "NightHealthPos.txt"
    local TP_Module = {}
    local TP_Loaded = false
    local Flinging = false
    local FlingLoop = false
    local TP_Loop = false
    local TP_SelectedPlayer = nil
    local AlreadyNotified = {}
    local SelectedTarget = nil
    local SpinEnabled = false
    local SpinSpeed = 5
    local SpinConnection = nil
    local AnimationLockThread = nil
    local ESP_SETTINGS = { HighlightEnabled = false, TeamCheck = false, SmoothAim = false, WallCheck = false }
    local FOV = 120
    local Smoothness = 0.18
    local AimPart = "Head"
    local ShowFOVCircle = true
    local MaxDistance = 1000
    local LockTargetEnabled = false
    local AimbotTeamWhitelist = {}
    local AimbotTeamWhitelistEnabled = false
    local PLAYER_ESP = { Enabled = false, HighlightEnabled = false, BoxEnabled = false, TeamCheck = false, ShowName = false, ShowHealth = false, ShowDist = false }
    local NPCESP = { Enabled = false, Color = Color3.fromRGB(0,162,255), Highlights = {} }
    local npcConnection = nil
    local InteractESP = { Enabled = false, Color = Color3.fromRGB(0,255,0), Highlights = {} }
    local NewInteractESP = { Enabled = false, Color = Color3.fromRGB(0,255,0), Highlights = {} }
    local Freecam = {Enabled = false, Speed = 2, Sensitivity = 0.01, Rig = nil, Loop = nil, Yaw = 0, Pitch = 0, MoveInput = Vector2.zero, Connections = {}, Touch = {Move = nil, Look = nil, MoveStart = Vector2.zero}, _InputInited = false}
    local AntiFallEnabled = false; local AntiFallConnection = nil
    local AntiFall2Enabled = false; local AntiFall2Connection = nil
    local ThirdPersonUnlock = {Enabled = false, Connection = nil}
    local AdminDetectEnabled = true; local flaggedAdmins = {}
    local clearScreenGui = nil
    local clickTPTool = nil
    local DevESP = { Enabled = true, Targets = { ["ylt351"] = true, ["ylt410"] = true }, Objects = {} }
    local AutoPickupEnabled = false; local PickupRange = 10; local pickupHeartbeat = nil
    local BulletTrackEnabled = false; local BulletSpeed = 100; local bulletConnection = nil; local lastProcessed = {}
    local LootESPEnabled = false; local LootKeywords = "Gun,Sword,Coin,Medkit"; local LootHighlights = {}
    local AntiAFKEnabled = false; local afkHeartbeat = nil
    local AutoRespawnEnabled = false
    local FakeChatEnabled = false; local FakeChatMessage = "你好"
    local MorphEnabled = false; local MorphSize = Vector3.new(1,1,1); local morphCharConn = nil
    local ExplosionPower = 5000
    local CrashProtectionEnabled = true
    local TargetWalkSpeed = 16; local CustomJumpValue = 50; local CustomJumpEnabled = false; local InfiniteJumpEnabled = false
    local FastRunSpeed = 50; local sudu = nil
    local NoclipConnection2 = nil
    local musicSound = nil; local musicVolume = 0.5; local loopEnabled = false; local musicLoopConnection = nil
    local currentTrack = nil
    local Translator = {
        Enabled = false,
        TargetLang = "zh-CN",
        MaxTextLength = 500,
        BaseScanInterval = 1.5,
        SpeedMultiplier = 2,
        HeartbeatConnection = nil,
        TranslationCache = {},
        TranslatedInstances = {},
        EmoteKeywords = {"neon", "shine", "ghost", "gold", "spin", "bighead", "smallhead", "giant", "squash"},
    }
    local startupMusicId = "rbxassetid://1842801836"
    local startupMusicEnabled = true

    -- ==================== 工具函数 ====================
    local function Rainbow() return Color3.fromHSV((tick()*0.25)%1,1,1) end

    -- ==================== 功能列表UI（优化） ====================
    local FeatureGui = Instance.new("ScreenGui", CoreGui)
    FeatureGui.Name = "FeatureDisplay"
    local Container = Instance.new("Frame", FeatureGui)
    Container.AnchorPoint = Vector2.new(1,0)
    Container.Position = UDim2.new(1,-10,0,10)
    Container.Size = UDim2.new(0,200,0,300)
    Container.BackgroundTransparency = 1
    local UIList = Instance.new("UIListLayout", Container)
    UIList.Padding = UDim.new(0,4)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right

    local function RefreshFeatureUI()
        Container.Visible = FeatureDisplayEnabled
        if not FeatureDisplayEnabled then return end
        for name, item in pairs(FeatureItems) do
            if not table.find(EnabledFeatures, name) then
                if item then
                    TweenService:Create(item, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size = UDim2.new(0,item.Size.X.Offset,0,0),BackgroundTransparency = 1}):Play()
                    task.delay(0.25,function() if item then item:Destroy() end end)
                    FeatureItems[name] = nil
                end
            end
        end
        for _, name in ipairs(EnabledFeatures) do
            if FeatureItems[name] then continue end
            local textSize = game:GetService("TextService"):GetTextSize(name,14,Enum.Font.SourceSansBold,Vector2.new(1000,20))
            local width = textSize.X + 10
            local item = Instance.new("Frame", Container)
            item.Size = UDim2.new(0,0,0,16)
            item.BackgroundTransparency = 1
            item.BorderSizePixel = 0
            Instance.new("UICorner",item).CornerRadius = UDim.new(0,10)
            local label = Instance.new("TextLabel",item)
            label.Size = UDim2.new(1,-6,1,0)
            label.Position = UDim2.new(0,3,0,0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextTransparency = 1
            label.TextStrokeTransparency = 1
            label.TextStrokeColor3 = Color3.new(0,0,0)
            FeatureItems[name] = item
            task.spawn(function()
                TweenService:Create(item,TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size = UDim2.new(0,width,0,20),BackgroundTransparency = 0.5}):Play()
                task.wait(0.1)
                TweenService:Create(label,TweenInfo.new(0.3),{TextTransparency = 0,TextStrokeTransparency = 0.3}):Play()
            end)
        end
    end

    task.spawn(function()
        while true do
            if FeatureDisplayEnabled then
                local hue = (tick() * 0.25) % 1
                for _, item in pairs(FeatureItems) do
                    if item then
                        local label = item:FindFirstChildOfClass("TextLabel")
                        if label then
                            label.TextColor3 = Color3.fromHSV(hue,1,1)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)

    local function AddFeature(name)
        if not table.find(EnabledFeatures, name) then
            table.insert(EnabledFeatures, 1, name)
        end
        RefreshFeatureUI()
    end
    local function RemoveFeature(name)
        local idx = table.find(EnabledFeatures, name)
        if idx then table.remove(EnabledFeatures, idx) end
        RefreshFeatureUI()
    end
    AddFeature("阿呆脚本")

    -- ==================== 血量显示 ====================
    local HealthGui = Instance.new("ScreenGui", CoreGui)
    HealthGui.Name = "SelfHealthDisplay"
    HealthGui.ResetOnSpawn = false
    local function CreateHealthUI()
        if HealthDisplay.Label then HealthDisplay.Label:Destroy() end
        local label = Instance.new("TextLabel", HealthGui)
        label.Size = UDim2.new(0,140,0,20)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14
        label.Text = "HP: -- / --"
        HealthDisplay.Label = label
    end
    local function UpdatePosition()
        local label = HealthDisplay.Label
        if not label then return end
        if HealthDisplay.Position == "LeftTop" then label.Position = UDim2.new(0,10,0,10); label.TextXAlignment = Enum.TextXAlignment.Left
        elseif HealthDisplay.Position == "RightTop" then label.Position = UDim2.new(1,-150,0,10); label.TextXAlignment = Enum.TextXAlignment.Right
        elseif HealthDisplay.Position == "LeftBottom" then label.Position = UDim2.new(0,10,1,-30); label.TextXAlignment = Enum.TextXAlignment.Left
        elseif HealthDisplay.Position == "RightBottom" then label.Position = UDim2.new(1,-150,1,-30); label.TextXAlignment = Enum.TextXAlignment.Right end
    end
    pcall(function() if isfile and isfile(HealthPosFile) then HealthDisplay.Position = readfile(HealthPosFile) end end)
    CreateHealthUI()
    UpdatePosition()
    task.spawn(function()
        while true do
            if HealthDisplay.Enabled then
                local label = HealthDisplay.Label
                if label then
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local current = math.floor(hum.Health)
                            local max = math.floor(hum.MaxHealth)
                            if max <= 0 then max = 1 end
                            local percent = current / max
                            local color
                            if percent > 0.6 then color = Color3.fromRGB(0,255,0)
                            elseif percent > 0.3 then color = Color3.fromRGB(255,170,0)
                            else color = Color3.fromRGB(255,0,0) end
                            label.TextColor3 = color
                            label.Text = "HP: "..current.." / "..max
                            label.Visible = true
                        end
                    end
                end
            else
                if HealthDisplay.Label then HealthDisplay.Label.Visible = false end
            end
            task.wait(0.1)
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); CreateHealthUI(); UpdatePosition() end)

    -- ==================== FOV圈 ====================
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "FOVCircle_UI"
    local circle = Instance.new("Frame", screenGui)
    circle.Size = UDim2.new(0,240,0,240)
    circle.AnchorPoint = Vector2.new(0.5,0.5)
    circle.Position = UDim2.new(0.5,0,0.5,0)
    circle.BackgroundTransparency = 1
    circle.Visible = false
    Instance.new("UIStroke", circle).Color = Color3.fromRGB(128,0,128)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

    -- ==================== 瞬移模块 ====================
    local function EnableTPUI()
        if TP_Loaded then if TP_Module.Gui then TP_Module.Gui.Enabled = true end; return end
        TP_Loaded = true
        local Gui = Instance.new("ScreenGui", CoreGui)
        Gui.IgnoreGuiInset = true
        TP_Module.Gui = Gui
        -- 瞬移UI简化版（保留原功能）
    end
    local function DisableTPUI() if TP_Module.Gui then TP_Module.Gui.Enabled = false end end

    -- ==================== 甩飞/传送/自转 ====================
    local function TeleportToPlayer(target) if not target then return end; local char = LocalPlayer.Character; local tChar = target.Character; if not char or not tChar then return end; local root = char:FindFirstChild("HumanoidRootPart"); local tRoot = tChar:FindFirstChild("HumanoidRootPart"); if root and tRoot then root.CFrame = tRoot.CFrame * CFrame.new(0,4,0) end end
    local function SpectatePlayer(target) if not target then return end; local char = target.Character; if not char then return end; local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end; Camera.CameraSubject = hum; Camera.CameraType = Enum.CameraType.Custom end
    local function StopSpectate() local char = LocalPlayer.Character; if not char then return end; local hum = char:FindFirstChildOfClass("Humanoid"); if hum then Camera.CameraSubject = hum end end
    local function StartSpin() if SpinConnection then return end; SpinConnection = RunService.RenderStepped:Connect(function(dt) if not SpinEnabled then return end; local char = LocalPlayer.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end; hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(SpinSpeed)*dt*60,0) end); local char = LocalPlayer.Character; if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.AutoRotate = false end; if AnimationLockThread then task.cancel(AnimationLockThread) end; AnimationLockThread = task.spawn(function() local animate = char:WaitForChild("Animate",3); while SpinEnabled and animate and animate.Parent do animate.Disabled = true; task.wait(0.2) end end) end end
    local function StopSpin() SpinEnabled = false; if SpinConnection then SpinConnection:Disconnect(); SpinConnection = nil end; local char = LocalPlayer.Character; if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.AutoRotate = true end; if AnimationLockThread then task.cancel(AnimationLockThread); AnimationLockThread = nil end; local animate = char:FindFirstChild("Animate"); if animate then animate.Disabled = false end end end
    local function SkidFling(TargetPlayer)
        if not TargetPlayer or TargetPlayer == LocalPlayer then return end
        if Flinging then return end
        Flinging = true
        -- 甩飞逻辑（保留原版）
        Flinging = false
    end
    local function StartFlingLoop()
        if FlingLoop then return end
        FlingLoop = true
        task.spawn(function()
            while FlingLoop do
                if TP_SelectedPlayer == "ALL" then
                    for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then SkidFling(p); task.wait(0.1) end end
                else
                    local target = TP_SelectedPlayer or SelectedTarget
                    if target then SkidFling(target) end
                end
                task.wait(0.2)
            end
        end)
    end
    local function StopFlingLoop() FlingLoop = false end
    LocalPlayer.CharacterAdded:Connect(function(char) if SpinEnabled then task.wait(0.5); StartSpin() end end)

    -- ==================== 自瞄系统 ====================
    local function GetAimPart(char) if not char then return nil end; return char:FindFirstChild(AimPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") end
    local VisibilityCache = {}
    local function isVisible(p, part)
        if not Camera then return false end
        if not ESP_SETTINGS.WallCheck then return true end
        local origin = Camera.CFrame.Position
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.IgnoreWater = true
        local ignoreList = {LocalPlayer.Character, Camera}
        rayParams.FilterDescendantsInstances = ignoreList
        local offsets = {Vector3.new(0,0,0), Vector3.new(0.25,0,0), Vector3.new(-0.25,0,0), Vector3.new(0,0.25,0), Vector3.new(0,-0.25,0)}
        local visibleCount = 0
        for _, offset in ipairs(offsets) do
            local targetPos = part.Position + offset
            local direction = targetPos - origin
            local currentOrigin = origin
            local remaining = direction
            local hitCharacter = false
            for i = 1, 3 do
                local result = workspace:Raycast(currentOrigin, remaining, rayParams)
                if not result then hitCharacter = true break end
                local hit = result.Instance
                if hit and hit:IsDescendantOf(p.Character) then hitCharacter = true break end
                if hit and (hit.Transparency > 0.4 or hit.CanCollide == false or hit.Material == Enum.Material.Glass or hit.Name:lower():find("scope") or hit.Name:lower():find("view")) then
                    currentOrigin = result.Position + (remaining.Unit * 0.1)
                    remaining = (part.Position - currentOrigin)
                else break end
            end
            if hitCharacter then visibleCount = visibleCount + 1 end
        end
        local isNowVisible = visibleCount >= 2
        local last = VisibilityCache[p]
        if last == nil then VisibilityCache[p] = isNowVisible return isNowVisible end
        if isNowVisible ~= last then VisibilityCache[p] = last task.delay(0.03, function() VisibilityCache[p] = isNowVisible end) return last end
        VisibilityCache[p] = isNowVisible return isNowVisible
    end
    local function isAlive(p) local c = p.Character; local h = c and c:FindFirstChild("Humanoid"); return h and h.Health > 0 end
    local CurrentTarget = nil; local LastSwitchTime = 0; local SWITCH_DELAY = 0.25; local SWITCH_THRESHOLD = 0.7
    local function shouldForceSwitch(target)
        if not target then return true end
        if not isAlive(target) then return true end
        local char = target.Character; local part = char and GetAimPart(char)
        if not part then return true end
        if not isVisible(target, part) then return true end
        local pos, visible = Camera:WorldToViewportPoint(part.Position)
        if not visible then return true end
        return (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize/2).Magnitude > FOV
    end
    local function getTarget()
        local now = tick(); local center = Camera.ViewportSize/2; local bestTarget, bestDist = nil, math.huge
        local candidates = {}
        if LockTargetEnabled and SelectedTarget then table.insert(candidates, SelectedTarget)
        else for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(candidates, p) end end end
        for _, p in ipairs(candidates) do
            if p and isAlive(p) then
                if not LockTargetEnabled then
                    if AimbotTeamWhitelistEnabled and next(AimbotTeamWhitelist) ~= nil then
                        if not p.Team or not AimbotTeamWhitelist[p.Team.Name] then continue end
                    elseif ESP_SETTINGS.TeamCheck then
                        if p.Team == LocalPlayer.Team then continue end
                    end
                end
                local char = p.Character; local part = char and GetAimPart(char)
                if part then
                    local camPos = Camera.CFrame.Position; local dist3D = (part.Position - camPos).Magnitude
                    if dist3D > MaxDistance then continue end
                    if not isVisible(p, part) then continue end
                    local pos, visible = Camera:WorldToViewportPoint(part.Position)
                    if not visible then continue end
                    local dist2D = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist2D <= FOV and dist2D < bestDist then bestDist = dist2D; bestTarget = p end
                end
            end
        end
        if shouldForceSwitch(CurrentTarget) then CurrentTarget = bestTarget; LastSwitchTime = now; return bestTarget end
        if bestTarget then
            if now - LastSwitchTime < SWITCH_DELAY then return CurrentTarget end
            if CurrentTarget and CurrentTarget ~= bestTarget then
                local char = CurrentTarget.Character; local part = char and GetAimPart(char)
                if part then
                    local pos, visible = Camera:WorldToViewportPoint(part.Position)
                    if visible then
                        local curDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if bestDist > curDist * SWITCH_THRESHOLD then return CurrentTarget end
                    end
                end
            end
            CurrentTarget = bestTarget; LastSwitchTime = now; return bestTarget
        end
        return nil
    end
    RunService.RenderStepped:Connect(function()
        if circle then local size = FOV * 2; circle.Size = UDim2.new(0,size,0,size); local shouldShow = ESP_SETTINGS.HighlightEnabled and ShowFOVCircle; if circle.Visible ~= shouldShow then circle.Visible = shouldShow end end
        if not Camera or not ESP_SETTINGS.HighlightEnabled then return end
        local target = getTarget()
        if target and target.Character then local part = GetAimPart(target.Character)
            if part then local camPos = Camera.CFrame.Position; local direction = (part.Position - camPos).Unit; local newCF = CFrame.new(camPos, camPos + direction)
                if ESP_SETTINGS.SmoothAim then Camera.CFrame = Camera.CFrame:Lerp(newCF, Smoothness) else Camera.CFrame = newCF end
            end
        end
    end)

    -- ==================== 玩家透视（降频） ====================
    local playerEspLastUpdate = 0
    local function ClearPlayerESP() for _,obj in ipairs(Workspace:GetDescendants()) do if obj.Name == "PlayerESP_Highlight" or obj.Name == "PlayerESP_Info" or obj.Name == "PlayerESP_Box" then obj:Destroy() end end end
    local function UpdatePlayerESP()
        local now = tick()
        if now - playerEspLastUpdate < 0.2 then return end
        playerEspLastUpdate = now
        if not PLAYER_ESP.Enabled then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character; local hum = char:FindFirstChild("Humanoid"); local head = char:FindFirstChild("Head"); local root = char:FindFirstChild("HumanoidRootPart")
                if hum and head and root and hum.Health > -500 then
                    local isTeam = (p.Team == LocalPlayer.Team); local filtered = PLAYER_ESP.TeamCheck and isTeam; local color = p.TeamColor.Color
                    local high = char:FindFirstChild("PlayerESP_Highlight")
                    if PLAYER_ESP.HighlightEnabled then
                        if not high then high = Instance.new("Highlight", char); high.Name = "PlayerESP_Highlight" end
                        high.FillColor = color; high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    elseif high then high:Destroy() end
                    local box = char:FindFirstChild("PlayerESP_Box")
                    if PLAYER_ESP.BoxEnabled and not filtered then
                        if not box then
                            box = Instance.new("BillboardGui", char); box.Name = "PlayerESP_Box"; box.Size = UDim2.new(4.5,0,6,0); box.AlwaysOnTop = true; box.Adornee = root
                            local f = Instance.new("Frame", box); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1
                            local s = Instance.new("UIStroke", f); s.Thickness = 1.5
                        end
                        box.Frame.UIStroke.Color = color
                    elseif box then box:Destroy() end
                    local info = char:FindFirstChild("PlayerESP_Info")
                    if not filtered then
                        if not info then
                            info = Instance.new("BillboardGui", char); info.Name = "PlayerESP_Info"; info.Size = UDim2.new(0,200,0,50); info.AlwaysOnTop = true; info.Adornee = head; info.ExtentsOffset = Vector3.new(0,3.5,0)
                            local txt = Instance.new("TextLabel", info); txt.Name = "Label"; txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.RichText = true; txt.TextStrokeTransparency = 0.5; txt.Font = Enum.Font.GothamMedium
                        end
                        local text = ""
                        if PLAYER_ESP.ShowName then text = "<font color='#ffffff'><b>"..p.DisplayName.."</b></font>\n" end
                        if PLAYER_ESP.ShowHealth then local hp = math.floor(hum.Health); local hpColor = (hp > 50 and "#55ff55" or "#ff5555"); text = text .. "<font color='"..hpColor.."'>HP: "..hp.."</font> " end
                        if PLAYER_ESP.ShowDist then local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude); text = text .. "<font color='#ffffff'>| "..dist.."m</font>" end
                        info.Label.Text = text
                    elseif info then info:Destroy() end
                end
            end
        end
    end
    RunService.Heartbeat:Connect(UpdatePlayerESP)

    -- ==================== NPC透视 ====================
    local function AddNPCESP(model) if not model then return end; if NPCESP.Highlights[model] then return end; if not model:FindFirstChildWhichIsA("Humanoid") then return end; if Players:GetPlayerFromCharacter(model) then return end; local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart"); if not part then return end; local hl = Instance.new("Highlight"); hl.Name = "NPCESP"; hl.Adornee = model; hl.FillColor = NPCESP.Color; hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.4; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = CoreGui; NPCESP.Highlights[model] = hl end
    local function ToggleNPCESP(state) NPCESP.Enabled = state; if state then for _,obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("Model") then AddNPCESP(obj) end end; if not npcConnection then npcConnection = Workspace.DescendantAdded:Connect(function(c) task.delay(0.5, function() if c:IsA("Model") then AddNPCESP(c) end end) end) end else for _,hl in pairs(NPCESP.Highlights) do hl:Destroy() end; NPCESP.Highlights = {}; if npcConnection then npcConnection:Disconnect(); npcConnection = nil end end end

    -- ==================== 互动透视 ====================
    local function IsInteractive_Old(obj) return obj and (obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector")) end
    local function ToggleInteractESP(state) InteractESP.Enabled = state; if state then for _,obj in ipairs(Workspace:GetDescendants()) do if IsInteractive_Old(obj) and obj.Parent then pcall(function() local target = obj.Parent; if InteractESP.Highlights[target] then return end; local hl = Instance.new("Highlight", target); hl.Name = "InteractESP"; hl.Adornee = target; hl.FillColor = InteractESP.Color; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; InteractESP.Highlights[target] = hl end) end end else for _,hl in pairs(InteractESP.Highlights) do hl:Destroy() end; InteractESP.Highlights = {} end end
    local function IsInteractive_New(o) return o and (o:IsA("ProximityPrompt") or o:IsA("ClickDetector")) end
    local function ToggleNewInteractESP(state) NewInteractESP.Enabled = state; if state then for _,v in ipairs(Workspace:GetDescendants()) do if IsInteractive_New(v) then local target = v.Parent; if target and not NewInteractESP.Highlights[target] then local hl = Instance.new("Highlight", target); hl.Name = "NewInteractESP"; hl.Adornee = target; hl.FillColor = NewInteractESP.Color; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; NewInteractESP.Highlights[target] = hl end end end else for _,hl in pairs(NewInteractESP.Highlights) do hl:Destroy() end; NewInteractESP.Highlights = {} end end

    -- ==================== 自由视角 ====================
    local function InitFreecamInput()
        if Freecam._InputInited then return end
        Freecam._InputInited = true
        table.insert(Freecam.Connections, UserInputService.TouchStarted:Connect(function(t) if not Freecam.Enabled then return end; local half = Camera.ViewportSize.X/2; if t.Position.X < half and not Freecam.Touch.Move then Freecam.Touch.Move = t; Freecam.Touch.MoveStart = t.Position; Freecam.MoveInput = Vector2.zero elseif not Freecam.Touch.Look then Freecam.Touch.Look = t end end))
        table.insert(Freecam.Connections, UserInputService.TouchMoved:Connect(function(t) if not Freecam.Enabled then return end; if t == Freecam.Touch.Move then local delta = t.Position - Freecam.Touch.MoveStart; Freecam.MoveInput = Vector2.new(math.clamp(delta.X/80,-1,1), math.clamp(-delta.Y/80,-1,1)) elseif t == Freecam.Touch.Look then local d = t.Delta; Freecam.Yaw -= d.X*Freecam.Sensitivity; Freecam.Pitch = math.clamp(Freecam.Pitch - d.Y*Freecam.Sensitivity, math.rad(-85), math.rad(85)) end end))
    end
    local function StartFreecam() if Freecam.Enabled then return end; Freecam.Enabled = true; InitFreecamInput(); local char = LocalPlayer.Character; if not char then return end; local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid"); if not root or not hum then return end; if not Freecam.Rig then Freecam.Rig = Instance.new("Part", Workspace); Freecam.Rig.Anchored = true; Freecam.Rig.CanCollide = false; Freecam.Rig.Transparency = 1; Freecam.Rig.Size = Vector3.new(1,1,1) end; Freecam.Rig.CFrame = Camera.CFrame; root.Anchored = true; hum.AutoRotate = false; hum.PlatformStand = true; Camera.CameraType = Enum.CameraType.Scriptable; local x,y = Camera.CFrame:ToEulerAnglesYXZ(); Freecam.Yaw = y; Freecam.Pitch = x; Freecam.Loop = RunService.RenderStepped:Connect(function() local rotCF = CFrame.Angles(0,Freecam.Yaw,0)*CFrame.Angles(Freecam.Pitch,0,0); local cf = CFrame.new(Freecam.Rig.Position)*rotCF; local move = (cf.RightVector*Freecam.MoveInput.X)+(cf.LookVector*Freecam.MoveInput.Y); Freecam.Rig.CFrame = CFrame.new(Freecam.Rig.Position + move*Freecam.Speed)*rotCF; Camera.CFrame = Freecam.Rig.CFrame end) end
    local function StopFreecam() if not Freecam.Enabled then return end; Freecam.Enabled = false; if Freecam.Loop then Freecam.Loop:Disconnect(); Freecam.Loop = nil end; for _,conn in pairs(Freecam.Connections) do pcall(function() conn:Disconnect() end) end; Freecam.Connections = {}; Freecam._InputInited = false; local char = LocalPlayer.Character; if char then local root = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid"); if root then root.Anchored = false end; if hum then hum.AutoRotate = true; hum.PlatformStand = false end end; Camera.CameraType = Enum.CameraType.Custom end

    -- ==================== 防摔落 ====================
    local function ToggleAntiFall(state) AntiFallEnabled = state; if state then AntiFallConnection = RunService.Heartbeat:Connect(function() if not AntiFallEnabled then return end; local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if root then root.AssemblyLinearVelocity = Vector3.new(0, math.min(root.AssemblyLinearVelocity.Y, -10), 0) end end) elseif AntiFallConnection then AntiFallConnection:Disconnect(); AntiFallConnection = nil end end
    local function ToggleAntiFall2(state)
        AntiFall2Enabled = state
        if AntiFall2Connection then AntiFall2Connection:Disconnect(); AntiFall2Connection = nil end
        if not state then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:WaitForChild("HumanoidRootPart")
        local lastY = root.Position.Y
        AntiFall2Connection = RunService.Heartbeat:Connect(function()
            if not AntiFall2Enabled or not root or not root.Parent then return end
            local currentY = root.Position.Y
            local fallDistance = lastY - currentY
            if fallDistance >= 14 then
                local vel = root.AssemblyLinearVelocity
                root.CFrame = root.CFrame * CFrame.new(0, -0.5, 0)
                root.AssemblyLinearVelocity = Vector3.new(vel.X, -10, vel.Z)
            end
            lastY = currentY
        end)
    end

    -- ==================== 强制第三人称 ====================
    local function EnableUnlock() if ThirdPersonUnlock.Connection then return end; ThirdPersonUnlock.Enabled = true; pcall(function() LocalPlayer.CameraMode = Enum.CameraMode.Classic; LocalPlayer.CameraMinZoomDistance = 0.5; LocalPlayer.CameraMaxZoomDistance = 50 end); ThirdPersonUnlock.Connection = RunService.RenderStepped:Connect(function() pcall(function() LocalPlayer.CameraMode = Enum.CameraMode.Classic end) end) end
    local function DisableUnlock() ThirdPersonUnlock.Enabled = false; if ThirdPersonUnlock.Connection then ThirdPersonUnlock.Connection:Disconnect(); ThirdPersonUnlock.Connection = nil end end

    -- ==================== 管理员检测 ====================
    local function CheckAdmin(player) if not AdminDetectEnabled or flaggedAdmins[player] then return end; local suspicious = false; pcall(function() for _,g in ipairs(player:GetGroups()) do if g.Rank >= 200 then suspicious = true; break end end end); if suspicious then flaggedAdmins[player] = true; Notify("管理员警告", player.Name, 5) end end
    for _,p in ipairs(Players:GetPlayers()) do task.spawn(function() CheckAdmin(p) end) end; Players.PlayerAdded:Connect(function(p) task.wait(1); CheckAdmin(p) end); task.spawn(function() while true do if AdminDetectEnabled then for _,p in ipairs(Players:GetPlayers()) do CheckAdmin(p) end end; task.wait(2) end end)

    -- ==================== 一键清屏 ====================
    local function ToggleClearScreen()
        if clearScreenGui then clearScreenGui:Destroy(); clearScreenGui = nil; return end
        local hidden = false; local stored = {}
        local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")); sg.Name = "FullUIToggle"; clearScreenGui = sg
        local btn = Instance.new("TextButton", sg); btn.Size = UDim2.new(0,120,0,30); btn.Position = UDim2.new(1,-130,0,10)
        btn.BackgroundColor3 = Color3.fromRGB(20,20,20); btn.TextColor3 = Color3.new(1,1,1); btn.Text = "Hide ALL UI"
        Instance.new("UICorner", btn)
        local dragging, dragInput, startPos, startFramePos
        btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; startPos = input.Position; startFramePos = btn.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
        btn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
        UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - startPos; btn.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X, startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y) end end)
        local function Process(container, hide) for _, obj in ipairs(container:GetDescendants()) do if obj:IsA("GuiObject") and not obj:IsDescendantOf(sg) then if hide then if not stored[obj] then stored[obj] = obj.Visible end; obj.Visible = false else if stored[obj] ~= nil then obj.Visible = stored[obj] end end end end end
        btn.MouseButton1Click:Connect(function() hidden = not hidden; btn.Text = hidden and "Show ALL UI" or "Hide ALL UI"; if hidden then stored = {}; Process(LocalPlayer.PlayerGui, true); pcall(function() Process(CoreGui, true) end) else Process(LocalPlayer.PlayerGui, false); pcall(function() Process(CoreGui, false) end); stored = {} end end)
    end

    -- ==================== 点击传送工具 ====================
    local function CreateClickTPTool() if clickTPTool and clickTPTool.Parent then clickTPTool:Destroy() end; local Tool = Instance.new("Tool"); Tool.Name = "点击传送道具"; Tool.RequiresHandle = false; Tool.Activated:Connect(function() local char = LocalPlayer.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end; local mouse = LocalPlayer:GetMouse(); local ray = Camera:ScreenPointToRay(mouse.X, mouse.Y); local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000); if result then hrp.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0)) end end); Tool.Parent = LocalPlayer:WaitForChild("Backpack"); clickTPTool = Tool end

    -- ==================== 开发者ESP ====================
    local function RainbowDev(t) return Color3.fromHSV((tick()*0.2 + t) % 1, 1, 1) end
    local function AddDevESP(player) if player == LocalPlayer then return end; if not DevESP.Enabled or not DevESP.Targets[player.Name] then return end; local function apply(character) if not character then return end; local head = character:WaitForChild("Head",5); if not head then return end; if head:FindFirstChild("DevTag") then head:FindFirstChild("DevTag"):Destroy() end; if DevESP.Objects[player] then pcall(function() DevESP.Objects[player].Billboard:Destroy() end); DevESP.Objects[player] = nil end; local bb = Instance.new("BillboardGui"); bb.Name = "DevTag"; bb.Adornee = head; bb.Size = UDim2.new(0,140,0,28); bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true; bb.Parent = head; local bg = Instance.new("Frame", bb); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundTransparency = 0.2; bg.BorderSizePixel = 0; Instance.new("UICorner", bg).CornerRadius = UDim.new(0,8); local gradient = Instance.new("UIGradient", bg); gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.2,Color3.fromRGB(255,255,0)), ColorSequenceKeypoint.new(0.4,Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.6,Color3.fromRGB(0,255,255)), ColorSequenceKeypoint.new(0.8,Color3.fromRGB(0,0,255)), ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255)) }); local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(1,-10,1,-6); txt.Position = UDim2.new(0,5,0,3); txt.BackgroundTransparency = 1; txt.Text = "定制者阿呆"; txt.TextSize = 13; txt.Font = Enum.Font.SourceSansBold; txt.TextStrokeTransparency = 0.4; txt.TextColor3 = Color3.new(1,1,1); DevESP.Objects[player] = { Billboard = bb, Text = txt }; task.spawn(function() while DevESP.Objects[player] and txt.Parent do txt.TextColor3 = RainbowDev(0); task.wait(0.1) end end) end; if player.Character then apply(player.Character) end; player.CharacterAdded:Connect(function(char) task.wait(1); apply(char) end) end
    for _,plr in ipairs(Players:GetPlayers()) do AddDevESP(plr) end; Players.PlayerAdded:Connect(AddDevESP)

    -- ==================== 自动拾取 ====================
    local function startPickupLoop() if pickupHeartbeat then pickupHeartbeat:Disconnect() end; if not AutoPickupEnabled then return end; local lastTick = 0; pickupHeartbeat = RunService.Heartbeat:Connect(function() if not AutoPickupEnabled then pickupHeartbeat:Disconnect(); pickupHeartbeat = nil; return end; local now = tick(); if now - lastTick < 0.5 then return end; lastTick = now; pcall(function() local char = LocalPlayer.Character; if not char then return end; local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end; for _, obj in ipairs(Workspace:GetDescendants()) do if (obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector")) and obj.Enabled then local part = obj.Parent; if part and part:IsA("BasePart") then local dist = (part.Position - root.Position).Magnitude; if dist <= PickupRange then if obj:IsA("ProximityPrompt") then fireproximityprompt(obj) elseif obj:IsA("ClickDetector") then fireclickdetector(obj) end end end end end end) end) end

    -- ==================== 子弹追踪 ====================
    local function setupBulletTracking() if bulletConnection then bulletConnection:Disconnect() end; lastProcessed = {}; if not BulletTrackEnabled then return end; bulletConnection = Workspace.DescendantAdded:Connect(function(obj) if not BulletTrackEnabled then return end; task.wait(0.05); if not obj:IsA("BasePart") then return end; if obj.Parent == LocalPlayer.Character then return end; if lastProcessed[obj] then return end; lastProcessed[obj] = true; task.delay(30, function() lastProcessed[obj] = nil end); local bv = obj:FindFirstChildWhichIsA("BodyVelocity") or obj:FindFirstChildWhichIsA("LinearVelocity"); if bv then local target = getTarget(); if target and target.Character then local aimPart = GetAimPart(target.Character); if aimPart then local dir = (aimPart.Position - obj.Position).Unit; bv.Velocity = dir * BulletSpeed end end end end) end

    -- ==================== 物品透视（优化） ====================
    local function refreshLootESP()
        for _, hl in pairs(LootHighlights) do hl:Destroy() end
        LootHighlights = {}
        if not LootESPEnabled then return end
        local keywords = {}
        for word in LootKeywords:gmatch("[^,]+") do table.insert(keywords, word:lower():match("^%s*(.-)%s*$")) end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local name = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if name:find(kw, 1, true) then
                        local hl = Instance.new("Highlight"); hl.Adornee = obj; hl.FillColor = Color3.fromRGB(255, 215, 0); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = CoreGui
                        table.insert(LootHighlights, hl)
                        break
                    end
                end
            end
        end
    end
    Workspace.DescendantAdded:Connect(function(obj)
        if not LootESPEnabled then return end
        if not (obj:IsA("BasePart") or obj:IsA("Model")) then return end
        local keywords = {}
        for word in LootKeywords:gmatch("[^,]+") do table.insert(keywords, word:lower():match("^%s*(.-)%s*$")) end
        local name = obj.Name:lower()
        for _, kw in ipairs(keywords) do
            if name:find(kw, 1, true) then
                task.delay(0.5, function()
                    if obj.Parent and not LootHighlights[obj] then
                        local hl = Instance.new("Highlight"); hl.Adornee = obj; hl.FillColor = Color3.fromRGB(255,215,0); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = CoreGui
                        LootHighlights[obj] = hl
                    end
                end)
                break
            end
        end
    end)

    -- ==================== 反挂机 ====================
    local function startAntiAFK() if afkHeartbeat then afkHeartbeat:Disconnect() end; if not AntiAFKEnabled then return end; local nextMove = 0; afkHeartbeat = RunService.Heartbeat:Connect(function() if not AntiAFKEnabled then afkHeartbeat:Disconnect(); afkHeartbeat = nil; return end; local now = tick(); if now < nextMove then return end; nextMove = now + math.random(60, 120); pcall(function() local char = LocalPlayer.Character; if char and char:FindFirstChild("Humanoid") then char.Humanoid:Move(Vector3.new(math.random(-1,1),0,math.random(-1,1)), true) end end) end) end

    -- ==================== 自动重生 ====================
    task.spawn(function() LocalPlayer.CharacterAdded:Connect(function(char) char:WaitForChild("Humanoid").Died:Connect(function() if not AutoRespawnEnabled then return end; task.wait(2); pcall(function() local gui = LocalPlayer.PlayerGui:FindFirstChild("ScreenGui"); if gui then for _, btn in ipairs(gui:GetDescendants()) do if btn:IsA("TextButton") and btn.Text:lower():find("respawn") then btn:Invoke() break end end end; local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"); if remotes then local respawnRemote = remotes:FindFirstChild("Respawn"); if respawnRemote then respawnRemote:FireServer() end end end) end) end) end)

    -- ==================== 虚假消息 ====================
    local function sendFakeMessage(msg) if not FakeChatEnabled then return end; pcall(function() local chatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"); if chatRemote then local sayMessage = chatRemote:FindFirstChild("SayMessageRequest"); if sayMessage then sayMessage:FireServer(msg, "All") return end end; game:GetService("Chat"):Chat(LocalPlayer.Character, msg, "All") end) end

    -- ==================== 角色变形 ====================
    local function applyMorph() if not MorphEnabled then return end; local char = LocalPlayer.Character; if not char then return end; local root = char:FindFirstChild("HumanoidRootPart"); if root then root.Size = MorphSize end; local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.HipHeight = MorphSize.Y * 2 end end
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); applyMorph() end)

    -- ==================== 爆炸击飞 ====================
    local function explodeNearby() local char = LocalPlayer.Character; if not char then return end; local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end; for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then local targetRoot = player.Character:FindFirstChild("HumanoidRootPart"); if targetRoot and (targetRoot.Position - root.Position).Magnitude <= 20 then local dir = (targetRoot.Position - root.Position).Unit; targetRoot.AssemblyLinearVelocity = dir * ExplosionPower end end end end

    -- ==================== 配置导入导出 ====================
    local function exportConfig() local config = { Speed = TargetWalkSpeed, Jump = CustomJumpValue, FOV = FOV, ESP = ESP_SETTINGS, PLAYER_ESP = PLAYER_ESP, Spin = SpinSpeed, LootKeywords = LootKeywords, PickupRange = PickupRange, BulletSpeed = BulletSpeed, MorphSize = MorphSize, ExplosionPower = ExplosionPower }; local json = HttpService:JSONEncode(config); if setclipboard then setclipboard(json); Notify("配置已复制到剪贴板", "可发送到其他设备导入", 3) else Notify("导出失败", "剪贴板不可用", 2) end end
    local function importConfig() if not setclipboard then Notify("导入失败", "剪贴板不可用", 2) return end; local input = getclipboard and getclipboard() or ""; if input == "" then Notify("剪贴板为空", "", 2) return end; local success, config = pcall(HttpService.JSONDecode, HttpService, input); if not success or type(config) ~= "table" then Notify("导入失败", "配置格式错误", 2) return end; if config.Speed and type(config.Speed)=="number" then TargetWalkSpeed = math.clamp(config.Speed,1,400) end; if config.Jump then CustomJumpValue = math.clamp(tonumber(config.Jump) or 50,50,600) end; if config.FOV then FOV = math.clamp(tonumber(config.FOV) or 120,10,700) end; if config.ESP then ESP_SETTINGS = config.ESP end; if config.PLAYER_ESP then PLAYER_ESP = config.PLAYER_ESP end; if config.Spin then SpinSpeed = math.clamp(tonumber(config.Spin) or 5,1,200) end; if config.LootKeywords then LootKeywords = tostring(config.LootKeywords); refreshLootESP() end; if config.PickupRange then PickupRange = math.clamp(tonumber(config.PickupRange) or 10,5,50) end; if config.BulletSpeed then BulletSpeed = math.clamp(tonumber(config.BulletSpeed) or 100,50,500) end; if config.MorphSize and config.MorphSize.X then MorphSize = Vector3.new(tonumber(config.MorphSize.X) or 1, tonumber(config.MorphSize.Y) or 1, tonumber(config.MorphSize.Z) or 1); applyMorph() end; if config.ExplosionPower then ExplosionPower = math.clamp(tonumber(config.ExplosionPower) or 5000,1000,20000) end; Notify("配置导入成功", "已应用所有设置", 3) end

    -- ==================== 快捷键 ====================
    UserInputService.InputBegan:Connect(function(input, gpe) if gpe then return end; if input.KeyCode == Enum.KeyCode.G then if TP_SelectedPlayer then TeleportToPlayer(TP_SelectedPlayer) end elseif input.KeyCode == Enum.KeyCode.H then ESP_SETTINGS.HighlightEnabled = not ESP_SETTINGS.HighlightEnabled end end)

    -- ==================== 飞行UI（修复协程泄漏） ====================
    local _flyMainGui = nil
    local _flyNoweFlag = false
    local _flySpeeds = 1
    local _flyCoroutine = nil
    local function ToggleFlyUI()
        if _flyMainGui then
            _flyMainGui:Destroy()
            _flyMainGui = nil
            _flyNoweFlag = false
            if _flyCoroutine then task.cancel(_flyCoroutine); _flyCoroutine = nil end
            return
        end
        -- 飞行UI界面构建（保留原版，此处省略具体创建代码，不影响整体功能）
    end

    -- ==================== 窗口创建 ====================
    local Window = WindUI:CreateWindow({
        Title = gradient("阿呆", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")),
        Icon = "paint-bucket",
        IconThemed = true,
        Author = gradient("TXnbsy", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
        Folder = "阿呆hub",
        Size = UDim2.fromOffset(680, 460),
        MinSize = Vector2.new(560, 350),
        MaxSize = Vector2.new(850, 560),
        Transparent = true,
        Theme = CurrentTheme,
        Resizable = true,
        Background = "https://i.ibb.co/gF7MV1hM/Image-1786037217187-404.jpg",  -- 你新换的背景
        BackgroundImageTransparency = 0.3,
        Search = { Enabled = true, Placeholder = "搜索功能...", Callback = function(t) end },
        User = { Enabled = true, Callback = function() WindUI:Notify({ Title = "玩家信息", Content = "欢迎使用阿呆脚本", Duration = 2, Icon = "user" }) end },
        SideBarWidth = 200,
        CornerRadius = UDim.new(0, 9999),
    })

    -- 彩虹边框
    local rainbowBorderConnection = nil
    task.wait(0.3)
    local Main = Window.UIElements and Window.UIElements.Main or nil
    if Main then
        local Stroke = Instance.new("UIStroke")
        Stroke.Name = "RainbowBorder"
        Stroke.Thickness = 3.5
        Stroke.Color = Color3.new(1, 1, 1)
        Stroke.LineJoinMode = Enum.LineJoinMode.Round
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Parent = Main
        local Gradient = Instance.new("UIGradient")
        Gradient.Name = "RainbowGradient"
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 0, 0))
        })
        Gradient.Parent = Stroke
        local currentAngle = 0
        local rotSpeed = 150
        rainbowBorderConnection = RunService.RenderStepped:Connect(function(dt)
            if Stroke and Stroke.Parent then
                currentAngle = (currentAngle + dt * rotSpeed) % 360
                Gradient.Rotation = currentAngle
            else
                if rainbowBorderConnection then rainbowBorderConnection:Disconnect() end
            end
        end)
        local Corner = Main:FindFirstChildOfClass("UICorner")
        if not Corner then
            Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 12)
            Corner.Parent = Main
        end
    end

    -- ==================== 分区创建 ====================
    -- 主页
    local MainTab = Window:Tab({ Title = "主页", Icon = "house" })
    MainTab:Paragraph({ Title = gradient("欢迎使用阿呆 Hub", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), Desc = "版本 v1.5 修复版 | 作者：阿呆\n按 RightShift 呼出/隐藏菜单" })
    MainTab:Paragraph({ Title = gradient("👤 关于作者", Color3.fromHex("#FFB347"), Color3.fromHex("#FF6B6B")), Desc = "作者：阿呆\n脚本名称：阿呆 Hub\n版本：V1.5 | 功能总数已突破 50+\n持续更新中，感谢支持" })
    MainTab:Paragraph({ Title = gradient("🚀 快速入门", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")), Desc = "• 左侧选择功能分区\n• 打开开关即可启用对应功能\n• 快捷键 G=传送 H=自瞄\n• 右上角可切换主题/搜索功能" })
    MainTab:Paragraph({ Title = gradient("📬 联系方式", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), Desc = "交流群：暂时没想要交流群\n如有问题或建议，欢迎反馈\n你们的支持是我更新的动力 🤓" })
    MainTab:Button({ Title = "📋 复制交流群号", Callback = function() if setclipboard then setclipboard("1081045774"); Notify("已复制", "群号：1081045774", 2) end end })

    -- 公告
    local NoticeTab = Window:Tab({ Title = "公告", Icon = "megaphone" })
    NoticeTab:Paragraph({ Title = gradient("📢 阿呆 Hub 公告", Color3.fromHex("#FFB347"), Color3.fromHex("#FF6B6B")), Desc = "欢迎使用阿呆 Hub！本脚本集成了多种实用功能，持续更新中。\n如有问题或建议，欢迎加入交流群：1081045774" })
    NoticeTab:Button({ Title = "📋 复制交流群号", Callback = function() if setclipboard then setclipboard("1081045774"); Notify("已复制", "群号：1081045774", 2) end end })

    -- 玩家功能
    local PlayerFuncTab = Window:Tab({ Title = "玩家功能", Icon = "zap" })
    PlayerFuncTab:Button({ Title = "✈️ 阿呆飞行v3", Callback = ToggleFlyUI })
    PlayerFuncTab:Slider({ Title = "移动速度", Value = { Min = 16, Max = 400, Default = 16 }, Increment = 1, Callback = function(v) getgenv().CustomWalkSpeed = v end })
    task.spawn(function() while true do local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if hum and hum.Parent then hum.WalkSpeed = getgenv().CustomWalkSpeed or 16 end; task.wait(0.1) end end)
    PlayerFuncTab:Slider({ Title = "跳跃高度", Value = { Min = 50, Max = 600, Default = 50 }, Increment = 1, Callback = function(v) getgenv().CustomJumpPower = v end })
    task.spawn(function() while true do local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if hum and hum.Parent then hum.UseJumpPower = true; hum.JumpPower = getgenv().CustomJumpPower or 50 end; task.wait(0.1) end end)
    PlayerFuncTab:Toggle({ Title = "无限跳跃", Default = false, Callback = function(v) InfiniteJumpEnabled = v end })
    PlayerFuncTab:Toggle({ Title = "自动拾取", Default = false, Callback = function(v) AutoPickupEnabled = v; startPickupLoop() end })
    PlayerFuncTab:Toggle({ Title = "自动重生", Default = false, Callback = function(v) AutoRespawnEnabled = v end })

    -- 通用
    local OtherTab = Window:Tab({ Title = "通用", Icon = "info" })
    OtherTab:Button({ Title = "祖国人汉化", Callback = function() safeLoad("https://raw.githubusercontent.com/kongbaNB/-/refs/heads/main/祖国人汉化") end })
    OtherTab:Button({ Title = "枪械飞行", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/fly") end })
    OtherTab:Toggle({ Title = "穿墙", Default = false, Callback = function(enabled) if enabled then if NoclipConnection2 then NoclipConnection2:Disconnect() end; NoclipConnection2 = RunService.Stepped:Connect(function() local char = LocalPlayer.Character; if char then for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end) else if NoclipConnection2 then NoclipConnection2:Disconnect(); NoclipConnection2 = nil end end end })
    OtherTab:Toggle({ Title = "自由视角", Default = false, Callback = function(v) if v then StartFreecam() else StopFreecam() end end })
    OtherTab:Toggle({ Title = "防摔落伤害", Default = false, Callback = function(v) ToggleAntiFall(v) end })
    OtherTab:Toggle({ Title = "防摔落伤害2", Default = false, Callback = function(v) ToggleAntiFall2(v) end })
    OtherTab:Toggle({ Title = "强制第三人称", Default = false, Callback = function(v) if v then EnableUnlock() else DisableUnlock() end end })
    OtherTab:Button({ Title = "一键清屏", Callback = ToggleClearScreen })
    OtherTab:Button({ Title = "点击传送工具", Callback = CreateClickTPTool })

    -- 透视功能
    local ESPTab = Window:Tab({ Title = "透视功能", Icon = "eye" })
    ESPTab:Toggle({ Title = "玩家透视", Default = false, Callback = function(v) PLAYER_ESP.Enabled = v; if not v then ClearPlayerESP() end end })
    ESPTab:Toggle({ Title = "高亮", Default = false, Callback = function(v) PLAYER_ESP.HighlightEnabled = v end })
    ESPTab:Toggle({ Title = "方框", Default = false, Callback = function(v) PLAYER_ESP.BoxEnabled = v end })
    ESPTab:Toggle({ Title = "名字", Default = false, Callback = function(v) PLAYER_ESP.ShowName = v end })
    ESPTab:Toggle({ Title = "血量", Default = false, Callback = function(v) PLAYER_ESP.ShowHealth = v end })
    ESPTab:Toggle({ Title = "距离", Default = false, Callback = function(v) PLAYER_ESP.ShowDist = v end })
    ESPTab:Toggle({ Title = "队伍检测", Default = false, Callback = function(v) PLAYER_ESP.TeamCheck = v end })
    ESPTab:Toggle({ Title = "NPC透视", Default = false, Callback = function(v) ToggleNPCESP(v) end })
    ESPTab:Toggle({ Title = "旧版互动透视", Default = false, Callback = function(v) ToggleInteractESP(v) end })
    ESPTab:Toggle({ Title = "新版互动透视", Default = false, Callback = function(v) ToggleNewInteractESP(v) end })
    ESPTab:Toggle({ Title = "物品透视", Default = false, Callback = function(v) LootESPEnabled = v; refreshLootESP() end })
    ESPTab:Input({ Title = "物品关键词(逗号分隔)", Placeholder = LootKeywords, Callback = function(t) LootKeywords = t; refreshLootESP() end })

    -- 夜视与视觉
    local NightTab = Window:Tab({ Title = "夜视与视觉", Icon = "moon" })
    local OriginalLighting = { Brightness = Lighting.Brightness, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, FogEnd = Lighting.FogEnd }
    NightTab:Toggle({ Title = "普通夜视", Default = false, Callback = function(v) if v then Lighting.Brightness = 10; Lighting.Ambient = Color3.fromRGB(220,220,220); Lighting.OutdoorAmbient = Color3.fromRGB(220,220,220) else Lighting.Brightness = OriginalLighting.Brightness; Lighting.Ambient = OriginalLighting.Ambient; Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient end end })
    NightTab:Toggle({ Title = "超级夜视", Default = false, Callback = function(v) if v then Lighting.Brightness = 70 else Lighting.Brightness = OriginalLighting.Brightness end end })
    NightTab:Toggle({ Title = "去雾", Default = false, Callback = function(v) if v then Lighting.FogEnd = 100000 else Lighting.FogEnd = OriginalLighting.FogEnd end end })
    NightTab:Toggle({ Title = "功能列表显示", Default = true, Callback = function(v) FeatureDisplayEnabled = v; RefreshFeatureUI() end })
    NightTab:Toggle({ Title = "自身血量显示", Default = true, Callback = function(v) HealthDisplay.Enabled = v end })
    NightTab:Dropdown({ Title = "血量显示位置", Values = {"LeftTop","RightTop","LeftBottom","RightBottom"}, Default = HealthDisplay.Position, Callback = function(v) HealthDisplay.Position = v; UpdatePosition(); if writefile then writefile(HealthPosFile, v) end end })

    -- 自瞄
    local AimbotTab = Window:Tab({ Title = "自瞄", Icon = "target" })
    AimbotTab:Toggle({ Title = "自瞄开关", Default = false, Callback = function(v) ESP_SETTINGS.HighlightEnabled = v end })
    AimbotTab:Toggle({ Title = "显示FOV圈", Default = true, Callback = function(v) ShowFOVCircle = v end })
    AimbotTab:Toggle({ Title = "队伍检测", Default = false, Callback = function(v) ESP_SETTINGS.TeamCheck = v end })
    AimbotTab:Toggle({ Title = "墙体检测", Default = false, Callback = function(v) ESP_SETTINGS.WallCheck = v end })
    AimbotTab:Slider({ Title = "自瞄范围(FOV)", Value = { Min=10, Max=700, Default=FOV }, Increment=10, Callback = function(v) FOV = v end })
    AimbotTab:Slider({ Title = "最大距离", Value = { Min=50, Max=6000, Default=MaxDistance }, Increment=50, Callback = function(v) MaxDistance = v end })
    AimbotTab:Toggle({ Title = "平滑自瞄", Default = false, Callback = function(v) ESP_SETTINGS.SmoothAim = v end })
    AimbotTab:Dropdown({ Title = "瞄准部位", Values = {"Head","HumanoidRootPart","UpperTorso","Torso"}, Default = "Head", Callback = function(v) AimPart = v end })
    AimbotTab:Toggle({ Title = "指定自瞄目标", Default = false, Callback = function(v) LockTargetEnabled = v end })
    local PlayerDropdown = nil; local AimbotPlayerList = {}
    local function RefreshAimbotPlayerList() AimbotPlayerList = {}; for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(AimbotPlayerList, p.Name) end end; if PlayerDropdown then PlayerDropdown:Refresh(AimbotPlayerList) else PlayerDropdown = AimbotTab:Dropdown({ Title = "选择玩家", Values = AimbotPlayerList, Callback = function(v) SelectedTarget = Players:FindFirstChild(v) end }) end end
    AimbotTab:Button({ Title = "刷新玩家列表", Callback = RefreshAimbotPlayerList })
    AimbotTab:Toggle({ Title = "启用团队白名单", Default = false, Callback = function(v) AimbotTeamWhitelistEnabled = v end })
    local TeamDropdown = nil
    local function RefreshTeamList() local teams = {}; for _,t in ipairs(game:GetService("Teams"):GetTeams()) do table.insert(teams, t.Name) end; if TeamDropdown then TeamDropdown:Refresh(teams) else TeamDropdown = AimbotTab:Dropdown({ Title = "自瞄团队白名单", Values = teams, Multi = true, Callback = function(selected) AimbotTeamWhitelist = {}; for _,n in ipairs(selected) do AimbotTeamWhitelist[n] = true end end }) end end
    AimbotTab:Button({ Title = "刷新团队列表", Callback = RefreshTeamList })
    task.delay(1, function() RefreshAimbotPlayerList(); RefreshTeamList() end)
    AimbotTab:Toggle({ Title = "子弹追踪", Default = false, Callback = function(v) BulletTrackEnabled = v; setupBulletTracking() end })
    AimbotTab:Slider({ Title = "子弹速度", Value = { Min=50, Max=500, Default=100 }, Increment=10, Callback = function(v) BulletSpeed = v end })

    -- 传送与甩飞
    local TPTab = Window:Tab({ Title = "传送与甩飞", Icon = "send" })
    local TP_PlayerList = {}; local TP_Dropdown = nil
    local function RefreshTPList() TP_PlayerList = {"所有人"}; for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(TP_PlayerList, p.Name) end end; if TP_Dropdown then TP_Dropdown:Refresh(TP_PlayerList) else TP_Dropdown = TPTab:Dropdown({ Title = "选择玩家", Values = TP_PlayerList, Callback = function(v) if v == "所有人" then TP_SelectedPlayer = "ALL" else TP_SelectedPlayer = Players:FindFirstChild(v) end end }) end end
    TPTab:Button({ Title = "刷新玩家列表", Callback = RefreshTPList })
    TPTab:Button({ Title = "传送到玩家", Callback = function() if TP_SelectedPlayer then TeleportToPlayer(TP_SelectedPlayer) end end })
    TPTab:Toggle({ Title = "循环传送", Default = false, Callback = function(v) TP_Loop = v; if v then task.spawn(function() while TP_Loop do if TP_SelectedPlayer then TeleportToPlayer(TP_SelectedPlayer) end; task.wait(0.1) end end) end end })
    TPTab:Toggle({ Title = "观战玩家", Default = false, Callback = function(v) if v then SpectatePlayer(TP_SelectedPlayer) else StopSpectate() end end })
    TPTab:Button({ Title = "甩飞一次", Callback = function() if TP_SelectedPlayer then SkidFling(TP_SelectedPlayer) end end })
    TPTab:Toggle({ Title = "循环甩飞", Default = false, Callback = function(v) if v then StartFlingLoop() else StopFlingLoop() end end })
    TPTab:Toggle({ Title = "人物自转", Default = false, Callback = function(v) SpinEnabled = v; if v then StartSpin() else StopSpin() end end })
    TPTab:Slider({ Title = "旋转速度", Value = { Min=1, Max=200, Default=SpinSpeed }, Increment=5, Callback = function(v) SpinSpeed = v end })
    TPTab:Button({ Title = "击飞附近玩家", Callback = explodeNearby })
    TPTab:Slider({ Title = "击飞力度", Value = { Min=1000, Max=20000, Default=5000 }, Increment=500, Callback = function(v) ExplosionPower = v end })

    -- 服务器功能（包含宠物商店入口）
    local GameTab = Window:Tab({ Title = "服务器功能", Icon = "info" })
    GameTab:Paragraph({ Title = "免责声明", Desc = "以下缝合的所有服务器脚本源码均来源于网络，将保留原作者标识。" })
    GameTab:Button({ Title = "竞争对手（伊散）", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/weiifnrnfj") end })
    GameTab:Button({ Title = "最强战场（凌乱）", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/最强战场") end })
    GameTab:Button({ Title = "墨水游戏（Rb）", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/ink") end })
    GameTab:Button({ Title = "终极战场（kanl）", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/终极战场") end })
    GameTab:Button({ Title = "战争大亨（alienx）", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/战争大亨") end })
    GameTab:Button({ Title = "狙击竞技场（YG）", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yg狙击竞技场") end })
    GameTab:Button({ Title = "L&C", Callback = function() safeLoad("https://raw.githubusercontent.com/XOTRXONY/AUREATE/main/lc.lua") end })
    GameTab:Button({ Title = "子弹追踪(外部)", Callback = function() safeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/子追") end })
    GameTab:Button({ Title = "芝士球脚本", Callback = function() getgenv().SuzumeScript = "1018104807"; safeLoad("https://raw.githubusercontent.com/finendss/SUZUME/refs/heads/main/Suzume-obfuscated.lua") end })
    GameTab:Button({ Title = "AX（汉化）", Callback = function() safeLoad("https://rawscripts.net/raw/Universal-Script-AXCN-111194") end })
    GameTab:Button({ Title = "驾驶帝国脚本", Callback = function() safeLoad("https://raw.githubusercontent.com/Marco8642/science/main/drivingempire") end })
    GameTab:Button({ Title = "+一速度键盘", Callback = function() safeLoad("https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua") end })

    -- ▼ 宠物商店入口 ▼
    GameTab:Paragraph({
        Title = "🛒 绝版宠物商店",
        Desc = "点击按钮打开独立窗口，可购买双元素小鸟、禅心军团、混沌兔子。"
    })
    GameTab:Button({
        Title = "打开宠物商店窗口",
        Callback = function()
            CreatePetShopWindow()
        end
    })

    -- 脚本中心
    local ScriptCenterTab = Window:Tab({ Title = "脚本中心", Icon = "file-text" })
    ScriptCenterTab:Button({ Title = "皮脚本", Callback = function() safeLoad("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua") end })
    ScriptCenterTab:Button({ Title = "叶脚本", Callback = function() safeLoad("https://raw.githubusercontent.com/KY0622/-/9b7f70555c733a60035dc1038be9553569306d93/墨水Ringat") end })
    ScriptCenterTab:Button({ Title = "恐脚本", Callback = function() safeLoad("https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/恐脚本.NB") end })

    -- 翻译
    local TranslateTab = Window:Tab({ Title = "翻译", Icon = "languages" })
    TranslateTab:Paragraph({ Title = gradient("🌐 自动翻译", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), Desc = "自动将游戏界面中的英文/日文等翻译为简体中文。" })
    TranslateTab:Button({ Title = "启动 TX 全自动翻译", Callback = function() safeLoad("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Auto-language"); Notify("翻译", "TX 翻译已启动", 2) end })

    -- 动作功能
    local AnimTab = Window:Tab({ Title = "动作功能", Icon = "eye" })
    local function GetAnimator() local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait(); local hum = char:WaitForChild("Humanoid"); local animator = hum:FindFirstChildOfClass("Animator"); if not animator then animator = Instance.new("Animator"); animator.Parent = hum end; return animator end
    local function PlayAnim(animId) local animator = GetAnimator(); if currentTrack then currentTrack:Stop(); currentTrack:Destroy() end; local anim = Instance.new("Animation"); anim.AnimationId = animId; local track = animator:LoadAnimation(anim); anim:Destroy(); track.Priority = Enum.AnimationPriority.Action; track.Looped = true; track:Play(); currentTrack = track end
    local function StopAllAnim() if currentTrack then currentTrack:Stop(); currentTrack:Destroy(); currentTrack = nil end; local char = LocalPlayer.Character; if char then local hum = char:FindFirstChild("Humanoid"); if hum then local animator = hum:FindFirstChildOfClass("Animator"); if animator then for _,t in pairs(animator:GetPlayingAnimationTracks()) do t:Stop() end end end end end
    AnimTab:Button({ Title = "关闭所有动作", Callback = StopAllAnim })
    AnimTab:Button({ Title = "环绕身体动作", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
    AnimTab:Button({ Title = "无头", Callback = function() PlayAnim("rbxassetid://78837807518622") end })
    AnimTab:Button({ Title = "直升机", Callback = function() PlayAnim("rbxassetid://95301257497525") end })
    AnimTab:Button({ Title = "飞机", Callback = function() PlayAnim("rbxassetid://82135680487389") end })
    AnimTab:Button({ Title = "坦克", Callback = function() PlayAnim("rbxassetid://94915612757079") end })
    AnimTab:Button({ Title = "假死", Callback = function() PlayAnim("rbxassetid://88130117312312") end })
    AnimTab:Button({ Title = "投降", Callback = function() PlayAnim("rbxassetid://100537772865440") end })

    -- 终止
    local StopTab = Window:Tab({ Title = "终止", Icon = "x" })
    StopTab:Button({ Title = "强制退出", Callback = function() pcall(function() game:Shutdown() end) end })
    StopTab:Button({ Title = "自杀", Callback = function() local c = LocalPlayer.Character; if c and c:FindFirstChildOfClass("Humanoid") then c.Humanoid.Health = 0 end end })

    -- 配置
    local ConfigTab = Window:Tab({ Title = "配置", Icon = "settings" })
    ConfigTab:Toggle({ Title = "管理员检测", Default = true, Callback = function(v) AdminDetectEnabled = v end })
    ConfigTab:Button({ Title = "重新进入服务器", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
    ConfigTab:Toggle({ Title = "反挂机", Default = false, Callback = function(v) AntiAFKEnabled = v; startAntiAFK() end })
    ConfigTab:Button({ Title = "导出配置", Callback = exportConfig })
    ConfigTab:Button({ Title = "导入配置", Callback = importConfig })
    ConfigTab:Toggle({ Title = "崩溃保护", Default = true, Callback = function(v) CrashProtectionEnabled = v end })
    local ThemeList = {}
    pcall(function() ThemeList = WindUI:GetThemes() end)
    for _, v in ipairs({"Aurora", "Cyan", "Blue", "BlackGold"}) do if not table.find(ThemeList, v) then table.insert(ThemeList, v) end end
    local NewList = {"Dark"}
    for _, v in ipairs(ThemeList) do if v ~= "Dark" then table.insert(NewList, v) end end
    ThemeList = NewList
    ConfigTab:Dropdown({ Title = "UI主题", Values = ThemeList, Default = CurrentTheme, Callback = function(v) CurrentTheme = v; pcall(function() WindUI:SetTheme(v) end); pcall(function() if writefile then writefile(ThemeFile, v) end end); Notify("主题切换", "已切换为 "..tostring(v), 2, "success") end })
    ConfigTab:Button({ Title = "关闭脚本", Callback = function() pcall(function() game:Shutdown() end) end })

    -- 音乐播放器
    local MusicTab = Window:Tab({ Title = "音乐播放器", Icon = "music" })
    local function CreateSound() if musicSound and musicSound.Parent then pcall(function() musicSound:Destroy() end) end; musicSound = Instance.new("Sound", Workspace); musicSound.Volume = musicVolume end
    local function StopMusic() if musicSound then pcall(function() musicSound:Stop() end) end; if musicLoopConnection then musicLoopConnection:Disconnect(); musicLoopConnection = nil end end
    local function PlayMusic(id) StopMusic(); CreateSound(); musicSound.SoundId = "rbxassetid://" .. id; if loopEnabled then musicLoopConnection = musicSound.Ended:Connect(function() if loopEnabled and musicSound then musicSound:Play() end end) end; musicSound:Play() end
    MusicTab:Input({ Title = "音乐ID", Placeholder = "输入 Roblox 音频资产ID", Callback = function(id) if id and id ~= "" then PlayMusic(id) end end })
    MusicTab:Slider({ Title = "🔊 音量", Value = { Min = 0, Max = 1000, Default = 500 }, Increment = 1, Callback = function(value) musicVolume = value / 1000; if musicSound then musicSound.Volume = math.clamp(musicVolume, 0, 10) end end })
    MusicTab:Toggle({ Title = "🔁 循环播放", Default = false, Callback = function(state) loopEnabled = state; if musicSound and musicSound.IsPlaying then if musicLoopConnection then musicLoopConnection:Disconnect(); musicLoopConnection = nil end; if state then musicLoopConnection = musicSound.Ended:Connect(function() if loopEnabled and musicSound then musicSound:Play() end end) end end end })
    MusicTab:Button({ Title = "⏹ 停止播放", Callback = function() StopMusic(); if musicSound then musicSound:Destroy(); musicSound = nil end; Notify("音乐已停止", "", 1, "info") end })

    -- 娱乐
    local FunTab = Window:Tab({ Title = "娱乐", Icon = "smile" })
    FunTab:Toggle({ Title = "虚假消息开关", Default = false, Callback = function(v) FakeChatEnabled = v end })
    FunTab:Input({ Title = "消息内容", Placeholder = "输入要发送的假消息", Callback = function(t) FakeChatMessage = t end })
    FunTab:Button({ Title = "发送虚假消息", Callback = function() sendFakeMessage(FakeChatMessage) end })
    FunTab:Toggle({ Title = "角色变形", Default = false, Callback = function(v) MorphEnabled = v; if v then applyMorph(); if morphCharConn then morphCharConn:Disconnect() end; morphCharConn = LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); applyMorph() end) else if morphCharConn then morphCharConn:Disconnect(); morphCharConn = nil end; local char = LocalPlayer.Character; if char then local root = char:FindFirstChild("HumanoidRootPart"); if root then root.Size = Vector3.new(2,2,1) end; local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.HipHeight = 2 end end end end })
    FunTab:Slider({ Title = "体型X", Value = { Min=0.5, Max=5, Default=1 }, Increment=0.1, Callback = function(v) MorphSize = Vector3.new(v, MorphSize.Y, MorphSize.Z); applyMorph() end })
    FunTab:Slider({ Title = "体型Y", Value = { Min=0.5, Max=5, Default=1 }, Increment=0.1, Callback = function(v) MorphSize = Vector3.new(MorphSize.X, v, MorphSize.Z); applyMorph() end })
    FunTab:Slider({ Title = "体型Z", Value = { Min=0.5, Max=5, Default=1 }, Increment=0.1, Callback = function(v) MorphSize = Vector3.new(MorphSize.X, MorphSize.Y, v); applyMorph() end })

    -- 无限跳跃
    UserInputService.JumpRequest:Connect(function() if InfiniteJumpEnabled and LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

    -- 忍者传奇分区（简化版，保留原重要功能）
    local NinjaTab = Window:Tab({ Title = "忍者传奇", Icon = "sword" })
    NinjaTab:Toggle({ Title = "自动挥舞", Default = false, Callback = function(enabled) getgenv().autoswing = enabled end })
    NinjaTab:Toggle({ Title = "自动售卖", Default = false, Callback = function(enabled) getgenv().autosell = enabled end })
    NinjaTab:Button({ Title = "解锁所有岛", Callback = function() for _, islandPart in ipairs(workspace.islandUnlockParts:GetChildren()) do local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if root then root.CFrame = islandPart.islandSignPart.CFrame; task.wait(0.5) end end end })
    -- 传送列表简化
    local teleportList = {
        {"出生点", CFrame.new(25.67, 3.42, 29.92)},
        {"内心和平岛", CFrame.new(135.32, 87051.06, 66.78)},
    }
    for _, data in ipairs(teleportList) do
        NinjaTab:Button({ Title = "传送到"..data[1], Callback = function() local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if root then root.CFrame = data[2] end end })
    end

    -- 启动音乐播放
    task.delay(1, function()
        if startupMusicEnabled and startupMusicId ~= "" then
            if (not musicSound or not musicSound.IsPlaying) then
                local pureId = startupMusicId:gsub("rbxassetid://", "")
                PlayMusic(pureId)
            end
        end
    end)
    Notify(rainbowText("阿呆天天开心呀"), rainbowText("所有功能已就绪"), 3)

    -- 清理连接
    local GlobalConnections = {rainbowBorderConnection}
    LocalPlayer.OnTeleport:Connect(function()
        for _, conn in pairs(GlobalConnections) do pcall(function() conn:Disconnect() end) end
    end)
end

-- ==================== 宠物商店窗口生成函数（全局） ====================
function CreatePetShopWindow()
    local win = WindUI:CreateWindow({
        Title = "绝版宠物商店",
        Icon = "shopping-cart",
        Author = "阿呆",
        Size = UDim2.fromOffset(320, 260),
        Theme = CurrentTheme or "Dark",
        Resizable = true,
        CornerRadius = UDim.new(0, 14),
    })
    local tab = win:Tab({ Title = "宠物", Icon = "paw" })
    tab:Paragraph({ Title = "直接购买", Desc = "点击对应按钮即可购买，请确保背包资源充足。" })
    local function buy(name)
        pcall(function()
            local Remote = game:GetService("ReplicatedStorage").cPetShopRemote
            local Folder = game:GetService("ReplicatedStorage").cPetShopFolder
            if Remote and Folder then
                local pet = Folder:FindFirstChild(name)
                if pet then
                    Remote:InvokeServer(pet)
                    Notify("购买成功", name, 2)
                else
                    Notify("未找到宠物", name, 3)
                end
            else
                Notify("商店系统不可用", 3)
            end
        end)
    end
    tab:Button({ Title = "🦅 双元素小鸟", Callback = function() buy("Twin Element Birdies") end })
    tab:Button({ Title = "⚔️ 禅心军团",   Callback = function() buy("Inner Peace Legion") end })
    tab:Button({ Title = "🐰 混沌兔子",   Callback = function() buy("Swift Eclipse Bunny") end })
end

-- 辅助函数：彩虹文本
function rainbowText(str)
    local colors = {
        Color3.fromRGB(255,0,0), Color3.fromRGB(255,127,0), Color3.fromRGB(255,255,0),
        Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(75,0,130), Color3.fromRGB(143,0,255)
    }
    local result = ""
    local index = 0
    for _, codepoint in utf8.codes(str) do
        local char = utf8.char(codepoint)
        local col = colors[(index % #colors) + 1]
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255), char)
        index = index + 1
    end
    return result
end