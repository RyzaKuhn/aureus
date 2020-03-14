wait()
local m = {}
local players = game:GetService("Players")
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local mouse = player:GetMouse()
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

-- GUI CUSTOM DRAG
drag = function(gui)
	spawn(function()
		local dragging = nil
		local dragInput = nil
		local dragStart = nil
		local startPos = nil
		local update = function(input)
			local delta = input.Position - dragStart
			gui:TweenPosition(UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y),"InOut","Linear",0.01,true,nil)
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)
		uis.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

-- PRESETS
local noclip = false
local infjump = false
local compass = false
local settingsMenuOpen = false
local prefixMenuOpen = false
local jumpRequest = nil
local compassConnection = nil
local platformSize = Vector3.new(5,1,5)
local rigtype = player.Character.Humanoid.RigType
local oldHeadCanCollide = player.Character:WaitForChild("Head").CanCollide
local oldTorsoCanCollide = player.Character:WaitForChild("Torso").CanCollide

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
	game:GetService("TweenService"):Create(t, TweenInfo.new(0.3), {Position = UDim2.new(0.85,0,0.544,0)}):Play()
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
	settingstitle.Position = UDim2.new(0.85,0,0.544,0)
	settingstitle.Size = UDim2.new(0,300,0,25)
	settingstitle.Font = Enum.Font.Code
	settingstitle.Text = "settings"
	settingstitle.TextColor3 = Color3.fromRGB(255,255,255)
	settingstitle.TextSize = 15
	settingsframe = Instance.new("Frame",settingstitle)
	settingsframe.BackgroundTransparency = 1
	settingsframe.Position = UDim2.new(0,0,1,0)
	settingsframe.Size = UDim2.new(0,300,0,0)
	settingslayout = Instance.new("UIGridLayout",settingsframe)
	settingslayout.CellPadding = UDim2.new(0,0,0,0)
	settingslayout.CellSize = UDim2.new(0,300,0,35)
	settingsexit = Instance.new("TextButton",settingstitle)
	settingsexit.BackgroundTransparency = 1
	settingsexit.Position = UDim2.new(0,0,0,0)
	settingsexit.Size = UDim2.new(0,25,0,25)
	settingsexit.Font = Enum.Font.Code
	settingsexit.Text = "X"
	settingsexit.TextColor3 = Color3.fromRGB(255,255,255)
	settingsexit.TextSize = 15
	settingsexit.MouseButton1Click:Connect(function()
		settingstitle:Destroy()
	end)
	drag(settingstitle)
end

-- PREFIX MENU
local prefixframe
createPrefixMenu = function()
	prefixframe = Instance.new("ScrollingFrame",aureus)
	prefixframe.BackgroundColor3 = Color3.fromRGB(35,35,35)
	prefixframe.BorderSizePixel = 0
	prefixframe.Position = UDim2.new(0.676,0,0.543,0)
	prefixframe.Size = UDim2.new(0,110,0,200)
	prefixframe.CanvasSize = UDim2.new(0,0,2,0)
	prefixframe.ScrollBarThickness = 5
	prefixframe.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
	local prefixscrollgrid = Instance.new("UIGridLayout",prefixframe)
	prefixscrollgrid.CellPadding = UDim2.new(0,5,0,5)
	prefixscrollgrid.CellSize = UDim2.new(0,100,0,20)
	local prefixpadding = Instance.new("UIPadding",prefixframe)
	prefixpadding.PaddingLeft = UDim.new(0,10)
	drag(prefixframe)
end
addPrefixBtn = function(text,func)
	local btn = Instance.new("TextButton",prefixframe)
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.Code
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Text = text
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(function()
		func()
	end)
end

