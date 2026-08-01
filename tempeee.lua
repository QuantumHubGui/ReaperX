local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Icons = {}
local iconSuccess, loadedIcons = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))()
end)

if iconSuccess and loadedIcons then
	Icons = loadedIcons
end

local function applyIcon(imageLabel, iconName)
	if not iconName or iconName == "" then
		imageLabel.Visible = false
		return
	end

	local iconData = nil
	if type(Icons) == "table" then
		if Icons[iconName] then
			iconData = Icons[iconName]
		elseif type(Icons.getIcon) == "function" then
			iconData = Icons.getIcon(iconName)
		elseif type(Icons.Init) == "function" then
			iconData = Icons.Init(iconName)
		end
	end

	if type(iconData) == "table" then
		imageLabel.Image = iconData.Image or iconData.id or iconData[1] or ""
		if iconData.ImageRectOffset then
			imageLabel.ImageRectOffset = iconData.ImageRectOffset
		end
		if iconData.ImageRectSize then
			imageLabel.ImageRectSize = iconData.ImageRectSize
		end
		imageLabel.Visible = true
	elseif type(iconData) == "string" and iconData ~= "" then
		imageLabel.Image = iconData
		imageLabel.Visible = true
	elseif type(iconName) == "string" then
		if iconName:find("rbxassetid://") or tonumber(iconName) then
			imageLabel.Image = iconName:find("rbxassetid://") and iconName or "rbxassetid://" .. iconName
			imageLabel.Visible = true
		else
			imageLabel.Image = "rbxassetid://6031097225"
			imageLabel.Visible = true
		end
	end
end

local function createCustomCloud(parentFrame, size, position, scaleFactor)
	scaleFactor = scaleFactor or 1

	local CloudContainer = Instance.new("Frame")
	CloudContainer.Name = "CustomCloud"
	CloudContainer.Size = size
	CloudContainer.Position = position
	CloudContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	CloudContainer.BackgroundTransparency = 1
	CloudContainer.Parent = parentFrame

	local ShadowLayer = Instance.new("Frame")
	ShadowLayer.Name = "ShadowLayer"
	ShadowLayer.Size = UDim2.new(1, 0, 1, 0)
	ShadowLayer.Position = UDim2.new(0, 4 * scaleFactor, 0, 6 * scaleFactor)
	ShadowLayer.BackgroundTransparency = 1
	ShadowLayer.Parent = CloudContainer

	local shadowPuffs = {
		{UDim2.new(0.72, 0, 0.44, 0), UDim2.new(0.14, 0, 0.5, 0)},
		{UDim2.new(0.42, 0, 0.62, 0), UDim2.new(0.08, 0, 0.3, 0)},
		{UDim2.new(0.52, 0, 0.74, 0), UDim2.new(0.24, 0, 0.08, 0)},
		{UDim2.new(0.44, 0, 0.64, 0), UDim2.new(0.5, 0, 0.22, 0)}
	}

	for _, pData in ipairs(shadowPuffs) do
		local puff = Instance.new("Frame")
		puff.Size = pData[1]
		puff.Position = pData[2]
		puff.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		puff.BackgroundTransparency = 0.55
		puff.BorderSizePixel = 0
		puff.Parent = ShadowLayer

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = puff
	end

	local BodyLayer = Instance.new("Frame")
	BodyLayer.Name = "BodyLayer"
	BodyLayer.Size = UDim2.new(1, 0, 1, 0)
	BodyLayer.BackgroundTransparency = 1
	BodyLayer.Parent = CloudContainer

	local bodyPuffs = {
		{UDim2.new(0.74, 0, 0.44, 0), UDim2.new(0.13, 0, 0.5, 0), Color3.fromRGB(240, 242, 248), Color3.fromRGB(200, 204, 218)},
		{UDim2.new(0.42, 0, 0.62, 0), UDim2.new(0.07, 0, 0.3, 0), Color3.fromRGB(245, 246, 252), Color3.fromRGB(210, 215, 228)},
		{UDim2.new(0.54, 0, 0.76, 0), UDim2.new(0.23, 0, 0.06, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(225, 230, 242)},
		{UDim2.new(0.46, 0, 0.66, 0), UDim2.new(0.49, 0, 0.2, 0), Color3.fromRGB(248, 250, 255), Color3.fromRGB(215, 220, 234)},
		{UDim2.new(0.36, 0, 0.54, 0), UDim2.new(0.27, 0, 0.08, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(235, 240, 250)}
	}

	for _, pData in ipairs(bodyPuffs) do
		local puff = Instance.new("Frame")
		puff.Size = pData[1]
		puff.Position = pData[2]
		puff.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		puff.BorderSizePixel = 0
		puff.Parent = BodyLayer

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = puff

		local grad = Instance.new("UIGradient")
		grad.Rotation = 90
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, pData[3]),
			ColorSequenceKeypoint.new(1, pData[4])
		})
		grad.Parent = puff
	end

	return CloudContainer
end

local CloudyLib = {}
CloudyLib.__index = CloudyLib

