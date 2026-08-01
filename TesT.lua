local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local LocalPlayer = Players.LocalPlayer

local function GetUrlContent(url)
	local content = nil
	pcall(function()
		if typeof(game) == "Instance" and typeof(game.HttpGet) == "function" then
			content = game:HttpGet(url)
		elseif type(request) == "function" then
			local resp = request({Url = url, Method = "GET"})
			if resp and resp.Body then content = resp.Body end
		elseif type(http_request) == "function" then
			local resp = http_request({Url = url, Method = "GET"})
			if resp and resp.Body then content = resp.Body end
		elseif type(syn) == "table" and type(syn.request) == "function" then
			local resp = syn.request({Url = url, Method = "GET"})
			if resp and resp.Body then content = resp.Body end
		else
			local ok, res = pcall(function() return HttpService:GetAsync(url) end)
			if ok then content = res end
		end
	end)
	return content
end

local function CompileString(src)
	if not src or type(src) ~= "string" or #src < 10 then
		return nil
	end
	local compiledFn = nil
	if type(loadstring) == "function" then
		local ok, res = pcall(loadstring, src)
		if ok and type(res) == "function" then
			compiledFn = res
		end
	elseif type(getgenv) == "function" and type(getgenv().loadstring) == "function" then
		local ok, res = pcall(getgenv().loadstring, src)
		if ok and type(res) == "function" then
			compiledFn = res
		end
	end
	return compiledFn
end

local function FetchIconPack(url)
	local rawSrc = GetUrlContent(url)
	if rawSrc then
		local fn = CompileString(rawSrc)
		if type(fn) == "function" then
			local ok, pack = pcall(fn)
			if ok and type(pack) == "table" then
				return pack
			end
		end
	end
	return nil
end

local IconModule = {
	IconsType = "solar",
	New = nil,
	IconThemeTag = nil,

	Icons = {
		solar = FetchIconPack("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua") or {},
		gravity = FetchIconPack("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/gravity/dist/Icons.lua") or {},
	},
}

local function parseIconString(iconString)
	if type(iconString) == "string" then
		local splitIndex = iconString:find(":")
		if splitIndex then
			local iconType = iconString:sub(1, splitIndex - 1)
			local iconName = iconString:sub(splitIndex + 1)
			return iconType, iconName
		end
	end
	return nil, iconString
end

function IconModule.AddIcons(packName, iconsData)
	if type(packName) ~= "string" or type(iconsData) ~= "table" then
		return
	end

	if not IconModule.Icons[packName] then
		IconModule.Icons[packName] = {
			Icons = {},
			Spritesheets = {},
		}
	end

	for iconName, iconValue in pairs(iconsData) do
		if type(iconValue) ~= "table" then
			local imageId = iconValue
			if type(iconValue) == "number" then
				imageId = "rbxassetid://" .. tostring(iconValue)
			end

			IconModule.Icons[packName].Icons[iconName] = {
				Image = imageId,
				ImageRectSize = Vector2.new(0, 0),
				ImageRectPosition = Vector2.new(0, 0),
				Parts = nil,
			}
			IconModule.Icons[packName].Spritesheets[imageId] = imageId
		elseif type(iconValue) == "table" then
			if iconValue.Image and iconValue.ImageRectSize and iconValue.ImageRectPosition then
				local imageId = iconValue.Image
				if type(imageId) == "number" then
					imageId = "rbxassetid://" .. tostring(imageId)
				end

				IconModule.Icons[packName].Icons[iconName] = {
					Image = imageId,
					ImageRectSize = iconValue.ImageRectSize,
					ImageRectPosition = iconValue.ImageRectPosition,
					Parts = iconValue.Parts,
				}

				if not IconModule.Icons[packName].Spritesheets[imageId] then
					IconModule.Icons[packName].Spritesheets[imageId] = imageId
				end
			end
		end
	end
end

