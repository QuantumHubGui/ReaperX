local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local SolarIcons = {}
pcall(function()
    SolarIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))()
end)

local function GetIcon(name)
    if not name or name == "" or name == 0 then return "" end
    local str = tostring(name)
    if type(name) == "number" or str:match("^%d+$") then
        return "rbxassetid://" .. str
    end
    if str:find("rbxassetid://") or str:find("http://") or str:find("https://") then
        return str
    end
    if SolarIcons and SolarIcons[str] then
        return SolarIcons[str]
    end
    return str
end

local function MakeDraggable(gui, handle)
    handle = handle or gui
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local Lighting = game:GetService("Lighting")

local function PlayIntroAnimation(screenGui, titleText, subText, onComplete)
    local IntroBlur
    pcall(function()
        IntroBlur = Instance.new("BlurEffect")
        IntroBlur.Name = "CloudyIntroBlur_" .. math.random(1000, 9999)
        IntroBlur.Size = 0
        IntroBlur.Parent = Lighting
        TweenService:Create(IntroBlur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 12 }):Play()
    end)

    -- Fullscreen canvas with ZERO dark background (100% transparent)
    local IntroCanvas = Instance.new("Frame")
    IntroCanvas.Name = "IntroCanvas"
    IntroCanvas.Size = UDim2.new(1, 0, 1, 0)
    IntroCanvas.Position = UDim2.new(0, 0, 0, 0)
    IntroCanvas.BackgroundTransparency = 1
    IntroCanvas.ClipsDescendants = false
    IntroCanvas.ZIndex = 100
    IntroCanvas.Parent = screenGui

    local function CreateRealisticCloud(parent, scale)
        scale = scale or 1
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0, math.floor(130 * scale), 0, math.floor(80 * scale))
        Container.BackgroundTransparency = 1
        Container.AnchorPoint = Vector2.new(0.5, 0.5)
        Container.ZIndex = 110

        -- Drop Shadow Group
        local ShadowGroup = Instance.new("Frame")
        ShadowGroup.Size = UDim2.new(1, 0, 1, 0)
        ShadowGroup.Position = UDim2.new(0, math.floor(5 * scale), 0, math.floor(7 * scale))
        ShadowGroup.BackgroundTransparency = 1
        ShadowGroup.ZIndex = 112
        ShadowGroup.Parent = Container

        local function AddShadowPuff(size, pos, isCircle)
            local p = Instance.new("Frame")
            p.Size = size
            p.Position = pos
            p.BackgroundColor3 = Color3.fromRGB(10, 14, 25)
            p.BackgroundTransparency = 0.55
            p.BorderSizePixel = 0
            p.ZIndex = 112
            p.Parent = ShadowGroup

            local c = Instance.new("UICorner")
            c.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, math.floor(12 * scale))
            c.Parent = p
        end

        AddShadowPuff(UDim2.new(0.9, 0, 0.45, 0), UDim2.new(0.05, 0, 0.45, 0), false)
        AddShadowPuff(UDim2.new(0.48, 0, 0.72, 0), UDim2.new(0.06, 0, 0.15, 0), true)
        AddShadowPuff(UDim2.new(0.58, 0, 0.88, 0), UDim2.new(0.28, 0, 0, 0), true)
        AddShadowPuff(UDim2.new(0.45, 0, 0.65, 0), UDim2.new(0.52, 0, 0.22, 0), true)

        -- Main Body Puff Group
        local BodyGroup = Instance.new("Frame")
        BodyGroup.Size = UDim2.new(1, 0, 1, 0)
        BodyGroup.BackgroundTransparency = 1
        BodyGroup.ZIndex = 113
        BodyGroup.Parent = Container

        local function AddBodyPuff(size, pos, isCircle)
            local p = Instance.new("Frame")
            p.Size = size
            p.Position = pos
            p.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
            p.BackgroundTransparency = 0
            p.BorderSizePixel = 0
            p.ZIndex = 114
            p.Parent = BodyGroup

            local c = Instance.new("UICorner")
            c.CornerRadius = isCircle and UDim.new(1, 0) or UDim.new(0, math.floor(12 * scale))
            c.Parent = p

            local g = Instance.new("UIGradient")
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 225, 240)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(140, 148, 168)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(70, 75, 95))
            })
            g.Rotation = 65
            g.Parent = p

            local s = Instance.new("UIStroke")
            s.Color = Color3.fromRGB(80, 88, 110)
            s.Thickness = 1.2
            s.Parent = p
        end

        AddBodyPuff(UDim2.new(0.9, 0, 0.45, 0), UDim2.new(0.05, 0, 0.45, 0), false)
        AddBodyPuff(UDim2.new(0.48, 0, 0.72, 0), UDim2.new(0.06, 0, 0.15, 0), true)
        AddBodyPuff(UDim2.new(0.58, 0, 0.88, 0), UDim2.new(0.28, 0, 0, 0), true)
        AddBodyPuff(UDim2.new(0.45, 0, 0.65, 0), UDim2.new(0.52, 0, 0.22, 0), true)

        Container.Parent = parent
        return Container
    end

    local CenterCloudGroup = Instance.new("Frame")
    CenterCloudGroup.Name = "CenterCloudGroup"
    CenterCloudGroup.Size = UDim2.new(0, 260, 0, 150)
    CenterCloudGroup.Position = UDim2.new(0.5, 0, 0.5, 0)
    CenterCloudGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CenterCloudGroup.BackgroundTransparency = 1
    CenterCloudGroup.ZIndex = 110
    CenterCloudGroup.Parent = IntroCanvas

    -- 3 Main Clouds
    local Cloud1 = CreateRealisticCloud(CenterCloudGroup, 1.15)
    Cloud1.Position = UDim2.new(-1.2, 0, -1.2, 0)
    Cloud1.Rotation = -35

    local Cloud2 = CreateRealisticCloud(CenterCloudGroup, 1.25)
    Cloud2.Position = UDim2.new(2.2, 0, -1.0, 0)
    Cloud2.Rotation = 40

    local Cloud3 = CreateRealisticCloud(CenterCloudGroup, 1.05)
    Cloud3.Position = UDim2.new(-0.8, 0, 2.2, 0)
    Cloud3.Rotation = -25

    local Target1 = UDim2.new(0.30, 0, 0.45, 0)
    local Target2 = UDim2.new(0.70, 0, 0.35, 0)
    local Target3 = UDim2.new(0.50, 0, 0.65, 0)

    local TextHolder = Instance.new("Frame")
    TextHolder.Name = "TextHolder"
    TextHolder.Size = UDim2.new(0, 240, 0, 70)
    TextHolder.Position = UDim2.new(0.5, 30, 0.5, -35)
    TextHolder.BackgroundTransparency = 1
    TextHolder.ZIndex = 120
    TextHolder.Parent = IntroCanvas

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, 0, 0, 44)
    TitleLbl.Position = UDim2.new(0, -40, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = string.upper(titleText or "CLOUDY")
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 40
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextTransparency = 1
    TitleLbl.ZIndex = 121
    TitleLbl.Parent = TextHolder

    local TitleGrad = Instance.new("UIGradient")
    TitleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 225, 240)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(140, 148, 168)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(70, 75, 95))
    })
    TitleGrad.Rotation = 0
    TitleGrad.Parent = TitleLbl

    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size = UDim2.new(1, 0, 0, 22)
    SubLbl.Position = UDim2.new(0, -40, 0, 44)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = subText or "UI Framework"
    SubLbl.TextColor3 = Color3.fromRGB(160, 168, 185)
    SubLbl.Font = Enum.Font.GothamMedium
    SubLbl.TextSize = 14
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.TextTransparency = 1
    SubLbl.ZIndex = 121
    SubLbl.Parent = TextHolder

    local infoGather = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(Cloud1, infoGather, { Position = Target1, Rotation = 0 }):Play()
    TweenService:Create(Cloud2, infoGather, { Position = Target2, Rotation = 0 }):Play()
    TweenService:Create(Cloud3, infoGather, { Position = Target3, Rotation = 0 }):Play()

    task.delay(0.55, function()
        local infoShift = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(CenterCloudGroup, infoShift, { Position = UDim2.new(0.5, -135, 0.5, 0) }):Play()
        TweenService:Create(TextHolder, infoShift, { Position = UDim2.new(0.5, 20, 0.5, -35) }):Play()

        local infoFadeText = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(TitleLbl, infoFadeText, { TextTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }):Play()
        TweenService:Create(SubLbl, infoFadeText, { TextTransparency = 0, Position = UDim2.new(0, 0, 0, 44) }):Play()

        task.delay(2.2, function()
            local infoOut = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(TitleLbl, infoOut, { TextTransparency = 1, Position = UDim2.new(0, 0, 0, -20) }):Play()
            TweenService:Create(SubLbl, infoOut, { TextTransparency = 1, Position = UDim2.new(0, 0, 0, 24) }):Play()
            if IntroBlur then
                TweenService:Create(IntroBlur, infoOut, { Size = 0 }):Play()
            end

            for _, child in ipairs(CenterCloudGroup:GetDescendants()) do
                if child:IsA("Frame") then
                    TweenService:Create(child, infoOut, { BackgroundTransparency = 1 }):Play()
                elseif child:IsA("UIStroke") then
                    TweenService:Create(child, infoOut, { Transparency = 1 }):Play()
                end
            end

            task.delay(0.6, function()
                IntroCanvas:Destroy()
                if IntroBlur then
                    pcall(function() IntroBlur:Destroy() end)
                end
                if onComplete then
                    onComplete()
                end
            end)
        end)
    end)