local function getGuiParent()
	local success, result = pcall(function()
		return CoreGui
	end)
	if success and result then
		return result
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function playIntroAnimation(screenGui, titleText, onComplete)
	local IntroFrame = Instance.new("Frame")
	IntroFrame.Name = "CloudyIntro"
	IntroFrame.Size = UDim2.new(1, 0, 1, 0)
	IntroFrame.Position = UDim2.new(0, 0, 0, 0)
	IntroFrame.BackgroundTransparency = 1
	IntroFrame.ClipsDescendants = true
	IntroFrame.ZIndex = 999
	IntroFrame.Parent = screenGui

	local cloud1 = createCustomCloud(IntroFrame, UDim2.new(0, 110, 0, 70), UDim2.new(1, 100, 0, -100), 1)
	local cloud2 = createCustomCloud(IntroFrame, UDim2.new(0, 110, 0, 70), UDim2.new(0, -100, 1, 100), 1)
	local cloud3 = createCustomCloud(IntroFrame, UDim2.new(0, 110, 0, 70), UDim2.new(0, -100, 0, -100), 1)

	local centerCloud = createCustomCloud(IntroFrame, UDim2.new(0, 30, 0, 20), UDim2.new(0.5, 0, 0.5, 0), 1.5)
	centerCloud.Visible = false

	local splashText = Instance.new("TextLabel")
	splashText.Size = UDim2.new(0, 260, 0, 70)
	splashText.Position = UDim2.new(0.5, 40, 0.5, -35)
	splashText.BackgroundTransparency = 1
	splashText.Text = titleText
	splashText.Font = Enum.Font.GothamBold
	splashText.TextSize = 48
	splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
	splashText.TextTransparency = 1
	splashText.TextXAlignment = Enum.TextXAlignment.Left
	splashText.Parent = IntroFrame

	local textGradient = Instance.new("UIGradient")
	textGradient.Rotation = 45
	textGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 72))
	})
	textGradient.Parent = splashText

	local tweenInfoMerge = TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	TweenService:Create(cloud1, tweenInfoMerge, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	TweenService:Create(cloud2, tweenInfoMerge, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	TweenService:Create(cloud3, tweenInfoMerge, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

	task.delay(0.7, function()
		cloud1:Destroy()
		cloud2:Destroy()
		cloud3:Destroy()

		centerCloud.Visible = true
		centerCloud.Size = UDim2.new(0, 30, 0, 20)

		local tweenInfoGrow = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		TweenService:Create(centerCloud, tweenInfoGrow, {Size = UDim2.new(0, 180, 0, 115)}):Play()

		task.delay(0.5, function()
			local tweenInfoMoveLeft = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			TweenService:Create(centerCloud, tweenInfoMoveLeft, {Position = UDim2.new(0.5, -140, 0.5, 0)}):Play()
			TweenService:Create(splashText, tweenInfoMoveLeft, {TextTransparency = 0, Position = UDim2.new(0.5, -30, 0.5, -35)}):Play()

			task.delay(0.9, function()
				local tweenInfoFadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				for _, child in pairs(centerCloud:GetDescendants()) do
					if child:IsA("Frame") then
						TweenService:Create(child, tweenInfoFadeOut, {BackgroundTransparency = 1}):Play()
					end
				end
				TweenService:Create(splashText, tweenInfoFadeOut, {TextTransparency = 1}):Play()

				task.delay(0.5, function()
					IntroFrame:Destroy()
					if onComplete then
						onComplete()
					end
				end)
			end)
		end)
	end)
end

function CloudyLib:CreateWindow(options)
	options = options or {}
	local titleText = options.Title or "Cloudy"
	local logoIcon = options.Logo or "cloud"

	local parentFolder = getGuiParent()
	if parentFolder:FindFirstChild("CloudyUI") then
		parentFolder:FindFirstChild("CloudyUI"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CloudyUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = parentFolder

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 600, 0, 380)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Color3.fromRGB(38, 38, 50)
	MainStroke.Thickness = 1
	MainStroke.Parent = MainFrame

	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 48)
	Topbar.Position = UDim2.new(0, 0, 0, 0)
	Topbar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	Topbar.BorderSizePixel = 0
	Topbar.Parent = MainFrame

	local LeftContainer = Instance.new("Frame")
	LeftContainer.Size = UDim2.new(0, 300, 1, 0)
	LeftContainer.Position = UDim2.new(0, 14, 0, 0)
	LeftContainer.BackgroundTransparency = 1
	LeftContainer.Parent = Topbar

	local LeftLayout = Instance.new("UIListLayout")
	LeftLayout.FillDirection = Enum.FillDirection.Horizontal
	LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LeftLayout.Padding = UDim.new(0, 10)
	LeftLayout.Parent = LeftContainer

	local LogoImage = Instance.new("ImageLabel")
	LogoImage.Size = UDim2.new(0, 32, 0, 32)
	LogoImage.BackgroundTransparency = 1
	LogoImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.LayoutOrder = 1
	LogoImage.Parent = LeftContainer
	applyIcon(LogoImage, logoIcon)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(0, 220, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = titleText
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 22
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.LayoutOrder = 2
	TitleLabel.Parent = LeftContainer

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Rotation = 45
	TitleGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 72))
	})
	TitleGradient.Parent = TitleLabel

	local RightContainer = Instance.new("Frame")
	RightContainer.Size = UDim2.new(0, 110, 1, 0)
	RightContainer.Position = UDim2.new(1, -120, 0, 0)
	RightContainer.BackgroundTransparency = 1
	RightContainer.Parent = Topbar

	local RightLayout = Instance.new("UIListLayout")
	RightLayout.FillDirection = Enum.FillDirection.Horizontal
	RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	RightLayout.Padding = UDim.new(0, 8)
	RightLayout.Parent = RightContainer

	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
	MinimizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	MinimizeBtn.Text = "⌟ ⌞"
	MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.TextSize = 11
	MinimizeBtn.AutoButtonColor = false
	MinimizeBtn.LayoutOrder = 1
	MinimizeBtn.Parent = RightContainer

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 6)
	MinCorner.Parent = MinimizeBtn

	local ResizeBtn = Instance.new("TextButton")
	ResizeBtn.Size = UDim2.new(0, 26, 0, 26)
	ResizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	ResizeBtn.Text = "⌜ ⌝"
	ResizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ResizeBtn.Font = Enum.Font.GothamBold
	ResizeBtn.TextSize = 11
	ResizeBtn.AutoButtonColor = false
	ResizeBtn.LayoutOrder = 2
	ResizeBtn.Parent = RightContainer

	local ResizeCorner = Instance.new("UICorner")
	ResizeCorner.CornerRadius = UDim.new(0, 6)
	ResizeCorner.Parent = ResizeBtn

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 26, 0, 26)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 13
	CloseBtn.AutoButtonColor = false
	CloseBtn.LayoutOrder = 3
	CloseBtn.Parent = RightContainer

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseBtn

	local dragging, dragInput, dragStart, startPos
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local RestoreBtn = Instance.new("TextButton")
	RestoreBtn.Name = "CloudyRestoreBtn"
	RestoreBtn.Size = UDim2.new(0, 44, 0, 44)
	RestoreBtn.Position = UDim2.new(0, 20, 0.5, -22)
	RestoreBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	RestoreBtn.Text = "C"
	RestoreBtn.Font = Enum.Font.GothamBold
	RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	RestoreBtn.TextSize = 18
	RestoreBtn.Visible = false
	RestoreBtn.Parent = ScreenGui

	local RestoreCorner = Instance.new("UICorner")
	RestoreCorner.CornerRadius = UDim.new(0, 10)
	RestoreCorner.Parent = RestoreBtn

	local RestoreStroke = Instance.new("UIStroke")
	RestoreStroke.Color = Color3.fromRGB(45, 45, 60)
	RestoreStroke.Thickness = 1.5
	RestoreStroke.Parent = RestoreBtn

	local isMinimized = false
	local function toggleMinimize()
		isMinimized = not isMinimized
		MainFrame.Visible = not isMinimized
		RestoreBtn.Visible = isMinimized
	end

	MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)
	RestoreBtn.MouseButton1Click:Connect(toggleMinimize)

	local isExpanded = false
	ResizeBtn.MouseButton1Click:Connect(function()
		isExpanded = not isExpanded
		if isExpanded then
			MainFrame.Size = UDim2.new(0, 780, 0, 480)
			MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
		else
			MainFrame.Size = UDim2.new(0, 600, 0, 380)
			MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	CloseBtn.MouseEnter:Connect(function()
		CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	end)
	CloseBtn.MouseLeave:Connect(function()
		CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	end)

	MinimizeBtn.MouseEnter:Connect(function()
		MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	end)
	MinimizeBtn.MouseLeave:Connect(function()
		MinimizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	end)

	ResizeBtn.MouseEnter:Connect(function()
		ResizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	end)
	ResizeBtn.MouseLeave:Connect(function()
		ResizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	end)

	local Body = Instance.new("Frame")
	Body.Name = "Body"
	Body.Size = UDim2.new(1, 0, 1, -48)
	Body.Position = UDim2.new(0, 0, 0, 48)
	Body.BackgroundTransparency = 1
	Body.Parent = MainFrame

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 170, 1, 0)
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Body

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.ScrollBarThickness = 2
	TabScroll.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 58)
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.Parent = Sidebar

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 4)
	TabListLayout.Parent = TabScroll

	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingTop = UDim.new(0, 8)
	TabPadding.PaddingLeft = UDim.new(0, 8)
	TabPadding.PaddingRight = UDim.new(0, 8)
	TabPadding.PaddingBottom = UDim.new(0, 8)
	TabPadding.Parent = TabScroll

	TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
	end)

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -170, 1, 0)
	ContentContainer.Position = UDim2.new(0, 170, 0, 0)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = Body

	playIntroAnimation(ScreenGui, titleText, function()
		MainFrame.Visible = true
	end)

	local WindowObj = {
		Tabs = {},
		ActiveTab = nil,
		TabCount = 0
	}

	function WindowObj:CreateTab(tabName, iconName)
		WindowObj.TabCount = WindowObj.TabCount + 1
		iconName = iconName or "settings"

		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = "Tab_" .. tabName
		TabBtn.Size = UDim2.new(1, 0, 0, 38)
		TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = ""
		TabBtn.AutoButtonColor = false
		TabBtn.LayoutOrder = WindowObj.TabCount
		TabBtn.Parent = TabScroll

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 8)
		TabCorner.Parent = TabBtn

		local TabContentLayout = Instance.new("UIListLayout")
		TabContentLayout.FillDirection = Enum.FillDirection.Horizontal
		TabContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		TabContentLayout.Padding = UDim.new(0, 10)
		TabContentLayout.Parent = TabBtn

		local TabContentPadding = Instance.new("UIPadding")
		TabContentPadding.PaddingLeft = UDim.new(0, 10)
		TabContentPadding.Parent = TabBtn

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Size = UDim2.new(0, 18, 0, 18)
		TabIcon.BackgroundTransparency = 1
		TabIcon.ImageColor3 = Color3.fromRGB(160, 160, 175)
		TabIcon.LayoutOrder = 1
		TabIcon.Parent = TabBtn
		applyIcon(TabIcon, iconName)

		local TabText = Instance.new("TextLabel")
		TabText.Size = UDim2.new(1, -30, 1, 0)
		TabText.BackgroundTransparency = 1
		TabText.Text = tabName
		TabText.Font = Enum.Font.GothamMedium
		TabText.TextSize = 13
		TabText.TextColor3 = Color3.fromRGB(160, 160, 175)
		TabText.TextXAlignment = Enum.TextXAlignment.Left
		TabText.LayoutOrder = 2
		TabText.Parent = TabBtn

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = "Page_" .. tabName
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 3
		TabPage.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 58)
		TabPage.Visible = false
		TabPage.Parent = ContentContainer

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.Parent = TabPage

		local PagePadding = Instance.new("UIPadding")
		PagePadding.PaddingTop = UDim.new(0, 12)
		PagePadding.PaddingLeft = UDim.new(0, 14)
		PagePadding.PaddingRight = UDim.new(0, 14)
		PagePadding.PaddingBottom = UDim.new(0, 12)
		PagePadding.Parent = TabPage

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 24)
		end)

		local TabObj = {
			Button = TabBtn,
			Page = TabPage,
			ElementCount = 0
		}

		local function selectTab()
			for _, t in pairs(WindowObj.Tabs) do
				t.Page.Visible = false
				t.Button.BackgroundTransparency = 1
				local icon = t.Button:FindFirstChildOfClass("ImageLabel")
				local text = t.Button:FindFirstChildOfClass("TextLabel")
				if icon then icon.ImageColor3 = Color3.fromRGB(160, 160, 175) end
				if text then text.TextColor3 = Color3.fromRGB(160, 160, 175) end
			end
			TabPage.Visible = true
			TabBtn.BackgroundTransparency = 0
			TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
			WindowObj.ActiveTab = TabObj
		end

		TabBtn.MouseButton1Click:Connect(selectTab)

		if WindowObj.TabCount == 1 then
			selectTab()
		end

		table.insert(WindowObj.Tabs, TabObj)

		function TabObj:AddSection(text, defaultOpen)
			TabObj.ElementCount = TabObj.ElementCount + 1
			local isOpen = (defaultOpen == nil) and true or defaultOpen

			local SectionHolder = Instance.new("Frame")
			SectionHolder.Size = UDim2.new(1, 0, 0, 32)
			SectionHolder.BackgroundTransparency = 1
			SectionHolder.LayoutOrder = TabObj.ElementCount
			SectionHolder.Parent = TabPage

			local HeaderBtn = Instance.new("TextButton")
			HeaderBtn.Size = UDim2.new(1, 0, 0, 28)
			HeaderBtn.BackgroundTransparency = 1
			HeaderBtn.Text = ""
			HeaderBtn.Parent = SectionHolder

			local SectionText = Instance.new("TextLabel")
			SectionText.Size = UDim2.new(1, -30, 1, 0)
			SectionText.BackgroundTransparency = 1
			SectionText.Text = text
			SectionText.Font = Enum.Font.GothamBold
			SectionText.TextSize = 14
			SectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionText.TextXAlignment = Enum.TextXAlignment.Left
			SectionText.Parent = HeaderBtn

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 1, 0)
			Arrow.Position = UDim2.new(1, -20, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = isOpen and "v" or "^"
			Arrow.Font = Enum.Font.GothamBold
			Arrow.TextSize = 12
			Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.Parent = HeaderBtn

			local Underline = Instance.new("Frame")
			Underline.Size = UDim2.new(1, 0, 0, 1)
			Underline.Position = UDim2.new(0, 0, 1, -1)
			Underline.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
			Underline.BorderSizePixel = 0
			Underline.Parent = SectionHolder

			local ItemsContainer = Instance.new("Frame")
			ItemsContainer.Size = UDim2.new(1, 0, 0, 0)
			ItemsContainer.Position = UDim2.new(0, 0, 0, 32)
			ItemsContainer.BackgroundTransparency = 1
			ItemsContainer.Visible = isOpen
			ItemsContainer.Parent = SectionHolder

			local ItemsLayout = Instance.new("UIListLayout")
			ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ItemsLayout.Padding = UDim.new(0, 8)
			ItemsLayout.Parent = ItemsContainer

			ItemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if isOpen then
					ItemsContainer.Size = UDim2.new(1, 0, 0, ItemsLayout.AbsoluteContentSize.Y)
					SectionHolder.Size = UDim2.new(1, 0, 0, 32 + ItemsLayout.AbsoluteContentSize.Y + 6)
				end
			end)

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				ItemsContainer.Visible = isOpen
				Arrow.Text = isOpen and "v" or "^"
				if isOpen then
					ItemsContainer.Size = UDim2.new(1, 0, 0, ItemsLayout.AbsoluteContentSize.Y)
					SectionHolder.Size = UDim2.new(1, 0, 0, 32 + ItemsLayout.AbsoluteContentSize.Y + 6)
				else
					SectionHolder.Size = UDim2.new(1, 0, 0, 32)
				end
			end)

			local SectionObj = {}

			local function addToSection(elementFrame)
				elementFrame.Parent = ItemsContainer
				if isOpen then
					ItemsContainer.Size = UDim2.new(1, 0, 0, ItemsLayout.AbsoluteContentSize.Y)
					SectionHolder.Size = UDim2.new(1, 0, 0, 32 + ItemsLayout.AbsoluteContentSize.Y + 6)
				end
			end

			function SectionObj:AddButton(btnText, callback)
				TabObj:AddButton(btnText, callback, ItemsContainer)
				local lastChild = ItemsContainer:GetChildren()[#ItemsContainer:GetChildren()]
				if lastChild and lastChild:IsA("Frame") then
					addToSection(lastChild)
				end
			end

			function SectionObj:AddToggle(toggleText, defaultVal, callback)
				TabObj:AddToggle(toggleText, defaultVal, callback, ItemsContainer)
				local lastChild = ItemsContainer:GetChildren()[#ItemsContainer:GetChildren()]
				if lastChild and lastChild:IsA("Frame") then
					addToSection(lastChild)
				end
			end

			function SectionObj:AddSlider(sliderText, minV, maxV, defV, callback)
				TabObj:AddSlider(sliderText, minV, maxV, defV, callback, ItemsContainer)
				local lastChild = ItemsContainer:GetChildren()[#ItemsContainer:GetChildren()]
				if lastChild and lastChild:IsA("Frame") then
					addToSection(lastChild)
				end
			end

			function SectionObj:AddDropdown(dropText, optList, defOpt, callback)
				TabObj:AddDropdown(dropText, optList, defOpt, callback, ItemsContainer)
				local lastChild = ItemsContainer:GetChildren()[#ItemsContainer:GetChildren()]
				if lastChild and lastChild:IsA("Frame") then
					addToSection(lastChild)
				end
			end

			return SectionObj
		end

		function TabObj:AddButton(text, callback, targetParent)
			TabObj.ElementCount = TabObj.ElementCount + 1
			callback = callback or function() end
			targetParent = targetParent or TabPage

			local BtnFrame = Instance.new("Frame")
			BtnFrame.Size = UDim2.new(1, 0, 0, 38)
			BtnFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			BtnFrame.LayoutOrder = TabObj.ElementCount
			BtnFrame.Parent = targetParent

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = BtnFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(42, 42, 54)
			Stroke.Thickness = 1
			Stroke.Parent = BtnFrame

			local ActionBtn = Instance.new("TextButton")
			ActionBtn.Size = UDim2.new(1, 0, 1, 0)
			ActionBtn.BackgroundTransparency = 1
			ActionBtn.Text = text
			ActionBtn.Font = Enum.Font.GothamMedium
			ActionBtn.TextSize = 13
			ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			ActionBtn.Parent = BtnFrame

			ActionBtn.MouseEnter:Connect(function()
				BtnFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
			end)
			ActionBtn.MouseLeave:Connect(function()
				BtnFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			end)
			ActionBtn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function TabObj:AddToggle(text, defaultState, callback, targetParent)
			TabObj.ElementCount = TabObj.ElementCount + 1
			local state = defaultState or false
			callback = callback or function() end
			targetParent = targetParent or TabPage

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			ToggleFrame.LayoutOrder = TabObj.ElementCount
			ToggleFrame.Parent = targetParent

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = ToggleFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(42, 42, 54)
			Stroke.Thickness = 1
			Stroke.Parent = ToggleFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -70, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame

			local SwitchBg = Instance.new("Frame")
			SwitchBg.Size = UDim2.new(0, 42, 0, 20)
			SwitchBg.Position = UDim2.new(1, -54, 0.5, -10)
			SwitchBg.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(48, 48, 62)
			SwitchBg.Parent = ToggleFrame

			local SwitchCorner = Instance.new("UICorner")
			SwitchCorner.CornerRadius = UDim.new(1, 0)
			SwitchCorner.Parent = SwitchBg

			local Dot = Instance.new("Frame")
			Dot.Size = UDim2.new(0, 14, 0, 14)
			Dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
			Dot.BackgroundColor3 = state and Color3.fromRGB(20, 20, 26) or Color3.fromRGB(255, 255, 255)
			Dot.Parent = SwitchBg

			local DotCorner = Instance.new("UICorner")
			DotCorner.CornerRadius = UDim.new(1, 0)
			DotCorner.Parent = Dot

			local ClickArea = Instance.new("TextButton")
			ClickArea.Size = UDim2.new(1, 0, 1, 0)
			ClickArea.BackgroundTransparency = 1
			ClickArea.Text = ""
			ClickArea.Parent = ToggleFrame

			local function updateToggle()
				if state then
					SwitchBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Dot.Position = UDim2.new(1, -17, 0.5, -7)
					Dot.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
				else
					SwitchBg.BackgroundColor3 = Color3.fromRGB(48, 48, 62)
					Dot.Position = UDim2.new(0, 3, 0.5, -7)
					Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				end
				pcall(callback, state)
			end

			ClickArea.MouseButton1Click:Connect(function()
				state = not state
				updateToggle()
			end)
		end

		function TabObj:AddSlider(text, minVal, maxVal, defaultVal, callback, targetParent)
			TabObj.ElementCount = TabObj.ElementCount + 1
			minVal = minVal or 0
			maxVal = maxVal or 100
			defaultVal = defaultVal or minVal
			callback = callback or function() end
			targetParent = targetParent or TabPage

			local currentVal = math.clamp(defaultVal, minVal, maxVal)

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 50)
			SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			SliderFrame.LayoutOrder = TabObj.ElementCount
			SliderFrame.Parent = targetParent

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = SliderFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(42, 42, 54)
			Stroke.Thickness = 1
			Stroke.Parent = SliderFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -80, 0, 22)
			Label.Position = UDim2.new(0, 12, 0, 4)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local ValLabel = Instance.new("TextLabel")
			ValLabel.Size = UDim2.new(0, 60, 0, 22)
			ValLabel.Position = UDim2.new(1, -72, 0, 4)
			ValLabel.BackgroundTransparency = 1
			ValLabel.Text = tostring(currentVal)
			ValLabel.Font = Enum.Font.GothamBold
			ValLabel.TextSize = 13
			ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ValLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValLabel.Parent = SliderFrame

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, -24, 0, 6)
			Track.Position = UDim2.new(0, 12, 0, 33)
			Track.BackgroundColor3 = Color3.fromRGB(48, 48, 62)
			Track.Parent = SliderFrame

			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(1, 0)
			TrackCorner.Parent = Track

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
			Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Fill.Parent = Track

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.new(0, 12, 0, 12)
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			Knob.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
			Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Knob.Parent = Track

			local KnobCorner = Instance.new("UICorner")
			KnobCorner.CornerRadius = UDim.new(1, 0)
			KnobCorner.Parent = Knob

			local isDragging = false

			local function updateSlider(input)
				local trackAbsPos = Track.AbsolutePosition.X
				local trackAbsSize = Track.AbsoluteSize.X
				local mouseX = input.Position.X
				local ratio = math.clamp((mouseX - trackAbsPos) / trackAbsSize, 0, 1)
				currentVal = math.floor(minVal + (maxVal - minVal) * ratio)
				ValLabel.Text = tostring(currentVal)
				Fill.Size = UDim2.new(ratio, 0, 1, 0)
				Knob.Position = UDim2.new(ratio, 0, 0.5, 0)
				pcall(callback, currentVal)
			end

			Track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isDragging = true
					updateSlider(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isDragging = false
				end
			end)
		end

		function TabObj:AddDropdown(text, optionsList, defaultOpt, callback, targetParent)
			TabObj.ElementCount = TabObj.ElementCount + 1
			optionsList = optionsList or {}
			defaultOpt = defaultOpt or optionsList[1] or ""
			callback = callback or function() end
			targetParent = targetParent or TabPage

			local selectedOption = defaultOpt
			local isOpen = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.LayoutOrder = TabObj.ElementCount
			DropdownFrame.Parent = targetParent

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = DropdownFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(42, 42, 54)
			Stroke.Thickness = 1
			Stroke.Parent = DropdownFrame

			local HeaderBtn = Instance.new("TextButton")
			HeaderBtn.Size = UDim2.new(1, 0, 0, 40)
			HeaderBtn.BackgroundTransparency = 1
			HeaderBtn.Text = ""
			HeaderBtn.Parent = DropdownFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.4, 0, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = HeaderBtn

			local ValueBox = Instance.new("Frame")
			ValueBox.Size = UDim2.new(0, 160, 0, 26)
			ValueBox.Position = UDim2.new(1, -172, 0.5, -13)
			ValueBox.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			ValueBox.Parent = HeaderBtn

			local ValCorner = Instance.new("UICorner")
			ValCorner.CornerRadius = UDim.new(0, 6)
			ValCorner.Parent = ValueBox

			local ValText = Instance.new("TextLabel")
			ValText.Size = UDim2.new(1, -24, 1, 0)
			ValText.Position = UDim2.new(0, 8, 0, 0)
			ValText.BackgroundTransparency = 1
			ValText.Text = selectedOption
			ValText.Font = Enum.Font.Gotham
			ValText.TextSize = 12
			ValText.TextColor3 = Color3.fromRGB(255, 255, 255)
			ValText.TextXAlignment = Enum.TextXAlignment.Left
			ValText.TextTruncate = Enum.TextTruncate.AtEnd
			ValText.Parent = ValueBox

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 1, 0)
			Arrow.Position = UDim2.new(1, -20, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "v"
			Arrow.Font = Enum.Font.GothamBold
			Arrow.TextSize = 11
			Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.Parent = ValueBox

			local ListHolder = Instance.new("Frame")
			ListHolder.Size = UDim2.new(1, -24, 0, 0)
			ListHolder.Position = UDim2.new(0, 12, 0, 44)
			ListHolder.BackgroundTransparency = 1
			ListHolder.Parent = DropdownFrame

			local ListLayout = Instance.new("UIListLayout")
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Padding = UDim.new(0, 4)
			ListLayout.Parent = ListHolder

			local function renderOptions()
				for _, child in pairs(ListHolder:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for idx, opt in ipairs(optionsList) do
					local ItemBtn = Instance.new("TextButton")
					ItemBtn.Size = UDim2.new(1, 0, 0, 28)
					ItemBtn.BackgroundColor3 = (opt == selectedOption) and Color3.fromRGB(42, 42, 54) or Color3.fromRGB(20, 20, 26)
					ItemBtn.Text = "  " .. opt
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextSize = 12
					ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
					ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
					ItemBtn.LayoutOrder = idx
					ItemBtn.Parent = ListHolder

					local ItemCorner = Instance.new("UICorner")
					ItemCorner.CornerRadius = UDim.new(0, 6)
					ItemCorner.Parent = ItemBtn

					ItemBtn.MouseButton1Click:Connect(function()
						selectedOption = opt
						ValText.Text = selectedOption
						isOpen = false
						DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
						Arrow.Text = "v"
						renderOptions()
						pcall(callback, selectedOption)
					end)
				end
			end

			renderOptions()

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (48 + #optionsList * 32) or 40
				DropdownFrame.Size = UDim2.new(1, 0, 0, targetHeight)
				Arrow.Text = isOpen and "^" or "v"
			end)
		end

		function TabObj:AddMultiDropdown(text, optionsList, defaultSelected, callback, targetParent)
			TabObj.ElementCount = TabObj.ElementCount + 1
			optionsList = optionsList or {}
			defaultSelected = defaultSelected or {}
			callback = callback or function() end
			targetParent = targetParent or TabPage

			local selectedMap = {}
			for _, val in ipairs(defaultSelected) do
				selectedMap[val] = true
			end

			local isOpen = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.LayoutOrder = TabObj.ElementCount
			DropdownFrame.Parent = targetParent

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = DropdownFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(42, 42, 54)
			Stroke.Thickness = 1
			Stroke.Parent = DropdownFrame

			local HeaderBtn = Instance.new("TextButton")
			HeaderBtn.Size = UDim2.new(1, 0, 0, 40)
			HeaderBtn.BackgroundTransparency = 1
			HeaderBtn.Text = ""
			HeaderBtn.Parent = DropdownFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.4, 0, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = HeaderBtn

			local ValueBox = Instance.new("Frame")
			ValueBox.Size = UDim2.new(0, 160, 0, 26)
			ValueBox.Position = UDim2.new(1, -172, 0.5, -13)
			ValueBox.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			ValueBox.Parent = HeaderBtn

			local ValCorner = Instance.new("UICorner")
			ValCorner.CornerRadius = UDim.new(0, 6)
			ValCorner.Parent = ValueBox

			local ValText = Instance.new("TextLabel")
			ValText.Size = UDim2.new(1, -24, 1, 0)
			ValText.Position = UDim2.new(0, 8, 0, 0)
			ValText.BackgroundTransparency = 1
			ValText.Font = Enum.Font.Gotham
			ValText.TextSize = 12
			ValText.TextColor3 = Color3.fromRGB(255, 255, 255)
			ValText.TextXAlignment = Enum.TextXAlignment.Left
			ValText.TextTruncate = Enum.TextTruncate.AtEnd
			ValText.Parent = ValueBox

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 1, 0)
			Arrow.Position = UDim2.new(1, -20, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "v"
			Arrow.Font = Enum.Font.GothamBold
			Arrow.TextSize = 11
			Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.Parent = ValueBox

			local ListHolder = Instance.new("Frame")
			ListHolder.Size = UDim2.new(1, -24, 0, 0)
			ListHolder.Position = UDim2.new(0, 12, 0, 44)
			ListHolder.BackgroundTransparency = 1
			ListHolder.Parent = DropdownFrame

			local ListLayout = Instance.new("UIListLayout")
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Padding = UDim.new(0, 4)
			ListLayout.Parent = ListHolder

			local function getSelectedList()
				local result = {}
				for _, opt in ipairs(optionsList) do
					if selectedMap[opt] then
						table.insert(result, opt)
					end
				end
				return result
			end

			local function updateHeaderLabel()
				local list = getSelectedList()
				if #list == 0 then
					ValText.Text = "Pilih..."
				else
					ValText.Text = table.concat(list, ", ")
				end
			end

			local function renderOptions()
				for _, child in pairs(ListHolder:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for idx, opt in ipairs(optionsList) do
					local isSel = selectedMap[opt] or false

					local ItemBtn = Instance.new("TextButton")
					ItemBtn.Size = UDim2.new(1, 0, 0, 28)
					ItemBtn.BackgroundColor3 = isSel and Color3.fromRGB(42, 42, 54) or Color3.fromRGB(20, 20, 26)
					ItemBtn.Text = (isSel and "  [x] " or "  [  ] ") .. opt
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextSize = 12
					ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
					ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
					ItemBtn.LayoutOrder = idx
					ItemBtn.Parent = ListHolder

					local ItemCorner = Instance.new("UICorner")
					ItemCorner.CornerRadius = UDim.new(0, 6)
					ItemCorner.Parent = ItemBtn

					ItemBtn.MouseButton1Click:Connect(function()
						selectedMap[opt] = not selectedMap[opt]
						updateHeaderLabel()
						renderOptions()
						pcall(callback, getSelectedList())
					end)
				end
			end

			updateHeaderLabel()
			renderOptions()

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (48 + #optionsList * 32) or 40
				DropdownFrame.Size = UDim2.new(1, 0, 0, targetHeight)
				Arrow.Text = isOpen and "^" or "v"
			end)
		end

		function TabObj:AddTextBox(text, placeholder, callback, targetParent)
			TabObj.ElementCount = TabObj.ElementCount + 1
			placeholder = placeholder or "Ketik di sini..."
			callback = callback or function() end
			targetParent = targetParent or TabPage

			local BoxFrame = Instance.new("Frame")
			BoxFrame.Size = UDim2.new(1, 0, 0, 40)
			BoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			BoxFrame.LayoutOrder = TabObj.ElementCount
			BoxFrame.Parent = targetParent

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = BoxFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(42, 42, 54)
			Stroke.Thickness = 1
			Stroke.Parent = BoxFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.4, 0, 1, 0)
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 13
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = BoxFrame

			local InputBox = Instance.new("TextBox")
			InputBox.Size = UDim2.new(0, 160, 0, 26)
			InputBox.Position = UDim2.new(1, -172, 0.5, -13)
			InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			InputBox.Text = ""
			InputBox.PlaceholderText = placeholder
			InputBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 145)
			InputBox.Font = Enum.Font.Gotham
			InputBox.TextSize = 12
			InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			InputBox.ClearTextOnFocus = false
			InputBox.Parent = BoxFrame

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 6)
			InputCorner.Parent = InputBox

			InputBox.FocusLost:Connect(function(enterPressed)
				pcall(callback, InputBox.Text, enterPressed)
			end)
		end

		return TabObj
	end

	return WindowObj
