local ReaperHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/QuantumHubGui/ReaperX/main/.lua"))()

local Window = ReaperHub:CreateWindow({
    Title = "Reaper Hub"
})

local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "home"
})

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "sword"
})

local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "user"
})

local VisualTab = Window:CreateTab({
    Name = "Visual",
    Icon = "eye"
})

local TeleportTab = Window:CreateTab({
    Name = "Teleport",
    Icon = "map-pin"
})

local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "sliders"
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings"
})


local MainSection = Window:CreateSection(MainTab, {
    Name = "Welcome",
    Collapsed = false
})

Window:CreateParagraph(MainTab, {
    Text = "Reaper Hub Loaded Successfully. Use the tabs below to access features. Press RightShift to toggle UI.",
    Parent = MainSection.Content
})

Window:CreateDivider(MainTab, {Parent = MainSection.Content})

Window:CreateButton(MainTab, {
    Text = "Rejoin Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local p = game:GetService("Players").LocalPlayer
        ts:Teleport(game.PlaceId, p)
    end,
    Parent = MainSection.Content
})

Window:CreateButton(MainTab, {
    Text = "Server Hop",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local hs = game:GetService("HttpService")
        local p = game:GetService("Players").LocalPlayer
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = hs:JSONDecode(req)
        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                ts:TeleportToPlaceInstance(game.PlaceId, server.id, p)
                break
            end
        end
    end,
    Parent = MainSection.Content
})


local CombatSection = Window:CreateSection(CombatTab, {
    Name = "Combat",
    Collapsed = false
})

local AutoClick = false
Window:CreateToggle(CombatTab, {
    Text = "Auto Click",
    Default = false,
    Callback = function(state)
        AutoClick = state
        if state then
            task.spawn(function()
                while AutoClick do
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.05)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    task.wait(0.05)
                end
            end)
        end
    end,
    Parent = CombatSection.Content
})