function IconModule.SetIconsType(iconType)
	IconModule.IconsType = iconType
end

function IconModule.Init(New, IconThemeTag)
	IconModule.New = New
	IconModule.IconThemeTag = IconThemeTag
	return IconModule
end

function IconModule.Icon(Icon, Type, DefaultFormat)
	DefaultFormat = DefaultFormat ~= false
	local iconType, iconName = parseIconString(Icon)

	local targetType = iconType or Type or IconModule.IconsType
	local targetName = iconName

	if not targetName or targetName == "" then return nil end

	local iconSet = IconModule.Icons[targetType]
	if not iconSet then return nil end

	if type(iconSet.Icons) == "table" and iconSet.Icons[targetName] then
		local item = iconSet.Icons[targetName]
		local sheet = (type(iconSet.Spritesheets) == "table" and iconSet.Spritesheets[tostring(item.Image)]) or item.Image
		return { sheet, item }
	end

	local resolvedAsset = nil

	if type(iconSet[targetName]) == "string" and string.find(iconSet[targetName], "rbxassetid://") then
		resolvedAsset = iconSet[targetName]
	end

	if not resolvedAsset and targetType == "solar" then
		local boldName = (targetName:sub(-5) == "-bold") and targetName or (targetName .. "-bold")
		if type(iconSet[boldName]) == "string" and string.find(iconSet[boldName], "rbxassetid://") then
			resolvedAsset = iconSet[boldName]
		end

		if not resolvedAsset then
			local suffixes = {"-linear", "-outline", "-broken", "-line-duotone", "-bold-duotone"}
			for _, s in ipairs(suffixes) do
				if type(iconSet[targetName .. s]) == "string" and string.find(iconSet[targetName .. s], "rbxassetid://") then
					resolvedAsset = iconSet[targetName .. s]
					break
				end
			end
		end
	end

	if not resolvedAsset then
		local aliases = {
			["minus"] = "minus",
			["maximize"] = "chevrons-expand-up-right",
			["close"] = "xmark",
			["x"] = "xmark",
			["alt-arrow-down"] = "alt-arrow-down-bold",
			["home"] = "home-2-bold",
			["home-2"] = "home-2-bold",
			["user"] = "user-bold",
			["eye"] = "eye-bold",
			["compass"] = "compass-bold",
			["server"] = "server-bold",
			["settings"] = "settings-bold",
			["cloud"] = "cloud-bold",
		}
		if aliases[targetName] and type(iconSet[aliases[targetName]]) == "string" then
			resolvedAsset = iconSet[aliases[targetName]]
		end
	end

	if not resolvedAsset then
		for k, v in pairs(iconSet) do
			if type(k) == "string" and k:find(targetName, 1, true) and type(v) == "string" and string.find(v, "rbxassetid://") then
				resolvedAsset = v
				break
			end
		end
	end

	if resolvedAsset then
		return DefaultFormat
				and {
					resolvedAsset,
					{ ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) },
				}
			or resolvedAsset
	end

	return nil
end

function IconModule.GetIcon(Icon, Type)
	return IconModule.Icon(Icon, Type, false)
end

function IconModule.Icon2(Icon, Type, DefaultFormat)
	return IconModule.Icon(Icon, Type, true)
end

