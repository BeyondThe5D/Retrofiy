--[[
	██████╗░███████╗████████╗██████╗░░█████╗░███████╗██╗██╗░░░██╗
	██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║╚██╗░██╔╝
	██████╔╝█████╗░░░░░██║░░░██████╔╝██║░░██║█████╗░░██║░╚████╔╝░
	██╔══██╗██╔══╝░░░░░██║░░░██╔══██╗██║░░██║██╔══╝░░██║░░╚██╔╝░░
	██║░░██║███████╗░░░██║░░░██║░░██║╚█████╔╝██║░░░░░██║░░░██║░░░
	╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚═╝░░░╚═╝░░░
	2016 client simulator
	
	Developed by Beyond 5D#5878
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
	RetroWorkspace = true, -- [R] -- Uses old materials, disables terrain decoration, only allows brick colors and returns 2016 studs
	RetroCharacters = true, -- [B] -- Displays health bars above the heads of characters & returns old oof sound
	RetroChat = true, -- [R] -- If default chat is enabled it will convert it to the 2016 chat
	BCOnly = false -- [O] -- Makes all premium players appear as BC players instead of it being User ID linked
}

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetServicea("MaterialService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local Chat = game:GetService("Chat")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local NetworkClient = game:GetService("NetworkClient")
local GuiService = game:GetService("GuiService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local MaxInteger = 2147483647

local AssetFunction = getsynasset or getcustomasset

local function ImprovedKeyPress(keys)
	for _, key in pairs(keys) do
		keypress(key)
		keyrelease(key)
	end
end

local function GetAsset(asset)
	return AssetFunction("Retrofiy/" .. asset)
end

-- Could attempt to improve this guide!
local Contents = {
	["Retrofiy\\Assets\\Textures\\Backpack.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/Backpack.png",
	["Retrofiy\\Assets\\Textures\\Backpack_Down.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/Backpack_Down.png",
	["Retrofiy\\Assets\\Textures\\Chat.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/Chat.png",
	["Retrofiy\\Assets\\Textures\\ChatDown.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/ChatDown.png",
	["Retrofiy\\Assets\\Textures\\Hamburger.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/Hamburger.png",
	["Retrofiy\\Assets\\Textures\\HamburgerDown.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/HamburgerDown.png",
	["Retrofiy\\Assets\\Textures\\Studs.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/Studs.png",
	["Retrofiy\\Assets\\Textures\\icon_BC-16.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/icon_BC-16.png",
	["Retrofiy\\Assets\\Textures\\icon_TBC-16.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/icon_TBC-16.png",
	["Retrofiy\\Assets\\Textures\\icon_OBC-16.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/icon_OBC-16.png",
	["Retrofiy\\Assets\\Textures\\icon_DEV-16.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/icon_DEV-16.png",
	["Retrofiy\\Assets\\Textures\\icon_EDGY-16.png"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Textures/icon_EDGY-16.png",
	["Retrofiy\\Assets\\Sounds\\uuhhh.mp3"] = "https://raw.githubusercontent.com/BeyondThe5D/Retrofiy/main/Retrofiy/Assets/Sounds/uuhhh.mp3"
}

RunService:Set3dRenderingEnabled(false)

local Folders = {
	"Retrofiy\\Assets",
	"Retrofiy\\Assets\\Textures",
	"Retrofiy\\Assets\\Sounds",
	"Retrofiy\\Patches"
}

for _, folders in pairs(Folders) do
	if not isfolder(folders) then
		makefolder(folders)
	end
end

for folder, contents in pairs(Contents) do
	if not isfile(folder) then
		writefile(folder, game:HttpGet(contents))
	end
end

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
		["33"] = "icon_BC-16.png",
		["67"] = "icon_TBC-16.png",
		["0"] = "icon_OBC-16.png"
	}
	local SpecialPlayers = {
		[2601528367] = "icon_DEV-16.png",
		[3897409161] = "icon_DEV-16.png",
		[2408936922] = "icon_EDGY-16.png"
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
	local KickMessage = Instance.new("TextLabel")
	KickMessage.AnchorPoint = Vector2.new(0.5, 0)
	KickMessage.BackgroundColor3 = Color3.fromRGB(253, 68, 72)
	KickMessage.BorderSizePixel = 0
	KickMessage.Position = UDim2.new(0.5, 0, 0, 0)
	KickMessage.Size = UDim2.new(0.5, 0, 0, 80)
	KickMessage.Visible = false
	KickMessage.Font = Enum.Font.SourceSansBold
	KickMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
	KickMessage.TextSize = 14
	KickMessage.Parent = RetroGui

	local function CreateIcon(size, image)
		local Button = Instance.new("ImageButton")
		Button.BackgroundTransparency = 1
		Button.Size = UDim2.new(0, 50, 0, 36)
		Button.Parent = IconsFolder
		local Image = Instance.new("ImageLabel")
		Image.AnchorPoint = Vector2.new(0.5, 0.5)
		Image.BackgroundTransparency = 1
		Image.Position = UDim2.new(0.5, 0, 0.5, 0)
		Image.Size = size
		Image.Image = GetAsset("Assets/Textures/" .. image)
		Image.Parent = Button
		return Button
	end

	local function AttachHumanoidToHealthBar(humanoid)
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
		[true] = "ChatDown.png",
		[false] = "Chat.png"
	}
	local BackpackTextures = {
		[true] = "Backpack_Down.png",
		[false] = "Backpack.png"
	}

	local CoreChatBools = {
		["rbxasset://textures/ui/TopBar/chatOn.png"] = ChatTextures[true],
		["rbxasset://textures/ui/TopBar/chatOff.png"] = ChatTextures[false]
	}

	local SettingsButton = CreateIcon(UDim2.new(0, 32, 0, 25), "Hamburger.png", 0)
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

		if SpecialPlayer then
			Icon.Image = GetAsset("Assets/Textures/" .. SpecialPlayer)
		elseif player.MembershipType == Enum.MembershipType.Premium then
			if RetrofiyConfig.BCOnly then
				Icon.Image = GetAsset("Assets/Textures/" .. Memberships["33"])
			else
				Icon.Image = GetAsset("Assets/Textures/" .. Memberships[tostring(math.round((player.UserId / 3) * 100) * 0.01):split(".")[2] or "0"])
			end
		end
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
			ChatButton.ImageLabel.Image = GetAsset("Assets/Textures/" .. ChatTextures[Player.PlayerGui.Chat.Frame.Visible])
		end)
	end

	CoreGui.RobloxGui.Backpack.Inventory.Changed:Connect(function()
		BackpackButton.ImageLabel.Image = GetAsset("Assets/Textures/" .. BackpackTextures[CoreGui.RobloxGui.Backpack.Inventory.Visible])
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

	NetworkClient.ChildRemoved:Connect(function(object)
		if object:IsA("ClientReplicator") then
			GuiService:ClearError()

			local ErrorPrompt = CoreGui.RobloxPromptGui.promptOverlay:WaitForChild("ErrorPrompt")
			local KickPrompt = ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text

			if KickPrompt == "You were kicked from this experience: Player service requests player disconnect\n(Error Code: 267)" then
				KickMessage.Text = "This game has shut down"
			else
				KickMessage.Text = KickPrompt:split("You were kicked from this experience: ")[2]:split("\n(Error Code: ")[1]
			end

			KickMessage.Visible = true
		end
	end)

	RunService.RenderStepped:Connect(function()
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
				basepart.Parent:WaitForChild("Humanoid", 2)
			end
		end

		for face, surface in pairs(Surface) do
			if basepart:IsA("BasePart") and not basepart:IsA("UnionOperation") and basepart.Parent and not basepart:FindFirstChildOfClass("MeshPart") and not basepart:FindFirstChildOfClass("SpecialMesh") and not basepart.Parent:FindFirstChildOfClass("Humanoid") and basepart.Material == Enum.Material.Plastic and basepart[surface] == Enum.SurfaceType.Studs then
				local Studs = Instance.new("Texture")
				Studs.Color3 = basepart.Color -- omg lua
				Studs.Color3 = Color3.new(Studs.Color3.R * 2, Studs.Color3.G * 2, Studs.Color3.B * 2)
				Studs.Texture = GetAsset("Assets/Textures/Studs.png")
				Studs.Transparency = basepart.Transparency
				Studs.ZIndex = -2147483648
				Studs.Face = _Faces[face]
				Studs.Parent = basepart

				basepart:GetPropertyChangedSignal("Color"):Connect(function()
					Studs.Color3 = basepart.Color -- omg lua
					Studs.Color3 = Color3.new(Studs.Color3.R * 2, Studs.Color3.G * 2, Studs.Color3.B * 2)
				end)

				basepart:GetPropertyChangedSignal("Transparency"):Connect(function()
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
	MaterialService:GetPropertyChangedSignal("Use2022Materials"):Connect(function()
		MaterialService.Use2022Materials = false
	end)
end

if RetrofiyConfig.RetroCharacters then
	local Humanoids = {}

	local function ConvertCharacter(object)
		if object:IsA("Humanoid") then
			if object.HealthDisplayType == Enum.HumanoidHealthDisplayType.DisplayWhenDamaged then
				object.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
			end

			if workspace.CurrentCamera.CameraSubject ~= object and not table.find(Humanoids, object) then
				table.insert(Humanoids, object)
				object.AncestryChanged:Connect(function()
					if not object:IsDescendantOf(workspace) then
						table.remove(Humanoids, table.find(Humanoids, object))
					end
				end)
			end
		elseif object:IsA("Sound") and object.SoundId == "rbxasset://sounds/uuhhh.mp3" then
			object:GetPropertyChangedSignal("Playing"):Connect(function() -- improve maybe?
				object:Stop()
				local ClientAudio = Instance.new("Sound")
				ClientAudio.SoundId = GetAsset("Assets/Sounds/uuhhh.mp3")
				ClientAudio.Parent = object.Parent
				ClientAudio:Play()
			end)
		end
	end

	for _, objects in pairs(workspace:GetDescendants()) do
		ConvertCharacter(objects)
	end

	workspace.DescendantAdded:Connect(ConvertCharacter)

	local PreviousCameraSubject = workspace.CurrentCamera.CameraSubject

	workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
		if table.find(Humanoids, workspace.CurrentCamera.CameraSubject) then
			table.remove(Humanoids, table.find(Humanoids, workspace.CurrentCamera.CameraSubject))
		else
			ConvertCharacter(PreviousCameraSubject)
		end
		PreviousCameraSubject = workspace.CurrentCamera.CameraSubject
	end)

	spawn(function()
		while true do
			for _, humanoids in pairs(Humanoids) do -- Does not work if player has infinite health!
				humanoids.MaxHealth += 0.00001
				RunService.RenderStepped:Wait()
				humanoids.MaxHealth -= 0.00001
			end
			RunService.RenderStepped:Wait()
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
