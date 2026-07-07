local ReaperHub = {}
ReaperHub.__index = ReaperHub

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local WindowSize = UDim2.new(0, 650, 0, 450)
local WindowPosition = UDim2.new(0.5, -325, 0.5, -225)
local FloatingImageId = "72659078152849"
local FloatingSize = UDim2.new(0, 55, 0, 55)
local FloatingPosition = UDim2.new(0, 30, 0, 30)

local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function RoundCorner(instance, radius)
    radius = radius or UDim.new(0, 6)
    local corner = Create("UICorner", {
        CornerRadius = radius,
        Parent = instance
    })
    return corner
end

local function AddStroke(instance, color, thickness)
    thickness = thickness or 1
    color = color or Color3.fromRGB(40, 40, 40)
    local stroke = Create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = 0.5,
        Parent = instance
    })
    return stroke
end

local function AddPadding(instance, padding)
    padding = padding or 10
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        Parent = instance
    })
end

local IconLibrary = {}
IconLibrary.__index = IconLibrary
IconLibrary.Packs = {}
IconLibrary.DefaultPack = "lucide"

function IconLibrary:LoadPack(name, url)
    local success, result = pcall(function()
        if game:HttpGet then
            local source = game:HttpGet(url)
            local loaded = loadstring(source)
            if loaded then
                self.Packs[name] = loaded()
                return true
            end
        end
        return false
    end)
    if not success then
        warn("[ReaperHub] Failed to load icon pack '" .. name .. "': " .. tostring(result))
        return false
    end
    return result
end