local function applyIcon(imageLabel, iconName)
	if not imageLabel or not iconName or iconName == "" then
		if imageLabel then imageLabel.Visible = false end
		return
	end

	for _, child in pairs(imageLabel:GetChildren()) do
		if child:IsA("ImageLabel") then child:Destroy() end
	end

	local iconData = IconModule.Icon2(iconName, "solar")
	if iconData then
		if typeof(iconData) == "string" then
			imageLabel.Image = iconData
			imageLabel.ImageRectSize = Vector2.new(0, 0)
			imageLabel.ImageRectOffset = Vector2.new(0, 0)
			imageLabel.Visible = true
		elseif type(iconData) == "table" and iconData[1] and iconData[2] then
			imageLabel.Image = iconData[1]
			imageLabel.ImageRectSize = iconData[2].ImageRectSize or Vector2.new(0, 0)
			imageLabel.ImageRectOffset = iconData[2].ImageRectPosition or iconData[2].ImageRectOffset or Vector2.new(0, 0)
			imageLabel.Visible = true

			if iconData[2].Parts then
				for idx, part in ipairs(iconData[2].Parts) do
					local partData = IconModule.Icon(part, "solar")
					if partData and partData[1] and partData[2] then
						local partLabel = Instance.new("ImageLabel")
						partLabel.Size = UDim2.new(1, 0, 1, 0)
						partLabel.BackgroundTransparency = 1
						partLabel.Image = partData[1]
						partLabel.ImageRectSize = partData[2].ImageRectSize
						partLabel.ImageRectOffset = partData[2].ImageRectPosition or partData[2].ImageRectOffset
						partLabel.Parent = imageLabel
					end
				end
			end
		end
	elseif type(iconName) == "string" and (iconName:sub(1, 13) == "rbxassetid://" or iconName:sub(1, 4) == "http") then
		imageLabel.Image = iconName
		imageLabel.ImageRectSize = Vector2.new(0, 0)
		imageLabel.ImageRectOffset = Vector2.new(0, 0)
		imageLabel.Visible = true
	else
		imageLabel.Visible = false
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
	local logoIcon = options.Logo or "cloud-bold"

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

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 170, 1, 0)
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	Sidebar.BorderSizePixel = 0
	Sidebar.ClipsDescendants = true
	Sidebar.Parent = MainFrame

	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 10)
	SidebarCorner.Parent = Sidebar

	local SidebarHeader = Instance.new("Frame")
	SidebarHeader.Name = "SidebarHeader"
	SidebarHeader.Size = UDim2.new(1, 0, 0, 48)
	SidebarHeader.Position = UDim2.new(0, 0, 0, 0)
	SidebarHeader.BackgroundTransparency = 1
	SidebarHeader.Parent = Sidebar

	local HeaderContainer = Instance.new("Frame")
	HeaderContainer.Size = UDim2.new(1, -16, 1, 0)
	HeaderContainer.Position = UDim2.new(0, 12, 0, 0)
	HeaderContainer.BackgroundTransparency = 1
	HeaderContainer.Parent = SidebarHeader

	local HeaderLayout = Instance.new("UIListLayout")
	HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
	HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
	HeaderLayout.Padding = UDim.new(0, 8)
	HeaderLayout.Parent = HeaderContainer

	local LogoImage = Instance.new("ImageLabel")
	LogoImage.Size = UDim2.new(0, 26, 0, 26)
	LogoImage.BackgroundTransparency = 1
	LogoImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.LayoutOrder = 1
	LogoImage.Parent = HeaderContainer
	applyIcon(LogoImage, logoIcon)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -38, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = titleText
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 18
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.LayoutOrder = 2
	TitleLabel.Parent = HeaderContainer

	local TitleGradient = Instance.new("UIGradient")
	TitleGradient.Rotation = 45
	TitleGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 170))
	})
	TitleGradient.Parent = TitleLabel

	local SidebarDivider = Instance.new("Frame")
	SidebarDivider.Name = "SidebarDivider"
	SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
	SidebarDivider.Position = UDim2.new(0, 170, 0, 0)
	SidebarDivider.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
	SidebarDivider.BorderSizePixel = 0
	SidebarDivider.ZIndex = 3
	SidebarDivider.Parent = MainFrame

	local MainContent = Instance.new("Frame")
	MainContent.Name = "MainContent"
	MainContent.Size = UDim2.new(1, -171, 1, 0)
	MainContent.Position = UDim2.new(0, 171, 0, 0)
	MainContent.BackgroundTransparency = 1
	MainContent.ClipsDescendants = true
	MainContent.Parent = MainFrame

	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 48)
	Topbar.Position = UDim2.new(0, 0, 0, 0)
	Topbar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	Topbar.BorderSizePixel = 0
	Topbar.Parent = MainContent

	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, 10)
	TopbarCorner.Parent = Topbar

	local RightContainer = Instance.new("Frame")
	RightContainer.Size = UDim2.new(0, 110, 1, 0)
	RightContainer.Position = UDim2.new(1, -118, 0, 0)
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
	MinimizeBtn.Text = ""
	MinimizeBtn.AutoButtonColor = false
	MinimizeBtn.LayoutOrder = 1
	MinimizeBtn.Parent = RightContainer

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 6)
	MinCorner.Parent = MinimizeBtn

	local MinimizeIcon = Instance.new("ImageLabel")
	MinimizeIcon.Size = UDim2.new(0, 14, 0, 14)
	MinimizeIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
	MinimizeIcon.BackgroundTransparency = 1
	MinimizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 215)
	MinimizeIcon.Parent = MinimizeBtn
	applyIcon(MinimizeIcon, "gravity:minus")

	local ResizeBtn = Instance.new("TextButton")
	ResizeBtn.Size = UDim2.new(0, 26, 0, 26)
	ResizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	ResizeBtn.Text = ""
	ResizeBtn.AutoButtonColor = false
	ResizeBtn.LayoutOrder = 2
	ResizeBtn.Parent = RightContainer

	local ResizeCorner = Instance.new("UICorner")
	ResizeCorner.CornerRadius = UDim.new(0, 6)
	ResizeCorner.Parent = ResizeBtn

	local ResizeIcon = Instance.new("ImageLabel")
	ResizeIcon.Size = UDim2.new(0, 14, 0, 14)
	ResizeIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
	ResizeIcon.BackgroundTransparency = 1
	ResizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 215)
	ResizeIcon.Parent = ResizeBtn
	applyIcon(ResizeIcon, "gravity:chevrons-expand-up-right")

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 26, 0, 26)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	CloseBtn.Text = ""
	CloseBtn.AutoButtonColor = false
	CloseBtn.LayoutOrder = 3
	CloseBtn.Parent = RightContainer

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseBtn

	local CloseIcon = Instance.new("ImageLabel")
	CloseIcon.Size = UDim2.new(0, 14, 0, 14)
	CloseIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
	CloseIcon.BackgroundTransparency = 1
	CloseIcon.ImageColor3 = Color3.fromRGB(200, 200, 215)
	CloseIcon.Parent = CloseBtn
	applyIcon(CloseIcon, "gravity:xmark")

	local dragging, dragInput, dragStart, startPos
	local function onDragBegan(input)
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
	end

	Topbar.InputBegan:Connect(onDragBegan)
	SidebarHeader.InputBegan:Connect(onDragBegan)

	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	SidebarHeader.InputChanged:Connect(function(input)
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

	local RestoreBtn = Instance.new("ImageButton")
	RestoreBtn.Name = "CloudyRestoreBtn"
	RestoreBtn.Size = UDim2.new(0, 60, 0, 60)
	RestoreBtn.Position = UDim2.new(0, 20, 0.5, -30)
	RestoreBtn.BackgroundTransparency = 1
	RestoreBtn.Image = "rbxassetid://88244237473485"
	RestoreBtn.AutoButtonColor = false
	RestoreBtn.Visible = false
	RestoreBtn.ZIndex = 9999
	RestoreBtn.Parent = ScreenGui

	local floatDragging, floatDragInput, floatDragStart, floatStartPos
	local floatDragMoved = false

	RestoreBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			floatDragging = true
			floatDragMoved = false
			floatDragStart = input.Position
			floatStartPos = RestoreBtn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					floatDragging = false
				end
			end)
		end
	end)

	RestoreBtn.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			floatDragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == floatDragInput and floatDragging then
			local delta = input.Position - floatDragStart
			if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
				floatDragMoved = true
			end
			RestoreBtn.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
		end
	end)

	local isMinimized = false
	local function toggleMinimize()
		isMinimized = not isMinimized
		MainFrame.Visible = not isMinimized
		RestoreBtn.Visible = isMinimized
	end

	MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)
	RestoreBtn.MouseButton1Up:Connect(function()
		if not floatDragMoved then
			toggleMinimize()
		end
	end)

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
		TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
		TweenService:Create(CloseIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()
		TweenService:Create(CloseIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(200, 200, 215)}):Play()
	end)

	MinimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 52)}):Play()
		TweenService:Create(MinimizeIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	MinimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()
		TweenService:Create(MinimizeIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(200, 200, 215)}):Play()
	end)

	ResizeBtn.MouseEnter:Connect(function()
		TweenService:Create(ResizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 52)}):Play()
		TweenService:Create(ResizeIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	ResizeBtn.MouseLeave:Connect(function()
		TweenService:Create(ResizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()
		TweenService:Create(ResizeIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(200, 200, 215)}):Play()
	end)

	local TabIndicator = Instance.new("Frame")
	TabIndicator.Name = "TabIndicator"
	TabIndicator.Size = UDim2.new(0, 154, 0, 38)
	TabIndicator.Position = UDim2.new(0, 8, 0, 56)
	TabIndicator.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	TabIndicator.BackgroundTransparency = 0.2
	TabIndicator.BorderSizePixel = 0
	TabIndicator.Visible = false
	TabIndicator.ZIndex = 1
	TabIndicator.Parent = Sidebar

	local IndCorner = Instance.new("UICorner")
	IndCorner.CornerRadius = UDim.new(0, 8)
	IndCorner.Parent = TabIndicator

	local IndLine = Instance.new("Frame")
	IndLine.Name = "WhiteIndicatorLine"
	IndLine.Size = UDim2.new(0, 3, 0, 20)
	IndLine.Position = UDim2.new(0, 2, 0.5, -10)
	IndLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IndLine.BorderSizePixel = 0
	IndLine.Parent = TabIndicator

	local LineCorner = Instance.new("UICorner")
	LineCorner.CornerRadius = UDim.new(1, 0)
	LineCorner.Parent = IndLine

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, -48)
	TabScroll.Position = UDim2.new(0, 0, 0, 48)
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.ScrollBarThickness = 2
	TabScroll.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 58)
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.ZIndex = 2
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
	ContentContainer.Size = UDim2.new(1, -171, 1, -48)
	ContentContainer.Position = UDim2.new(0, 171, 0, 48)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame

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
		iconName = iconName or "settings-bold"

		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = "Tab_" .. tabName
		TabBtn.Size = UDim2.new(1, 0, 0, 38)
		TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = ""
		TabBtn.AutoButtonColor = false
		TabBtn.ZIndex = 3
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
		TabIcon.ZIndex = 3
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
		TabText.ZIndex = 3
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

		local function selectTab(animated)
			local prevTab = WindowObj.ActiveTab
			WindowObj.ActiveTab = TabObj

			local targetY = TabBtn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y
			local targetPos = UDim2.new(0, 8, 0, targetY)

			TabIndicator.Visible = true

			if animated ~= false and prevTab then
				TweenService:Create(TabIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = targetPos
				}):Play()
			else
				TabIndicator.Position = targetPos
			end

			for _, t in pairs(WindowObj.Tabs) do
				local isSelected = (t == TabObj)
				local icon = t.Button:FindFirstChildOfClass("ImageLabel")
				local text = t.Button:FindFirstChildOfClass("TextLabel")

				local targetIconColor = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 175)
				local targetTextColor = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 175)

				if icon then
					TweenService:Create(icon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = targetIconColor}):Play()
				end
				if text then
					TweenService:Create(text, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = targetTextColor}):Play()
				end

				if not isSelected then
					t.Page.Visible = false
				end
			end

			TabPage.Position = UDim2.new(0, 10, 0, 0)
			TabPage.Visible = true
			TweenService:Create(TabPage, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, 0, 0, 0)
			}):Play()
		end

		TabBtn.MouseButton1Click:Connect(function()
			selectTab(true)
		end)

		if WindowObj.TabCount == 1 then
			task.delay(0.1, function()
				selectTab(false)
			end)
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

			local ArrowIcon = Instance.new("ImageLabel")
			ArrowIcon.Name = "ArrowIcon"
			ArrowIcon.Size = UDim2.new(0, 16, 0, 16)
			ArrowIcon.Position = UDim2.new(1, -20, 0.5, -8)
			ArrowIcon.BackgroundTransparency = 1
			ArrowIcon.ImageColor3 = Color3.fromRGB(200, 200, 215)
			ArrowIcon.Rotation = isOpen and 0 or -90
			ArrowIcon.Parent = HeaderBtn
			applyIcon(ArrowIcon, "alt-arrow-down-bold")

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
				TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Rotation = isOpen and 0 or -90
				}):Play()

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

			local ArrowIcon = Instance.new("ImageLabel")
			ArrowIcon.Name = "ArrowIcon"
			ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
			ArrowIcon.Position = UDim2.new(1, -18, 0.5, -7)
			ArrowIcon.BackgroundTransparency = 1
			ArrowIcon.ImageColor3 = Color3.fromRGB(200, 200, 215)
			ArrowIcon.Rotation = isOpen and 180 or 0
			ArrowIcon.Parent = ValueBox
			applyIcon(ArrowIcon, "alt-arrow-down-bold")

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
						TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = 0}):Play()
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
				TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Rotation = isOpen and 180 or 0
				}):Play()
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

			local ArrowIcon = Instance.new("ImageLabel")
			ArrowIcon.Name = "ArrowIcon"
			ArrowIcon.Size = UDim2.new(0, 14, 0, 14)
			ArrowIcon.Position = UDim2.new(1, -18, 0.5, -7)
			ArrowIcon.BackgroundTransparency = 1
			ArrowIcon.ImageColor3 = Color3.fromRGB(200, 200, 215)
			ArrowIcon.Rotation = isOpen and 180 or 0
			ArrowIcon.Parent = ValueBox
			applyIcon(ArrowIcon, "alt-arrow-down-bold")

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
				TweenService:Create(ArrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Rotation = isOpen and 180 or 0
				}):Play()
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
	Logo = "cloud-bold"
})