end

local Cloudy = {}
Cloudy.__index = Cloudy

function Cloudy.new(options)
    options = options or {}
    local windowTitle = options.Title or "Cloudy"
    local windowSub = options.SubTitle or "UI Framework"
    local toggleIcon = options.ToggleIcon or options.ToggleImage or 88244237473485
    local logoIcon = options.Logo or options.LogoIcon or options.Icon or "cloud-bold"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CloudyUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

    -- Floating UI Toggle Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "FloatingToggle"
    ToggleBtn.Size = UDim2.new(0, 44, 0, 44)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
    ToggleBtn.BackgroundTransparency = 0.15
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = ""
    ToggleBtn.ClipsDescendants = true
    ToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(45, 48, 60)
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.2
    ToggleStroke.Parent = ToggleBtn

    local ToggleIconImg = Instance.new("ImageLabel")
    ToggleIconImg.Name = "Icon"
    ToggleIconImg.Size = UDim2.new(0, 24, 0, 24)
    ToggleIconImg.AnchorPoint = Vector2.new(0.5, 0.5)
    ToggleIconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    ToggleIconImg.BackgroundTransparency = 1
    ToggleIconImg.BorderSizePixel = 0
    ToggleIconImg.Image = GetIcon(toggleIcon)
    ToggleIconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIconImg.ScaleType = Enum.ScaleType.Fit
    ToggleIconImg.Parent = ToggleBtn

    MakeDraggable(ToggleBtn)

    local defaultSize = UDim2.new(0, 560, 0, 380)
    local expandedSize = UDim2.new(0, 720, 0, 480)
    local isMaximized = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = defaultSize
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(48, 51, 62)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 155, 1, -16)
    Sidebar.Position = UDim2.new(0, 8, 0, 8)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 23, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Color3.fromRGB(36, 39, 48)
    SidebarStroke.Thickness = 1
    SidebarStroke.Parent = Sidebar

    local BrandContainer = Instance.new("Frame")
    BrandContainer.Size = UDim2.new(1, 0, 0, 58)
    BrandContainer.BackgroundTransparency = 1
    BrandContainer.Parent = Sidebar

    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Size = UDim2.new(0, 22, 0, 22)
    LogoIcon.Position = UDim2.new(0, 16, 0, 18)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = GetIcon(logoIcon)
    if not tostring(logoIcon):find("rbxassetid://") and not type(logoIcon) == "number" and not tostring(logoIcon):match("^%d+$") then
        LogoIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
    LogoIcon.Parent = BrandContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 0, 24)
    TitleLabel.Position = UDim2.new(0, 44, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = BrandContainer

    local TitleGrad = Instance.new("UIGradient")
    TitleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(210, 215, 225)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 145, 160)),
        ColorSequenceKeypoint.new(0.85, Color3.fromRGB(90, 95, 110)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(60, 65, 78))
    })
    TitleGrad.Rotation = 0
    TitleGrad.Parent = TitleLabel

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -50, 0, 14)
    SubLabel.Position = UDim2.new(0, 44, 0, 34)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = windowSub
    SubLabel.TextColor3 = Color3.fromRGB(120, 125, 138)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = BrandContainer

    -- Horizontal divider line inside Sidebar
    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "SidebarDivider"
    SidebarDivider.Size = UDim2.new(1, -16, 0, 1)
    SidebarDivider.Position = UDim2.new(0, 8, 0, 58)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(36, 39, 50)
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -16, 1, -74)
    TabContainer.Position = UDim2.new(0, 8, 0, 64)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(60, 65, 75)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabContainer

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    -- Vertical divider line between Sidebar and Content Frame
    local VerticalDivider = Instance.new("Frame")
    VerticalDivider.Name = "VerticalDivider"
    VerticalDivider.Size = UDim2.new(0, 1, 1, -16)
    VerticalDivider.Position = UDim2.new(0, 166, 0, 8)
    VerticalDivider.BackgroundColor3 = Color3.fromRGB(36, 39, 48)
    VerticalDivider.BorderSizePixel = 0
    VerticalDivider.Parent = MainFrame

    -- Transparent TopBar seamlessly integrated with window
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, -179, 0, 42)
    TopBar.Position = UDim2.new(0, 171, 0, 8)
    TopBar.BackgroundTransparency = 1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    MakeDraggable(MainFrame, TopBar)

    local PageTitle = Instance.new("TextLabel")
    PageTitle.Size = UDim2.new(1, -130, 1, 0)
    PageTitle.Position = UDim2.new(0, 16, 0, 0)
    PageTitle.BackgroundTransparency = 1
    PageTitle.Text = "Dashboard"
    PageTitle.TextColor3 = Color3.fromRGB(235, 238, 245)
    PageTitle.Font = Enum.Font.GothamBold
    PageTitle.TextSize = 14
    PageTitle.TextXAlignment = Enum.TextXAlignment.Left
    PageTitle.Parent = TopBar

    -- TopBar Window Controls Container (Minimize, Maximize/Resize, Close)
    local ControlHolder = Instance.new("Frame")
    ControlHolder.Name = "ControlHolder"
    ControlHolder.Size = UDim2.new(0, 110, 1, 0)
    ControlHolder.Position = UDim2.new(1, -114, 0, 0)
    ControlHolder.BackgroundTransparency = 1
    ControlHolder.Parent = TopBar

    local ControlLayout = Instance.new("UIListLayout")
    ControlLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ControlLayout.Padding = UDim.new(0, 6)
    ControlLayout.Parent = ControlHolder

    local function CreateTopBarButton(name, iconAsset, order, hoverBg)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.BackgroundTransparency = 1
        btn.BackgroundColor3 = hoverBg or Color3.fromRGB(36, 39, 50)
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.LayoutOrder = order
        btn.Parent = ControlHolder

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 15, 0, 15)
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        icon.BackgroundTransparency = 1
        icon.Image = GetIcon(iconAsset)
        icon.ImageColor3 = Color3.fromRGB(220, 225, 240)
        icon.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.3
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageColor3 = Color3.fromRGB(220, 225, 240)
            }):Play()
        end)

        return btn, icon
    end

    -- Solar Icon Assets for TopBar Controls (matching exact screenshot design)
    local MinimizeBtn = CreateTopBarButton("MinimizeBtn", "rbxassetid://10747383819", 1)
    local MaximizeBtn = CreateTopBarButton("MaximizeBtn", "rbxassetid://10747383961", 2)
    local CloseBtn = CreateTopBarButton("CloseBtn", "rbxassetid://10747384394", 3, Color3.fromRGB(180, 45, 55))

    -- Main Content Area (Clean solid dark gray theme)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -179, 1, -64)
    ContentArea.Position = UDim2.new(0, 171, 0, 56)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame

    -- Clean, instant UI toggle (NO over-the-top/lebay bounce or shrink animation)
    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
        ToggleBtn.Visible = not MainFrame.Visible
    end

    ToggleBtn.MouseButton1Click:Connect(ToggleUI)

    -- Minimize button: instantly hides main window (completely disappears, not half visible!)
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ToggleBtn.Visible = true
    end)

    -- Maximize / Resize button: toggles UI scale between standard (560x380) and expanded (720x480)
    MaximizeBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        local targetSize = isMaximized and expandedSize or defaultSize
        local targetPos = isMaximized and UDim2.new(0.5, -360, 0.5, -240) or UDim2.new(0.5, -280, 0.5, -190)
        MainFrame.Size = targetSize
        MainFrame.Position = targetPos
    end)

    -- Close button: completely DESTROYS the UI ScreenGui
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local showIntro = options.Intro
    if showIntro == nil then showIntro = true end

    if showIntro then
        MainFrame.Visible = false
        ToggleBtn.Visible = false
        PlayIntroAnimation(ScreenGui, windowTitle, windowSub, function()
            MainFrame.Visible = true
            ToggleBtn.Visible = true
        end)
    else
        MainFrame.Visible = true
        ToggleBtn.Visible = true
    end

    local selfObj = setmetatable({
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabContainer = TabContainer,
        ContentArea = ContentArea,
        PageTitle = PageTitle,
        Tabs = {},
        ActiveTab = nil
    }, Cloudy)

    return selfObj