function IconLibrary:GetIcon(name, pack)
    pack = pack or self.DefaultPack
    local iconPack = self.Packs[pack]
    if not iconPack then
        if pack == "lucide" then
            self:LoadPack("lucide", "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
            iconPack = self.Packs["lucide"]
        end
    end
    if iconPack and iconPack[name] then
        return iconPack[name]
    end
    return nil
end

function IconLibrary:CreateIcon(config)
    config = config or {}
    local iconName = config.Icon or "circle"
    local pack = config.Pack or self.DefaultPack
    local size = config.Size or UDim2.new(0, 18, 0, 18)
    local color = config.Color or Color3.fromRGB(255, 255, 255)
    local iconData = self:GetIcon(iconName, pack)
    local iconLabel = Create("ImageLabel", {
        Size = size,
        BackgroundTransparency = 1,
        ImageColor3 = color,
        Image = iconData or "",
        Parent = config.Parent
    })
    return iconLabel
end

function IconLibrary:Init()
    self:LoadPack("lucide", "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
end

local FloatingUI = {}
FloatingUI.__index = FloatingUI

function FloatingUI.new(config)
    local self = setmetatable({}, FloatingUI)
    config = config or {}
    self.ImageId = config.ImageId or FloatingImageId
    self.Size = config.Size or FloatingSize
    self.Position = config.Position or FloatingPosition
    self.DragEnabled = config.DragEnabled ~= false
    self.OnClick = config.OnClick or function() end
    self:Build()
    return self
end

function FloatingUI:Build()
    self.ScreenGui = Create("ScreenGui", {
        Name = "ReaperHubFloating",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    self.MainFrame = Create("Frame", {
        Name = "FloatingButton",
        Size = self.Size,
        Position = self.Position,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    RoundCorner(self.MainFrame, UDim.new(1, 0))
    AddStroke(self.MainFrame, Color3.fromRGB(60, 60, 60), 1)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = self.MainFrame
    })
    shadow.ZIndex = -1
    self.LogoImage = Create("ImageLabel", {
        Name = "Logo",
        Size = UDim2.new(0.7, 0, 0.7, 0),
        Position = UDim2.new(0.15, 0, 0.15, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://" .. tostring(self.ImageId),
        Parent = self.MainFrame
    })
    self.ClickButton = Create("TextButton", {
        Name = "ClickDetector",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.MainFrame
    })
    self.MainFrame.MouseEnter:Connect(function()
        Tween(self.MainFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
        Tween(self.MainFrame, {Size = UDim2.new(0, 60, 0, 60)}, 0.2)
    end)
    self.MainFrame.MouseLeave:Connect(function()
        Tween(self.MainFrame, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}, 0.2)
        Tween(self.MainFrame, {Size = self.Size}, 0.2)
    end)
    self.ClickButton.MouseButton1Click:Connect(function()
        Tween(self.MainFrame, {Size = UDim2.new(0, 50, 0, 50)}, 0.1)
        task.wait(0.1)
        Tween(self.MainFrame, {Size = UDim2.new(0, 60, 0, 60)}, 0.2)
        self.OnClick()
    end)
    if self.DragEnabled then
        self:EnableDrag()
    end
end

function FloatingUI:EnableDrag()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    self.ClickButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function FloatingUI:SetVisible(visible)
    self.ScreenGui.Enabled = visible
end

function FloatingUI:Destroy()
    self.ScreenGui:Destroy()
end

local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    config = config or {}
    self.Title = config.Title or "Reaper Hub"
    self.Size = WindowSize
    self.Position = WindowPosition
    self.Tabs = {}
    self.CurrentTab = nil
    self.IconLibrary = IconLibrary
    self.IconLibrary:Init()
    self:Build()
    self:BuildFloatingUI()
    return self
end

function Window:Build()
    self.ScreenGui = Create("ScreenGui", {
        Name = "ReaperHubUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    self.MainFrame = Create("Frame", {
        Name = "MainWindow",
        Size = self.Size,
        Position = self.Position,
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    RoundCorner(self.MainFrame, UDim.new(0, 10))
    AddStroke(self.MainFrame, Color3.fromRGB(30, 30, 30), 1)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = self.MainFrame
    })
    shadow.ZIndex = -1
    self.TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    RoundCorner(self.TopBar, UDim.new(0, 10))
    local topBarFix = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0,
        Parent = self.TopBar
    })
    self.TitleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TopBar
    })
    self.CloseButton = Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = self.TopBar
    })
    RoundCorner(self.CloseButton, UDim.new(0, 6))
    self.CloseButton.MouseEnter:Connect(function()
        Tween(self.CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
    end)
    self.CloseButton.MouseLeave:Connect(function()
        Tween(self.CloseButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
    end)
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    self.MinimizeButton = Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "−",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = self.TopBar
    })
    RoundCorner(self.MinimizeButton, UDim.new(0, 6))
    self.MinimizeButton.MouseEnter:Connect(function()
        Tween(self.MinimizeButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
    end)
    self.MinimizeButton.MouseLeave:Connect(function()
        Tween(self.MinimizeButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
    end)
    self.Minimized = false
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    self.Sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    local sidebarFix = Create("Frame", {
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Parent = self.Sidebar
    })
    self.TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Sidebar
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = self.TabContainer
    })
    AddPadding(self.TabContainer, 8)
    self.ContentArea = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -150, 1, -40),
        Position = UDim2.new(0, 150, 0, 40),
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    self.ContentScroll = Create("ScrollingFrame", {
        Name = "ContentScroll",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.ContentArea
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = self.ContentScroll
    })
    AddPadding(self.ContentScroll, 5)
    self:EnableDrag()
    self:EnableResize()
end

function Window:BuildFloatingUI()
    self.FloatingUI = FloatingUI.new({
        ImageId = FloatingImageId,
        Size = FloatingSize,
        Position = FloatingPosition,
        DragEnabled = true,
        OnClick = function()
            self.MainFrame.Visible = not self.MainFrame.Visible
            if self.MainFrame.Visible then
                self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
                self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                Tween(self.MainFrame, {Size = self.Size, Position = self.Position}, 0.3)
            end
        end
    })
end

