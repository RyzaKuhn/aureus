wait()
local m = {}
local players = game:GetService("Players")
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera
local aureus = Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
local cmdbar = Instance.new("TextBox",aureus)
aureus.Name = "Aureus"
cmdbar.BackgroundColor3 = Color3.fromRGB(0,0,0)
cmdbar.BackgroundTransparency = 0.5
cmdbar.BorderSizePixel = 0
cmdbar.Position = UDim2.new(1,0,0.5,0)
cmdbar.Size = UDim2.new(0,300,0,25)
cmdbar.TextEditable = false
cmdbar.Font = Enum.Font.Code
cmdbar.TextSize = 15
cmdbar.TextColor3 = Color3.fromRGB(255,255,255)
cmdbar.Text = ""
cmdbar.Position = UDim2.new(1,0,0.5,0)

-- PRESETS
local noclip = false
local infjump = false
local compass = false
local settingsMenuOpen = false
local notifytime = 3
local jumpRequest = nil
local compassConnection = nil
local rigtype = player.Character.Humanoid.RigType

-- COMPASS
local radarContainer
local pointer
local northwest
local northeast
local southwest
local southeast
local north
local south
local east
local west
createCompass = function()
	radarContainer = Instance.new("Folder", aureus)
	radarContainer.Name = "Radar"
	pointer = Instance.new("ImageLabel", radarContainer)
	pointer.AnchorPoint = Vector2.new(0.5,0.5)
	pointer.Name = "Pointer"
	pointer.BackgroundTransparency = 1
	pointer.Image = "rbxassetid://402675744"
	pointer.Position = UDim2.new(0.094,0,0.855,0)
	pointer.Size = UDim2.new(0,100,0,100)
	northwest = Instance.new("TextLabel", radarContainer)
	northwest.BackgroundTransparency = 1
	northwest.Position = UDim2.new(0.018,0,0.735,0)
	northwest.Size = UDim2.new(0,50,0,50)
	northwest.Font = Enum.Font.Code
	northwest.Text = "NW"
	northwest.TextColor3 = Color3.fromRGB(255,255,255)
	northwest.TextSize = 25
	northwest.TextStrokeTransparency = 0.75
	northeast = Instance.new("TextLabel", radarContainer)
	northeast.BackgroundTransparency = 1
	northeast.Position = UDim2.new(0.132,0,0.735,0)
	northeast.Size = UDim2.new(0,50,0,50)
	northeast.Font = Enum.Font.Code
	northeast.Text = "NE"
	northeast.TextColor3 = Color3.fromRGB(255,255,255)
	northeast.TextSize = 25
	northeast.TextStrokeTransparency = 0.75
	southwest = Instance.new("TextLabel", radarContainer)
	southwest.BackgroundTransparency = 1
	southwest.Position = UDim2.new(0.018,0,0.914,0)
	southwest.Size = UDim2.new(0,50,0,50)
	southwest.Font = Enum.Font.Code
	southwest.Text = "SW"
	southwest.TextColor3 = Color3.fromRGB(255,255,255)
	southwest.TextSize = 25
	southwest.TextStrokeTransparency = 0.75
	southeast = Instance.new("TextLabel", radarContainer)
	southeast.BackgroundTransparency = 1
	southeast.Position = UDim2.new(0.132,0,0.914,0)
	southeast.Size = UDim2.new(0,50,0,50)
	southeast.Font = Enum.Font.Code
	southeast.Text = "SE"
	southeast.TextColor3 = Color3.fromRGB(255,255,255)
	southeast.TextSize = 25
	southeast.TextStrokeTransparency = 0.75
	north = Instance.new("TextLabel", radarContainer)
	north.BackgroundTransparency = 1
	north.Position = UDim2.new(0.056,0,0.735,0)
	north.Size = UDim2.new(0,100,0,50)
	north.Font = Enum.Font.Code
	north.Text = "N"
	north.TextColor3 = Color3.fromRGB(255,255,255)
	north.TextSize = 25
	north.TextStrokeTransparency = 0.75
	south = Instance.new("TextLabel", radarContainer)
	south.BackgroundTransparency = 1
	south.Position = UDim2.new(0.056,0,0.914,0)
	south.Size = UDim2.new(0,100,0,50)
	south.Font = Enum.Font.Code
	south.Text = "S"
	south.TextColor3 = Color3.fromRGB(255,255,255)
	south.TextSize = 25
	south.TextStrokeTransparency = 0.75
	west = Instance.new("TextLabel", radarContainer)
	west.BackgroundTransparency = 1
	west.Position = UDim2.new(0.018,0,0.795,0)
	west.Size = UDim2.new(0,50,0,100)
	west.Font = Enum.Font.Code
	west.Text = "S"
	west.TextColor3 = Color3.fromRGB(255,255,255)
	west.TextSize = 25
	west.TextStrokeTransparency = 0.75
	east = Instance.new("TextLabel", radarContainer)
	east.BackgroundTransparency = 1
	east.Position = UDim2.new(0.132,0,0.795,0)
	east.Size = UDim2.new(0,50,0,100)
	east.Font = Enum.Font.Code
	east.Text = "E"
	east.TextColor3 = Color3.fromRGB(255,255,255)
	east.TextSize = 25
	east.TextStrokeTransparency = 0.75