end

function Cloudy:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

function Cloudy:CreateTab(tabName, iconName)
    iconName = iconName or "document-text-linear"

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
    TabBtn.AutoButtonColor = false
    TabBtn.Text = ""
    TabBtn.Parent = self.TabContainer

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabBtn

    local TabIndicator = Instance.new("Frame")
    TabIndicator.Size = UDim2.new(0, 3, 0, 16)
    TabIndicator.Position = UDim2.new(0, 4, 0.5, -8)
    TabIndicator.BackgroundColor3 = Color3.fromRGB(240, 243, 250)
    TabIndicator.BackgroundTransparency = 1
    TabIndicator.Parent = TabBtn

    local TabIndCorner = Instance.new("UICorner")
    TabIndCorner.CornerRadius = UDim.new(0, 4)
    TabIndCorner.Parent = TabIndicator

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 18, 0, 18)
    TabIcon.Position = UDim2.new(0, 14, 0.5, -9)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = GetIcon(iconName)
    TabIcon.ImageColor3 = Color3.fromRGB(130, 135, 148)
    TabIcon.Parent = TabBtn

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -40, 1, 0)
    TabLabel.Position = UDim2.new(0, 38, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.TextColor3 = Color3.fromRGB(130, 135, 148)
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextSize = 13
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabBtn

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, -24, 1, -16)
    TabPage.Position = UDim2.new(0, 12, 0, 8)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(50, 55, 65)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.Visible = false
    TabPage.Parent = self.ContentArea

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = TabPage

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
    end)

    local tabObject = {
        Button = TabBtn,
        Page = TabPage,
        Label = TabLabel,
        Icon = TabIcon,
        Indicator = TabIndicator,
        Name = tabName
    }

    local function SelectTab()
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
            t.Label.TextColor3 = Color3.fromRGB(130, 135, 148)
            t.Icon.ImageColor3 = Color3.fromRGB(130, 135, 148)
            t.Indicator.BackgroundTransparency = 1
        end

        TabPage.Visible = true
        self.PageTitle.Text = tabName
        self.ActiveTab = tabObject

        TabBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 44)
        TabLabel.TextColor3 = Color3.fromRGB(245, 247, 250)
        TabIcon.ImageColor3 = Color3.fromRGB(245, 247, 250)
        TabIndicator.BackgroundTransparency = 0
    end

    TabBtn.MouseButton1Click:Connect(SelectTab)

    table.insert(self.Tabs, tabObject)

    if #self.Tabs == 1 then
        SelectTab()
    end

    local TabMethods = {}

    function TabMethods:CreateSection(sectionTitle, defaultOpen)
        if defaultOpen == nil then defaultOpen = true end
        local isCollapsed = not defaultOpen

        local SecFrame = Instance.new("Frame")
        SecFrame.Name = "Section_" .. tostring(sectionTitle)
        SecFrame.Size = UDim2.new(1, 0, 0, 34)
        SecFrame.BackgroundTransparency = 1
        SecFrame.ClipsDescendants = true
        SecFrame.Parent = TabPage

        local SecHeader = Instance.new("TextButton")
        SecHeader.Name = "SecHeader"
        SecHeader.Size = UDim2.new(1, 0, 0, 34)
        SecHeader.BackgroundTransparency = 1
        SecHeader.Text = ""
        SecHeader.AutoButtonColor = false
        SecHeader.Parent = SecFrame

        local SecTitle = Instance.new("TextLabel")
        SecTitle.Size = UDim2.new(1, -40, 1, 0)
        SecTitle.Position = UDim2.new(0, 12, 0, 0)
        SecTitle.BackgroundTransparency = 1
        SecTitle.Text = sectionTitle
        SecTitle.TextColor3 = Color3.fromRGB(215, 220, 230)
        SecTitle.Font = Enum.Font.GothamBold
        SecTitle.TextSize = 12
        SecTitle.TextXAlignment = Enum.TextXAlignment.Left
        SecTitle.Parent = SecHeader

        local CollapseIcon = Instance.new("ImageLabel")
        CollapseIcon.Size = UDim2.new(0, 16, 0, 16)
        CollapseIcon.Position = UDim2.new(1, -26, 0.5, -8)
        CollapseIcon.BackgroundTransparency = 1
        CollapseIcon.Image = GetIcon("alt-arrow-down-linear")
        CollapseIcon.ImageColor3 = Color3.fromRGB(160, 165, 178)
        CollapseIcon.Rotation = isCollapsed and -90 or 0
        CollapseIcon.Parent = SecHeader

        local SecContent = Instance.new("Frame")
        SecContent.Name = "SecContent"
        SecContent.Size = UDim2.new(1, -16, 0, 0)
        SecContent.Position = UDim2.new(0, 8, 0, 34)
        SecContent.BackgroundTransparency = 1
        SecContent.Visible = not isCollapsed
        SecContent.Parent = SecFrame

        local SecLayout = Instance.new("UIListLayout")
        SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SecLayout.Padding = UDim.new(0, 6)
        SecLayout.Parent = SecContent

        local function UpdateSectionSize()
            if isCollapsed then
                SecContent.Visible = false
                SecFrame.Size = UDim2.new(1, 0, 0, 34)
                CollapseIcon.Rotation = -90
            else
                SecContent.Visible = true
                SecFrame.Size = UDim2.new(1, 0, 0, SecLayout.AbsoluteContentSize.Y + 42)
                CollapseIcon.Rotation = 0
            end
        end

        SecLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)

        SecHeader.MouseButton1Click:Connect(function()
            isCollapsed = not isCollapsed
            UpdateSectionSize()
        end)

        local SecMethods = {}

        function SecMethods:CreateBanner(opts)
            if type(opts) == "string" or type(opts) == "number" then
                opts = { Image = opts }
            end
            opts = opts or {}
            local title = opts.Title or ""
            local desc = opts.Description or opts.SubTitle or ""
            local imageId = opts.Image or opts.AssetId or 0
            local height = opts.Height or 95

            local BanFrame = Instance.new("Frame")
            BanFrame.Size = UDim2.new(1, 0, 0, height)
            BanFrame.BackgroundTransparency = 1
            BanFrame.ClipsDescendants = true
            BanFrame.Parent = SecContent

            local BanCorner = Instance.new("UICorner")
            BanCorner.CornerRadius = UDim.new(0, 10)
            BanCorner.Parent = BanFrame

            if imageId and imageId ~= "" and imageId ~= 0 then
                local BanImg = Instance.new("ImageLabel")
                BanImg.Size = UDim2.new(1, 0, 1, 0)
                BanImg.BackgroundTransparency = 1
                BanImg.Image = GetIcon(imageId)
                BanImg.ImageTransparency = opts.ImageTransparency or 0.4
                BanImg.ScaleType = Enum.ScaleType.Crop
                BanImg.Parent = BanFrame
            end

            local Overlay = Instance.new("Frame")
            Overlay.Size = UDim2.new(1, 0, 1, 0)
            Overlay.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
            Overlay.BackgroundTransparency = 0.35
            Overlay.Parent = BanFrame

            local Grad = Instance.new("UIGradient")
            Grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 17, 24)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 30, 42))
            })
            Grad.Rotation = 45
            Grad.Parent = Overlay

            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, -24, 1, -16)
            Holder.Position = UDim2.new(0, 12, 0, 8)
            Holder.BackgroundTransparency = 1
            Holder.Parent = BanFrame

            if title ~= "" then
                local TxtTitle = Instance.new("TextLabel")
                TxtTitle.Size = UDim2.new(1, 0, 0, 22)
                TxtTitle.Position = UDim2.new(0, 0, 0, 4)
                TxtTitle.BackgroundTransparency = 1
                TxtTitle.Text = title
                TxtTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                TxtTitle.Font = Enum.Font.GothamBold
                TxtTitle.TextSize = 14
                TxtTitle.TextXAlignment = Enum.TextXAlignment.Left
                TxtTitle.Parent = Holder
            end

            if desc ~= "" then
                local TxtDesc = Instance.new("TextLabel")
                TxtDesc.Size = UDim2.new(1, 0, 1, title ~= "" and -28 or 0)
                TxtDesc.Position = UDim2.new(0, 0, 0, title ~= "" and 26 or 0)
                TxtDesc.BackgroundTransparency = 1
                TxtDesc.Text = desc
                TxtDesc.TextColor3 = Color3.fromRGB(200, 205, 218)
                TxtDesc.Font = Enum.Font.GothamMedium
                TxtDesc.TextSize = 11
                TxtDesc.TextXAlignment = Enum.TextXAlignment.Left
                TxtDesc.TextYAlignment = Enum.TextYAlignment.Top
                TxtDesc.TextWrapped = true
                TxtDesc.Parent = Holder
            end

            return BanFrame
        end

        function SecMethods:CreateImage(opts)
            if type(opts) == "string" or type(opts) == "number" then
                opts = { Image = opts }
            end
            opts = opts or {}
            local imageId = opts.Image or opts.AssetId or 0
            local height = opts.Height or 130
            local scaleType = opts.ScaleType or Enum.ScaleType.Fit

            local ImgFrame = Instance.new("Frame")
            ImgFrame.Size = UDim2.new(1, 0, 0, height)
            ImgFrame.BackgroundTransparency = 1
            ImgFrame.ClipsDescendants = true
            ImgFrame.Parent = SecContent

            local ImgCorner = Instance.new("UICorner")
            ImgCorner.CornerRadius = UDim.new(0, 10)
            ImgCorner.Parent = ImgFrame

            local DisplayImg = Instance.new("ImageLabel")
            DisplayImg.Size = UDim2.new(1, 0, 1, 0)
            DisplayImg.BackgroundTransparency = 1
            DisplayImg.Image = GetIcon(imageId)
            DisplayImg.ScaleType = scaleType
            DisplayImg.Parent = ImgFrame

            return ImgFrame
        end

        function SecMethods:CreateImageButton(opts, callback)
            if type(opts) == "string" or type(opts) == "number" then
                opts = { Image = opts, Title = "Click Me" }
            end
            opts = opts or {}
            callback = callback or function() end
            local title = opts.Title or "Button"
            local desc = opts.Description or ""
            local imageId = opts.Image or opts.AssetId or 0
            local height = opts.Height or 80

            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Size = UDim2.new(1, 0, 0, height)
            BtnFrame.BackgroundTransparency = 1
            BtnFrame.AutoButtonColor = false
            BtnFrame.Text = ""
            BtnFrame.ClipsDescendants = true
            BtnFrame.Parent = SecContent

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 10)
            BtnCorner.Parent = BtnFrame

            if imageId and imageId ~= "" and imageId ~= 0 then
                local BtnImg = Instance.new("ImageLabel")
                BtnImg.Size = UDim2.new(1, 0, 1, 0)
                BtnImg.BackgroundTransparency = 1
                BtnImg.Image = GetIcon(imageId)
                BtnImg.ImageTransparency = opts.ImageTransparency or 0.45
                BtnImg.ScaleType = Enum.ScaleType.Crop
                BtnImg.Parent = BtnFrame
            end

            local Overlay = Instance.new("Frame")
            Overlay.Size = UDim2.new(1, 0, 1, 0)
            Overlay.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
            Overlay.BackgroundTransparency = 0.3
            Overlay.Parent = BtnFrame

            local Holder = Instance.new("Frame")
            Holder.Size = UDim2.new(1, -24, 1, -16)
            Holder.Position = UDim2.new(0, 12, 0, 8)
            Holder.BackgroundTransparency = 1
            Holder.Parent = BtnFrame

            local TxtTitle = Instance.new("TextLabel")
            TxtTitle.Size = UDim2.new(1, 0, 0, 20)
            TxtTitle.Position = UDim2.new(0, 0, 0, 4)
            TxtTitle.BackgroundTransparency = 1
            TxtTitle.Text = title
            TxtTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TxtTitle.Font = Enum.Font.GothamBold
            TxtTitle.TextSize = 13
            TxtTitle.TextXAlignment = Enum.TextXAlignment.Left
            TxtTitle.Parent = Holder

            if desc ~= "" then
                local TxtDesc = Instance.new("TextLabel")
                TxtDesc.Size = UDim2.new(1, 0, 0, 18)
                TxtDesc.Position = UDim2.new(0, 0, 0, 24)
                TxtDesc.BackgroundTransparency = 1
                TxtDesc.Text = desc
                TxtDesc.TextColor3 = Color3.fromRGB(190, 195, 208)
                TxtDesc.Font = Enum.Font.GothamMedium
                TxtDesc.TextSize = 11
                TxtDesc.TextXAlignment = Enum.TextXAlignment.Left
                TxtDesc.Parent = Holder
            end

            BtnFrame.MouseButton1Click:Connect(function()
                pcall(callback)
            end)

            return BtnFrame
        end

        function SecMethods:CreateHeader(text)
            local HeaderLabel = Instance.new("TextLabel")
            HeaderLabel.Size = UDim2.new(1, 0, 0, 20)
            HeaderLabel.BackgroundTransparency = 1
            HeaderLabel.Text = text
            HeaderLabel.TextColor3 = Color3.fromRGB(150, 155, 170)
            HeaderLabel.Font = Enum.Font.GothamBold
            HeaderLabel.TextSize = 11
            HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
            HeaderLabel.Parent = SecContent
        end

        function SecMethods:CreateParagraph(title, content)
            local ParaFrame = Instance.new("Frame")
            ParaFrame.Size = UDim2.new(1, 0, 0, 48)
            ParaFrame.BackgroundTransparency = 1
            ParaFrame.Parent = SecContent

            local PTitle = Instance.new("TextLabel")
            PTitle.Size = UDim2.new(1, -24, 0, 20)
            PTitle.Position = UDim2.new(0, 12, 0, 4)
            PTitle.BackgroundTransparency = 1
            PTitle.Text = title
            PTitle.TextColor3 = Color3.fromRGB(230, 234, 245)
            PTitle.Font = Enum.Font.GothamBold
            PTitle.TextSize = 12
            PTitle.TextXAlignment = Enum.TextXAlignment.Left
            PTitle.Parent = ParaFrame

            local PText = Instance.new("TextLabel")
            PText.Size = UDim2.new(1, -24, 0, 20)
            PText.Position = UDim2.new(0, 12, 0, 24)
            PText.BackgroundTransparency = 1
            PText.Text = content
            PText.TextColor3 = Color3.fromRGB(140, 145, 158)
            PText.Font = Enum.Font.GothamMedium
            PText.TextSize = 11
            PText.TextXAlignment = Enum.TextXAlignment.Left
            PText.TextWrapped = true
            PText.Parent = ParaFrame
        end

        function SecMethods:CreateButton(text, callback)
            callback = callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundTransparency = 1
            Btn.AutoButtonColor = false
            Btn.Text = ""
            Btn.Parent = SecContent

            local BtnLabel = Instance.new("TextLabel")
            BtnLabel.Size = UDim2.new(1, -40, 1, 0)
            BtnLabel.Position = UDim2.new(0, 12, 0, 0)
            BtnLabel.BackgroundTransparency = 1
            BtnLabel.Text = text
            BtnLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            BtnLabel.Font = Enum.Font.GothamMedium
            BtnLabel.TextSize = 12
            BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
            BtnLabel.Parent = Btn

            local BtnIcon = Instance.new("ImageLabel")
            BtnIcon.Size = UDim2.new(0, 16, 0, 16)
            BtnIcon.Position = UDim2.new(1, -24, 0.5, -8)
            BtnIcon.BackgroundTransparency = 1
            BtnIcon.Image = GetIcon("alt-arrow-right-linear")
            BtnIcon.ImageColor3 = Color3.fromRGB(140, 145, 160)
            BtnIcon.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function SecMethods:CreateToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            local toggled = default

            local TogFrame = Instance.new("Frame")
            TogFrame.Size = UDim2.new(1, 0, 0, 34)
            TogFrame.BackgroundTransparency = 1
            TogFrame.Parent = SecContent

            local TogLabel = Instance.new("TextLabel")
            TogLabel.Size = UDim2.new(1, -60, 1, 0)
            TogLabel.Position = UDim2.new(0, 12, 0, 0)
            TogLabel.BackgroundTransparency = 1
            TogLabel.Text = text
            TogLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            TogLabel.Font = Enum.Font.GothamMedium
            TogLabel.TextSize = 12
            TogLabel.TextXAlignment = Enum.TextXAlignment.Left
            TogLabel.Parent = TogFrame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 36, 0, 20)
            Switch.Position = UDim2.new(1, -44, 0.5, -10)
            Switch.BackgroundColor3 = toggled and Color3.fromRGB(235, 238, 245) or Color3.fromRGB(45, 48, 60)
            Switch.AutoButtonColor = false
            Switch.Text = ""
            Switch.Parent = TogFrame

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Circle.BackgroundColor3 = toggled and Color3.fromRGB(20, 22, 28) or Color3.fromRGB(150, 155, 170)
            Circle.Parent = Switch

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local function UpdateToggle()
                if toggled then
                    Switch.BackgroundColor3 = Color3.fromRGB(235, 238, 245)
                    Circle.Position = UDim2.new(1, -17, 0.5, -7)
                    Circle.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
                else
                    Switch.BackgroundColor3 = Color3.fromRGB(45, 48, 60)
                    Circle.Position = UDim2.new(0, 3, 0.5, -7)
                    Circle.BackgroundColor3 = Color3.fromRGB(150, 155, 170)
                end
                pcall(callback, toggled)
            end

            local ClickBtn = Instance.new("TextButton")
            ClickBtn.Size = UDim2.new(1, 0, 1, 0)
            ClickBtn.BackgroundTransparency = 1
            ClickBtn.Text = ""
            ClickBtn.Parent = TogFrame

            ClickBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
        end

        function SecMethods:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = math.clamp(default or min, min, max)
            callback = callback or function() end

            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 50)
            SldFrame.BackgroundTransparency = 1
            SldFrame.Parent = SecContent

            local SldLabel = Instance.new("TextLabel")
            SldLabel.Size = UDim2.new(1, -60, 0, 20)
            SldLabel.Position = UDim2.new(0, 12, 0, 4)
            SldLabel.BackgroundTransparency = 1
            SldLabel.Text = text
            SldLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            SldLabel.Font = Enum.Font.GothamMedium
            SldLabel.TextSize = 12
            SldLabel.TextXAlignment = Enum.TextXAlignment.Left
            SldLabel.Parent = SldFrame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 50, 0, 20)
            ValLabel.Position = UDim2.new(1, -62, 0, 4)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(default)
            ValLabel.TextColor3 = Color3.fromRGB(160, 165, 178)
            ValLabel.Font = Enum.Font.GothamMedium
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = SldFrame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 0, 33)
            Track.BackgroundColor3 = Color3.fromRGB(45, 48, 60)
            Track.AutoButtonColor = false
            Track.Text = ""
            Track.Parent = SldFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            local initPct = (default - min) / (max - min)
            Fill.Size = UDim2.new(initPct, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(235, 238, 245)
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = UDim2.new(initPct, 0, 0.5, 0)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Track

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = Knob

            local KnobStroke = Instance.new("UIStroke")
            KnobStroke.Color = Color3.fromRGB(35, 37, 46)
            KnobStroke.Thickness = 2
            KnobStroke.Parent = Knob

            local isDragging = false

            local function UpdateSlider(input)
                local pct = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pct)
                ValLabel.Text = tostring(val)
                Fill.Size = UDim2.new(pct, 0, 1, 0)
                Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                pcall(callback, val)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)
        end

        function SecMethods:CreateDropdown(text, options, default, callback)
            options = options or {}
            default = default or options[1] or ""
            callback = callback or function() end

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 34)
            DropFrame.BackgroundTransparency = 1
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = SecContent

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0, 120, 0, 34)
            DropLabel.Position = UDim2.new(0, 12, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = text
            DropLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            DropLabel.Font = Enum.Font.GothamMedium
            DropLabel.TextSize = 12
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropFrame

            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Size = UDim2.new(1, -165, 0, 34)
            SelectedLabel.Position = UDim2.new(0, 130, 0, 0)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Text = tostring(default)
            SelectedLabel.TextColor3 = Color3.fromRGB(160, 165, 178)
            SelectedLabel.Font = Enum.Font.GothamMedium
            SelectedLabel.TextSize = 12
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.Parent = DropFrame

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
            ArrowIcon.Position = UDim2.new(1, -24, 0, 10)
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Image = GetIcon("alt-arrow-down-linear")
            ArrowIcon.ImageColor3 = Color3.fromRGB(140, 145, 160)
            ArrowIcon.Parent = DropFrame

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, -16, 0, #options * 26)
            OptionContainer.Position = UDim2.new(0, 8, 0, 34)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = DropFrame

            local OptLayout = Instance.new("UIListLayout")
            OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptLayout.Padding = UDim.new(0, 2)
            OptLayout.Parent = OptionContainer

            local isExpanded = false

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 24)
                OptBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
                OptBtn.AutoButtonColor = false
                OptBtn.Text = "  " .. tostring(opt)
                OptBtn.TextColor3 = Color3.fromRGB(190, 195, 208)
                OptBtn.Font = Enum.Font.GothamMedium
                OptBtn.TextSize = 11
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Parent = OptionContainer

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 6)
                OptCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    SelectedLabel.Text = tostring(opt)
                    isExpanded = false
                    DropFrame.Size = UDim2.new(1, 0, 0, 34)
                    ArrowIcon.Rotation = 0
                    pcall(callback, opt)
                end)
            end

            local ToggleDropBtn = Instance.new("TextButton")
            ToggleDropBtn.Size = UDim2.new(1, 0, 0, 34)
            ToggleDropBtn.BackgroundTransparency = 1
            ToggleDropBtn.Text = ""
            ToggleDropBtn.Parent = DropFrame

            ToggleDropBtn.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                DropFrame.Size = UDim2.new(1, 0, 0, isExpanded and (38 + #options * 26) or 34)
                ArrowIcon.Rotation = isExpanded and 180 or 0
            end)
        end

        function SecMethods:CreateMultiDropdown(text, options, defaultTable, callback)
            options = options or {}
            defaultTable = defaultTable or {}
            callback = callback or function() end

            local selectedMap = {}
            for _, v in ipairs(defaultTable) do
                selectedMap[v] = true
            end

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 34)
            DropFrame.BackgroundTransparency = 1
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = SecContent

            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0, 120, 0, 34)
            DropLabel.Position = UDim2.new(0, 12, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = text
            DropLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            DropLabel.Font = Enum.Font.GothamMedium
            DropLabel.TextSize = 12
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropFrame

            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Size = UDim2.new(1, -165, 0, 34)
            SelectedLabel.Position = UDim2.new(0, 130, 0, 0)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.TextColor3 = Color3.fromRGB(160, 165, 178)
            SelectedLabel.Font = Enum.Font.GothamMedium
            SelectedLabel.TextSize = 11
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.Parent = DropFrame

            local function RefreshLabel()
                local list = {}
                for k, v in pairs(selectedMap) do
                    if v then table.insert(list, k) end
                end
                if #list == 0 then
                    SelectedLabel.Text = "None"
                else
                    SelectedLabel.Text = table.concat(list, ", ")
                end
            end
            RefreshLabel()

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
            ArrowIcon.Position = UDim2.new(1, -24, 0, 10)
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Image = GetIcon("alt-arrow-down-linear")
            ArrowIcon.ImageColor3 = Color3.fromRGB(140, 145, 160)
            ArrowIcon.Parent = DropFrame

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Size = UDim2.new(1, -16, 0, #options * 26)
            OptionContainer.Position = UDim2.new(0, 8, 0, 34)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = DropFrame

            local OptLayout = Instance.new("UIListLayout")
            OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptLayout.Padding = UDim.new(0, 2)
            OptLayout.Parent = OptionContainer

            local isExpanded = false

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 24)
                OptBtn.BackgroundColor3 = selectedMap[opt] and Color3.fromRGB(42, 45, 58) or Color3.fromRGB(24, 26, 34)
                OptBtn.AutoButtonColor = false
                OptBtn.Text = "  " .. tostring(opt)
                OptBtn.TextColor3 = selectedMap[opt] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 185, 198)
                OptBtn.Font = Enum.Font.GothamMedium
                OptBtn.TextSize = 11
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Parent = OptionContainer

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 6)
                OptCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    selectedMap[opt] = not selectedMap[opt]
                    OptBtn.BackgroundColor3 = selectedMap[opt] and Color3.fromRGB(42, 45, 58) or Color3.fromRGB(24, 26, 34)
                    OptBtn.TextColor3 = selectedMap[opt] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 185, 198)
                    RefreshLabel()
                    local res = {}
                    for k, v in pairs(selectedMap) do
                        if v then table.insert(res, k) end
                    end
                    pcall(callback, res)
                end)
            end

            local ToggleDropBtn = Instance.new("TextButton")
            ToggleDropBtn.Size = UDim2.new(1, 0, 0, 34)
            ToggleDropBtn.BackgroundTransparency = 1
            ToggleDropBtn.Text = ""
            ToggleDropBtn.Parent = DropFrame

            ToggleDropBtn.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                DropFrame.Size = UDim2.new(1, 0, 0, isExpanded and (38 + #options * 26) or 34)
                ArrowIcon.Rotation = isExpanded and 180 or 0
            end)
        end

        function SecMethods:CreateColorPicker(text, defaultColor, callback)
            defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
            callback = callback or function() end
            local currentColor = defaultColor

            local CPFrame = Instance.new("Frame")
            CPFrame.Size = UDim2.new(1, 0, 0, 34)
            CPFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            CPFrame.Parent = SecContent

            local CPCorner = Instance.new("UICorner")
            CPCorner.CornerRadius = UDim.new(0, 8)
            CPCorner.Parent = CPFrame

            local CPStroke = Instance.new("UIStroke")
            CPStroke.Color = Color3.fromRGB(45, 48, 60)
            CPStroke.Thickness = 1
            CPStroke.Parent = CPFrame

            local CPLabel = Instance.new("TextLabel")
            CPLabel.Size = UDim2.new(1, -60, 1, 0)
            CPLabel.Position = UDim2.new(0, 12, 0, 0)
            CPLabel.BackgroundTransparency = 1
            CPLabel.Text = text
            CPLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            CPLabel.Font = Enum.Font.GothamMedium
            CPLabel.TextSize = 12
            CPLabel.TextXAlignment = Enum.TextXAlignment.Left
            CPLabel.Parent = CPFrame

            local Preview = Instance.new("Frame")
            Preview.Size = UDim2.new(0, 26, 0, 18)
            Preview.Position = UDim2.new(1, -38, 0.5, -9)
            Preview.BackgroundColor3 = currentColor
            Preview.Parent = CPFrame

            local PrevCorner = Instance.new("UICorner")
            PrevCorner.CornerRadius = UDim.new(0, 6)
            PrevCorner.Parent = Preview

            local PrevStroke = Instance.new("UIStroke")
            PrevStroke.Color = Color3.fromRGB(60, 65, 78)
            PrevStroke.Thickness = 1
        function SecMethods:CreateInput(text, placeholder, callback)
            placeholder = placeholder or "Type here..."
            callback = callback or function() end

            local InpFrame = Instance.new("Frame")
            InpFrame.Size = UDim2.new(1, 0, 0, 34)
            InpFrame.BackgroundTransparency = 1
            InpFrame.Parent = SecContent

            local InpLabel = Instance.new("TextLabel")
            InpLabel.Size = UDim2.new(0, 120, 1, 0)
            InpLabel.Position = UDim2.new(0, 12, 0, 0)
            InpLabel.BackgroundTransparency = 1
            InpLabel.Text = text
            InpLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            InpLabel.Font = Enum.Font.GothamMedium
            InpLabel.TextSize = 12
            InpLabel.TextXAlignment = Enum.TextXAlignment.Left
            InpLabel.Parent = InpFrame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -145, 0, 24)
            TextBox.Position = UDim2.new(0, 133, 0.5, -12)
            TextBox.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder
            TextBox.PlaceholderColor3 = Color3.fromRGB(100, 105, 118)
            TextBox.TextColor3 = Color3.fromRGB(240, 243, 250)
            TextBox.Font = Enum.Font.GothamMedium
            TextBox.TextSize = 11
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = InpFrame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = TextBox

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(40, 43, 54)
            BoxStroke.Thickness = 1
            BoxStroke.Parent = TextBox

            TextBox.FocusLost:Connect(function(enterPressed)
                pcall(callback, TextBox.Text, enterPressed)
            end)
        end

        function SecMethods:CreateKeybind(text, defaultKey, callback)
            defaultKey = defaultKey or Enum.KeyCode.E
            callback = callback or function() end
            local currentKey = defaultKey

            local KeyFrame = Instance.new("Frame")
            KeyFrame.Size = UDim2.new(1, 0, 0, 34)
            KeyFrame.BackgroundTransparency = 1
            KeyFrame.Parent = SecContent

            local KeyLabel = Instance.new("TextLabel")
            KeyLabel.Size = UDim2.new(1, -90, 1, 0)
            KeyLabel.Position = UDim2.new(0, 12, 0, 0)
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.Text = text
            KeyLabel.TextColor3 = Color3.fromRGB(220, 224, 235)
            KeyLabel.Font = Enum.Font.GothamMedium
            KeyLabel.TextSize = 12
            KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeyLabel.Parent = KeyFrame

            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Size = UDim2.new(0, 70, 0, 22)
            KeyBtn.Position = UDim2.new(1, -78, 0.5, -11)
            KeyBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
            KeyBtn.AutoButtonColor = false
            KeyBtn.Text = currentKey.Name
            KeyBtn.TextColor3 = Color3.fromRGB(200, 205, 218)
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 11
            KeyBtn.Parent = KeyFrame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = KeyBtn

            local listening = false
            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
                KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    currentKey = input.KeyCode
                    KeyBtn.Text = currentKey.Name
                    KeyBtn.TextColor3 = Color3.fromRGB(200, 205, 218)
                    pcall(callback, currentKey)
                end
            end)
        end

        return SecMethods
    end

    return TabMethods
