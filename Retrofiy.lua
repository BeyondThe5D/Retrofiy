--[[
	██████╗░███████╗████████╗██████╗░░█████╗░███████╗██╗██╗░░░██╗
	██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║╚██╗░██╔╝
	██████╔╝█████╗░░░░░██║░░░██████╔╝██║░░██║█████╗░░██║░╚████╔╝░
	██╔══██╗██╔══╝░░░░░██║░░░██╔══██╗██║░░██║██╔══╝░░██║░░╚██╔╝░░
	██║░░██║███████╗░░░██║░░░██║░░██║╚█████╔╝██║░░░░░██║░░░██║░░░
	╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚═╝░░░╚═╝░░░
	2016 client simulator
	
	Developed by Beyond 5D#4592
	https://discord.gg/FS2u5bfmKy
--]]

--[[
	Keys:
	
	[R] - Recommended, you should keep it on for accuracy sake and has no big/known issues
	[B] - Buggy, isn't fully implemented and/or may not be accurate
	[L] - Low compatibility, works perfectly fine on some games
	[O] - Optional, improvement or a personal preference
--]]

local RetrofiyConfig = {
	RetroLighting = true, -- [R] -- Force disables lighting properties that weren't in 2016, uses compatibility Techology and deletes effects not seen in 2016
	RetroCoreGui = true, -- [B] -- Replaces the Core Gui with a 2016 Core Gui (Playerlist, topbar, etc)
	RetroWorkspace = true, -- [B] -- Uses old materials, disables terrain decoration, only allows brick colors and returns 2016 studs
	RetroCharacters = true, -- [B] -- Displays health bars above the heads of characters & returns old oof sound
	RetroChat = true, -- [B] -- If default chat is enabled it will convert it to the 2016 chat
	BCOnly = false -- [O] -- Makes all premium players appear as BC players instead of it being User ID linked
}

if not game:IsLoaded() then
	game.Loaded:Wait()
end

makefolder("Retrofiy")
makefolder("Retrofiy\\Patches")

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local Chat = game:GetService("Chat")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local MaxInteger = 2147483647

local function ImprovedKeyPress(keys)
	for _, key in pairs(keys) do
		keypress(key)
		keyrelease(key)
	end
end

RunService:Set3dRenderingEnabled(false)

if RetrofiyConfig.RetroLighting then
	local RestrictedLighting = {
		["EnvironmentDiffuseScale"] = 0,
		["EnvironmentSpecularScale"] = 0,
		["ExposureCompensation"] = 0
	}
	local RestrictedEffects = {
		"DepthOfFieldEffect",
		"Atmosphere"
	}

	local function RemoveEffect(effect)
		if table.find(RestrictedEffects, effect.ClassName) then
			RunService.RenderStepped:Wait()
			effect:Destroy()
		end
	end

	sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)

	for property, value in pairs(RestrictedLighting) do
		Lighting[property] = value
	end

	for _, effects in pairs(Lighting:GetDescendants()) do
		RemoveEffect(effects)
	end

	Lighting.DescendantAdded:Connect(RemoveEffect)

	Lighting.Changed:Connect(function(property)
		local Property = RestrictedLighting[property]

		if Property then
			Lighting[property] = Property
		end
	end)
end

