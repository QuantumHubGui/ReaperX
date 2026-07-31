local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

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

function CloudyLib:CreateWindow(options)
	options = options or {}
	local titleText = options.Title or "Cloudy"
	local logoId = options.Logo or "rbxassetid://6031075931"

	local parentFolder = getGuiParent()
	if parentFolder:FindFirstChild("CloudyUI") then
		parentFolder:FindFirstChild("CloudyUI"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "CloudyUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = parentFolder

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 230, 1, 0)
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = ScreenGui

	local SidebarLine = Instance.new("Frame")
	SidebarLine.Size = UDim2.new(0, 1, 1, 0)
	SidebarLine.Position = UDim2.new(1, -1, 0, 0)
	SidebarLine.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	SidebarLine.BorderSizePixel = 0
	SidebarLine.Parent = Sidebar

	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 50)
	Topbar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	Topbar.BorderSizePixel = 0
	Topbar.Parent = Sidebar

	local TopbarLine = Instance.new("Frame")
	TopbarLine.Size = UDim2.new(1, 0, 0, 1)
	TopbarLine.Position = UDim2.new(0, 0, 1, -1)
	TopbarLine.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	TopbarLine.BorderSizePixel = 0
	TopbarLine.Parent = Topbar

	local LeftContainer = Instance.new("Frame")
	LeftContainer.Size = UDim2.new(1, -70, 1, 0)
	LeftContainer.Position = UDim2.new(0, 12, 0, 0)
	LeftContainer.BackgroundTransparency = 1
	LeftContainer.Parent = Topbar

	local LeftLayout = Instance.new("UIListLayout")
	LeftLayout.FillDirection = Enum.FillDirection.Horizontal
	LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LeftLayout.Padding = UDim.new(0, 8)
	LeftLayout.Parent = LeftContainer

	local LogoImage = Instance.new("ImageLabel")
	LogoImage.Size = UDim2.new(0, 22, 0, 22)
	LogoImage.BackgroundTransparency = 1
	LogoImage.Image = logoId
	LogoImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.LayoutOrder = 1
	LogoImage.Parent = LeftContainer

	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(0, 6)
	LogoCorner.Parent = LogoImage

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -30, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = titleText
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 17
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TitleLabel.LayoutOrder = 2
	TitleLabel.Parent = LeftContainer

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Rotation = 45
	TitleGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 52))
	})
	TitleGradient.Parent = TitleLabel

	local RightContainer = Instance.new("Frame")
	RightContainer.Size = UDim2.new(0, 60, 1, 0)
	RightContainer.Position = UDim2.new(1, -66, 0, 0)
	RightContainer.BackgroundTransparency = 1
	RightContainer.Parent = Topbar

	local RightLayout = Instance.new("UIListLayout")
	RightLayout.FillDirection = Enum.FillDirection.Horizontal
	RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	RightLayout.Padding = UDim.new(0, 6)
	RightLayout.Parent = RightContainer

	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
	MinimizeBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	MinimizeBtn.Text = "-"
	MinimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.TextSize = 15
	MinimizeBtn.AutoButtonColor = false
	MinimizeBtn.LayoutOrder = 1
	MinimizeBtn.Parent = RightContainer

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 6)
	MinCorner.Parent = MinimizeBtn

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 13
	CloseBtn.AutoButtonColor = false
	CloseBtn.LayoutOrder = 2
	CloseBtn.Parent = RightContainer

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseBtn

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, -50)
	TabScroll.Position = UDim2.new(0, 0, 0, 50)
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.ScrollBarThickness = 2
	TabScroll.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 50)
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.Parent = Sidebar

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 4)
	TabListLayout.Parent = TabScroll

	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingTop = UDim.new(0, 12)
	TabPadding.PaddingLeft = UDim.new(0, 10)
	TabPadding.PaddingRight = UDim.new(0, 10)
	TabPadding.PaddingBottom = UDim.new(0, 12)
	TabPadding.Parent = TabScroll

	TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 24)
	end)

	local ModalFrame = Instance.new("Frame")
	ModalFrame.Name = "ModalFrame"
	ModalFrame.Size = UDim2.new(0, 580, 0, 420)
	ModalFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ModalFrame.Position = UDim2.new(0.5, 80, 0.5, 0)
	ModalFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	ModalFrame.BorderSizePixel = 0
	ModalFrame.ClipsDescendants = true
	ModalFrame.Visible = false
	ModalFrame.Parent = ScreenGui

	local ModalCorner = Instance.new("UICorner")
	ModalCorner.CornerRadius = UDim.new(0, 12)
	ModalCorner.Parent = ModalFrame

	local ModalStroke = Instance.new("UIStroke")
	ModalStroke.Color = Color3.fromRGB(32, 32, 40)
	ModalStroke.Thickness = 1
	ModalStroke.Parent = ModalFrame

	local ModalTopbar = Instance.new("Frame")
	ModalTopbar.Name = "ModalTopbar"
	ModalTopbar.Size = UDim2.new(1, 0, 0, 48)
	ModalTopbar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
	ModalTopbar.BorderSizePixel = 0
	ModalTopbar.Parent = ModalFrame

	local ModalTitle = Instance.new("TextLabel")
	ModalTitle.Size = UDim2.new(1, -60, 1, 0)
	ModalTitle.Position = UDim2.new(0, 16, 0, 0)
	ModalTitle.BackgroundTransparency = 1
	ModalTitle.Text = "Pengaturan"
	ModalTitle.Font = Enum.Font.GothamBold
	ModalTitle.TextSize = 18
	ModalTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	ModalTitle.TextXAlignment = Enum.TextXAlignment.Left
	ModalTitle.Parent = ModalTopbar

	local ModalCloseBtn = Instance.new("TextButton")
	ModalCloseBtn.Size = UDim2.new(0, 28, 0, 28)
	ModalCloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
	ModalCloseBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
	ModalCloseBtn.Text = "X"
	ModalCloseBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
	ModalCloseBtn.Font = Enum.Font.GothamBold
	ModalCloseBtn.TextSize = 14
	ModalCloseBtn.AutoButtonColor = false
	ModalCloseBtn.Parent = ModalTopbar

	local ModalCloseCorner = Instance.new("UICorner")
	ModalCloseCorner.CornerRadius = UDim.new(0, 6)
	ModalCloseCorner.Parent = ModalCloseBtn

	ModalCloseBtn.MouseButton1Click:Connect(function()
		ModalFrame.Visible = false
	end)

	local ModalBody = Instance.new("Frame")
	ModalBody.Name = "ModalBody"
	ModalBody.Size = UDim2.new(1, 0, 1, -48)
	ModalBody.Position = UDim2.new(0, 0, 0, 48)
	ModalBody.BackgroundTransparency = 1
	ModalBody.Parent = ModalFrame

	local dragging, dragInput, dragStart, startPos
	ModalTopbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = ModalFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	ModalTopbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			ModalFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local RestoreBtn = Instance.new("TextButton")
	RestoreBtn.Name = "CloudyRestoreBtn"
	RestoreBtn.Size = UDim2.new(0, 48, 0, 48)
	RestoreBtn.Position = UDim2.new(0, 20, 0.5, -24)
	RestoreBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	RestoreBtn.Text = "C"
	RestoreBtn.Font = Enum.Font.GothamBold
	RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	RestoreBtn.TextSize = 20
	RestoreBtn.Visible = false
	RestoreBtn.Parent = ScreenGui

	local RestoreCorner = Instance.new("UICorner")
	RestoreCorner.CornerRadius = UDim.new(0, 12)
	RestoreCorner.Parent = RestoreBtn

	local RestoreStroke = Instance.new("UIStroke")
	RestoreStroke.Color = Color3.fromRGB(50, 50, 64)
	RestoreStroke.Thickness = 1.5
	RestoreStroke.Parent = RestoreBtn

	local isMinimized = false
	local function toggleMinimize()
		isMinimized = not isMinimized
		Sidebar.Visible = not isMinimized
		if isMinimized then
			ModalFrame.Visible = false
		end
		RestoreBtn.Visible = isMinimized
	end

	MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)
	RestoreBtn.MouseButton1Click:Connect(toggleMinimize)

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 24), TextColor3 = Color3.fromRGB(180, 180, 195)}):Play()
	end)

	MinimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36, 36, 48), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	MinimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 24), TextColor3 = Color3.fromRGB(180, 180, 195)}):Play()
	end)

	local WindowObj = {
		Tabs = {},
		ActiveTab = nil,
		TabCount = 0
	}

	function WindowObj:CreateTab(tabName, iconId)
		WindowObj.TabCount = WindowObj.TabCount + 1
		iconId = iconId or "rbxassetid://6031097225"

		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = "Tab_" .. tabName
		TabBtn.Size = UDim2.new(1, 0, 0, 42)
		TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
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
		TabContentLayout.Padding = UDim.new(0, 12)
		TabContentLayout.Parent = TabBtn

		local TabContentPadding = Instance.new("UIPadding")
		TabContentPadding.PaddingLeft = UDim.new(0, 12)
		TabContentPadding.Parent = TabBtn

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Size = UDim2.new(0, 20, 0, 20)
		TabIcon.BackgroundTransparency = 1
		TabIcon.Image = iconId
		TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 165)
		TabIcon.LayoutOrder = 1
		TabIcon.Parent = TabBtn

		local TabText = Instance.new("TextLabel")
		TabText.Size = UDim2.new(1, -36, 1, 0)
		TabText.BackgroundTransparency = 1
		TabText.Text = tabName
		TabText.Font = Enum.Font.GothamMedium
		TabText.TextSize = 14
		TabText.TextColor3 = Color3.fromRGB(150, 150, 165)
		TabText.TextXAlignment = Enum.TextXAlignment.Left
		TabText.LayoutOrder = 2
		TabText.Parent = TabBtn

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = "Page_" .. tabName
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 3
		TabPage.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 65)
		TabPage.Visible = false
		TabPage.Parent = ModalBody

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 10)
		PageLayout.Parent = TabPage

		local PagePadding = Instance.new("UIPadding")
		PagePadding.PaddingTop = UDim.new(0, 16)
		PagePadding.PaddingLeft = UDim.new(0, 18)
		PagePadding.PaddingRight = UDim.new(0, 18)
		PagePadding.PaddingBottom = UDim.new(0, 16)
		PagePadding.Parent = TabPage

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 32)
		end)

		local TabObj = {
			Button = TabBtn,
			Page = TabPage,
			Name = tabName,
			ElementCount = 0
		}

		local function selectTab()
			for _, t in pairs(WindowObj.Tabs) do
				t.Page.Visible = false
				TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				local icon = t.Button:FindFirstChildOfClass("ImageLabel")
				local text = t.Button:FindFirstChildOfClass("TextLabel")
				if icon then TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(130, 130, 145)}):Play() end
				if text then TweenService:Create(text, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(130, 130, 145)}):Play() end
			end

			ModalTitle.Text = tabName
			TabPage.Visible = true
			ModalFrame.Visible = true

			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
			TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TweenService:Create(TabText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			WindowObj.ActiveTab = TabObj
		end

		TabBtn.MouseButton1Click:Connect(selectTab)

		table.insert(WindowObj.Tabs, TabObj)

		function TabObj:AddSection(text)
			TabObj.ElementCount = TabObj.ElementCount + 1

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, 0, 0, 36)
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.LayoutOrder = TabObj.ElementCount
			SectionFrame.Parent = TabPage

			local SectionText = Instance.new("TextLabel")
			SectionText.Size = UDim2.new(1, 0, 0, 24)
			SectionText.BackgroundTransparency = 1
			SectionText.Text = text
			SectionText.Font = Enum.Font.GothamBold
			SectionText.TextSize = 16
			SectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionText.TextXAlignment = Enum.TextXAlignment.Left
			SectionText.Parent = SectionFrame

			local Line = Instance.new("Frame")
			Line.Size = UDim2.new(1, 0, 0, 1)
			Line.Position = UDim2.new(0, 0, 1, -2)
			Line.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
			Line.BorderSizePixel = 0
			Line.Parent = SectionFrame
		end

		function TabObj:AddButton(text, callback)
			TabObj.ElementCount = TabObj.ElementCount + 1
			callback = callback or function() end

			local BtnFrame = Instance.new("Frame")
			BtnFrame.Size = UDim2.new(1, 0, 0, 42)
			BtnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			BtnFrame.LayoutOrder = TabObj.ElementCount
			BtnFrame.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = BtnFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(32, 32, 42)
			Stroke.Thickness = 1
			Stroke.Parent = BtnFrame

			local ActionBtn = Instance.new("TextButton")
			ActionBtn.Size = UDim2.new(1, 0, 1, 0)
			ActionBtn.BackgroundTransparency = 1
			ActionBtn.Text = text
			ActionBtn.Font = Enum.Font.GothamMedium
			ActionBtn.TextSize = 14
			ActionBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
			ActionBtn.Parent = BtnFrame

			ActionBtn.MouseEnter:Connect(function()
				TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}):Play()
			end)
			ActionBtn.MouseLeave:Connect(function()
				TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play()
			end)
			ActionBtn.MouseButton1Click:Connect(function()
				TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 56)}):Play()
				task.delay(0.1, function()
					TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}):Play()
				end)
				pcall(callback)
			end)
		end

		function TabObj:AddToggle(text, defaultState, callback)
			TabObj.ElementCount = TabObj.ElementCount + 1
			local state = defaultState or false
			callback = callback or function() end

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, 0, 0, 46)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			ToggleFrame.LayoutOrder = TabObj.ElementCount
			ToggleFrame.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = ToggleFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(32, 32, 42)
			Stroke.Thickness = 1
			Stroke.Parent = ToggleFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -70, 1, 0)
			Label.Position = UDim2.new(0, 14, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 14
			Label.TextColor3 = Color3.fromRGB(220, 220, 235)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame

			local SwitchBg = Instance.new("Frame")
			SwitchBg.Size = UDim2.new(0, 46, 0, 24)
			SwitchBg.Position = UDim2.new(1, -60, 0.5, -12)
			SwitchBg.BackgroundColor3 = state and Color3.fromRGB(60, 125, 245) or Color3.fromRGB(36, 36, 46)
			SwitchBg.Parent = ToggleFrame

			local SwitchCorner = Instance.new("UICorner")
			SwitchCorner.CornerRadius = UDim.new(1, 0)
			SwitchCorner.Parent = SwitchBg

			local Dot = Instance.new("Frame")
			Dot.Size = UDim2.new(0, 18, 0, 18)
			Dot.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
					TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 125, 245)}):Play()
					TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
				else
					TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36, 36, 46)}):Play()
					TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
				end
				pcall(callback, state)
			end

			ClickArea.MouseButton1Click:Connect(function()
				state = not state
				updateToggle()
			end)
		end

		function TabObj:AddSlider(text, minVal, maxVal, defaultVal, callback)
			TabObj.ElementCount = TabObj.ElementCount + 1
			minVal = minVal or 0
			maxVal = maxVal or 100
			defaultVal = defaultVal or minVal
			callback = callback or function() end

			local currentVal = math.clamp(defaultVal, minVal, maxVal)

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, 0, 0, 56)
			SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			SliderFrame.LayoutOrder = TabObj.ElementCount
			SliderFrame.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = SliderFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(32, 32, 42)
			Stroke.Thickness = 1
			Stroke.Parent = SliderFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -80, 0, 24)
			Label.Position = UDim2.new(0, 14, 0, 6)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 14
			Label.TextColor3 = Color3.fromRGB(220, 220, 235)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame

			local ValLabel = Instance.new("TextLabel")
			ValLabel.Size = UDim2.new(0, 60, 0, 24)
			ValLabel.Position = UDim2.new(1, -74, 0, 6)
			ValLabel.BackgroundTransparency = 1
			ValLabel.Text = tostring(currentVal)
			ValLabel.Font = Enum.Font.GothamBold
			ValLabel.TextSize = 13
			ValLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
			ValLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValLabel.Parent = SliderFrame

			local Track = Instance.new("Frame")
			Track.Size = UDim2.new(1, -28, 0, 6)
			Track.Position = UDim2.new(0, 14, 0, 38)
			Track.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
			Track.Parent = SliderFrame

			local TrackCorner = Instance.new("UICorner")
			TrackCorner.CornerRadius = UDim.new(1, 0)
			TrackCorner.Parent = Track

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
			Fill.BackgroundColor3 = Color3.fromRGB(60, 125, 245)
			Fill.Parent = Track

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill

			local Knob = Instance.new("Frame")
			Knob.Size = UDim2.new(0, 14, 0, 14)
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

		function TabObj:AddDropdown(text, optionsList, defaultOpt, callback)
			TabObj.ElementCount = TabObj.ElementCount + 1
			optionsList = optionsList or {}
			defaultOpt = defaultOpt or optionsList[1] or ""
			callback = callback or function() end

			local selectedOption = defaultOpt
			local isOpen = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 46)
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.LayoutOrder = TabObj.ElementCount
			DropdownFrame.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = DropdownFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(32, 32, 42)
			Stroke.Thickness = 1
			Stroke.Parent = DropdownFrame

			local HeaderBtn = Instance.new("TextButton")
			HeaderBtn.Size = UDim2.new(1, 0, 0, 46)
			HeaderBtn.BackgroundTransparency = 1
			HeaderBtn.Text = ""
			HeaderBtn.Parent = DropdownFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.4, 0, 1, 0)
			Label.Position = UDim2.new(0, 14, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 14
			Label.TextColor3 = Color3.fromRGB(220, 220, 235)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = HeaderBtn

			local ValueBox = Instance.new("Frame")
			ValueBox.Size = UDim2.new(0, 190, 0, 30)
			ValueBox.Position = UDim2.new(1, -204, 0.5, -15)
			ValueBox.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
			ValueBox.Parent = HeaderBtn

			local ValCorner = Instance.new("UICorner")
			ValCorner.CornerRadius = UDim.new(0, 6)
			ValCorner.Parent = ValueBox

			local ValStroke = Instance.new("UIStroke")
			ValStroke.Color = Color3.fromRGB(34, 34, 44)
			ValStroke.Thickness = 1
			ValStroke.Parent = ValueBox

			local ValText = Instance.new("TextLabel")
			ValText.Size = UDim2.new(1, -28, 1, 0)
			ValText.Position = UDim2.new(0, 10, 0, 0)
			ValText.BackgroundTransparency = 1
			ValText.Text = selectedOption
			ValText.Font = Enum.Font.Gotham
			ValText.TextSize = 13
			ValText.TextColor3 = Color3.fromRGB(200, 200, 215)
			ValText.TextXAlignment = Enum.TextXAlignment.Left
			ValText.TextTruncate = Enum.TextTruncate.AtEnd
			ValText.Parent = ValueBox

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 22, 1, 0)
			Arrow.Position = UDim2.new(1, -24, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "v"
			Arrow.Font = Enum.Font.GothamBold
			Arrow.TextSize = 12
			Arrow.TextColor3 = Color3.fromRGB(150, 150, 170)
			Arrow.Parent = ValueBox

			local ListHolder = Instance.new("Frame")
			ListHolder.Size = UDim2.new(1, -28, 0, 0)
			ListHolder.Position = UDim2.new(0, 14, 0, 52)
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
					ItemBtn.Size = UDim2.new(1, 0, 0, 32)
					ItemBtn.BackgroundColor3 = (opt == selectedOption) and Color3.fromRGB(36, 36, 48) or Color3.fromRGB(14, 14, 18)
					ItemBtn.Text = "  " .. opt
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextSize = 13
					ItemBtn.TextColor3 = (opt == selectedOption) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 185)
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
						TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 46)}):Play()
						Arrow.Text = "v"
						renderOptions()
						pcall(callback, selectedOption)
					end)
				end
			end

			renderOptions()

			HeaderBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (58 + #optionsList * 36) or 46
				TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
				Arrow.Text = isOpen and "^" or "v"
			end)
		end

		function TabObj:AddMultiDropdown(text, optionsList, defaultSelected, callback)
			TabObj.ElementCount = TabObj.ElementCount + 1
			optionsList = optionsList or {}
			defaultSelected = defaultSelected or {}
			callback = callback or function() end

			local selectedMap = {}
			for _, val in ipairs(defaultSelected) do
				selectedMap[val] = true
			end

			local isOpen = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Size = UDim2.new(1, 0, 0, 46)
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.LayoutOrder = TabObj.ElementCount
			DropdownFrame.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = DropdownFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(32, 32, 42)
			Stroke.Thickness = 1
			Stroke.Parent = DropdownFrame

			local HeaderBtn = Instance.new("TextButton")
			HeaderBtn.Size = UDim2.new(1, 0, 0, 46)
			HeaderBtn.BackgroundTransparency = 1
			HeaderBtn.Text = ""
			HeaderBtn.Parent = DropdownFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.4, 0, 1, 0)
			Label.Position = UDim2.new(0, 14, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 14
			Label.TextColor3 = Color3.fromRGB(220, 220, 235)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = HeaderBtn

			local ValueBox = Instance.new("Frame")
			ValueBox.Size = UDim2.new(0, 190, 0, 30)
			ValueBox.Position = UDim2.new(1, -204, 0.5, -15)
			ValueBox.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
			ValueBox.Parent = HeaderBtn

			local ValCorner = Instance.new("UICorner")
			ValCorner.CornerRadius = UDim.new(0, 6)
			ValCorner.Parent = ValueBox

			local ValStroke = Instance.new("UIStroke")
			ValStroke.Color = Color3.fromRGB(34, 34, 44)
			ValStroke.Thickness = 1
			ValStroke.Parent = ValueBox

			local ValText = Instance.new("TextLabel")
			ValText.Size = UDim2.new(1, -28, 1, 0)
			ValText.Position = UDim2.new(0, 10, 0, 0)
			ValText.BackgroundTransparency = 1
			ValText.Font = Enum.Font.Gotham
			ValText.TextSize = 13
			ValText.TextColor3 = Color3.fromRGB(200, 200, 215)
			ValText.TextXAlignment = Enum.TextXAlignment.Left
			ValText.TextTruncate = Enum.TextTruncate.AtEnd
			ValText.Parent = ValueBox

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 22, 1, 0)
			Arrow.Position = UDim2.new(1, -24, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "v"
			Arrow.Font = Enum.Font.GothamBold
			Arrow.TextSize = 12
			Arrow.TextColor3 = Color3.fromRGB(150, 150, 170)
			Arrow.Parent = ValueBox

			local ListHolder = Instance.new("Frame")
			ListHolder.Size = UDim2.new(1, -28, 0, 0)
			ListHolder.Position = UDim2.new(0, 14, 0, 52)
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
					ItemBtn.Size = UDim2.new(1, 0, 0, 32)
					ItemBtn.BackgroundColor3 = isSel and Color3.fromRGB(36, 36, 48) or Color3.fromRGB(14, 14, 18)
					ItemBtn.Text = (isSel and "  [x] " or "  [  ] ") .. opt
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextSize = 13
					ItemBtn.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 185)
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
				local targetHeight = isOpen and (58 + #optionsList * 36) or 46
				TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
				Arrow.Text = isOpen and "^" or "v"
			end)
		end

		function TabObj:AddTextBox(text, placeholder, callback)
			TabObj.ElementCount = TabObj.ElementCount + 1
			placeholder = placeholder or "Ketik di sini..."
			callback = callback or function() end

			local BoxFrame = Instance.new("Frame")
			BoxFrame.Size = UDim2.new(1, 0, 0, 46)
			BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			BoxFrame.LayoutOrder = TabObj.ElementCount
			BoxFrame.Parent = TabPage

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 8)
			Corner.Parent = BoxFrame

			local Stroke = Instance.new("UIStroke")
			Stroke.Color = Color3.fromRGB(32, 32, 42)
			Stroke.Thickness = 1
			Stroke.Parent = BoxFrame

			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0.4, 0, 1, 0)
			Label.Position = UDim2.new(0, 14, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.Font = Enum.Font.GothamMedium
			Label.TextSize = 14
			Label.TextColor3 = Color3.fromRGB(220, 220, 235)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = BoxFrame

			local InputBox = Instance.new("TextBox")
			InputBox.Size = UDim2.new(0, 190, 0, 30)
			InputBox.Position = UDim2.new(1, -204, 0.5, -15)
			InputBox.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
			InputBox.Text = ""
			InputBox.PlaceholderText = placeholder
			InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 115)
			InputBox.Font = Enum.Font.Gotham
			InputBox.TextSize = 13
			InputBox.TextColor3 = Color3.fromRGB(240, 240, 250)
			InputBox.ClearTextOnFocus = false
			InputBox.Parent = BoxFrame

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 6)
			InputCorner.Parent = InputBox

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Color = Color3.fromRGB(34, 34, 44)
			InputStroke.Thickness = 1
			InputStroke.Parent = InputBox

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
	Logo = "rbxassetid://6031075931"
})