end
-- NOTIFY
notify = function(title,description)
	local t = Instance.new("TextLabel", aureus)
	t.BackgroundColor3 = Color3.fromRGB(45,45,45)
	t.BorderSizePixel = 0
	t.Position = UDim2.new(1,0,0.544,0)
	t.Size = UDim2.new(0,300,0,25)
	t.Font = Enum.Font.Code
	t.Text = title
	t.TextSize = 20
	t.TextColor3 = Color3.fromRGB(255,255,255)
	local d = Instance.new("TextLabel", t)
	d.BackgroundColor3 = Color3.fromRGB(30,30,30)
	d.BorderSizePixel = 0
	d.Position = UDim2.new(0,0,1,0)
	d.Size = UDim2.new(0,300,0,70)
	d.Font = Enum.Font.Code
	d.Text = description
	d.TextSize = 14
	d.TextColor3 = Color3.fromRGB(255,255,255)
	d.TextWrapped = true
	d.TextXAlignment = Enum.TextXAlignment.Center
	d.TextYAlignment = Enum.TextYAlignment.Top
	game:GetService("TweenService"):Create(t, TweenInfo.new(0.3), {Position = UDim2.new(0.77,0,0.544,0)}):Play()
	delay(3,function()
		game:GetService("TweenService"):Create(t, TweenInfo.new(0.3), {Position = UDim2.new(1,0,0.544,0)}):Play()
		delay(1,function()
			t:Destroy()
		end)
	end)
end
-- SETTINGS MENU
local settingstitle
local settingsframe
local settingslayout
local settingsexit
createSettingsMenu = function()
	settingstitle = Instance.new("TextLabel",aureus)
	settingstitle.BackgroundColor3 = Color3.fromRGB(35,35,35)
	settingstitle.BorderSizePixel = 0
	settingstitle.Position = UDim2.new(0.77,0,0.544,0)
	settingstitle.Size = UDim2.new(0,300,0,25)
	settingstitle.Font = Enum.Font.Code
	settingstitle.Text = "settings"
	settingstitle.TextColor3 = Color3.fromRGB(255,255,255)
	settingstitle.TextSize = 15
	settingstitle.Draggable = true
	settingsframe = Instance.new("Frame",settingstitle)
	settingsframe.BackgroundTransparency = 1
	settingsframe.Position = UDim2.new(0,0,1,0)
	settingsframe.Size = UDim2.new(0,300,0,0)
	settingslayout = Instance.new("UIGridLayout",settingsframe)
	settingslayout.CellPadding = UDim2.new(0,0,0,0)
	settingslayout.CellSize = UDim2.new(0,300,0,35)
	settingsexit = Instance.new("TextButton",settingstitle)
	settingsexit.BackgroundTransparency = 1
	settingsexit.Position = UDim2.new(0.917,0,0,0)
	settingsexit.Size = UDim2.new(0,25,0,25)
	settingsexit.Font = Enum.Font.Code
	settingsexit.Text = "X"
	settingsexit.TextColor3 = Color3.fromRGB(255,255,255)
	settingsexit.TextSize = 15
	settingsexit.MouseButton1Click:Connect(function()
		settingstitle:Destroy()
	end)
end

addLoopToggle = function(text,func)
	local toggled = false
	local debounce = false
	local toggle = Instance.new("TextButton",settingsframe)
	toggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
	toggle.BorderSizePixel = 0
	toggle.Font = Enum.Font.Code
	toggle.TextColor3 = Color3.fromRGB(255,255,255)
	toggle.AutoButtonColor = false
	toggle.Text = "[ON] "..text
	if toggled then toggle.Text = "[ON] "..text elseif not toggled then toggle.Text = "[OFF] "..text end
	local whileToggled = function()
		while toggled do
			func()
		end
	end
	toggle.MouseButton1Click:Connect(function()
		if not debounce then
			debounce = true
			if not toggled then
				toggled = true
				toggle.Text = "[ON] "..text
				whileToggled()
			elseif toggled then
				toggled = false
				toggle.Text = "[OFF] "..text
			end
		elseif debounce then
			warn("Debounce")
		end
		wait(3)
		debounce = false
	end)
