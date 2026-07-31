local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local SolarIcons = {}
pcall(function()
    SolarIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))()
end)

local function GetIcon(name)
    if not name or name == "" then return "" end
    if SolarIcons and SolarIcons[name] then
        return SolarIcons[name]
    end
    return name
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

local Cloudy = {}
Cloudy.__index = Cloudy

function Cloudy.new(options)
    options = options or {}
    local windowTitle = options.Title or "Cloudy"
    local windowSub = options.SubTitle or "UI Framework"
    local toggleIcon = options.ToggleIcon or "cloud-bold"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CloudyUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false

    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "FloatingToggle"
    ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 31)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleBtn

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(55, 58, 68)
    ToggleStroke.Thickness = 1.5
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ToggleStroke.Parent = ToggleBtn

    local ToggleIconImg = Instance.new("ImageLabel")
    ToggleIconImg.Name = "Icon"
    ToggleIconImg.Size = UDim2.new(0, 24, 0, 24)
    ToggleIconImg.AnchorPoint = Vector2.new(0.5, 0.5)
    ToggleIconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    ToggleIconImg.BackgroundTransparency = 1
    ToggleIconImg.Image = GetIcon(toggleIcon)
    ToggleIconImg.ImageColor3 = Color3.fromRGB(235, 238, 245)
    ToggleIconImg.Parent = ToggleBtn

    MakeDraggable(ToggleBtn)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 640, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(48, 51, 62)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(35, 37, 46)
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local BrandContainer = Instance.new("Frame")
    BrandContainer.Size = UDim2.new(1, 0, 0, 65)
    BrandContainer.BackgroundTransparency = 1
    BrandContainer.Parent = Sidebar

    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Size = UDim2.new(0, 22, 0, 22)
    LogoIcon.Position = UDim2.new(0, 16, 0, 20)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = GetIcon("cloud-bold")
    LogoIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LogoIcon.Parent = BrandContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 0, 24)
    TitleLabel.Position = UDim2.new(0, 44, 0, 14)
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
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(210, 214, 222)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(115, 120, 132)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(42, 45, 54))
    })
    TitleGrad.Rotation = 0
    TitleGrad.Parent = TitleLabel

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, -50, 0, 14)
    SubLabel.Position = UDim2.new(0, 44, 0, 36)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = windowSub
    SubLabel.TextColor3 = Color3.fromRGB(120, 125, 138)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 11
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Parent = BrandContainer

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -16, 1, -80)
    TabContainer.Position = UDim2.new(0, 8, 0, 70)
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

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, -180, 0, 45)
    TopBar.Position = UDim2.new(0, 180, 0, 0)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    MakeDraggable(MainFrame, TopBar)

    local PageTitle = Instance.new("TextLabel")
    PageTitle.Size = UDim2.new(1, -80, 1, 0)
    PageTitle.Position = UDim2.new(0, 20, 0, 0)
    PageTitle.BackgroundTransparency = 1
    PageTitle.Text = "Dashboard"
    PageTitle.TextColor3 = Color3.fromRGB(235, 238, 245)
    PageTitle.Font = Enum.Font.GothamBold
    PageTitle.TextSize = 14
    PageTitle.TextXAlignment = Enum.TextXAlignment.Left
    PageTitle.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    CloseBtn.AutoButtonColor = false
    CloseBtn.Text = ""
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Size = UDim2.new(0, 14, 0, 14)
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = GetIcon("close-square-linear")
    CloseIcon.ImageColor3 = Color3.fromRGB(160, 165, 178)
    CloseIcon.Parent = CloseBtn

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -180, 1, -45)
    ContentArea.Position = UDim2.new(0, 180, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local isOpen = true
    local function ToggleUI()
        isOpen = not isOpen
        MainFrame.Visible = isOpen
    end

    ToggleBtn.MouseButton1Click:Connect(ToggleUI)
    CloseBtn.MouseButton1Click:Connect(ToggleUI)

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

    function TabMethods:CreateSection(sectionTitle)
        local SecFrame = Instance.new("Frame")
        SecFrame.Size = UDim2.new(1, 0, 0, 30)
        SecFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
        SecFrame.Parent = TabPage

        local SecCorner = Instance.new("UICorner")
        SecCorner.CornerRadius = UDim.new(0, 10)
        SecCorner.Parent = SecFrame

        local SecStroke = Instance.new("UIStroke")
        SecStroke.Color = Color3.fromRGB(38, 40, 50)
        SecStroke.Thickness = 1
        SecStroke.Parent = SecFrame

        local SecTitle = Instance.new("TextLabel")
        SecTitle.Size = UDim2.new(1, -20, 0, 24)
        SecTitle.Position = UDim2.new(0, 12, 0, 6)
        SecTitle.BackgroundTransparency = 1
        SecTitle.Text = sectionTitle
        SecTitle.TextColor3 = Color3.fromRGB(200, 204, 215)
        SecTitle.Font = Enum.Font.GothamBold
        SecTitle.TextSize = 12
        SecTitle.TextXAlignment = Enum.TextXAlignment.Left
        SecTitle.Parent = SecFrame

        local SecContent = Instance.new("Frame")
        SecContent.Size = UDim2.new(1, -16, 1, -34)
        SecContent.Position = UDim2.new(0, 8, 0, 30)
        SecContent.BackgroundTransparency = 1
        SecContent.Parent = SecFrame

        local SecLayout = Instance.new("UIListLayout")
        SecLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SecLayout.Padding = UDim.new(0, 6)
        SecLayout.Parent = SecContent

        SecLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SecFrame.Size = UDim2.new(1, 0, 0, SecLayout.AbsoluteContentSize.Y + 38)
        end)

        local SecMethods = {}

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
            ParaFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            ParaFrame.Parent = SecContent

            local ParaCorner = Instance.new("UICorner")
            ParaCorner.CornerRadius = UDim.new(0, 8)
            ParaCorner.Parent = ParaFrame

            local ParaStroke = Instance.new("UIStroke")
            ParaStroke.Color = Color3.fromRGB(45, 48, 60)
            ParaStroke.Thickness = 1
            ParaStroke.Parent = ParaFrame

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
            Btn.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            Btn.AutoButtonColor = false
            Btn.Text = ""
            Btn.Parent = SecContent

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Btn

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(45, 48, 60)
            BtnStroke.Thickness = 1
            BtnStroke.Parent = Btn

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
            TogFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            TogFrame.Parent = SecContent

            local TogCorner = Instance.new("UICorner")
            TogCorner.CornerRadius = UDim.new(0, 8)
            TogCorner.Parent = TogFrame

            local TogStroke = Instance.new("UIStroke")
            TogStroke.Color = Color3.fromRGB(45, 48, 60)
            TogStroke.Thickness = 1
            TogStroke.Parent = TogFrame

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
            SldFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            SldFrame.Parent = SecContent

            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = UDim.new(0, 8)
            SldCorner.Parent = SldFrame

            local SldStroke = Instance.new("UIStroke")
            SldStroke.Color = Color3.fromRGB(45, 48, 60)
            SldStroke.Thickness = 1
            SldStroke.Parent = SldFrame

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
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = SecContent

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = DropFrame

            local DropStroke = Instance.new("UIStroke")
            DropStroke.Color = Color3.fromRGB(45, 48, 60)
            DropStroke.Thickness = 1
            DropStroke.Parent = DropFrame

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
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = SecContent

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = DropFrame

            local DropStroke = Instance.new("UIStroke")
            DropStroke.Color = Color3.fromRGB(45, 48, 60)
            DropStroke.Thickness = 1
            DropStroke.Parent = DropFrame

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
            PrevStroke.Parent = Preview
        end

        function SecMethods:CreateInput(text, placeholder, callback)
            placeholder = placeholder or "Type here..."
            callback = callback or function() end

            local InpFrame = Instance.new("Frame")
            InpFrame.Size = UDim2.new(1, 0, 0, 34)
            InpFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            InpFrame.Parent = SecContent

            local InpCorner = Instance.new("UICorner")
            InpCorner.CornerRadius = UDim.new(0, 8)
            InpCorner.Parent = InpFrame

            local InpStroke = Instance.new("UIStroke")
            InpStroke.Color = Color3.fromRGB(45, 48, 60)
            InpStroke.Thickness = 1
            InpStroke.Parent = InpFrame

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
            KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            KeyFrame.Parent = SecContent

            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 8)
            KeyCorner.Parent = KeyFrame

            local KeyStroke = Instance.new("UIStroke")
            KeyStroke.Color = Color3.fromRGB(45, 48, 60)
            KeyStroke.Thickness = 1
            KeyStroke.Parent = KeyFrame

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