end

local Window = CloudyLib:CreateWindow({
	Title = "Cloudy",
	Logo = "cloud"
})

local TabPengaturan = Window:CreateTab("Pengaturan", "settings")
local TabFitur = Window:CreateTab("Fitur Utama", "user")
local TabPengguna = Window:CreateTab("Pengguna", "bell")
local TabLaporan = Window:CreateTab("Laporkan", "shield")

local AudioSec = TabPengaturan:AddSection("Audio & Suara", true)
AudioSec:AddSlider("Volume Master", 0, 100, 80, function(val)
	print("Volume set to:", val)
end)
AudioSec:AddDropdown("Perangkat Output", {"Default (Android audio output)", "Speaker Built-In", "Headset Bluetooth"}, "Default (Android audio output)", function(selected)
	print("Audio Output:", selected)
end)

local ChatSec = TabPengaturan:AddSection("Chat & Bahasa", true)
ChatSec:AddToggle("Terjemahan Otomatis", true, function(state)
	print("Terjemahan Otomatis:", state)
end)
ChatSec:AddDropdown("Bahasa Pengalaman Virtual", {"Bahasa Indonesia", "English (US)", "Español", "Tiếng Việt"}, "Bahasa Indonesia", function(selected)
	print("Bahasa Virtual:", selected)
end)

local MainSec = TabFitur:AddSection("Modifikasi Player", true)
MainSec:AddToggle("Auto Farm", false, function(state)
	print("Auto Farm:", state)
end)
MainSec:AddSlider("WalkSpeed", 16, 200, 50, function(val)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = val
	end
end)

TabFitur:AddMultiDropdown("Target Mob", {"Bandit", "Boss Skeleton", "Dragon Lord", "Shadow Knight"}, {"Bandit"}, function(selectedList)
	print("Target Mobs:", table.concat(selectedList, ", "))
end)
TabFitur:AddTextBox("Custom Key", "Masukan key...", function(text)
	print("Input Key:", text)
end)
TabFitur:AddButton("Execute Command", function()
	print("Command Executed!")
end)

return CloudyLib