function Window:EnableDrag()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Window:EnableResize()
    local resizeHandle = Create("TextButton", {
        Name = "ResizeHandle",
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -15, 1, -15),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.MainFrame
    })
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = self.MainFrame.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(400, startSize.X.Offset + delta.X)
            local newHeight = math.max(300, startSize.Y.Offset + delta.Y)
            self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            self.ContentArea.Size = UDim2.new(1, -150, 1, -40)
            self.ContentArea.Position = UDim2.new(0, 150, 0, 40)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        Tween(self.MainFrame, {Size = UDim2.new(0, self.Size.X.Offset, 0, 40)}, 0.3)
        self.Sidebar.Visible = false
        self.ContentArea.Visible = false
    else
        Tween(self.MainFrame, {Size = self.Size}, 0.3)
        task.wait(0.3)
        self.Sidebar.Visible = true
        self.ContentArea.Visible = true
    end
end

function Window:Close()
    Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    Tween(self.MainFrame, {Position = UDim2.new(self.MainFrame.Position.X.Scale, self.MainFrame.Position.X.Offset + self.MainFrame.Size.X.Offset/2, self.MainFrame.Position.Y.Scale, self.MainFrame.Position.Y.Offset + self.MainFrame.Size.Y.Offset/2)}, 0.3)
    task.wait(0.3)
    self.ScreenGui:Destroy()
    if self.FloatingUI then
        self.FloatingUI:Destroy()
    end
end

function Window:CreateTab(config)
    config = config or {}
    local tabName = config.Name or "Tab"
    local icon = config.Icon or nil
    local tab = {}
    tab.Name = tabName
    tab.Elements = {}
    tab.Button = Create("TextButton", {
        Name = tabName .. "Tab",
        Size = UDim2.new(1, -16, 0, 36),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = "",
        Parent = self.TabContainer
    })
    RoundCorner(tab.Button, UDim.new(0, 8))
    if icon then
        tab.IconLabel = self.IconLibrary:CreateIcon({
            Icon = icon,
            Size = UDim2.new(0, 18, 0, 18),
            Color = Color3.fromRGB(180, 180, 180),
            Parent = tab.Button
        })
        tab.IconLabel.Position = UDim2.new(0, 10, 0.5, -9)
    end
    tab.TextLabel = Create("TextLabel", {
        Size = UDim2.new(1, icon and -40 or -20, 1, 0),
        Position = UDim2.new(0, icon and 35 or 10, 0, 0),
        BackgroundTransparency = 1,
        Text = tabName,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Button
    })
    tab.Content = Create("Frame", {
        Name = tabName .. "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentScroll
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = tab.Content
    })
    AddPadding(tab.Content, 5)
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
        end
    end)
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
        end
    end)
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    self:UpdateCanvasSize()
    return tab
end

function Window:SelectTab(tab)
    if self.CurrentTab then
           self.CurrentTab.Content.Visible = false
        Tween(self.CurrentTab.Button, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
        self.CurrentTab.TextLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        if self.CurrentTab.IconLabel then
            self.CurrentTab.IconLabel.ImageColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    self.CurrentTab = tab
    tab.Content.Visible = true
    Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
    tab.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    if tab.IconLabel then
        tab.IconLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end

function Window:UpdateCanvasSize()
    local totalHeight = 0
    for _, tab in ipairs(self.Tabs) do
        totalHeight = totalHeight + 40
    end
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

function Window:CreateSection(tab, config)
    config = config or {}
    local sectionName = config.Name or "Section"
    local collapsed = config.Collapsed or false
    local section = {}
    section.Collapsed = collapsed
    section.Frame = Create("Frame", {
        Name = sectionName .. "Section",
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Parent = tab.Content
    })
    RoundCorner(section.Frame, UDim.new(0, 8))
    AddStroke(section.Frame, Color3.fromRGB(35, 35, 35), 1)
    section.Header = Create("TextButton", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "",
        Parent = section.Frame
    })
    section.Title = Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = sectionName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Header
    })
    section.CollapseIcon = Create("TextLabel", {
        Name = "CollapseIcon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Text = collapsed and "▶" or "▼",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = section.Header
    })
    section.Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = section.Frame
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = section.Content
    })
    AddPadding(section.Content, 10)
    section.Header.MouseButton1Click:Connect(function()
        section.Collapsed = not section.Collapsed
        section.CollapseIcon.Text = section.Collapsed and "▶" or "▼"
        if section.Collapsed then
            Tween(section.Frame, {Size = UDim2.new(1, -10, 0, 40)}, 0.3)
            section.Content.Visible = false
        else
            local contentHeight = section.Content.UIListLayout.AbsoluteContentSize.Y + 20
            Tween(section.Frame, {Size = UDim2.new(1, -10, 0, 40 + contentHeight)}, 0.3)
            section.Content.Visible = true
        end
    end)
    section.Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if not section.Collapsed then
            local contentHeight = section.Content.UIListLayout.AbsoluteContentSize.Y + 20
            section.Frame.Size = UDim2.new(1, -10, 0, 40 + contentHeight)
        end
    end)
    return section
