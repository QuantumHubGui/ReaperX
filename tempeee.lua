local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local SolarIcons = {}
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))()
end)

if success and type(result) == "table" then
    SolarIcons = result
end

local function GetIcon(name)
    if name and SolarIcons[name] then
        return SolarIcons[name]
    elseif name and type(name) == "string" and (name:find("rbxassetid://") or name:find("http")) then
        return name
    end
    return SolarIcons["widget-4-bold"] or "rbxassetid://10723416624"
end

local Library = {
    Icons = SolarIcons,
    ActiveScreenGui = nil
}
Library.__index = Library

function Library:GetIcon(name)
    return GetIcon(name)
end

local function MakeDraggable(gui, handle)
    handle = handle or gui
    local dragging = false
    local dragInput, dragStart, startPos

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
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Notify(notifyConfig)
    notifyConfig = notifyConfig or {}
    local title = notifyConfig.Title or "Notification"
    local content = notifyConfig.Content or ""
    local iconName = notifyConfig.Icon or "bell-bold"
    local duration = notifyConfig.Duration or 3.5

    local screen = Library.ActiveScreenGui
    if not screen then return end

    local notifContainer = screen:FindFirstChild("NotifContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotifContainer"
        notifContainer.Size = UDim2.new(0, 260, 1, -40)
        notifContainer.Position = UDim2.new(1, -270, 0, 20)
        notifContainer.BackgroundTransparency = 1
        notifContainer.ZIndex = 500
        notifContainer.Parent = screen

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 8)
        layout.Parent = notifContainer
    end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotifItem"
    NotifFrame.Size = UDim2.new(1, 0, 0, 56)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotifFrame.Parent = notifContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(225, 228, 238)
    NotifStroke.Thickness = 1
    NotifStroke.Parent = NotifFrame

    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 22, 0, 22)
    IconImg.Position = UDim2.new(0, 12, 0, 12)
    IconImg.BackgroundTransparency = 1
    IconImg.Image = GetIcon(iconName)
    IconImg.ImageColor3 = Color3.fromRGB(60, 65, 78)
    IconImg.Parent = NotifFrame

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -44, 0, 18)
    TitleLbl.Position = UDim2.new(0, 40, 0, 10)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.fromRGB(40, 45, 55)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = NotifFrame

    local ContentLbl = Instance.new("TextLabel")
    ContentLbl.Size = UDim2.new(1, -44, 0, 16)
    ContentLbl.Position = UDim2.new(0, 40, 0, 28)
    ContentLbl.BackgroundTransparency = 1
    ContentLbl.Text = content
    ContentLbl.TextColor3 = Color3.fromRGB(120, 125, 138)
    ContentLbl.Font = Enum.Font.Gotham
    ContentLbl.TextSize = 11
    ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
    ContentLbl.Parent = NotifFrame

    task.delay(duration, function()
        if NotifFrame and NotifFrame.Parent then
            NotifFrame:Destroy()
        end
    end)
end