local TabUtama = Window:CreateTab("Utama", "home-2-bold")
local TabVisual = Window:CreateTab("Visual & ESP", "eye-bold")
local TabTeleport = Window:CreateTab("Teleport", "compass-bold")
local TabMisc = Window:CreateTab("Misc & Server", "server-bold")
local TabPengaturan = Window:CreateTab("Pengaturan UI", "settings-bold")

local PlayerSec = TabUtama:AddSection("Modifikasi Player", true)
PlayerSec:AddToggle("Godmode (Infinite Health)", false, function(state)
	print("[Cloudy] Godmode set to:", state)
end)
PlayerSec:AddSlider("WalkSpeed (Kecepatan)", 16, 250, 50, function(val)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = val
	end
end)
PlayerSec:AddSlider("JumpPower (Lompatan)", 50, 300, 100, function(val)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = val
	end
end)
PlayerSec:AddToggle("Noclip (Tembus Tembok)", false, function(state)
	print("[Cloudy] Noclip:", state)
end)
PlayerSec:AddToggle("Fly Mode (Terbang)", false, function(state)
	print("[Cloudy] Fly Mode:", state)
end)

local FarmSec = TabUtama:AddSection("Automasi Game", true)
FarmSec:AddToggle("Auto Farm Level", false, function(state)
	print("[Cloudy] Auto Farm Level:", state)
end)
FarmSec:AddDropdown("Metode Farm", {"Fast Attack", "Behind Enemy", "Safe Distance"}, "Fast Attack", function(selected)
	print("[Cloudy] Metode Farm:", selected)
end)
FarmSec:AddMultiDropdown("Pilih Target Mob", {"Bandit Level 1", "Pirate Boss", "Marine Admiral", "Dragon King"}, {"Bandit Level 1"}, function(selectedList)
	print("[Cloudy] Target Mobs:", table.concat(selectedList, ", "))
end)