end

m.start = function(txt)
	local text = txt:sub(1,#txt)
	local cmd,args = nil,{}
	for i in text:gmatch("[%w%p]+") do
		if cmd == nil then
			cmd = i
		else
			table.insert(args,i)
		end
	end
	if m.cmds[cmd] then
		m.cmds[cmd](args)
	else
		notify("Invalid Command","The command '"..cmd.."' does not exist.")
	end
end

m.cmds = {
	print = function(args)
		for i,v in pairs(args) do
			print(v)
		end
	end,
	
	reset = function()
		player.Character:BreakJoints()
	end,
	
	kill = function(args)
		for a,b in pairs(args) do
			local args2 = b
			for i,v in pairs(players:GetPlayers()) do
				if args2:lower() == v.Name:lower() then
					v.Character:BreakJoints()
				elseif args2:lower() == player.Name:lower() then
					player.Character:BreakJoints()
				elseif args2:lower() == "" then
					player.Character:BreakJoints()
				elseif args2:lower() == "me" then
					player.Character:BreakJoints()
				elseif args2:lower() == "others" then
					if not v.Name:lower() == player.Name:lower() then
						v.Character:BreakJoints()
					end
				elseif args2:lower() == "all" then
					v.Character:BreakJoints()
				end
			end
		end
	end,
	
	noclip = function(args)
		if not noclip then
			noclip = true
			notify("Noclip","Enabled")
			repeat wait()
				player.Character.Humanoid:ChangeState(11)
			until not noclip
		end
	end,
	
	clip = function(args)
		if noclip then
			noclip = false
		end
	end,
	
	infjump = function(args)
		if not infjump then
			infjump = true
			jumpRequest = uis.InputBegan:Connect(function(input,isTyping)
				if not isTyping and input.KeyCode == Enum.KeyCode.Space then
					player.Character.Humanoid:ChangeState("Jumping")
				end
			end)
		end
	end,
	
	noinfjump = function(args)
		if infjump then
			infjump = false
			jumpRequest:Disconnect()
		end
	end,
	
	compass = function(args)
		if not compass then
			compass = true
			createCompass()
			pcall(function()
				compassConnection = rs.RenderStepped:Connect(function()
					radarContainer = player.PlayerGui:WaitForChild("Aureus"):WaitForChild("Radar")
					local angle = math.atan2(player.Character.HumanoidRootPart.CFrame.lookVector.x, player.Character.HumanoidRootPart.CFrame.lookVector.z)
					local degrees = math.ceil(math.abs(math.deg(angle) - 180))
					pointer = radarContainer:WaitForChild("Pointer")
					pointer.Rotation = degrees
				end)
			end)
			notify("Compass","Enabled")
		end
	end,
	
	nocompass = function(args)
		if compass then
			compass = false
			radarContainer:Destroy()
			compassConnection:Disconnect()
			notify("Compass","Disabled")
		end
	end,
		
	rigtype = function()
		if player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
			notify("RigType","R15")
		else
			notify("RigType","R6")
		end
	end,
	
	settings = function()
		if not settingsMenuOpen then
			createSettingsMenu()
			addLoopToggle("Example",function()
				print("yeet")
				wait(1)
			end)
		end
	end,
	
	panic = function()
		noclip = false
		infjump = false
		compass = false
		settingsMenuOpen = false
		pcall(function()
			jumpRequest:Disconnect()
			compassConnection:Disconnect()
		end)
	end,
	
	quit = function()
		aureus:Destroy()
		script:Destroy()
	end,
}

uis.InputBegan:Connect(function(input,isTyping)
	if not isTyping and input.KeyCode == Enum.KeyCode.Semicolon then
		cmdbar:CaptureFocus()
	end
end)

cmdbar.Focused:Connect(function()
	game:GetService("TweenService"):Create(cmdbar, TweenInfo.new(0.3), {Position = UDim2.new(0.77, 0, 0.5, 0)}):Play()
	wait()
	cmdbar.TextEditable = true
end)

cmdbar.FocusLost:Connect(function()
	game:GetService("TweenService"):Create(cmdbar, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0.5, 0)}):Play()
	wait()
	cmdbar.TextEditable = false
	m.start(cmdbar.Text:lower())
end)

return m