function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Cloudy"
    local windowSub = config.SubTitle or "v2.0 • Premium Edition"
    local windowIcon = config.Icon or "cloud-bold"

    local parent = (gethui and gethui()) or CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CloudyUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = parent

    Library.ActiveScreenGui = ScreenGui

    local FloatingBtn = Instance.new("TextButton")
    FloatingBtn.Name = "FloatingToggle"
    FloatingBtn.Size = UDim2.new(0, 48, 0, 48)
    FloatingBtn.Position = UDim2.new(0.04, 0, 0.15, 0)
    FloatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FloatingBtn.Text = ""
    FloatingBtn.AutoButtonColor = false
    FloatingBtn.ZIndex = 100
    FloatingBtn.Parent = ScreenGui

    local FloatingCorner = Instance.new("UICorner")
    FloatingCorner.CornerRadius = UDim.new(0, 12)
    FloatingCorner.Parent = FloatingBtn

    local FloatingStroke = Instance.new("UIStroke")
    FloatingStroke.Color = Color3.fromRGB(220, 224, 234)
    FloatingStroke.Thickness = 1.5
    FloatingStroke.Parent = FloatingBtn

    local FloatingIcon = Instance.new("ImageLabel")
    FloatingIcon.Size = UDim2.new(0, 24, 0, 24)
    FloatingIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
    FloatingIcon.BackgroundTransparency = 1
    FloatingIcon.Image = GetIcon(windowIcon)
    FloatingIcon.ImageColor3 = Color3.fromRGB(60, 65, 78)
    FloatingIcon.ZIndex = 101
    FloatingIcon.Parent = FloatingBtn

    MakeDraggable(FloatingBtn)

    local defaultSize = UDim2.new(0, 660, 0, 450)
    local expandedSize = UDim2.new(0, 780, 0, 530)
    local minimizedSize = UDim2.new(0, 660, 0, 45)

    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = defaultSize
    MainWindow.Position = UDim2.new(0.5, -330, 0.5, -225)
    MainWindow.BackgroundColor3 = Color3.fromRGB(248, 249, 252)
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainWindow

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(225, 228, 236)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainWindow

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 190, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(240, 242, 247)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 14)
    SidebarCorner.Parent = Sidebar

    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(1, 0, 0, 65)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = Sidebar

    local AppIcon = Instance.new("ImageLabel")
    AppIcon.Size = UDim2.new(0, 24, 0, 24)
    AppIcon.Position = UDim2.new(0, 16, 0.5, -12)
    AppIcon.BackgroundTransparency = 1
    AppIcon.Image = GetIcon(windowIcon)
    AppIcon.ImageColor3 = Color3.fromRGB(70, 75, 88)
    AppIcon.Parent = TitleContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 0, 24)
    TitleLabel.Position = UDim2.new(0, 48, 0, 14)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleContainer

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 40, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 115, 128)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 210, 220))
    })
    TitleGradient.Parent = TitleLabel

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -50, 0, 16)
    SubLabel.Position = UDim2.new(0, 48, 0, 36)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = windowSub
    SubLabel.TextColor3 = Color3.fromRGB(150, 155, 168)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = TitleContainer

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Name = "TabHolder"
    TabHolder.Size = UDim2.new(1, -20, 1, -80)
    TabHolder.Position = UDim2.new(0, 10, 0, 70)
    TabHolder.BackgroundTransparency = 1
    TabHolder.BorderSizePixel = 0
    TabHolder.ScrollBarThickness = 0
    TabHolder.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.Parent = TabHolder

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -200, 1, -45)
    ContentContainer.Position = UDim2.new(0, 195, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainWindow

    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, -190, 0, 40)
    HeaderBar.Position = UDim2.new(0, 190, 0, 0)
    HeaderBar.BackgroundTransparency = 1
    HeaderBar.Parent = MainWindow

    MakeDraggable(MainWindow, HeaderBar)

    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Name = "HeaderControls"
    ControlsContainer.Size = UDim2.new(0, 105, 1, 0)
    ControlsContainer.Position = UDim2.new(1, -110, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = HeaderBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 242, 247)
    CloseBtn.Text = ""
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = ControlsContainer

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Size = UDim2.new(0, 16, 0, 16)
    CloseIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = GetIcon("close-square-linear")
    CloseIcon.ImageColor3 = Color3.fromRGB(110, 115, 128)
    CloseIcon.Parent = CloseBtn

    local ResizeBtn = Instance.new("TextButton")
    ResizeBtn.Name = "ResizeBtn"
    ResizeBtn.Size = UDim2.new(0, 28, 0, 28)
    ResizeBtn.Position = UDim2.new(1, -66, 0.5, -14)
    ResizeBtn.BackgroundColor3 = Color3.fromRGB(240, 242, 247)
    ResizeBtn.Text = ""
    ResizeBtn.AutoButtonColor = false
    ResizeBtn.Parent = ControlsContainer

    local ResizeCorner = Instance.new("UICorner")
    ResizeCorner.CornerRadius = UDim.new(0, 8)
    ResizeCorner.Parent = ResizeBtn

    local ResizeIcon = Instance.new("ImageLabel")
    ResizeIcon.Size = UDim2.new(0, 16, 0, 16)
    ResizeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    ResizeIcon.BackgroundTransparency = 1
    ResizeIcon.Image = GetIcon("bookmark-square-linear")
    ResizeIcon.ImageColor3 = Color3.fromRGB(110, 115, 128)
    ResizeIcon.Parent = ResizeBtn

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    MinimizeBtn.Position = UDim2.new(1, -100, 0.5, -14)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(240, 242, 247)
    MinimizeBtn.Text = ""
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Parent = ControlsContainer

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeBtn

    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.Size = UDim2.new(0, 16, 0, 16)
    MinimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.Image = GetIcon("alt-arrow-up-bold")
    MinimizeIcon.ImageColor3 = Color3.fromRGB(110, 115, 128)
    MinimizeIcon.Parent = MinimizeBtn

    local isVisible = true
    local isMinimized = false
    local isExpanded = false

    local function ToggleUI()
        isVisible = not isVisible
        MainWindow.Visible = isVisible
    end

    FloatingBtn.MouseButton1Click:Connect(ToggleUI)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainWindow.Size = minimizedSize
            ContentContainer.Visible = false
            Sidebar.Size = UDim2.new(0, 190, 0, 45)
            MinimizeIcon.Image = GetIcon("alt-arrow-down-bold")
        else
            MainWindow.Size = isExpanded and expandedSize or defaultSize
            ContentContainer.Visible = true
            Sidebar.Size = UDim2.new(0, 190, 1, 0)
            MinimizeIcon.Image = GetIcon("alt-arrow-up-bold")
        end
    end)

    ResizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then return end
        isExpanded = not isExpanded
        if isExpanded then
            MainWindow.Size = expandedSize
            MainWindow.Position = UDim2.new(0.5, -390, 0.5, -265)
        else
            MainWindow.Size = defaultSize
            MainWindow.Position = UDim2.new(0.5, -330, 0.5, -225)
        end
    end)

    local WindowObj = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        TabHolder = TabHolder,
        ContentContainer = ContentContainer,
        Tabs = {},
        ActiveTab = nil
    }

    function WindowObj:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "home-2-bold"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName .. "_TabBtn"
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabHolder

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 10)
        TabBtnCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 12, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = GetIcon(tabIcon)
        TabIcon.ImageColor3 = Color3.fromRGB(140, 145, 158)
        TabIcon.Parent = TabBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 38, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Color3.fromRGB(120, 125, 138)
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "_Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(210, 215, 225)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 4)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.Parent = TabContent

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        local TabObj = {
            TabBtn = TabBtn,
            TabContent = TabContent
        }

        local function Activate()
            for _, t in pairs(WindowObj.Tabs) do
                t.TabContent.Visible = false
                t.TabBtn.BackgroundTransparency = 1
                local icon = t.TabBtn:FindFirstChildOfClass("ImageLabel")
                local label = t.TabBtn:FindFirstChildOfClass("TextLabel")
                if icon then icon.ImageColor3 = Color3.fromRGB(140, 145, 158) end
                if label then label.TextColor3 = Color3.fromRGB(120, 125, 138) end
            end

            TabContent.Visible = true
            WindowObj.ActiveTab = TabObj
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabIcon.ImageColor3 = Color3.fromRGB(40, 45, 55)
            TabLabel.TextColor3 = Color3.fromRGB(30, 35, 45)
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if #WindowObj.Tabs == 0 then
            Activate()
        end

        table.insert(WindowObj.Tabs, TabObj)

        function TabObj:CreateSection(sectionConfig)
            local sectionTitle = type(sectionConfig) == "table" and (sectionConfig.Name or "Section") or tostring(sectionConfig)
            local isCollapsible = type(sectionConfig) == "table" and (sectionConfig.Collapsible ~= false) or true
            local isCollapsed = type(sectionConfig) == "table" and (sectionConfig.DefaultCollapsed or false) or false

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section_" .. sectionTitle
            SectionFrame.Size = UDim2.new(1, 0, 0, 34)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionFrame.ClipsDescendants = true
            SectionFrame.Parent = TabContent

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionFrame

            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = Color3.fromRGB(232, 235, 242)
            SectionStroke.Thickness = 1
            SectionStroke.Parent = SectionFrame

            local SectionHeaderBtn = Instance.new("TextButton")
            SectionHeaderBtn.Name = "HeaderBtn"
            SectionHeaderBtn.Size = UDim2.new(1, 0, 0, 34)
            SectionHeaderBtn.BackgroundTransparency = 1
            SectionHeaderBtn.Text = ""
            SectionHeaderBtn.AutoButtonColor = false
            SectionHeaderBtn.Parent = SectionFrame

            local SectionHeaderLabel = Instance.new("TextLabel")
            SectionHeaderLabel.Size = UDim2.new(1, -40, 1, 0)
            SectionHeaderLabel.Position = UDim2.new(0, 12, 0, 0)
            SectionHeaderLabel.BackgroundTransparency = 1
            SectionHeaderLabel.Text = string.upper(sectionTitle)
            SectionHeaderLabel.TextColor3 = Color3.fromRGB(130, 135, 150)
            SectionHeaderLabel.Font = Enum.Font.GothamBold
            SectionHeaderLabel.TextSize = 11
            SectionHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionHeaderLabel.Parent = SectionHeaderBtn

            local ArrowIcon = Instance.new("ImageLabel")
            ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
            ArrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Image = GetIcon("alt-arrow-down-bold")
            ArrowIcon.ImageColor3 = Color3.fromRGB(140, 145, 160)
            ArrowIcon.Visible = isCollapsible
            ArrowIcon.Parent = SectionHeaderBtn

            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = "ItemsContainer"
            SectionContainer.Size = UDim2.new(1, -20, 0, 0)
            SectionContainer.Position = UDim2.new(0, 10, 0, 36)
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Parent = SectionFrame

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.Parent = SectionContainer

            local function UpdateSectionSize()
                if isCollapsed then
                    SectionFrame.Size = UDim2.new(1, 0, 0, 34)
                    SectionContainer.Visible = false
                    ArrowIcon.Image = GetIcon("alt-arrow-right-bold")
                else
                    SectionContainer.Visible = true
                    SectionFrame.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 44)
                    ArrowIcon.Image = GetIcon("alt-arrow-down-bold")
                end
            end

            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)

            if isCollapsible then
                SectionHeaderBtn.MouseButton1Click:Connect(function()
                    isCollapsed = not isCollapsed
                    UpdateSectionSize()
                end)
            end

            UpdateSectionSize()

            local SectionObj = {}

            function SectionObj:CreateButton(btnConfig)
                btnConfig = btnConfig or {}
                local name = btnConfig.Name or "Button"
                local iconName = btnConfig.Icon or "cursor-bold"
                local callback = btnConfig.Callback or function() end

                local BtnFrame = Instance.new("TextButton")
                BtnFrame.Name = "Button_" .. name
                BtnFrame.Size = UDim2.new(1, 0, 0, 36)
                BtnFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                BtnFrame.Text = ""
                BtnFrame.AutoButtonColor = false
                BtnFrame.Parent = SectionContainer

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = BtnFrame

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Color3.fromRGB(230, 233, 240)
                BtnStroke.Thickness = 1
                BtnStroke.Parent = BtnFrame

                local BtnText = Instance.new("TextLabel")
                BtnText.Size = UDim2.new(1, -40, 1, 0)
                BtnText.Position = UDim2.new(0, 12, 0, 0)
                BtnText.BackgroundTransparency = 1
                BtnText.Text = name
                BtnText.TextColor3 = Color3.fromRGB(50, 55, 68)
                BtnText.Font = Enum.Font.GothamMedium
                BtnText.TextSize = 13
                BtnText.TextXAlignment = Enum.TextXAlignment.Left
                BtnText.Parent = BtnFrame

                local ActionIcon = Instance.new("ImageLabel")
                ActionIcon.Size = UDim2.new(0, 16, 0, 16)
                ActionIcon.Position = UDim2.new(1, -26, 0.5, -8)
                ActionIcon.BackgroundTransparency = 1
                ActionIcon.Image = GetIcon(iconName)
                ActionIcon.ImageColor3 = Color3.fromRGB(140, 145, 158)
                ActionIcon.Parent = BtnFrame

                BtnFrame.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)

                return BtnFrame
            end

            function SectionObj:CreateToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local name = toggleConfig.Name or "Toggle"
                local state = toggleConfig.Default or false
                local callback = toggleConfig.Callback or function() end

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle_" .. name
                ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                ToggleFrame.Parent = SectionContainer

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = ToggleFrame

                local ToggleStroke = Instance.new("UIStroke")
                ToggleStroke.Color = Color3.fromRGB(230, 233, 240)
                ToggleStroke.Thickness = 1
                ToggleStroke.Parent = ToggleFrame

                local ToggleText = Instance.new("TextLabel")
                ToggleText.Size = UDim2.new(1, -60, 1, 0)
                ToggleText.Position = UDim2.new(0, 12, 0, 0)
                ToggleText.BackgroundTransparency = 1
                ToggleText.Text = name
                ToggleText.TextColor3 = Color3.fromRGB(50, 55, 68)
                ToggleText.Font = Enum.Font.GothamMedium
                ToggleText.TextSize = 13
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left
                ToggleText.Parent = ToggleFrame

                local SwitchBg = Instance.new("TextButton")
                SwitchBg.Size = UDim2.new(0, 38, 0, 20)
                SwitchBg.Position = UDim2.new(1, -48, 0.5, -10)
                SwitchBg.BackgroundColor3 = state and Color3.fromRGB(60, 65, 78) or Color3.fromRGB(215, 220, 228)
                SwitchBg.Text = ""
                SwitchBg.AutoButtonColor = false
                SwitchBg.Parent = ToggleFrame

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = SwitchBg

                local SwitchKnob = Instance.new("Frame")
                SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
                SwitchKnob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SwitchKnob.Parent = SwitchBg

                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SwitchKnob

                local function UpdateState()
                    SwitchBg.BackgroundColor3 = state and Color3.fromRGB(60, 65, 78) or Color3.fromRGB(215, 220, 228)
                    SwitchKnob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    pcall(callback, state)
                end

                local ClickArea = Instance.new("TextButton")
                ClickArea.Size = UDim2.new(1, 0, 1, 0)
                ClickArea.BackgroundTransparency = 1
                ClickArea.Text = ""
                ClickArea.Parent = ToggleFrame

                ClickArea.MouseButton1Click:Connect(function()
                    state = not state
                    UpdateState()
                end)

                return ToggleFrame
            end

            function SectionObj:CreateSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                local name = sliderConfig.Name or "Slider"
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Default or min
                local suffix = sliderConfig.Suffix or ""
                local callback = sliderConfig.Callback or function() end

                local currentValue = math.clamp(default, min, max)

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "Slider_" .. name
                SliderFrame.Size = UDim2.new(1, 0, 0, 48)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                SliderFrame.Parent = SectionContainer

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Parent = SliderFrame

                local SliderStroke = Instance.new("UIStroke")
                SliderStroke.Color = Color3.fromRGB(230, 233, 240)
                SliderStroke.Thickness = 1
                SliderStroke.Parent = SliderFrame

                local SliderText = Instance.new("TextLabel")
                SliderText.Size = UDim2.new(1, -90, 0, 22)
                SliderText.Position = UDim2.new(0, 12, 0, 4)
                SliderText.BackgroundTransparency = 1
                SliderText.Text = name
                SliderText.TextColor3 = Color3.fromRGB(50, 55, 68)
                SliderText.Font = Enum.Font.GothamMedium
                SliderText.TextSize = 13
                SliderText.TextXAlignment = Enum.TextXAlignment.Left
                SliderText.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 75, 0, 22)
                ValueLabel.Position = UDim2.new(1, -87, 0, 4)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(currentValue) .. (suffix ~= "" and (" " .. suffix) or "")
                ValueLabel.TextColor3 = Color3.fromRGB(120, 125, 138)
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, -24, 0, 6)
                Track.Position = UDim2.new(0, 12, 0, 32)
                Track.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
                Track.Parent = SliderFrame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(70, 75, 88)
                Fill.Parent = Track

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                local dragging = false
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor(min + (max - min) * pos)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    ValueLabel.Text = tostring(currentValue) .. (suffix ~= "" and (" " .. suffix) or "")
                    pcall(callback, currentValue)
                end

                SliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                SliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)

                return SliderFrame
            end

            function SectionObj:CreateDropdown(dropConfig)
                dropConfig = dropConfig or {}
                local name = dropConfig.Name or "Dropdown"
                local options = dropConfig.Options or {}
                local default = dropConfig.Default or options[1] or ""
                local callback = dropConfig.Callback or function() end

                local selected = default
                local isDropdownExpanded = false

                local DropFrame = Instance.new("Frame")
                DropFrame.Name = "Dropdown_" .. name
                DropFrame.Size = UDim2.new(1, 0, 0, 40)
                DropFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                DropFrame.ClipsDescendants = true
                DropFrame.Parent = SectionContainer

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 8)
                DropCorner.Parent = DropFrame

                local DropStroke = Instance.new("UIStroke")
                DropStroke.Color = Color3.fromRGB(230, 233, 240)
                DropStroke.Thickness = 1
                DropStroke.Parent = DropFrame

                local DropHeader = Instance.new("TextButton")
                DropHeader.Size = UDim2.new(1, 0, 0, 40)
                DropHeader.BackgroundTransparency = 1
                DropHeader.Text = ""
                DropHeader.Parent = DropFrame

                local DropTitle = Instance.new("TextLabel")
                DropTitle.Size = UDim2.new(0.5, -12, 1, 0)
                DropTitle.Position = UDim2.new(0, 12, 0, 0)
                DropTitle.BackgroundTransparency = 1
                DropTitle.Text = name
                DropTitle.TextColor3 = Color3.fromRGB(50, 55, 68)
                DropTitle.Font = Enum.Font.GothamMedium
                DropTitle.TextSize = 13
                DropTitle.TextXAlignment = Enum.TextXAlignment.Left
                DropTitle.Parent = DropHeader

                local DropVal = Instance.new("TextLabel")
                DropVal.Size = UDim2.new(0.5, -28, 1, 0)
                DropVal.Position = UDim2.new(0.5, -10, 0, 0)
                DropVal.BackgroundTransparency = 1
                DropVal.Text = selected
                DropVal.TextColor3 = Color3.fromRGB(120, 125, 138)
                DropVal.Font = Enum.Font.Gotham
                DropVal.TextSize = 12
                DropVal.TextXAlignment = Enum.TextXAlignment.Right
                DropVal.Parent = DropHeader

                local ArrowIcon = Instance.new("ImageLabel")
                ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
                ArrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Image = GetIcon("alt-arrow-down-bold")
                ArrowIcon.ImageColor3 = Color3.fromRGB(140, 145, 158)
                ArrowIcon.Parent = DropHeader

                local ListHolder = Instance.new("Frame")
                ListHolder.Size = UDim2.new(1, -16, 0, #options * 30)
                ListHolder.Position = UDim2.new(0, 8, 0, 40)
                ListHolder.BackgroundTransparency = 1
                ListHolder.Parent = DropFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 4)
                ListLayout.Parent = ListHolder

                local function ToggleDropdown()
                    isDropdownExpanded = not isDropdownExpanded
                    DropFrame.Size = UDim2.new(1, 0, 0, isDropdownExpanded and (45 + ListLayout.AbsoluteContentSize.Y) or 40)
                    ArrowIcon.Image = isDropdownExpanded and GetIcon("alt-arrow-up-bold") or GetIcon("alt-arrow-down-bold")
                    UpdateSectionSize()
                end

                DropHeader.MouseButton1Click:Connect(ToggleDropdown)

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = (opt == selected) and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(130, 135, 148)
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    OptBtn.AutoButtonColor = false
                    OptBtn.Parent = ListHolder

                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 6)
                    OptCorner.Parent = OptBtn

                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        DropVal.Text = selected
                        for _, child in ipairs(ListHolder:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.TextColor3 = (child.Text == selected) and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(130, 135, 148)
                            end
                        end
                        ToggleDropdown()
                        pcall(callback, selected)
                    end)
                end

                return DropFrame
            end

            function SectionObj:CreateMultiDropdown(multiConfig)
                multiConfig = multiConfig or {}
                local name = multiConfig.Name or "Multi Dropdown"
                local options = multiConfig.Options or {}
                local default = multiConfig.Default or {}
                local callback = multiConfig.Callback or function() end

                local selectedMap = {}
                for _, opt in ipairs(default) do
                    selectedMap[opt] = true
                end

                local isExpanded = false

                local MultiFrame = Instance.new("Frame")
                MultiFrame.Name = "MultiDropdown_" .. name
                MultiFrame.Size = UDim2.new(1, 0, 0, 40)
                MultiFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                MultiFrame.ClipsDescendants = true
                MultiFrame.Parent = SectionContainer

                local MultiCorner = Instance.new("UICorner")
                MultiCorner.CornerRadius = UDim.new(0, 8)
                MultiCorner.Parent = MultiFrame

                local MultiStroke = Instance.new("UIStroke")
                MultiStroke.Color = Color3.fromRGB(230, 233, 240)
                MultiStroke.Thickness = 1
                MultiStroke.Parent = MultiFrame

                local MultiHeader = Instance.new("TextButton")
                MultiHeader.Size = UDim2.new(1, 0, 0, 40)
                MultiHeader.BackgroundTransparency = 1
                MultiHeader.Text = ""
                MultiHeader.Parent = MultiFrame

                local MultiTitle = Instance.new("TextLabel")
                MultiTitle.Size = UDim2.new(0.5, -12, 1, 0)
                MultiTitle.Position = UDim2.new(0, 12, 0, 0)
                MultiTitle.BackgroundTransparency = 1
                MultiTitle.Text = name
                MultiTitle.TextColor3 = Color3.fromRGB(50, 55, 68)
                MultiTitle.Font = Enum.Font.GothamMedium
                MultiTitle.TextSize = 13
                MultiTitle.TextXAlignment = Enum.TextXAlignment.Left
                MultiTitle.Parent = MultiHeader

                local MultiVal = Instance.new("TextLabel")
                MultiVal.Size = UDim2.new(0.5, -28, 1, 0)
                MultiVal.Position = UDim2.new(0.5, -10, 0, 0)
                MultiVal.BackgroundTransparency = 1
                MultiVal.Text = "None"
                MultiVal.TextColor3 = Color3.fromRGB(120, 125, 138)
                MultiVal.Font = Enum.Font.Gotham
                MultiVal.TextSize = 12
                MultiVal.TextXAlignment = Enum.TextXAlignment.Right
                MultiVal.Parent = MultiHeader

                local ArrowIcon = Instance.new("ImageLabel")
                ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
                ArrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
                ArrowIcon.BackgroundTransparency = 1
                ArrowIcon.Image = GetIcon("alt-arrow-down-bold")
                ArrowIcon.ImageColor3 = Color3.fromRGB(140, 145, 158)
                ArrowIcon.Parent = MultiHeader

                local ListHolder = Instance.new("Frame")
                ListHolder.Size = UDim2.new(1, -16, 0, #options * 30)
                ListHolder.Position = UDim2.new(0, 8, 0, 40)
                ListHolder.BackgroundTransparency = 1
                ListHolder.Parent = MultiFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 4)
                ListLayout.Parent = ListHolder

                local function GetSelectedList()
                    local list = {}
                    for _, opt in ipairs(options) do
                        if selectedMap[opt] then
                            table.insert(list, opt)
                        end
                    end
                    return list
                end

                local function UpdateDisplay()
                    local active = GetSelectedList()
                    if #active == 0 then
                        MultiVal.Text = "None"
                    elseif #active == 1 then
                        MultiVal.Text = active[1]
                    else
                        MultiVal.Text = #active .. " Selected"
                    end
                end

                UpdateDisplay()

                local function ToggleDropdown()
                    isExpanded = not isExpanded
                    MultiFrame.Size = UDim2.new(1, 0, 0, isExpanded and (45 + ListLayout.AbsoluteContentSize.Y) or 40)
                    ArrowIcon.Image = isExpanded and GetIcon("alt-arrow-up-bold") or GetIcon("alt-arrow-down-bold")
                    UpdateSectionSize()
                end

                MultiHeader.MouseButton1Click:Connect(ToggleDropdown)

                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundColor3 = selectedMap[opt] and Color3.fromRGB(240, 243, 250) or Color3.fromRGB(255, 255, 255)
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = selectedMap[opt] and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(130, 135, 148)
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    OptBtn.AutoButtonColor = false
                    OptBtn.Parent = ListHolder

                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 6)
                    OptCorner.Parent = OptBtn

                    local CheckIcon = Instance.new("ImageLabel")
                    CheckIcon.Size = UDim2.new(0, 14, 0, 14)
                    CheckIcon.Position = UDim2.new(1, -20, 0.5, -7)
                    CheckIcon.BackgroundTransparency = 1
                    CheckIcon.Image = GetIcon("check-square-bold")
                    CheckIcon.ImageColor3 = Color3.fromRGB(60, 65, 78)
                    CheckIcon.Visible = selectedMap[opt] or false
                    CheckIcon.Parent = OptBtn

                    OptBtn.MouseButton1Click:Connect(function()
                        selectedMap[opt] = not selectedMap[opt]
                        CheckIcon.Visible = selectedMap[opt]
                        OptBtn.BackgroundColor3 = selectedMap[opt] and Color3.fromRGB(240, 243, 250) or Color3.fromRGB(255, 255, 255)
                        OptBtn.TextColor3 = selectedMap[opt] and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(130, 135, 148)
                        UpdateDisplay()
                        pcall(callback, GetSelectedList(), selectedMap)
                    end)
                end

                return MultiFrame
            end

            function SectionObj:CreateKeybind(keybindConfig)
                keybindConfig = keybindConfig or {}
                local name = keybindConfig.Name or "Keybind"
                local defaultKey = keybindConfig.Default or Enum.KeyCode.E
                local callback = keybindConfig.Callback or function() end

                local currentKey = defaultKey
                local isBinding = false

                local KeyFrame = Instance.new("Frame")
                KeyFrame.Name = "Keybind_" .. name
                KeyFrame.Size = UDim2.new(1, 0, 0, 38)
                KeyFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                KeyFrame.Parent = SectionContainer

                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 8)
                KeyCorner.Parent = KeyFrame

                local KeyStroke = Instance.new("UIStroke")
                KeyStroke.Color = Color3.fromRGB(230, 233, 240)
                KeyStroke.Thickness = 1
                KeyStroke.Parent = KeyFrame

                local KeyTitle = Instance.new("TextLabel")
                KeyTitle.Size = UDim2.new(0.6, -12, 1, 0)
                KeyTitle.Position = UDim2.new(0, 12, 0, 0)
                KeyTitle.BackgroundTransparency = 1
                KeyTitle.Text = name
                KeyTitle.TextColor3 = Color3.fromRGB(50, 55, 68)
                KeyTitle.Font = Enum.Font.GothamMedium
                KeyTitle.TextSize = 13
                KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
                KeyTitle.Parent = KeyFrame

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size = UDim2.new(0, 80, 0, 24)
                KeyBtn.Position = UDim2.new(1, -92, 0.5, -12)
                KeyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeyBtn.Text = currentKey.Name
                KeyBtn.TextColor3 = Color3.fromRGB(40, 45, 55)
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.TextSize = 11
                KeyBtn.AutoButtonColor = false
                KeyBtn.Parent = KeyFrame

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = KeyBtn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Color3.fromRGB(225, 228, 236)
                BtnStroke.Thickness = 1
                BtnStroke.Parent = KeyBtn

                KeyBtn.MouseButton1Click:Connect(function()
                    isBinding = true
                    KeyBtn.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
                            currentKey = input.KeyCode
                            KeyBtn.Text = currentKey.Name
                        end
                        isBinding = false
                    elseif not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == currentKey then
                            pcall(callback, currentKey)
                        end
                    end
                end)

                return KeyFrame
            end

            function SectionObj:CreateInput(inputConfig)
                inputConfig = inputConfig or {}
                local name = inputConfig.Name or "Input"
                local placeholder = inputConfig.Placeholder or "Type here..."
                local callback = inputConfig.Callback or function() end

                local InputFrame = Instance.new("Frame")
                InputFrame.Name = "Input_" .. name
                InputFrame.Size = UDim2.new(1, 0, 0, 40)
                InputFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                InputFrame.Parent = SectionContainer

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 8)
                InputCorner.Parent = InputFrame

                local InputStroke = Instance.new("UIStroke")
                InputStroke.Color = Color3.fromRGB(230, 233, 240)
                InputStroke.Thickness = 1
                InputStroke.Parent = InputFrame

                local InputTitle = Instance.new("TextLabel")
                InputTitle.Size = UDim2.new(0.4, -12, 1, 0)
                InputTitle.Position = UDim2.new(0, 12, 0, 0)
                InputTitle.BackgroundTransparency = 1
                InputTitle.Text = name
                InputTitle.TextColor3 = Color3.fromRGB(50, 55, 68)
                InputTitle.Font = Enum.Font.GothamMedium
                InputTitle.TextSize = 13
                InputTitle.TextXAlignment = Enum.TextXAlignment.Left
                InputTitle.Parent = InputFrame

                local TextBox = Instance.new("TextBox")
                TextBox.Size = UDim2.new(0.6, -16, 0, 26)
                TextBox.Position = UDim2.new(0.4, 4, 0.5, -13)
                TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.Text = ""
                TextBox.PlaceholderText = placeholder
                TextBox.TextColor3 = Color3.fromRGB(40, 45, 55)
                TextBox.PlaceholderColor3 = Color3.fromRGB(160, 165, 178)
                TextBox.Font = Enum.Font.Gotham
                TextBox.TextSize = 12
                TextBox.ClearTextOnFocus = false
                TextBox.Parent = InputFrame

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = TextBox

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = Color3.fromRGB(225, 228, 236)
                BoxStroke.Thickness = 1
                BoxStroke.Parent = TextBox

                TextBox.FocusLost:Connect(function(enterPressed)
                    pcall(callback, TextBox.Text, enterPressed)
                end)

                return InputFrame
            end

            function SectionObj:CreateParagraph(paraConfig)
                paraConfig = paraConfig or {}
                local title = paraConfig.Title or "Information"
                local content = paraConfig.Content or ""
                local iconName = paraConfig.Icon or "info-square-bold"

                local ParaFrame = Instance.new("Frame")
                ParaFrame.Name = "Paragraph_" .. title
                ParaFrame.Size = UDim2.new(1, 0, 0, 58)
                ParaFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                ParaFrame.Parent = SectionContainer

                local ParaCorner = Instance.new("UICorner")
                ParaCorner.CornerRadius = UDim.new(0, 8)
                ParaCorner.Parent = ParaFrame

                local ParaStroke = Instance.new("UIStroke")
                ParaStroke.Color = Color3.fromRGB(230, 233, 240)
                ParaStroke.Thickness = 1
                ParaStroke.Parent = ParaFrame

                local ParaIcon = Instance.new("ImageLabel")
                ParaIcon.Size = UDim2.new(0, 18, 0, 18)
                ParaIcon.Position = UDim2.new(0, 10, 0, 10)
                ParaIcon.BackgroundTransparency = 1
                ParaIcon.Image = GetIcon(iconName)
                ParaIcon.ImageColor3 = Color3.fromRGB(110, 115, 130)
                ParaIcon.Parent = ParaFrame

                local ParaTitle = Instance.new("TextLabel")
                ParaTitle.Size = UDim2.new(1, -38, 0, 20)
                ParaTitle.Position = UDim2.new(0, 34, 0, 8)
                ParaTitle.BackgroundTransparency = 1
                ParaTitle.Text = title
                ParaTitle.TextColor3 = Color3.fromRGB(40, 45, 55)
                ParaTitle.Font = Enum.Font.GothamBold
                ParaTitle.TextSize = 13
                ParaTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParaTitle.Parent = ParaFrame

                local ParaText = Instance.new("TextLabel")
                ParaText.Size = UDim2.new(1, -38, 0, 24)
                ParaText.Position = UDim2.new(0, 34, 0, 28)
                ParaText.BackgroundTransparency = 1
                ParaText.Text = content
                ParaText.TextColor3 = Color3.fromRGB(120, 125, 138)
                ParaText.Font = Enum.Font.Gotham
                ParaText.TextSize = 11
                ParaText.TextWrapped = true
                ParaText.TextXAlignment = Enum.TextXAlignment.Left
                ParaText.Parent = ParaFrame

                return ParaFrame
            end

            function SectionObj:CreateLabel(labelConfig)
                labelConfig = labelConfig or {}
                local text = type(labelConfig) == "table" and (labelConfig.Text or "Label") or tostring(labelConfig)
                local iconName = type(labelConfig) == "table" and labelConfig.Icon or "info-square-bold"

                local LabelFrame = Instance.new("Frame")
                LabelFrame.Name = "Label_" .. text
                LabelFrame.Size = UDim2.new(1, 0, 0, 32)
                LabelFrame.BackgroundColor3 = Color3.fromRGB(245, 247, 252)
                LabelFrame.Parent = SectionContainer

                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 8)
                LabelCorner.Parent = LabelFrame

                local LabelStroke = Instance.new("UIStroke")
                LabelStroke.Color = Color3.fromRGB(230, 233, 240)
                LabelStroke.Thickness = 1
                LabelStroke.Parent = LabelFrame

                local InfoIcon = Instance.new("ImageLabel")
                InfoIcon.Size = UDim2.new(0, 16, 0, 16)
                InfoIcon.Position = UDim2.new(0, 10, 0.5, -8)
                InfoIcon.BackgroundTransparency = 1
                InfoIcon.Image = GetIcon(iconName)
                InfoIcon.ImageColor3 = Color3.fromRGB(130, 135, 150)
                InfoIcon.Parent = LabelFrame

                local LabelText = Instance.new("TextLabel")
                LabelText.Size = UDim2.new(1, -36, 1, 0)
                LabelText.Position = UDim2.new(0, 32, 0, 0)
                LabelText.BackgroundTransparency = 1
                LabelText.Text = text
                LabelText.TextColor3 = Color3.fromRGB(70, 75, 88)
                LabelText.Font = Enum.Font.Gotham
                LabelText.TextSize = 12
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                LabelText.Parent = LabelFrame

                return LabelFrame
            end

            return SectionObj
        end

        return TabObj
    end

    return WindowObj
end

return Library