end

function Cloudy:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    local icon = config.Icon or "info-square-linear"

    local NotifGui = self.ScreenGui
    local NotifContainer = NotifGui:FindFirstChild("NotifContainer")

    if not NotifContainer then
        NotifContainer = Instance.new("Frame")
        NotifContainer.Name = "NotifContainer"
        NotifContainer.Size = UDim2.new(0, 240, 1, -20)
        NotifContainer.Position = UDim2.new(1, -250, 0, 10)
        NotifContainer.BackgroundTransparency = 1
        NotifContainer.Parent = NotifGui

        local NotifLayout = Instance.new("UIListLayout")
        NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
        NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        NotifLayout.Padding = UDim.new(0, 8)
        NotifLayout.Parent = NotifContainer
    end

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 54)
    Card.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
    Card.Parent = NotifContainer

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(50, 54, 66)
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local CardIcon = Instance.new("ImageLabel")
    CardIcon.Size = UDim2.new(0, 20, 0, 20)
    CardIcon.Position = UDim2.new(0, 12, 0, 12)
    CardIcon.BackgroundTransparency = 1
    CardIcon.Image = GetIcon(icon)
    CardIcon.ImageColor3 = Color3.fromRGB(240, 243, 250)
    CardIcon.Parent = Card

    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -42, 0, 18)
    CardTitle.Position = UDim2.new(0, 38, 0, 10)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = title
    CardTitle.TextColor3 = Color3.fromRGB(245, 247, 250)
    CardTitle.Font = Enum.Font.GothamBold
    CardTitle.TextSize = 12
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card

    local CardText = Instance.new("TextLabel")
    CardText.Size = UDim2.new(1, -42, 0, 16)
    CardText.Position = UDim2.new(0, 38, 0, 28)
    CardText.BackgroundTransparency = 1
    CardText.Text = content
    CardText.TextColor3 = Color3.fromRGB(150, 155, 168)
    CardText.Font = Enum.Font.GothamMedium
    CardText.TextSize = 11
    CardText.TextXAlignment = Enum.TextXAlignment.Left
    CardText.Parent = Card

    task.delay(duration, function()
        if Card and Card.Parent then
            Card:Destroy()
        end
    end)