end

function Window:CreateParagraph(tab, config)
    config = config or {}
    local text = config.Text or "Paragraph text here..."
    local parent = config.Parent or tab.Content
    local paragraphFrame = Create("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Parent = parent
    })
    RoundCorner(paragraphFrame, UDim.new(0, 6))
    AddStroke(paragraphFrame, Color3.fromRGB(35, 35, 35), 1)
    local textLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = paragraphFrame
    })
    task.spawn(function()
        task.wait(0.1)
        paragraphFrame.Size = UDim2.new(1, -10, 0, textLabel.AbsoluteSize.Y + 20)
    end)
    return paragraphFrame
end

function Window:CreateButton(tab, config)
    config = config or {}
    local buttonText = config.Text or "Button"
    local callback = config.Callback or function() end
    local parent = config.Parent or tab.Content
    local button = Create("TextButton", {
        Name = buttonText .. "Button",
        Size = UDim2.new(1, -10, 0, 36),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = buttonText,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        Parent = parent
    })
    RoundCorner(button, UDim.new(0, 8))
    AddStroke(button, Color3.fromRGB(45, 45, 45), 1)
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
    end)
    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
    end)
    button.MouseButton1Click:Connect(function()
        Tween(button, {Size = UDim2.new(1, -14, 0, 32)}, 0.1)
        task.wait(0.1)
        Tween(button, {Size = UDim2.new(1, -10, 0, 36)}, 0.2)
        callback()
    end)
    return button
end

function Window:CreateToggle(tab, config)
    config = config or {}
    local toggleText = config.Text or "Toggle"
    local defaultState = config.Default or false
    local callback = config.Callback or function() end
    local parent = config.Parent or tab.Content
    local toggle = {}
    toggle.State = defaultState
    toggle.Frame = Create("Frame", {
        Name = toggleText .. "Toggle",
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Parent = parent
    })
    RoundCorner(toggle.Frame, UDim.new(0, 8))
    AddStroke(toggle.Frame, Color3.fromRGB(35, 35, 35), 1)
    toggle.TextLabel = Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = toggleText,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggle.Frame
    })
    toggle.Switch = Create("Frame", {
        Name = "Switch",
        Size = UDim2.new(0, 44, 0, 24),
        Position = UDim2.new(1, -54, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = toggle.Frame
    })
    RoundCorner(toggle.Switch, UDim.new(1, 0))
    toggle.Knob = Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 18, 0, 18),
        Position = defaultState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150),
        BorderSizePixel = 0,
        Parent = toggle.Switch
    })
    RoundCorner(toggle.Knob, UDim.new(1, 0))
    local clickArea = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = toggle.Frame
    })
    local function UpdateToggle()
        if toggle.State then
            Tween(toggle.Switch, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
            Tween(toggle.Knob, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2)
            Tween(toggle.Knob, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        else
            Tween(toggle.Switch, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            Tween(toggle.Knob, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2)
            Tween(toggle.Knob, {BackgroundColor3 = Color3.fromRGB(150, 150, 150)}, 0.2)
        end
        callback(toggle.State)
    end
    clickArea.MouseButton1Click:Connect(function()
        toggle.State = not toggle.State
        UpdateToggle()
    end)
    return toggle
end

function Window:CreateSlider(tab, config)
    config = config or {}
    local sliderText = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end
    local parent = config.Parent or tab.Content
    local slider = {}
    slider.Value = default
    slider.Frame = Create("Frame", {
        Name = sliderText .. "Slider",
        Size = UDim2.new(1, -10, 0, 60),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Parent = parent
    })
    RoundCorner(slider.Frame, UDim.new(0, 8))
    AddStroke(slider.Frame, Color3.fromRGB(35, 35, 35), 1)
    slider.TextLabel = Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 25),
        Position = UDim2.new(0, 15, 0, 5),
        BackgroundTransparency = 1,
        Text = sliderText,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = slider.Frame
    })
    slider.ValueLabel = Create("TextLabel", {
        Size = UDim2.new(0.5, -20, 0, 25),
        Position = UDim2.new(0.5, 5, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = slider.Frame
    })
    slider.Track = Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, -30, 0, 6),
        Position = UDim2.new(0, 15, 0, 38),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Parent = slider.Frame
    })
    RoundCorner(slider.Track, UDim.new(1, 0))
    slider.Fill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = slider.Track
    })
    RoundCorner(slider.Fill, UDim.new(1, 0))
    slider.Knob = Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = slider.Track
    })
    RoundCorner(slider.Knob, UDim.new(1, 0))
    local dragging = false
    local function UpdateSlider(input)
        local trackPos = slider.Track.AbsolutePosition.X
        local trackSize = slider.Track.AbsoluteSize.X
        local mouseX = input.Position.X
        local percent = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
        local value = min + (percent * (max - min))
        slider.Value = math.floor(value)
        slider.ValueLabel.Text = tostring(slider.Value)
        slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
        slider.Knob.Position = UDim2.new(percent, -7, 0.5, -7)
        callback(slider.Value)
    end
    slider.Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    slider.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    return slider