-- CHAMS
local surfFront = nil
local surfBack = nil
local surfTop = nil
local surfBottom = nil
local surfLeft = nil
local surfRight = nil
local chamsConn = nil
local chamsEnabled = false
addChams = function(parent,plr)
	surfFront = Instance.new("SurfaceGui",parent)
	surfFront.AlwaysOnTop = true
	surfFront.Face = "Front"
	local frameF = Instance.new("Frame",surfFront)
	frameF.Size = UDim2.new(1,0,1,0)
	frameF.BorderSizePixel = 0
	frameF.BackgroundColor3 = Color3.fromRGB(255,255,255)	
	surfBack = Instance.new("SurfaceGui",parent)
	surfBack.AlwaysOnTop = true
	surfBack.Face = "Back"
	local frameB = Instance.new("Frame",surfBack)
	frameB.Size = UDim2.new(1,0,1,0)
	frameB.BorderSizePixel = 0
	frameB.BackgroundColor3 = Color3.fromRGB(255,255,255)
	surfTop = Instance.new("SurfaceGui",parent)
	surfTop.AlwaysOnTop = true
	surfTop.Face = "Top"
	local frameT = Instance.new("Frame",surfTop)
	frameT.Size = UDim2.new(1,0,1,0)
	frameT.BorderSizePixel = 0
	frameT.BackgroundColor3 = Color3.fromRGB(255,255,255)
	surfBottom = Instance.new("SurfaceGui",parent)
	surfBottom.AlwaysOnTop = true
	surfBottom.Face = "Front"
	local frameBot = Instance.new("Frame",surfBottom)
	frameBot.Size = UDim2.new(1,0,1,0)
	frameBot.BorderSizePixel = 0
	frameBot.BackgroundColor3 = Color3.fromRGB(255,255,255)			
	surfLeft = Instance.new("SurfaceGui",parent)
	surfLeft.AlwaysOnTop = true
	surfLeft.Face = "Left"
	local frameL = Instance.new("Frame",surfLeft)
	frameL.Size = UDim2.new(1,0,1,0)
	frameL.BorderSizePixel = 0
	frameL.BackgroundColor3 = Color3.fromRGB(255,255,255)			
	surfRight = Instance.new("SurfaceGui",parent)
	surfRight.AlwaysOnTop = true
	surfRight.Face = "Right"
	local frameR = Instance.new("Frame",surfRight)
	frameR.Size = UDim2.new(1,0,1,0)
	frameR.BorderSizePixel = 0
	frameR.BackgroundColor3 = Color3.fromRGB(255,255,255)
	if plr ~= nil then
		local bbg = Instance.new("BillboardGui",plr.Character.Head)
		bbg.Size = UDim2.new(15,0,1,0)
		bbg.StudsOffset = Vector3.new(0,3,0)
		bbg.ClipsDescendants = false
		local overhead = Instance.new("TextLabel",bbg)
		overhead.BackgroundTransparency = 1
		overhead.Size = UDim2.new(1,0,1,0)
		overhead.ClipsDescendants = false
		overhead.Font = Enum.Font.Code
		overhead.TextColor3 = Color3.fromRGB(255,255,255)
		overhead.TextSize = 15
		overhead.TextStrokeColor3 = Color3.fromRGB(0,0,0)
		overhead.TextStrokeTransparency = 0.75
		chamsConn = rs.RenderStepped:Connect(function()
			local dist = math.floor((player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude)
			overhead.Text = ("Name: "..plr.Name.." | ".."Health: "..plr.Character.Humanoid.Health.." | ".."Studs Away: "..dist)
			wait()
		end)
	end
end

-- HASH PLAYER MENU
hashMenuOpen = false
createHashMenu = function()
	local hashmenu = Instance.new("TextLabel",aureus)
	hashmenu.BackgroundColor3 = Color3.fromRGB(35,35,35)
	hashmenu.BorderSizePixel = 0
	hashmenu.Position = UDim2.new(0.85,0,0.544)
	hashmenu.Size = UDim2.new(0,300,0,25)
	hashmenu.Font = Enum.Font.Code
	hashmenu.Text = "hash player"
	hashmenu.TextColor3 = Color3.fromRGB(255,255,255)
	hashmenu.TextSize = 15
	local exitbtn = Instance.new("TextButton",hashmenu)
	exitbtn.BackgroundTransparency = 1
	exitbtn.BorderSizePixel = 0
	exitbtn.Position = UDim2.new(0,0,0,0)
	exitbtn.Size = UDim2.new(0,25,0,25)
	exitbtn.Font = Enum.Font.Code
	exitbtn.Text = "X"
	exitbtn.TextColor3 = Color3.fromRGB(255,255,255)
	exitbtn.TextSize = 15
	exitbtn.MouseButton1Click:Connect(function()
		hashMenuOpen = false
		hashmenu:Destroy()
	end)
	local hashframe = Instance.new("Frame",hashmenu)
	hashframe.BackgroundColor3 = Color3.fromRGB(35,35,35)
	hashframe.BorderSizePixel = 0
	hashframe.Position = UDim2.new(0,0,1,0)
	hashframe.Size = UDim2.new(0,300,0,60)
	local hashframegrid = Instance.new("UIGridLayout",hashframe)
	hashframegrid.CellPadding = UDim2.new(0,0,0,0)
	hashframegrid.CellSize = UDim2.new(1,0,0,20)
	local toolbox = Instance.new("TextBox",hashframe)
	toolbox.BackgroundColor3 = Color3.fromRGB(45,45,45)
	toolbox.BorderSizePixel = 0
	toolbox.Font = Enum.Font.Code
	toolbox.PlaceholderColor3 = Color3.fromRGB(178,178,178)
	toolbox.PlaceholderText = "Radio Name"
	toolbox.TextColor3 = Color3.fromRGB(255,255,255)
	toolbox.Text = ""
	local hashbox = Instance.new("TextBox",hashframe)
	hashbox.BackgroundColor3 = Color3.fromRGB(45,45,45)
	hashbox.BorderSizePixel = 0
	hashbox.Font = Enum.Font.Code
	hashbox.PlaceholderColor3 = Color3.fromRGB(178,178,178)
	hashbox.PlaceholderText = "Hash"
	hashbox.TextColor3 = Color3.fromRGB(255,255,255)
	hashbox.TextWrapped = true
	hashbox.Text = ""
	local playbutton = Instance.new("TextButton",hashframe)
	playbutton.BackgroundColor3 = Color3.fromRGB(45,45,45)
	playbutton.BorderSizePixel = 0
	playbutton.Font = Enum.Font.Code
	playbutton.Text = "Play"
	playbutton.TextColor3 = Color3.fromRGB(255,255,255)
	playbutton.MouseButton1Click:Connect(function()
		pcall(function()
			local hash = hashbox.Text
			local tool = player.Character:FindFirstChildOfClass("Tool")
			local remote = tool:FindFirstChildOfClass("RemoteEvent")
			remote:FireServer("PlaySong",tostring("rbxassetid://0&hash="..hash))
		end)
	end)
	drag(hashmenu)
end

-- PLATFORM TOOL MENU
platformToolMenuOpen = false
createPlatformToolMenu = function()
	local platformtoolmenu = Instance.new("TextLabel",aureus)
	platformtoolmenu.BackgroundColor3 = Color3.fromRGB(35,35,35)
	platformtoolmenu.BorderSizePixel = 0
	platformtoolmenu.Position = UDim2.new(0.85,0,0.544)
	platformtoolmenu.Size = UDim2.new(0,300,0,25)
	platformtoolmenu.Font = Enum.Font.Code
	platformtoolmenu.Text = "platform customization"
	platformtoolmenu.TextColor3 = Color3.fromRGB(255,255,255)
	platformtoolmenu.TextSize = 15
	local exitbtn = Instance.new("TextButton",platformtoolmenu)
	exitbtn.BackgroundTransparency = 1
	exitbtn.BorderSizePixel = 0
	exitbtn.Position = UDim2.new(0,0,0,0)
	exitbtn.Size = UDim2.new(0,25,0,25)
	exitbtn.Font = Enum.Font.Code
	exitbtn.Text = "X"
	exitbtn.TextColor3 = Color3.fromRGB(255,255,255)
	exitbtn.TextSize = 15
	exitbtn.MouseButton1Click:Connect(function()
		platformToolMenuOpen = false
		platformtoolmenu:Destroy()
	end)
	local platformtoolframe = Instance.new("Frame",platformtoolmenu)
	platformtoolframe.BackgroundColor3 = Color3.fromRGB(35,35,35)
	platformtoolframe.BorderSizePixel = 0
	platformtoolframe.Position = UDim2.new(0,0,1,0)
	platformtoolframe.Size = UDim2.new(0,300,0,40)
	local platformtoolframegrid = Instance.new("UIGridLayout",platformtoolframe)
	platformtoolframegrid.CellPadding = UDim2.new(0,0,0,0)
	platformtoolframegrid.CellSize = UDim2.new(1,0,0,20)
	local platformtoolsizebox = Instance.new("TextBox",platformtoolframe)
	platformtoolsizebox.BackgroundColor3 = Color3.fromRGB(45,45,45)
	platformtoolsizebox.BorderSizePixel = 0
	platformtoolsizebox.Font = Enum.Font.Code
	platformtoolsizebox.PlaceholderColor3 = Color3.fromRGB(178,178,178)
	platformtoolsizebox.PlaceholderText = "Platform Size"
	platformtoolsizebox.TextColor3 = Color3.fromRGB(255,255,255)
	platformtoolsizebox.Text = ""
	local platformtoolbutton = Instance.new("TextButton",platformtoolframe)
	platformtoolbutton.BackgroundColor3 = Color3.fromRGB(45,45,45)
	platformtoolbutton.BorderSizePixel = 0
	platformtoolbutton.Font = Enum.Font.Code
	platformtoolbutton.Text = "Give Platform Tool"
	platformtoolbutton.TextColor3 = Color3.fromRGB(255,255,255)
	platformtoolbutton.MouseButton1Click:Connect(function()
		if platformtoolsizebox.Text == nil then
			notify("Platform Tool","Platform size cannot be blank!")
			return
		elseif platformtoolsizebox.Text ~= nil and #platformtoolsizebox.Text == 1 then
			local tool = Instance.new("Tool",player.Backpack)
			local size = Vector3.new(platformtoolsizebox.Text,1,platformtoolsizebox.Text)
			tool.Name = "Size "..platformtoolsizebox.Text
			tool.RequiresHandle = false
			tool.Activated:Connect(function()
				local p = Instance.new("Part",workspace)
				p.Anchored = true
				p.Size = size
				p.Position = mouse.Hit.p
			end)
		else
			notify("Platform Tool","1-9 are the only supported platform sizes!")
		end
	end)
	drag(platformtoolmenu)
end

-- WAYPOINTS MENU
local waypointsmenu = nil
local waypointsframe = nil
local waypointsMenuCreated = false
local waypointsMenuOpen = false
createWaypointsMenu = function()
	if not waypointsMenuOpen and not waypointsMenuCreated then
		waypointsMenuCreated = true
		waypointsMenuOpen = true
		waypointsmenu = Instance.new("TextLabel",aureus)
		waypointsmenu.BackgroundColor3 = Color3.fromRGB(35,35,35)
		waypointsmenu.BorderSizePixel = 0
		waypointsmenu.Position = UDim2.new(0.85,0,0.544,0)
		waypointsmenu.Size = UDim2.new(0,300,0,25)
		waypointsmenu.Font = Enum.Font.Code
		waypointsmenu.Text = "waypoints"
		waypointsmenu.TextColor3 = Color3.fromRGB(255,255,255)
		waypointsmenu.TextSize = 15
		local exitbtn = Instance.new("TextButton",waypointsmenu)
		exitbtn.BackgroundTransparency = 1
		exitbtn.BorderSizePixel = 0
		exitbtn.Position = UDim2.new(0,0,0,0)
		exitbtn.Size = UDim2.new(0,25,0,25)
		exitbtn.Font = Enum.Font.Code
		exitbtn.Text = "X"
		exitbtn.TextColor3 = Color3.fromRGB(255,255,255)
		exitbtn.TextSize = 15
		exitbtn.MouseButton1Click:Connect(function()
			waypointsMenuOpen = false
			waypointsmenu.Position = UDim2.new(1,0,0.544,0)
		end)
		local waypointnamebox = Instance.new("TextBox",waypointsmenu)
		waypointnamebox.BackgroundColor3 = Color3.fromRGB(35,35,35)
		waypointnamebox.BorderSizePixel = 0
		waypointnamebox.Position = UDim2.new(0.683,0,0,0)
		waypointnamebox.Size = UDim2.new(0,70,0,25)
		waypointnamebox.Font = Enum.Font.Code
		waypointnamebox.PlaceholderText = "name"
		waypointnamebox.Text = ""
		waypointnamebox.TextColor3 = Color3.fromRGB(255,255,255)
		waypointnamebox.TextSize = 10
		waypointnamebox.TextWrapped = true
		local addwaypointbtn = Instance.new("TextButton",waypointsmenu)
		addwaypointbtn.BackgroundTransparency = 1
		addwaypointbtn.BorderSizePixel = 0
		addwaypointbtn.Position = UDim2.new(0.917,0,0,0)
		addwaypointbtn.Size = UDim2.new(0,25,0,25)
		addwaypointbtn.Font = Enum.Font.Code
		addwaypointbtn.Text = "+"
		addwaypointbtn.TextColor3 = Color3.fromRGB(255,255,255)
		addwaypointbtn.TextSize = 15
		addwaypointbtn.MouseButton1Click:Connect(function()
			if waypointnamebox.Text ~= nil and #waypointnamebox.Text >= 1 and #waypointnamebox.Text <= 20 then
				addWaypoint(waypointnamebox.Text,player.Character.HumanoidRootPart.Position)
			end
		end)
		waypointsframe = Instance.new("Frame",waypointsmenu)
		waypointsframe.BackgroundColor3 = Color3.fromRGB(35,35,35)
		waypointsframe.BorderSizePixel = 0
		waypointsframe.Position = UDim2.new(0,0,1,0)
		waypointsframe.Size = UDim2.new(0,300,0,0)
		local waypointsgrid = Instance.new("UIGridLayout",waypointsframe)
		waypointsgrid.CellPadding = UDim2.new(0,0,0,0)
		waypointsgrid.CellSize = UDim2.new(1,0,0,20)
	elseif waypointsMenuOpen and waypointsMenuCreated then
		waypointsMenuOpen = false
		game:GetService("TweenService"):Create(waypointsmenu, TweenInfo.new(0.3), {Position = UDim2.new(0.85,0,0.544,0)}):Play()
	elseif not waypointsMenuOpen and waypointsMenuCreated then
		waypointsMenuOpen = true
		game:GetService("TweenService"):Create(waypointsmenu, TweenInfo.new(0.3), {Position = UDim2.new(0.85,0,0.544,0)}):Play()
	end
	drag(waypointsmenu)
end



local studConn = nil
addWaypoint = function(name,pos)
	local p = Instance.new("Part",workspace)
	p.Position = Vector3.new(pos.X,pos.Y-4,pos.Z)
	p.Size = Vector3.new(2,2,2)
	p.Anchored = true
	p.CanCollide = false
	p.Transparency = 1
	p.Name = name
	p.Material = Enum.Material.Neon
	p.BrickColor = BrickColor.new("Baby blue")
	
	local bbg = Instance.new("BillboardGui",p)
	bbg.Size = UDim2.new(15,0,1,0)
	bbg.StudsOffset = Vector3.new(0,3,0)
	bbg.ClipsDescendants = false
	
	local overhead = Instance.new("TextLabel",bbg)
	overhead.BackgroundTransparency = 1
	overhead.Size = UDim2.new(1,0,1,0)
	overhead.ClipsDescendants = false
	overhead.Font = Enum.Font.Code
	overhead.TextColor3 = Color3.fromRGB(255,255,255)
	overhead.TextSize = 15
	overhead.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	overhead.TextStrokeTransparency = 0.75
	
	local btn = Instance.new("TextButton",waypointsframe)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.Code
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.MouseButton1Click:Connect(function()
		p.Transparency = 1
		p.Size = Vector3.new(2,2,2)
		p.Position = Vector3.new(pos.X,pos.Y-4,pos.Z)
		player.Character:MoveTo(pos)
	end)
	
	local delbtn = Instance.new("TextButton",btn)
	delbtn.BackgroundTransparency = 1
	delbtn.Size = UDim2.new(0,20,0,20)
	delbtn.Position = UDim2.new(0,0,0,0)
	delbtn.Font = Enum.Font.Code
	delbtn.Text = "DEL"
	delbtn.TextColor3 = Color3.fromRGB(255,255,255)
	delbtn.MouseButton1Click:Connect(function()
		btn:Destroy()
		p:Destroy()
	end)
	
	waypointStudsDist(overhead,p,pos)
end

waypointStudsDist = function(overhead,p,pos)
	studConn = rs.RenderStepped:Connect(function()
		local dist = math.floor((player.Character.HumanoidRootPart.Position -p.Position).magnitude) - 4
		overhead.Text = ("Waypoint: "..p.Name.." | ".."Studs Away: "..dist)
		if dist > 10 then
			p.Transparency = 0
			p.Size = Vector3.new(2,1000,2)
			p.Position = Vector3.new(pos.X,pos.Y-4,pos.Z)
		elseif dist < 10 then
			p.Transparency = 1
			p.Size = Vector3.new(2,2,2)
			p.Position = Vector3.new(pos.X,pos.Y-4,pos.Z)
		end
		wait()
	end)
end

m.start = function(txt)
	local text = txt:sub(1,#txt)
	if #text < 1 then
		return
	else
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
end
local musicOn = false
local waypointsMenuToggled = false
m.cmds = {
	music = function(id)
		musicOn = false
		for i,v in pairs(player.Character.Head:GetChildren()) do
			if v:IsA("Sound") then
				musicOn = true
				v.TimePosition = 0
				v.SoundId = "rbxassetid://"..id[1]
			end
		end
		if not musicOn then
			local audio = Instance.new("Sound",player.Character.Head)
			audio.SoundId = "rbxassetid://"..id[1]
			audio.Looped = true
			audio.Playing = true
		end
	end,
	
	nomusic = function()
		for i,v in pairs(player.Character.Head:GetChildren()) do
			if v:IsA("Sound") then
				v:Destroy()
			end
		end
	end,
	
	hash = function()
		if not hashMenuOpen then
			hashMenuOpen = true
			createHashMenu()
		end
	end,
	
	platformtool = function()
		if not platformToolMenuOpen then
			platformToolMenuOpen = true
			createPlatformToolMenu()
		end
	end,
	
	chamsettings = function()
		
	end,
	
	waypoints = function(args)
		createWaypointsMenu()
	end,
	
	print = function(args)
		local results = {}
		for i,v in pairs(args) do
			table.insert(results,v)
		end
		print(table.concat(results," "))
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
				elseif args2 == nil then
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
			oldHeadCanCollide = player.Character:WaitForChild("Head").CanCollide
			oldTorsoCanCollide = player.Character:WaitForChild("Torso").CanCollide
			player.Character:WaitForChild("Head").CanCollide = false
			player.Character:WaitForChild("Torso").CanCollide = false
		end
	end,
	
	clip = function(args)
		if noclip then
			noclip = false
			notify("Noclip","Disabled")
			player.Character:WaitForChild("Head").CanCollide = oldHeadCanCollide
			player.Character:WaitForChild("Torso").CanCollide = oldTorsoCanCollide
		end
	end,
	
	infjump = function()
		if not infjump then
			infjump = true
			notify("Infinite Jump","Enabled")
			jumpRequest = uis.InputBegan:Connect(function(input,isTyping)
				if not isTyping and input.KeyCode == Enum.KeyCode.Space then
					player.Character.Humanoid:ChangeState("Jumping")
				end
			end)
		end
	end,
	
	noinfjump = function()
		if infjump then
			infjump = false
			notify("Infinite Jump","Disabled")
			jumpRequest:Disconnect()
		end
	end,
	
	compass = function()
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
	
	nocompass = function()
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
		end
	end,
	
	find = function(args)
		local text = string.sub(cmdbar.Text:lower(),6,#cmdbar.Text:lower())
		local matches = {}
		
		for i,v in pairs(players:GetChildren()) do
			local name = v.Name:lower()
			local term = string.sub(name,1,string.len(text))
			local match = string.find(term,text)
			if match then
				table.insert(matches,name)
			end
		end
		if #matches == 1 then
			for a,b in pairs(players:GetPlayers()) do
				if matches[1] == b.Name:lower() then
					for i,v in pairs(b.Character:GetChildren()) do
						if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
							addChams(v,b)
						end
					end
				end
			end
			notify("Chams","Applied chams to player")
		end
	end,
	
	unfind = function(args)
		local text = string.sub(cmdbar.Text:lower(),8,#cmdbar.Text:lower())
		local matches = {}
		for i,v in pairs(players:GetChildren()) do
			local name = v.Name:lower()
			local term = string.sub(name,1,string.len(text))
			local match = string.find(term,text)
			if match then
				table.insert(matches,name)
			end
		end
		if #matches == 1 then
			for a,b in pairs(players:GetPlayers()) do
				if matches[1] == b.Name:lower() then
					for c,d in pairs(b.Character:GetChildren()) do
						if not d:IsA("BasePart") then
							return
						else
							for i,v in pairs(d:GetChildren()) do
								if v:IsA("SurfaceGui") or v:IsA("BillboardGui") then
									v:Destroy()
								end
							end
						end
					end
				end
			end
			notify("Chams","Removed chams from player")
		end
	end,
	
	chams = function()
		if chamsEnabled then
			return
		elseif not chamsEnabled then
			for a,b in pairs(players:GetPlayers()) do
				if b.Name == player.Name then
					return
				else
					for c,d in pairs(b.Character:GetChildren()) do
						for e,f in pairs(d:GetChildren()) do
							addChams(d,b)
						end
					end
				end
			end
			notify("Chams","Enabled")
		end
	end,
	
	nochams = function()
		if not chamsEnabled then
			return
		elseif chamsEnabled then
			chamsEnabled = false
			for a,b in pairs(players:GetPlayers()) do
				for c,d in pairs(b.Character:GetChildren()) do
					for e,f in pairs(d:GetChildren()) do
						if f:IsA("SurfaceGui") or f:IsA("BillboardGui") then
							f:Destroy()
						end
					end
				end
			end
			chamsConn:Disconnect()
			notify("Chams","Disabled")
		end
	end,
	
	xray = function()
		pcall(function()
			for _,parts in pairs(game:GetDescendants()) do
				if parts:IsA("BasePart") then
					parts.Transparency = 0.5
					player.Character['Head'].Transparency = 0
					player.Character['Torso'].Transparency = 0
					player.Character['Left Arm'].Transparency = 0
					player.Character['Right Arm'].Transparency = 0
					player.Character['Left Leg'].Transparency = 0
					player.Character['Right Leg'].Transparency = 0
					player.Character['HumanoidRootPart'].Transparency = 1
				end
			end
			notify("X-Ray","Enabled")
		end)
	end,
	
	noxray = function()
		pcall(function()
			for _,parts in pairs(game:GetDescendants()) do
				if parts:IsA("BasePart") then
					parts.Transparency = 0
					player.Character['Head'].Transparency = 0
					player.Character['Torso'].Transparency = 0
					player.Character['Left Arm'].Transparency = 0
					player.Character['Right Arm'].Transparency = 0
					player.Character['Left Leg'].Transparency = 0
					player.Character['Right Leg'].Transparency = 0
					player.Character['HumanoidRootPart'].Transparency = 1
				end
			end
			notify("X-Ray","Disabled")
		end)
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
	
	exit = function()
		player:Kick()
	end,
	
	prefix = function()
		if not prefixMenuOpen then
			prefixMenuOpen = true
			createPrefixMenu()
			addPrefixBtn("EXIT",function()
				prefixMenuOpen = false
				prefixframe:Destroy()
			end)
			addPrefixBtn(";",function()
				m.prefix = "Semicolon"
			end)
			addPrefixBtn(".",function()
				m.prefix = "Period"
			end)
			addPrefixBtn(",",function()
				m.prefix = "Comma"
			end)
			addPrefixBtn("INS",function()
				m.prefix = "Insert"
			end)
			addPrefixBtn("RCtrl",function()
				m.prefix = "RightControl"
			end)
			addPrefixBtn("LCtrl",function()
				m.prefix = "LeftControl"
			end)
			addPrefixBtn("RShift",function()
				m.prefix = "RightShift"
			end)
			addPrefixBtn("LAlt",function()
				m.prefix = "LeftAlt"
			end)
			addPrefixBtn("RAlt",function()
				m.prefix = "RightAlt"
			end)
			addPrefixBtn("B",function()
				m.prefix = "B"
			end)
			addPrefixBtn("C",function()
				m.prefix = "C"
			end)
			addPrefixBtn("E",function()
				m.prefix = "E"
			end)
			addPrefixBtn("F",function()
				m.prefix = "F"
			end)
			addPrefixBtn("G",function()
				m.prefix = "G"
			end)
			addPrefixBtn("H",function()
				m.prefix = "H"
			end)
			addPrefixBtn("I",function()
				m.prefix = "I"
			end)
			addPrefixBtn("J",function()
				m.prefix = "J"
			end)
			addPrefixBtn("K",function()
				m.prefix = "K"
			end)
			addPrefixBtn("L",function()
				m.prefix = "L"
			end)
			addPrefixBtn("M",function()
				m.prefix = "M"
			end)
			addPrefixBtn("N",function()
				m.prefix = "N"
			end)
			addPrefixBtn("O",function()
				m.prefix = "O"
			end)
			addPrefixBtn("P",function()
				m.prefix = "P"
			end)
			addPrefixBtn("Q",function()
				m.prefix = "Q"
			end)
			addPrefixBtn("R",function()
				m.prefix = "R"
			end)
			addPrefixBtn("T",function()
				m.prefix = "T"
			end)
			addPrefixBtn("U",function()
				m.prefix = "U"
			end)
			addPrefixBtn("V",function()
				m.prefix = "V"
			end)
			addPrefixBtn("X",function()
				m.prefix = "X"
			end)
			addPrefixBtn("Y",function()
				m.prefix = "Y"
			end)
			addPrefixBtn("Z",function()
				m.prefix = "Z"
			end)
		end
	end,
}


players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if not chamsEnabled then
			return
		elseif chamsEnabled then
			for i,v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") then
					addChams(v,plr)
				end
			end
		end
	end)
end)

players.PlayerRemoving:Connect(function(plr)
	for a,b in pairs(plr.Character:GetChildren()) do
		if b:IsA("BasePart") then
			for i,v in pairs(b:GetChildren()) do
				if v:IsA("SurfaceGui") or v:IsA("BillboardGui") then
					v:Destroy()
				end
			end
		end
	end
end)

uis.InputBegan:Connect(function(input,isTyping)
	if not isTyping and input.KeyCode == Enum.KeyCode[m.prefix] then
		cmdbar:CaptureFocus()
	end
end)

cmdbar.Focused:Connect(function()
	game:GetService("TweenService"):Create(cmdbar, TweenInfo.new(0.3), {Position = UDim2.new(0.85, 0, 0.5, 0)}):Play()
	wait()
	cmdbar.TextEditable = true
end)

cmdbar.FocusLost:Connect(function()
	game:GetService("TweenService"):Create(cmdbar, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0.5, 0)}):Play()
	wait()
	cmdbar.TextEditable = false
	m.start(cmdbar.Text:lower())
end)

m.prefix = "Semicolon"
return m