end

local Window = Cloudy.new({
    Title = "Cloudy",
    SubTitle = "v2.0.0",
    ToggleIcon = "cloud-bold"
})

local MainTab = Window:CreateTab("Main", "home-2-bold")
local PlayerTab = Window:CreateTab("Player", "user-bold")
local VisualTab = Window:CreateTab("Visuals", "eye-bold")
local SettingsTab = Window:CreateTab("Settings", "settings-bold")

local MainSec = MainTab:CreateSection("Farming Controls")

MainSec:CreateHeader("Automated Settings")

MainSec:CreateToggle("Auto Farm Mobs", false, function(state)
    print("Auto Farm:", state)
end)

MainSec:CreateToggle("Auto Collect Drops", true, function(state)
    print("Auto Collect:", state)
end)

MainSec:CreateSlider("Attack Distance (Studs)", 5, 100, 25, function(val)
    print("Distance set to:", val)
end)

MainSec:CreateDropdown("Select Mode", {"Fast Attack", "Normal Attack", "Safe Attack"}, "Fast Attack", function(selected)
    print("Selected Mode:", selected)
end)

MainSec:CreateMultiDropdown("Target Mobs", {"Bandit", "Pirate", "Boss", "Skeleton"}, {"Bandit", "Boss"}, function(selectedTable)
    print("Target Mobs selected:", table.concat(selectedTable, ", "))
end)