local KillAura = false
Window:CreateToggle(CombatTab, {
    Text = "Kill Aura",
    Default = false,
    Callback = function(state)
        KillAura = state
        if state then
            task.spawn(function()
                while KillAura do
                    local lp = game:GetService("Players").LocalPlayer
                    local char = lp.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                            if player ~= lp and player.Character then
                                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                                local targetHum = player.Character:FindFirstChild("Humanoid")
                                local myHRP = char:FindFirstChild("HumanoidRootPart")
                                if targetHRP and targetHum and myHRP then
                                    local dist = (targetHRP.Position - myHRP.Position).Magnitude
                                    if dist <= 20 then
                                        targetHum.Health = 0
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end,
    Parent = CombatSection.Content
})

Window:CreateSlider(CombatTab, {
    Text = "Reach Distance",
    Min = 1,
    Max = 50,
    Default = 12,
    Callback = function(value)
    end,
    Parent = CombatSection.Content
})

Window:CreateKeybind(CombatTab, {
    Text = "Kill All Key",
    Default = Enum.KeyCode.K,
    Callback = function(key)
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Health = 0
                end
            end
        end
    end,
    Parent = CombatSection.Content
})


local PlayerSection = Window:CreateSection(PlayerTab, {
    Name = "Character",
    Collapsed = false
})

Window:CreateSlider(PlayerTab, {
    Text = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(value)
        local char = game:GetService("Players").LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
    Parent = PlayerSection.Content
})

Window:CreateSlider(PlayerTab, {
    Text = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        local char = game:GetService("Players").LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end,
    Parent = PlayerSection.Content
})

Window:CreateSlider(PlayerTab, {
    Text = "HipHeight",
    Min = 0,
    Max = 50,
    Default = 0,
    Callback = function(value)
        local char = game:GetService("Players").LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.HipHeight = value
        end
    end,
    Parent = PlayerSection.Content
})

local InfJump = false
Window:CreateToggle(PlayerTab, {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(state)
        InfJump = state
    end,
    Parent = PlayerSection.Content
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then
        local lp = game:GetService("Players").LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Noclip = false
Window:CreateToggle(PlayerTab, {
    Text = "Noclip",
    Default = false,
    Callback = function(state)
        Noclip = state
        if state then
            task.spawn(function()
                while Noclip do
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    task.wait()
                end
                local char = game:GetService("Players").LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
    end,
    Parent = PlayerSection.Content
})

local FlyEnabled = false
local FlySpeed = 50
local FlyConnection

Window:CreateToggle(PlayerTab, {
    Text = "Fly",
    Default = false,
    Callback = function(state)
        FlyEnabled = state
        local lp = game:GetService("Players").LocalPlayer
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if state then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp

            local bg = Instance.new("BodyGyro")
            bg.Name = "FlyGyro"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp

            FlyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if not FlyEnabled then return end
                local cam = workspace.CurrentCamera
                local direction = Vector3.zero
                local uis = game:GetService("UserInputService")

                if uis:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + cam.CFrame.LookVector
                end
                if uis:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - cam.CFrame.LookVector
                end
                if uis:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - cam.CFrame.RightVector
                end
                if uis:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + cam.CFrame.RightVector
                end
                if uis:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end

                if bv then
                    bv.Velocity = direction * FlySpeed
                end
                if bg then
                    bg.CFrame = cam.CFrame
                end
            end)
        else
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
            local bv = hrp:FindFirstChild("FlyVelocity")
            local bg = hrp:FindFirstChild("FlyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end,
    Parent = PlayerSection.Content
})

Window:CreateSlider(PlayerTab, {
    Text = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(value)
        FlySpeed = value
    end,
    Parent = PlayerSection.Content
})

Window:CreateButton(PlayerTab, {
    Text = "Reset Character",
    Callback = function()
        local lp = game:GetService("Players").LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.Health = 0
        end
    end,
    Parent = PlayerSection.Content
})

Window:CreateButton(PlayerTab, {
    Text = "Full Bright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end,
    Parent = PlayerSection.Content
})


local VisualSection = Window:CreateSection(VisualTab, {
    Name = "ESP",
    Collapsed = false
})

local ESP_Enabled = false
local ESP_Boxes = false
local ESP_Names = false
local ESP_Distance = false
local ESP_Tracers = false
local ESP_Highlight = false
local ESPObjects = {}

local function CreateESP(player)
    if player == game:GetService("Players").LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Filled = false
    box.Transparency = 1

    local name = Drawing.new("Text")
    name.Visible = false
    name.Size = 14
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Outline = true
    name.Center = true

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 255, 255)

    local dist = Drawing.new("Text")
    dist.Visible = false
    dist.Size = 12
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Outline = true
    dist.Center = true

    ESPObjects[player] = {
        Box = box,
        Name = name,
        Tracer = tracer,
        Distance = dist
    }
end

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    CreateESP(player)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if not ESP_Enabled then
        for _, data in pairs(ESPObjects) do
            data.Box.Visible = false
            data.Name.Visible = false
            data.Tracer.Visible = false
            data.Distance.Visible = false
        end
        return
    end

    local cam = workspace.CurrentCamera
    local lp = game:GetService("Players").LocalPlayer

    for player, data in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local boxHeight = math.abs(headPos.Y - legPos.Y)
                local boxWidth = boxHeight * 0.6

                if ESP_Boxes then
                    data.Box.Size = Vector2.new(boxWidth, boxHeight)
                    data.Box.Position = Vector2.new(pos.X - boxWidth / 2, pos.Y - boxHeight / 2)
                    data.Box.Visible = true
                else
                    data.Box.Visible = false
                end

                if ESP_Names then
                    data.Name.Text = player.Name
                    data.Name.Position = Vector2.new(pos.X, pos.Y - boxHeight / 2 - 15)
                    data.Name.Visible = true
                else
                    data.Name.Visible = false
                end

                if ESP_Distance and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                    data.Distance.Text = math.floor(distance) .. " studs"
                    data.Distance.Position = Vector2.new(pos.X, pos.Y + boxHeight / 2 + 5)
                    data.Distance.Visible = true
                else
                    data.Distance.Visible = false
                end

                if ESP_Tracers then
                    data.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    data.Tracer.To = Vector2.new(pos.X, pos.Y + boxHeight / 2)
                    data.Tracer.Visible = true
                else
                    data.Tracer.Visible = false
                end
            else
                data.Box.Visible = false
                data.Name.Visible = false
                data.Tracer.Visible = false
                data.Distance.Visible = false
            end
        else
            data.Box.Visible = false
            data.Name.Visible = false
            data.Tracer.Visible = false
            data.Distance.Visible = false
        end
    end
end)

Window:CreateToggle(VisualTab, {
    Text = "ESP Master",
    Default = false,
    Callback = function(state)
        ESP_Enabled = state
    end,
    Parent = VisualSection.Content
})

Window:CreateToggle(VisualTab, {
    Text = "ESP Boxes",
    Default = false,
    Callback = function(state)
        ESP_Boxes = state
    end,
    Parent = VisualSection.Content
})

Window:CreateToggle(VisualTab, {
    Text = "ESP Names",
    Default = false,
    Callback = function(state)
        ESP_Names = state
    end,
    Parent = VisualSection.Content
})

Window:CreateToggle(VisualTab, {
    Text = "ESP Distance",
    Default = false,
    Callback = function(state)
        ESP_Distance = state
    end,
    Parent = VisualSection.Content
})

Window:CreateToggle(VisualTab, {
    Text = "ESP Tracers",
    Default = false,
    Callback = function(state)
        ESP_Tracers = state
    end,
    Parent = VisualSection.Content
})

local ChamsSection = Window:CreateSection(VisualTab, {
    Name = "Chams",
    Collapsed = true
})

local ChamsEnabled = false
local ChamsColor = Color3.fromRGB(255, 0, 0)
local ChamsObjects = {}

local function UpdateChams()
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("Chams") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "Chams"
                    highlight.FillColor = ChamsColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = part
                    table.insert(ChamsObjects, highlight)
                end
            end
        end
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if ChamsEnabled then
            task.wait(1)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "Chams"
                    highlight.FillColor = ChamsColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = part
                    table.insert(ChamsObjects, highlight)
                end
            end
        end
    end)
end)