local EspSec = TabVisual:AddSection("ESP Player", true)
EspSec:AddToggle("ESP Boxes", true, function(state)
	print("[Cloudy] ESP Boxes:", state)
end)
EspSec:AddToggle("ESP Tracers", false, function(state)
	print("[Cloudy] ESP Tracers:", state)
end)
EspSec:AddToggle("ESP Names & Distance", true, function(state)
	print("[Cloudy] ESP Names:", state)
end)
EspSec:AddSlider("ESP Distance Limit", 100, 5000, 1000, function(val)
	print("[Cloudy] ESP Limit:", val)
end)

local WorldSec = TabVisual:AddSection("World Visuals", true)
WorldSec:AddToggle("Fullbright (Terang Malam)", true, function(state)
	print("[Cloudy] Fullbright:", state)
end)
WorldSec:AddToggle("Remove Fog (Hapus Kabut)", true, function(state)
	print("[Cloudy] Remove Fog:", state)
end)
WorldSec:AddSlider("Field of View (FOV)", 70, 120, 90, function(val)
	if workspace.CurrentCamera then
		workspace.CurrentCamera.FieldOfView = val
	end
end)

local LocationSec = TabTeleport:AddSection("Teleport Lokasi", true)
LocationSec:AddDropdown("Pilih Pulau / Zone", {"Starter Island", "Pirate Village", "Desert Kingdom", "Sky Castle", "Marine HQ"}, "Starter Island", function(selected)
	print("[Cloudy] Selected Island:", selected)
end)
LocationSec:AddButton("Teleport ke Lokasi", function()
	print("[Cloudy] Teleporting to selected location...")
end)