local TabUndang = Window:CreateTab("Undang Teman", "rbxassetid://6031082533")
local TabPengguna = Window:CreateTab("Pengguna", "rbxassetid://6031082533")
local TabPengaturan = Window:CreateTab("Pengaturan", "rbxassetid://6031280882")
local TabLaporkan = Window:CreateTab("Laporkan", "rbxassetid://6031082533")
local TabChat = Window:CreateTab("Chat teman", "rbxassetid://6031097225")
local TabAvatar = Window:CreateTab("Beralih avatar", "rbxassetid://6031082533")
local TabToko = Window:CreateTab("Toko", "rbxassetid://6031097225")
local TabLeaderboard = Window:CreateTab("Papan Peringkat", "rbxassetid://6031097225")
local TabEmote = Window:CreateTab("Emote", "rbxassetid://6031097225")
local TabInventaris = Window:CreateTab("Inventaris", "rbxassetid://6031097225")

TabPengaturan:AddSection("Audio")
TabPengaturan:AddSlider("Volume", 0, 100, 80, function(val)
	print("Volume set to:", val)
end)
TabPengaturan:AddDropdown("Perangkat Output", {"Default (Android audio output)", "Speaker Built-In", "Headset Bluetooth"}, "Default (Android audio output)", function(selected)
	print("Audio Output:", selected)
end)

TabPengaturan:AddSection("Chat & Bahasa")
TabPengaturan:AddToggle("Terjemahan Otomatis", true, function(state)
	print("Terjemahan Otomatis:", state)
end)
TabPengaturan:AddDropdown("Bahasa Pengalaman Virtual", {"Bahasa Indonesia", "English (US)", "Español", "Tiếng Việt"}, "Bahasa Indonesia", function(selected)
	print("Bahasa Virtual:", selected)
end)

TabUndang:AddSection("Undang Teman")
TabUndang:AddTextBox("Username", "Cari nama teman...", function(text)
	print("Mencari user:", text)
end)
TabUndang:AddButton("Kirim Undangan", function()
	print("Undangan terkirim!")
end)

TabPengguna:AddSection("Pengaturan Profil")
TabPengguna:AddToggle("Tampilkan Bio", true, function(val)
	print("Toggle Bio:", val)
end)
TabPengguna:AddMultiDropdown("Peran / Rank", {"Member", "VIP", "Moderator", "Developer"}, {"Member"}, function(list)
	print("Peran:", table.concat(list, ", "))
end)

return CloudyLib