Window:CreateToggle(VisualTab, {
    Text = "Chams",
    Default = false,
    Callback = function(state)
        ChamsEnabled = state
        if state then
            UpdateChams()
        else
            for _, obj in ipairs(ChamsObjects) do
                if obj then obj:Destroy() end
            end
            ChamsObjects = {}
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        local cham = part:FindFirstChild("Chams")
                        if cham then cham:Destroy() end
                    end
                end
            end
        end
    end,
    Parent = ChamsSection.Content
})

Window:CreateDropdown(VisualTab, {
    Text = "Chams Color",
    Options = {"Red", "Green", "Blue", "White", "Yellow", "Purple"},
    Default = "Red",
    Callback = function(option)
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 100, 255),
            White = Color3.fromRGB(255, 255, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(150, 0, 255)
        }
        ChamsColor = colors[option] or Color3.fromRGB(255, 0, 0)
        for _, obj in ipairs(ChamsObjects) do
            if obj then obj.FillColor = ChamsColor end
        end
    end,
    Parent = ChamsSection.Content
})


local TPSection = Window:CreateSection(TeleportTab, {
    Name = "Teleport",
    Collapsed = false
})

Window:CreateButton(TeleportTab, {
    Text = "Click TP (Hold Ctrl)",
    Callback = function()
    end,
    Parent = TPSection.Content
})

local ClickTP = false
Window:CreateToggle(TeleportTab, {
    Text = "Enable Click TP",
    Default = false,
    Callback = function(state)
        ClickTP = state
    end,
    Parent = TPSection.Content
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local lp = game:GetService("Players").LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

Window:CreateButton(TeleportTab, {
    Text = "TP to Random Player",
    Callback = function()
        local players = game:GetService("Players"):GetPlayers()
        local lp = game:GetService("Players").LocalPlayer
        local others = {}
        for _, p in ipairs(players) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(others, p)
            end
        end
        if #others > 0 then
            local target = others[math.random(1, #others)]
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end
    end,
    Parent = TPSection.Content
})

local PlayerList = {}
for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
    if p ~= game:GetService("Players").LocalPlayer then
        table.insert(PlayerList, p.Name)
    end
end

local TP_Dropdown = Window:CreateDropdown(TeleportTab, {
    Text = "TP to Player",
    Options = PlayerList,
    Default = PlayerList[1] or "",
    Callback = function(option)
        local target = game:GetService("Players"):FindFirstChild(option)
        local lp = game:GetService("Players").LocalPlayer
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end,
    Parent = TPSection.Content
})

game:GetService("Players").PlayerAdded:Connect(function(p)
    table.insert(PlayerList, p.Name)
end)

game:GetService("Players").PlayerRemoving:Connect(function(p)
    for i, name in ipairs(PlayerList) do
        if name == p.Name then
            table.remove(PlayerList, i)
            break
        end
    end
end)


local MiscSection = Window:CreateSection(MiscTab, {
    Name = "Miscellaneous",
    Collapsed = false
})

Window:CreateToggle(MiscTab, {
    Text = "Anti AFK",
    Default = false,
    Callback = function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end,
    Parent = MiscSection.Content
})

Window:CreateButton(MiscTab, {
    Text = "Unlock FPS",
    Callback = function()
        setfpscap(999)
    end,
    Parent = MiscSection.Content
})

Window:CreateButton(MiscTab, {
    Text = "Low Graphics",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end,
    Parent = MiscSection.Content
})

Window:CreateButton(MiscTab, {
    Text = "Copy JobId",
    Callback = function()
        setclipboard(game.JobId)
    end,
    Parent = MiscSection.Content
})

Window:CreateButton(MiscTab, {
    Text = "Copy PlaceId",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
    end,
    Parent = MiscSection.Content
})


local SettingsSection = Window:CreateSection(SettingsTab, {
    Name = "UI Settings",
    Collapsed = false
})

Window:CreateKeybind(SettingsTab, {
    Text = "Toggle UI Key",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key)
        Window.MainFrame.Visible = not Window.MainFrame.Visible
    end,
    Parent = SettingsSection.Content
})

Window:CreateButton(SettingsTab, {
    Text = "Save Config",
    Callback = function()
        print("[Reaper Hub] Config saved!")
    end,
    Parent = SettingsSection.Content
})

Window:CreateButton(SettingsTab, {
    Text = "Destroy UI",
    Callback = function()
        Window:Close()
    end,
    Parent = SettingsSection.Content
})


print("[Reaper Hub] Loaded Successfully!")
print("[Reaper Hub] Press RightShift to toggle UI")