if RetrofiyConfig.RetroCoreGui then
	local RetroGui = Instance.new("ScreenGui")
	RetroGui.Parent = CoreGui

	local Memberships = {
		["33"] = "10475940965",
		["67"] = "10475942003",
		["0"] = "10475943080"
	}
	local Icons = {
		["Developer"] = 10653988117,
		["YouTuber"] = 10515678373,
		["Retard"] = 10935164696
	}
	local SpecialPlayers = {
		[2601528367] = Icons["Developer"],
		[3897409161] = Icons["Developer"],
		[1923016785] = Icons["Retard"],
		[339379105] = Icons["Retard"],
		[1651222599] = Icons["Retard"],
		[42049882] = "rbxassetid://10582975516"
	}

	local CanTogglePlayerlist = true
	local ChosenPlayerlistVisibility = CanTogglePlayerlist

	CoreGui:WaitForChild("ThemeProvider").Enabled = false
	CoreGui.PlayerList.Enabled = false

	local Topbar = Instance.new("Frame")
	Topbar.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Topbar.BackgroundTransparency = Player.PlayerGui:GetTopbarTransparency()
	Topbar.BorderSizePixel = 0
	Topbar.Position = UDim2.new(0, 0, 0, -36)
	Topbar.Size = UDim2.new(1, 0, 0, 36)
	Topbar.Parent = RetroGui
	local PlayerlistContainer = Instance.new("ScrollingFrame")
	PlayerlistContainer.AnchorPoint = Vector2.new(1, 0)
	PlayerlistContainer.BackgroundTransparency = 1
	PlayerlistContainer.BorderSizePixel = 0
	PlayerlistContainer.Position = UDim2.new(1, 0, 0, 2)
	PlayerlistContainer.Size = UDim2.new(0, 170, 0.5, 0)
	PlayerlistContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	PlayerlistContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	PlayerlistContainer.ScrollBarImageColor3 = Color3.fromRGB(56, 56, 56)
	PlayerlistContainer.ScrollBarThickness = 6
	PlayerlistContainer.Parent = RetroGui
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Padding = UDim.new(0, 2)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = PlayerlistContainer
	local NameContainer = Instance.new("ImageButton")
	NameContainer.AnchorPoint = Vector2.new(1, 0)
	NameContainer.BackgroundTransparency = 1
	NameContainer.Position = UDim2.new(1, 0, 0, 0)
	NameContainer.Size = UDim2.new(0, 170, 1, 0)
	NameContainer.Parent = Topbar
	local Username = Instance.new("TextLabel")
	Username.BackgroundTransparency = 1
	Username.Position = UDim2.new(0, 7, 0, 0)
	Username.Size = UDim2.new(1, -14, 0, 22)
	Username.Font = Enum.Font.SourceSansBold
	Username.Text = Player.DisplayName
	Username.TextColor3 = Color3.fromRGB(255, 255, 255)
	Username.TextSize = 14
	Username.TextXAlignment = Enum.TextXAlignment.Left
	Username.TextYAlignment = Enum.TextYAlignment.Bottom
	Username.Parent = NameContainer
	local HealthBar = Instance.new("Frame")
	HealthBar.BackgroundColor3 = Color3.fromRGB(228, 236, 246)
	HealthBar.BorderSizePixel = 0
	HealthBar.Position = UDim2.new(0, 7, 1, -9)
	HealthBar.Size = UDim2.new(1, -14, 0, 3)
	HealthBar.Parent = NameContainer
	local HealthFill = Instance.new("Frame")
	HealthFill.BackgroundColor3 = Color3.fromRGB(27, 252, 107)
	HealthFill.BorderSizePixel = 0
	HealthFill.Size = UDim2.new(1, 0, 1, 0)
	HealthFill.Parent = HealthBar
	local IconsFolder = Instance.new("Folder")
	IconsFolder.Parent = Topbar
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = IconsFolder

	local function CreateIcon(size, image, hoverimage)
		local Button = Instance.new("ImageButton")
		Button.BackgroundTransparency = 1
		Button.Size = UDim2.new(0, 50, 0, 36)
		Button.Parent = IconsFolder
		local Image = Instance.new("ImageLabel")
		Image.AnchorPoint = Vector2.new(0.5, 0.5)
		Image.BackgroundTransparency = 1
		Image.Position = UDim2.new(0.5, 0, 0.5, 0)
		Image.Size = size
		Image.Image = "rbxassetid://" .. image
		Image.Parent = Button
		return Button
	end

	local function AttachHumanoidToHealthBar(humanoid) -- broken
		HealthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
		humanoid.HealthChanged:Connect(function()
			HealthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
		end)
	end

	local function TogglePlayerlist()
		if CanTogglePlayerlist then
			local Visibility = not PlayerlistContainer.Visible

			PlayerlistContainer.Visible = Visibility
			ChosenPlayerlistVisibility = Visibility
		end
	end

	local ChatTextures = {
		[true] = 10588179517,
		[false] = 10488448895
	}
	local BackpackTextures = {
		[true] = 10490800273,
		[false] = 10488415707
	}

	local CoreChatBools = {
		["rbxasset://textures/ui/TopBar/chatOn.png"] = ChatTextures[true],
		["rbxasset://textures/ui/TopBar/chatOff.png"] = ChatTextures[false]
	}

	local SettingsButton = CreateIcon(UDim2.new(0, 32, 0, 25), 10488455495, 0)
	local ChatButton = CreateIcon(UDim2.new(0, 28, 0, 27), CoreChatBools[CoreGui.ThemeProvider.TopBarFrame.LeftFrame.ChatIcon.Background.Icon.Image], 0)
	local BackpackButton = CreateIcon(UDim2.new(0, 22, 0, 28), BackpackTextures[CoreGui.RobloxGui.Backpack.Inventory.Visible], 0)

	ChatButton.MouseButton1Down:Connect(function()
		if Chat.LoadDefaultChat and Player.PlayerGui:FindFirstChild("Chat") then
			Player.PlayerGui.Chat.Frame.Visible = not Player.PlayerGui.Chat.Frame.Visible
		end
	end)
	BackpackButton.MouseButton1Down:Connect(function()
		ImprovedKeyPress({0xDF, 0xC0})
	end)
	NameContainer.MouseButton1Down:Connect(function()
		TogglePlayerlist()
	end)

	AttachHumanoidToHealthBar(Humanoid)

	Player.CharacterAdded:Connect(function(character)
		AttachHumanoidToHealthBar(character:WaitForChild("Humanoid"))
	end)

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Tab then
			TogglePlayerlist()
		end
	end)

	--[[
	local FakeMouse = Instance.new("ImageLabel")
	FakeMouse.AnchorPoint = Vector2.new(0.5, 0.5)
	FakeMouse.BackgroundTransparency = 1
	FakeMouse.Size = UDim2.new(0, 64, 0, 64)
	FakeMouse.Image = "rbxassetid://10575892276"
	FakeMouse.Parent = RetroGui
	
	local function DetectMouseHover(gui)
		if gui.ClassName:lower():find("button") then
			gui.MouseEnter:Connect(function()
				FakeMouse.Image = "rbxassetid://10582925132"
			end)

			gui.MouseLeave:Connect(function()
				FakeMouse.Image = "rbxassetid://10575892276"
			end)
		end
	end
	
	for _, objects in pairs(CoreGui:GetDescendants()) do
		DetectMouseHover(objects)
	end
	
	CoreGui.DescendantAdded:Connect(function(object)
		DetectMouseHover(object)
	end)
	
	for _, objects in pairs(Player.PlayerGui:GetDescendants()) do
		DetectMouseHover(objects)
	end
	
	Player.PlayerGui.DescendantAdded:Connect(function(object)
		DetectMouseHover(object)
	end)
	
	UserInputService.MouseIconEnabled = false
	
	Mouse.Move:Connect(function()
		FakeMouse.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
	end)
	--]]

	local TeamsOrderd = {}
	local NeutralTeamExists = false
	local Number = 0

	local function ReturnNeutralCount()
		local Count = 0

		for _, players in pairs(Players:GetPlayers()) do
			if players.Team == nil then
				Count += 1
			end
		end

		return Count
	end

	local function AddTeamToPlayerlist(team, color, order, neutralteam)
		if neutralteam then
			if NeutralTeamExists then
				return
			end
			NeutralTeamExists = true
		end

		if not order then
			Number += 1
		end

		TeamsOrderd[team] = order or Number
		local Button = Instance.new("ImageButton")
		Button.Name = team
		Button.AutoButtonColor = false
		Button.BackgroundColor3 = color
		Button.BackgroundTransparency = 0.5
		Button.BorderSizePixel = 0
		Button.LayoutOrder = order or Number
		Button.Size = UDim2.new(1, 0, 0, 18)
		Button.Parent = PlayerlistContainer
		local TeamName = Instance.new("TextLabel")
		TeamName.BackgroundTransparency = 1
		TeamName.Position = UDim2.new(0.01, 1, 0, 0)
		TeamName.Size = UDim2.new(-0.01, 170, 1, 0)
		TeamName.Font = Enum.Font.SourceSans
		TeamName.Text = team
		TeamName.TextColor3 = Color3.fromRGB(255, 255, 243)
		TeamName.TextSize = 14
		TeamName.TextStrokeColor3 = Color3.fromRGB(34, 34, 34)
		TeamName.TextStrokeTransparency = 0.75
		TeamName.TextXAlignment = Enum.TextXAlignment.Left
		TeamName.Parent = Button

		if neutralteam then
			Instance.new("BoolValue", Button) -- A little bit stinky
		end
	end

	local function AddPlayerToPlayerlist(player)
		local Button = Instance.new("ImageButton")
		Button.Name = player.UserId
		Button.AutoButtonColor = false
		Button.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
		Button.BackgroundTransparency = 0.5
		Button.BorderSizePixel = 0
		if player.Team then
			Button.LayoutOrder = TeamsOrderd[player.Team.Name]
		end
		Button.Size = UDim2.new(1, 0, 0, 24)
		Button.Parent = PlayerlistContainer
		local PlayerName = Instance.new("TextLabel")
		PlayerName.BackgroundTransparency = 1
		PlayerName.Position = UDim2.new(0.01, 19, 0, 0)
		PlayerName.Size = UDim2.new(-0.01, 151, 1, 0)
		PlayerName.Font = Enum.Font.SourceSans
		PlayerName.Text = player.DisplayName
		PlayerName.TextColor3 = Color3.fromRGB(255, 255, 243)
		PlayerName.TextSize = 14
		PlayerName.TextStrokeColor3 = Color3.fromRGB(34, 34, 34)
		PlayerName.TextStrokeTransparency = 0.75
		PlayerName.TextXAlignment = Enum.TextXAlignment.Left
		PlayerName.Parent = Button
		local Icon = Instance.new("ImageLabel")
		Icon.BackgroundTransparency = 1
		Icon.Position = UDim2.new(0.01, 1, 0.5, -8)
		Icon.Size = UDim2.new(0, 16, 0, 16)
		Icon.Parent = Button

		local function CheckTeams()
			if #Teams:GetChildren() > 0 then
				if player.Team then
					Button.LayoutOrder = TeamsOrderd[player.Team.Name]
				else
					AddTeamToPlayerlist("Neutral", Color3.fromRGB(255, 255, 255), MaxInteger, true)
					Button.LayoutOrder = MaxInteger
				end
			end
		end

		CheckTeams()

		player:GetPropertyChangedSignal("Team"):Connect(function()
			CheckTeams()

			if ReturnNeutralCount() <= 0 and PlayerlistContainer:FindFirstChild("Neutral") then
				for _, teams in pairs(PlayerlistContainer:GetChildren()) do
					if teams:FindFirstChildOfClass("BoolValue") then
						NeutralTeamExists = false
						teams:Destroy()
					end
				end
			end
		end)

		local SpecialPlayer = SpecialPlayers[player.UserId]

		pcall(function() -- idk if there is a way to remove this (yet)
			if SpecialPlayer then
				Icon.Image = "rbxassetid://" .. SpecialPlayer
			elseif player:IsInGroup(1200769) then -- causes issues
				Icon.Image = "rbxassetid://10926389485"
			elseif player.MembershipType == Enum.MembershipType.Premium then
				if RetrofiyConfig.BCOnly then
					Icon.Image = "rbxassetid://" .. Memberships["33"]
				else
					Icon.Image = "rbxassetid://" .. Memberships[tostring(math.round((player.UserId / 3) * 100) * 0.01):split(".")[2] or "0"]
				end
			end
		end)
	end

	for _, teams in pairs(Teams:GetChildren()) do
		if teams:IsA("Team") then
			AddTeamToPlayerlist(teams.Name, teams.TeamColor.Color)
		end
	end

	for _, players in pairs(Players:GetPlayers()) do
		AddPlayerToPlayerlist(players)
	end

	Players.PlayerAdded:Connect(function(player)
		AddPlayerToPlayerlist(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if PlayerlistContainer:FindFirstChild(player.UserId) then
			PlayerlistContainer[player.UserId]:Destroy()
		end
	end)

	if Chat.LoadDefaultChat and Player.PlayerGui:FindFirstChild("Chat") then
		Player.PlayerGui.Chat.Frame.Changed:Connect(function()
			ChatButton.ImageLabel.Image = "rbxassetid://" .. ChatTextures[Player.PlayerGui.Chat.Frame.Visible]
		end)
	end

	CoreGui.RobloxGui.Backpack.Inventory.Changed:Connect(function()
		BackpackButton.ImageLabel.Image = "rbxassetid://" .. BackpackTextures[CoreGui.RobloxGui.Backpack.Inventory.Visible]
	end)

	local function ConvertScrollingFrame(scrollingframe)
		scrollingframe.ScrollBarImageColor3 = Color3.fromRGB(56, 56, 56)
		scrollingframe.ScrollBarImageTransparency = 0
		scrollingframe.Changed:Connect(function()
			scrollingframe.ScrollBarImageColor3 = Color3.fromRGB(56, 56, 56)
			scrollingframe.ScrollBarImageTransparency = 0
		end)
	end

	for _, scrollingframes in pairs(game:GetDescendants()) do
		if scrollingframes:IsA("ScrollingFrame") then
			ConvertScrollingFrame(scrollingframes)
		end
	end

	workspace.DescendantAdded:Connect(function(scrollingframe)
		if scrollingframe:IsA("ScrollingFrame") then
			ConvertScrollingFrame(scrollingframe)
		end
	end)

	RunService.RenderStepped:Connect(function() --  This shit is the worst code here
		if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
			CanTogglePlayerlist = false
			PlayerlistContainer.Visible = false
		else
			if not CanTogglePlayerlist then
				CanTogglePlayerlist = true
				PlayerlistContainer.Visible = ChosenPlayerlistVisibility
			end
		end

		Topbar.BackgroundTransparency = Player.PlayerGui:GetTopbarTransparency()
		BackpackButton.Visible = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
		ChatButton.Visible = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
	end)
end

if RetrofiyConfig.RetroWorkspace then
	local Surface = {"BackSurface", "BottomSurface", "FrontSurface", "LeftSurface", "RightSurface", "TopSurface"}
	local _Faces = {"Back", "Bottom", "Front", "Left", "Right", "Top"}

	local function ConvertBasePart(basepart)
		if basepart.Parent and Players:FindFirstChild(basepart.Parent.Name) then -- Try remove
			if StarterPlayer.LoadCharacterAppearance then
				if not Players[basepart.Parent.Name]:HasAppearanceLoaded() then
					Players[basepart.Parent.Name].CharacterAppearanceLoaded:Wait()
				end
			end

			if basepart.Parent then
				basepart.Parent:WaitForChild("Humanoid", 1)
			end
		end

		for face, surface in pairs(Surface) do
			if basepart:IsA("BasePart") and basepart.Parent and not basepart:FindFirstChildOfClass("MeshPart") and not basepart:FindFirstChildOfClass("SpecialMesh") and not basepart.Parent:FindFirstChildOfClass("Humanoid") and basepart.Material == Enum.Material.Plastic and basepart[surface] == Enum.SurfaceType.Studs then
				local Studs = Instance.new("Texture")
				Studs.Color3 = basepart.Color -- amogus huh
				Studs.Color3 = Color3.new(Studs.Color3.R * 2, Studs.Color3.G * 2, Studs.Color3.B * 2)
				Studs.Texture = "rbxassetid://7027211371"
				Studs.Transparency = basepart.Transparency
				Studs.ZIndex = -2147483648
				Studs.Face = _Faces[face]
				Studs.Parent = basepart

				basepart.Changed:Connect(function() -- optimise kek
					Studs.Color3 = basepart.Color -- amogus huh
					Studs.Color3 = Color3.new(Studs.Color3.R * 2, Studs.Color3.G * 2, Studs.Color3.B * 2)
					Studs.Transparency = basepart.Transparency
				end)
			end
		end
	end

	for _, baseparts in pairs(workspace:GetDescendants()) do
		ConvertBasePart(baseparts)
	end

	workspace.DescendantAdded:Connect(function(basepart)
		ConvertBasePart(basepart)
	end)

	sethiddenproperty(workspace:FindFirstChildOfClass("Terrain"), "Decoration", false)
	MaterialService.Use2022Materials = false
end

if RetrofiyConfig.RetroCharacters then
	local function ConvertCharacter(object)
		if object:IsA("Humanoid") and object.HealthDisplayType == Enum.HumanoidHealthDisplayType.DisplayWhenDamaged then
			object.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
		elseif object:IsA("Sound") and object.SoundId == "rbxasset://sounds/uuhhh.mp3" then
			object:GetPropertyChangedSignal("Playing"):Connect(function()
				object:Stop()
				local ClientAudio = Instance.new("Sound")
				ClientAudio.SoundId = "rbxassetid://5143383166"
				ClientAudio.TimePosition = 0.5
				ClientAudio.Parent = object.Parent
				ClientAudio:Play()
			end)
		end
	end

	for _, objects in pairs(workspace:GetDescendants()) do
		ConvertCharacter(objects)
	end

	workspace.DescendantAdded:Connect(ConvertCharacter)

	local Humanoids = {}

	local function AddHumanoidToTable(humanoid)
		if humanoid:IsA("Humanoid") and not table.find(Humanoids, humanoid) then
			table.insert(Humanoids, humanoid)

			humanoid.AncestryChanged:Connect(function()
				if not humanoid:IsDescendantOf(workspace) then
					table.remove(Humanoids, table.find(Humanoids, humanoid))
				end
			end)
		end
	end

	for _, humanoids in pairs(workspace:GetDescendants()) do
		AddHumanoidToTable(humanoids)
	end

	workspace.DescendantAdded:Connect(function(humanoid)
		AddHumanoidToTable(humanoid)
	end)

	spawn(function()
		while true do
			for _, humanoids in pairs(Humanoids) do -- Does not work if player has infinite health!
				humanoids.MaxHealth -= 0.00001
				RunService.RenderStepped:Wait()
				humanoids.MaxHealth += 0.00001
			end
		end
	end)
end

if RetrofiyConfig.RetroChat then
	if Chat.LoadDefaultChat and Player.PlayerGui:FindFirstChild("Chat") then
		local ChatFrame = Player.PlayerGui.Chat.Frame
		ChatFrame.ChatBarParentFrame.Size = UDim2.new(1, 0, 0, 32)
		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Position = UDim2.new(0, 7, 0, 5)
		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Size = UDim2.new(1, -14, 1, -10)
		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Frame.Position = UDim2.new(0, 7, 0, 2)
		ChatFrame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

		for _, messages in pairs(ChatFrame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller:GetChildren()) do
			local TextLabel = messages:FindFirstChildOfClass("TextLabel")

			if TextLabel and TextLabel.Text == "Chat '/?' or '/help' for a list of chat commands." then
				TextLabel.Text = "Please chat '/?' for a list of commands"
			end
		end

		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.Focused:Connect(function()
			ChatFrame.ChatBarParentFrame.Size = UDim2.new(1, 0, 0, 40)
			ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Frame.Position = UDim2.new(0, 7, 0, 6)
			repeat
				ChatFrame.ChatBarParentFrame.Frame.BoxFrame.BackgroundTransparency = 0.1
				ChatFrame.ChatBarParentFrame.Frame.BoxFrame:GetPropertyChangedSignal("BackgroundTransparency"):Wait()
			until
			not ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar:IsFocused()
			ChatFrame.ChatBarParentFrame.Size = UDim2.new(1, 0, 0, 32)
			ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Frame.Position = UDim2.new(0, 7, 0, 2)
		end)

		local function UpdateBarThickness()
			if ChatFrame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ScrollBarThickness == 4 then
				ChatFrame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller.ScrollBarThickness = 7
			end
		end

		UpdateBarThickness()

		ChatFrame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller:GetPropertyChangedSignal("ScrollBarThickness"):Connect(function(value)
			UpdateBarThickness()
		end)
	end
end

local Patch = "Retrofiy\\Patches\\" .. game.PlaceId .. ".lua"

if isfile(Patch) then
	loadstring(readfile(Patch))()
end

RunService:Set3dRenderingEnabled(true)