local PlayerTpSec = TabTeleport:AddSection("Teleport Player", true)
PlayerTpSec:AddTextBox("Nama Player", "Ketik username...", function(text)
	print("[Cloudy] Target Player Username:", text)
end)
PlayerTpSec:AddButton("Teleport ke Player", function()
	print("[Cloudy] Teleporting to target player...")
end)

local ServerSec = TabMisc:AddSection("Server Utility", true)
ServerSec:AddButton("Rejoin Server", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
ServerSec:AddButton("Server Hop (Pindah Server)", function()
	print("[Cloudy] Hopping server...")
end)
ServerSec:AddButton("Copy Job ID", function()
	if setclipboard then
		setclipboard(game.JobId)
		print("[Cloudy] JobId copied!")
	end
end)

local FpsSec = TabMisc:AddSection("FPS & Optimization", true)
FpsSec:AddToggle("Unlock FPS (FPS Booster)", true, function(state)
	if setfpscap then setfpscap(state and 240 or 60) end
end)
FpsSec:AddToggle("Low Graphics Mode", false, function(state)
	print("[Cloudy] Low Graphics:", state)
end)
FpsSec:AddSlider("Max FPS Target", 30, 240, 120, function(val)
	if setfpscap then setfpscap(val) end
end)

local UiSec = TabPengaturan:AddSection("Konfigurasi UI", true)
UiSec:AddToggle("Notifikasi Execution", true, function(state)
	print("[Cloudy] Notifications:", state)
end)
UiSec:AddButton("Simpan Config", function()
	print("[Cloudy] Config saved!")
end)
UiSec:AddButton("Reset Default Config", function()
	print("[Cloudy] Config reset to default!")
end)

return CloudyLib