local MiscSec = MainTab:CreateSection("Actions & Information")

MiscSec:CreateParagraph("Cloudy Info", "Cloudy UI is now optimized with zero-animation instant response and custom circular slider handles!")

MiscSec:CreateButton("Teleport to Safe Zone", function()
    Window:Notify({
        Title = "Teleport",
        Content = "Successfully teleported to Safe Zone!",
        Duration = 3,
        Icon = "map-point-bold"
    })
end)

MiscSec:CreateInput("Custom Webhook", "https://discord.com/api/webhooks/...", function(text, enter)
    if enter then
        print("Webhook saved:", text)
    end
end)

local PlayerSec = PlayerTab:CreateSection("Movement")

PlayerSec:CreateSlider("WalkSpeed", 16, 250, 16, function(speed)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

PlayerSec:CreateSlider("JumpPower", 50, 300, 50, function(power)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = power
    end
end)

PlayerSec:CreateKeybind("Sprint Keybind", Enum.KeyCode.LeftShift, function(key)
    print("Keybind changed to:", key.Name)
end)

local VisualSec = VisualTab:CreateSection("ESP Settings")

VisualSec:CreateToggle("Enable ESP", true, function(state)
    print("ESP Enabled:", state)
end)

VisualSec:CreateColorPicker("ESP Box Color", Color3.fromRGB(255, 255, 255), function(color)
    print("Color changed:", color)
end)

Window:Notify({
    Title = "Cloudy Loaded",
    Content = "Welcome to Cloudy UI Framework v2!",
    Duration = 4,
    Icon = "check-circle-bold"
})