end

function Window:CreateInput(tab, config)
    config = config or {}
    local inputText = config.Text or "Input"
    local placeholder = config.Placeholder or "Type here..."
    local callback = config.Callback or function() end
    local parent = config.Parent or tab.Content
    local inputFrame = Create("Frame", {
        Name = inputText .. "Input",
        Size = UDim2.new(1, -10, 0, 70),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Parent = parent
    })
    RoundCorner(inputFrame, UDim.new(0, 8))
    AddStroke(inputFrame, Color3.fromRGB(35, 35, 35), 1)
    local textLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = inputText,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = inputFrame
    })
    local textBox = Create("TextBox", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 32),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "",
        PlaceholderText = placeholder,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = inputFrame
    })
    RoundCorner(textBox, UDim.new(0, 6))
    AddStroke(textBox, Color3.fromRGB(45, 45, 45), 1)
    textBox.Focused:Connect(function()
        Tween(textBox, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
    end)
    textBox.FocusLost:Connect(function()
        Tween(textBox, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
        callback(textBox.Text)
    end)
    return textBox
end

function Window:CreateDropdown(tab, config)
    config = config or {}
    local dropdownText = config.Text or "Dropdown"
    local options = config.Options or {}
    local default = config.Default or options[1] or ""
    local callback = config.Callback or function() end
    local parent = config.Parent or tab.Content
    local dropdown = {}
    dropdown.Open = false
    dropdown.Selected = default
    dropdown.Frame = Create("Frame", {
        Name = dropdownText .. "Dropdown",
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Parent = parent
    })
    RoundCorner(dropdown.Frame, UDim.new(0, 8))
    AddStroke(dropdown.Frame, Color3.fromRGB(35, 35, 35), 1)
    dropdown.TextLabel = Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = dropdownText,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dropdown.Frame
    })
    dropdown.SelectedLabel = Create("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -120, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = dropdown.Frame
    })
    dropdown.Arrow = Create("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Parent = dropdown.Frame
    })
    dropdown.OptionsFrame = Create("Frame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Parent = dropdown.Frame
    })
    RoundCorner(dropdown.OptionsFrame, UDim.new(0, 6))
    AddStroke(dropdown.OptionsFrame, Color3.fromRGB(40, 40, 40), 1)
    local optionsLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = dropdown.OptionsFrame
    })
    AddPadding(dropdown.OptionsFrame, 5)
    for _, option in ipairs(options) do
        local optionBtn = Create("TextButton", {
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Text = option,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Parent = dropdown.OptionsFrame
        })
        RoundCorner(optionBtn, UDim.new(0, 4))
        optionBtn.MouseEnter:Connect(function()
            Tween(optionBtn, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
        end)
        optionBtn.MouseLeave:Connect(function()
            Tween(optionBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
        end)
        optionBtn.MouseButton1Click:Connect(function()
            dropdown.Selected = option
            dropdown.SelectedLabel.Text = option
            dropdown:Close()
            callback(option)
        end)
    end
    function dropdown:Open()
        self.Open = true
        self.OptionsFrame.Visible = true
        local optionsHeight = math.min(#options * 32 + 10, 150)
        Tween(self.OptionsFrame, {Size = UDim2.new(1, 0, 0, optionsHeight)}, 0.2)
        self.Arrow.Text = "▲"
    end
    function dropdown:Close()
        self.Open = false
        Tween(self.OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        self.OptionsFrame.Visible = false
        self.Arrow.Text = "▼"
    end
    local clickArea = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = dropdown.Frame
    })
    clickArea.MouseButton1Click:Connect(function()
        if dropdown.Open then
            dropdown:Close()
        else
            dropdown:Open()
        end
    end)
    return dropdown
end

function Window:CreateKeybind(tab, config)
    config = config or {}
    local keybindText = config.Text or "Keybind"
    local defaultKey = config.Default or Enum.KeyCode.E
    local callback = config.Callback or function() end
    local parent = config.Parent or tab.Content
    local keybind = {}
    keybind.Key = defaultKey
    keybind.Listening = false
    keybind.Frame = Create("Frame", {
        Name = keybindText .. "Keybind",
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Parent = parent
    })
    RoundCorner(keybind.Frame, UDim.new(0, 8))
    AddStroke(keybind.Frame, Color3.fromRGB(35, 35, 35), 1)
    keybind.TextLabel = Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = keybindText,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keybind.Frame
    })})
    keybind.KeyButton = Create("TextButton", {
        Size = UDim2.new(0, 60, 0, 28),
        Position = UDim2.new(1, -70, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = defaultKey.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = keybind.Frame
    })
    RoundCorner(keybind.KeyButton, UDim.new(0, 6))
    AddStroke(keybind.KeyButton, Color3.fromRGB(45, 45, 45), 1)
    keybind.KeyButton.MouseButton1Click:Connect(function()
        if keybind.Listening then return end
        keybind.Listening = true
        keybind.KeyButton.Text = "..."
        Tween(keybind.KeyButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if keybind.Listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keybind.Key = input.KeyCode
                keybind.KeyButton.Text = input.KeyCode.Name
                keybind.Listening = false
                Tween(keybind.KeyButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
                callback(keybind.Key)
            end
        elseif input.KeyCode == keybind.Key and not gameProcessed then
            callback(keybind.Key)
        end
    end)
    return keybind
end

function Window:CreateLabel(tab, config)
    config = config or {}
    local labelText = config.Text or "Label"
    local parent = config.Parent or tab.Content
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -10, 0, 25),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = config.Color or Color3.fromRGB(180, 180, 180),
        TextSize = config.Size or 13,
        Font = config.Font or Enum.Font.Gotham,
        TextXAlignment = config.Alignment or Enum.TextXAlignment.Left,
        Parent = parent
    })
    return label
end

function Window:CreateDivider(tab, config)
    config = config or {}
    local parent = config.Parent or tab.Content
    local divider = Create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Parent = parent
    })
    return divider
end

function ReaperHub:CreateWindow(config)
    return Window.new(config)
end

function ReaperHub:CreateIcon(config)
    local iconLib = IconLibrary
    iconLib:Init()
    return iconLib:CreateIcon(config)
end

function ReaperHub:LoadIconPack(name, url)
    local iconLib = IconLibrary
    return iconLib:LoadPack(name, url)
end

return ReaperHub

     
