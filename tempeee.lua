local library = {}

function library:CreateWindow(config)
    local title = config.Title or "Cloudy"
    local logoId = config.Logo or ""
    
    local coreGui = game:GetService("CoreGui")
    local tweenService = game:GetService("TweenService")
    local userInputService = game:GetService("UserInputService")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "CloudyUI"
    sg.Parent = coreGui
    sg.IgnoreGuiInset = true
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(1, 0, 1, 0)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    main.BackgroundTransparency = 0.3
    main.BorderSizePixel = 0
    main.Parent = sg
    
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 280, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 80)
    topbar.BackgroundTransparency = 1
    topbar.Parent = sidebar
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 35, 0, 35)
    logo.Position = UDim2.new(0, 20, 0.5, -17.5)
    logo.BackgroundTransparency = 1
    logo.Image = logoId
    logo.Parent = topbar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -75, 1, 0)
    titleLabel.Position = UDim2.new(0, 65, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = titleLabel
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -80)
    tabList.Position = UDim2.new(0, 0, 0, 80)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.Parent = sidebar
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabList
    
    local tabListPad = Instance.new("UIPadding")
    tabListPad.PaddingTop = UDim.new(0, 10)
    tabListPad.PaddingLeft = UDim.new(0, 15)
    tabListPad.PaddingRight = UDim.new(0, 15)
    tabListPad.Parent = tabList
    
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -280, 1, 0)
    contentArea.Position = UDim2.new(0, 280, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = main
    
    local controlBar = Instance.new("Frame")
    controlBar.Size = UDim2.new(1, 0, 0, 60)
    controlBar.BackgroundTransparency = 1
    controlBar.Parent = contentArea
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -60, 0.5, -20)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Parent = controlBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 40, 0, 40)
    minBtn.Position = UDim2.new(1, -110, 0.5, -20)
    minBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 18
    minBtn.Parent = controlBar
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn
    
    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1, -40, 1, -80)
    pages.Position = UDim2.new(0, 20, 0, 60)
    pages.BackgroundTransparency = 1
    pages.Parent = contentArea
    
    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
    end)
    
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -main.AbsoluteSize.X, 0, 0)}):Play()
        else
            tweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end
    end)
    
    local window = {}
    local currentTab = nil
    
    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 45)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = "   " .. name
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 15
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabList
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabBtn
        
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 2
        page.Visible = false
        page.Parent = pages
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = page
        
        tabBtn.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
            for _, v in pairs(tabList:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    v.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            page.Visible = true
            currentTab = page
        end)
        
        local tab = {}
        
        function tab:CreateToggle(tname, callback)
            local toggleFrm = Instance.new("Frame")
            toggleFrm.Size = UDim2.new(1, 0, 0, 50)
            toggleFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            toggleFrm.Parent = page
            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 8)
            tCorner.Parent = toggleFrm
            
            local tLabel = Instance.new("TextLabel")
            tLabel.Size = UDim2.new(1, -70, 1, 0)
            tLabel.Position = UDim2.new(0, 20, 0, 0)
            tLabel.BackgroundTransparency = 1
            tLabel.Text = tname
            tLabel.Font = Enum.Font.Gotham
            tLabel.TextSize = 14
            tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tLabel.TextXAlignment = Enum.TextXAlignment.Left
            tLabel.Parent = toggleFrm
            
            local tBtn = Instance.new("TextButton")
            tBtn.Size = UDim2.new(0, 46, 0, 24)
            tBtn.Position = UDim2.new(1, -66, 0.5, -12)
            tBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            tBtn.Text = ""
            tBtn.Parent = toggleFrm
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(1, 0)
            btnCorner.Parent = tBtn
            
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 20, 0, 20)
            indicator.Position = UDim2.new(0, 2, 0.5, -10)
            indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            indicator.Parent = tBtn
            local indCorner = Instance.new("UICorner")
            indCorner.CornerRadius = UDim.new(1, 0)
            indCorner.Parent = indicator
            
            local state = false
            tBtn.MouseButton1Click:Connect(function()
                state = not state
                tweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
                tweenService:Create(tBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = state and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(50, 50, 50)}):Play()
                if callback then callback(state) end
            end)
        end
        
        function tab:CreateSlider(sname, min, max, default, callback)
            local sliderFrm = Instance.new("Frame")
            sliderFrm.Size = UDim2.new(1, 0, 0, 70)
            sliderFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            sliderFrm.Parent = page
            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 8)
            sCorner.Parent = sliderFrm
            
            local sLabel = Instance.new("TextLabel")
            sLabel.Size = UDim2.new(1, -40, 0, 35)
            sLabel.Position = UDim2.new(0, 20, 0, 0)
            sLabel.BackgroundTransparency = 1
            sLabel.Text = sname
            sLabel.Font = Enum.Font.Gotham
            sLabel.TextSize = 14
            sLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sLabel.TextXAlignment = Enum.TextXAlignment.Left
            sLabel.Parent = sliderFrm
            
            local sVal = Instance.new("TextLabel")
            sVal.Size = UDim2.new(0, 50, 0, 35)
            sVal.Position = UDim2.new(1, -70, 0, 0)
            sVal.BackgroundTransparency = 1
            sVal.Text = tostring(default)
            sVal.Font = Enum.Font.Gotham
            sVal.TextSize = 14
            sVal.TextColor3 = Color3.fromRGB(200, 200, 200)
            sVal.TextXAlignment = Enum.TextXAlignment.Right
            sVal.Parent = sliderFrm
            
            local sBg = Instance.new("TextButton")
            sBg.Size = UDim2.new(1, -40, 0, 8)
            sBg.Position = UDim2.new(0, 20, 0, 45)
            sBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sBg.Text = ""
            sBg.Parent = sliderFrm
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(1, 0)
            bgCorner.Parent = sBg
            
            local sFill = Instance.new("Frame")
            local defPct = math.clamp((default - min) / (max - min), 0, 1)
            sFill.Size = UDim2.new(defPct, 0, 1, 0)
            sFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sFill.Parent = sBg
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sFill
            
            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
                sFill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + ((max - min) * pos))
                sVal.Text = tostring(val)
                if callback then callback(val) end
            end
            sBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            userInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            userInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
        end
        
        function tab:CreateDropdown(dname, options, callback)
            local dropFrm = Instance.new("Frame")
            dropFrm.Size = UDim2.new(1, 0, 0, 50)
            dropFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            dropFrm.ClipsDescendants = true
            dropFrm.Parent = page
            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 8)
            dCorner.Parent = dropFrm
            
            local dBtn = Instance.new("TextButton")
            dBtn.Size = UDim2.new(1, 0, 0, 50)
            dBtn.BackgroundTransparency = 1
            dBtn.Text = ""
            dBtn.Parent = dropFrm
            
            local dLabel = Instance.new("TextLabel")
            dLabel.Size = UDim2.new(1, -40, 1, 0)
            dLabel.Position = UDim2.new(0, 20, 0, 0)
            dLabel.BackgroundTransparency = 1
            dLabel.Text = dname .. " : ..."
            dLabel.Font = Enum.Font.Gotham
            dLabel.TextSize = 14
            dLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dLabel.TextXAlignment = Enum.TextXAlignment.Left
            dLabel.Parent = dBtn
            
            local dScroll = Instance.new("ScrollingFrame")
            dScroll.Size = UDim2.new(1, -20, 0, 100)
            dScroll.Position = UDim2.new(0, 10, 0, 50)
            dScroll.BackgroundTransparency = 1
            dScroll.ScrollBarThickness = 2
            dScroll.Parent = dropFrm
            
            local dLayout = Instance.new("UIListLayout")
            dLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dLayout.Padding = UDim.new(0, 5)
            dLayout.Parent = dScroll
            
            local isOpen = false
            dBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                tweenService:Create(dropFrm, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isOpen and UDim2.new(1, 0, 0, 160) or UDim2.new(1, 0, 0, 50)}):Play()
            end)
            
            for _, opt in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                optBtn.Text = opt
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 13
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optBtn.Parent = dScroll
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    dLabel.Text = dname .. " : " .. opt
                    isOpen = false
                    tweenService:Create(dropFrm, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                    if callback then callback(opt) end
                end)
            end
        end
        
        function tab:CreateMultiDropdown(dname, options, callback)
            local dropFrm = Instance.new("Frame")
            dropFrm.Size = UDim2.new(1, 0, 0, 50)
            dropFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            dropFrm.ClipsDescendants = true
            dropFrm.Parent = page
            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 8)
            dCorner.Parent = dropFrm
            
            local dBtn = Instance.new("TextButton")
            dBtn.Size = UDim2.new(1, 0, 0, 50)
            dBtn.BackgroundTransparency = 1
            dBtn.Text = ""
            dBtn.Parent = dropFrm
            
            local dLabel = Instance.new("TextLabel")
            dLabel.Size = UDim2.new(1, -40, 1, 0)
            dLabel.Position = UDim2.new(0, 20, 0, 0)
            dLabel.BackgroundTransparency = 1
            dLabel.Text = dname .. " : []"
            dLabel.Font = Enum.Font.Gotham
            dLabel.TextSize = 14
            dLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dLabel.TextXAlignment = Enum.TextXAlignment.Left
            dLabel.Parent = dBtn
            
            local dScroll = Instance.new("ScrollingFrame")
            dScroll.Size = UDim2.new(1, -20, 0, 100)
            dScroll.Position = UDim2.new(0, 10, 0, 50)
            dScroll.BackgroundTransparency = 1
            dScroll.ScrollBarThickness = 2
            dScroll.Parent = dropFrm
            
            local dLayout = Instance.new("UIListLayout")
            dLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dLayout.Padding = UDim.new(0, 5)
            dLayout.Parent = dScroll
            
            local isOpen = false
            dBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                tweenService:Create(dropFrm, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = isOpen and UDim2.new(1, 0, 0, 160) or UDim2.new(1, 0, 0, 50)}):Play()
            end)
            
            local selected = {}
            for _, opt in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                optBtn.Text = opt
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 13
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optBtn.Parent = dScroll
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    if table.find(selected, opt) then
                        table.remove(selected, table.find(selected, opt))
                        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    else
                        table.insert(selected, opt)
                        optBtn.TextColor3 = Color3.fromRGB(120, 255, 120)
                    end
                    dLabel.Text = dname .. " : [" .. table.concat(selected, ", ") .. "]"
                    if callback then callback(selected) end
                end)
            end
        end
        
        function tab:CreateButton(bname, callback)
            local btnFrm = Instance.new("Frame")
            btnFrm.Size = UDim2.new(1, 0, 0, 45)
            btnFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btnFrm.Parent = page
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 8)
            bCorner.Parent = btnFrm
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = bname
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Parent = btnFrm
            
            btn.MouseButton1Click:Connect(function()
                tweenService:Create(btnFrm, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                task.wait(0.1)
                tweenService:Create(btnFrm, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                if callback then callback() end
            end)
        end
        
        function tab:CreateLabel(text)
            local lblFrm = Instance.new("Frame")
            lblFrm.Size = UDim2.new(1, 0, 0, 35)
            lblFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            lblFrm.BackgroundTransparency = 1
            lblFrm.Parent = page
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = lblFrm
            
            lblFrm.Size = UDim2.new(1, 0, 0, lbl.TextBounds.Y + 20)
            lbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
                lblFrm.Size = UDim2.new(1, 0, 0, lbl.TextBounds.Y + 20)
            end)
        end
        
        function tab:CreateTextbox(tname, placeholder, isNumeric, callback)
            local txtFrm = Instance.new("Frame")
            txtFrm.Size = UDim2.new(1, 0, 0, 50)
            txtFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            txtFrm.Parent = page
            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 8)
            tCorner.Parent = txtFrm
            
            local tLabel = Instance.new("TextLabel")
            tLabel.Size = UDim2.new(1, -120, 1, 0)
            tLabel.Position = UDim2.new(0, 20, 0, 0)
            tLabel.BackgroundTransparency = 1
            tLabel.Text = tname
            tLabel.Font = Enum.Font.Gotham
            tLabel.TextSize = 14
            tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tLabel.TextXAlignment = Enum.TextXAlignment.Left
            tLabel.Parent = txtFrm
            
            local txtBox = Instance.new("TextBox")
            txtBox.Size = UDim2.new(0, 100, 0, 30)
            txtBox.Position = UDim2.new(1, -110, 0.5, -15)
            txtBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            txtBox.Text = ""
            txtBox.PlaceholderText = placeholder or "Enter..."
            txtBox.Font = Enum.Font.Gotham
            txtBox.TextSize = 13
            txtBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            txtBox.Parent = txtFrm
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = txtBox
            
            txtBox.FocusLost:Connect(function(enterPressed)
                local val = txtBox.Text
                if isNumeric then
                    val = tonumber(val) or 0
                    txtBox.Text = tostring(val)
                end
                if callback then callback(val) end
            end)
        end
        
        function tab:CreateKeybind(kname, default, callback)
            local keyFrm = Instance.new("Frame")
            keyFrm.Size = UDim2.new(1, 0, 0, 50)
            keyFrm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            keyFrm.Parent = page
            local kCorner = Instance.new("UICorner")
            kCorner.CornerRadius = UDim.new(0, 8)
            kCorner.Parent = keyFrm
            
            local kLabel = Instance.new("TextLabel")
            kLabel.Size = UDim2.new(1, -120, 1, 0)
            kLabel.Position = UDim2.new(0, 20, 0, 0)
            kLabel.BackgroundTransparency = 1
            kLabel.Text = kname
            kLabel.Font = Enum.Font.Gotham
            kLabel.TextSize = 14
            kLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            kLabel.TextXAlignment = Enum.TextXAlignment.Left
            kLabel.Parent = keyFrm
            
            local kBtn = Instance.new("TextButton")
            kBtn.Size = UDim2.new(0, 100, 0, 30)
            kBtn.Position = UDim2.new(1, -110, 0.5, -15)
            kBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            kBtn.Text = default and default.Name or "None"
            kBtn.Font = Enum.Font.Gotham
            kBtn.TextSize = 13
            kBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            kBtn.Parent = keyFrm
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = kBtn
            
            local currentKey = default
            local binding = false
            
            kBtn.MouseButton1Click:Connect(function()
                binding = true
                kBtn.Text = "..."
            end)
            
            userInputService.InputBegan:Connect(function(input, processed)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    kBtn.Text = currentKey.Name
                    binding = false
                elseif not binding and not processed and currentKey and input.KeyCode == currentKey then
                    if callback then callback() end
                end
            end)
        end
        
        return tab
    end
    return window
end

return library
