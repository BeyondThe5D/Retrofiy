--[[
	██████╗░███████╗████████╗██████╗░░█████╗░███████╗██╗██╗░░░██╗
	██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║╚██╗░██╔╝
	██████╔╝█████╗░░░░░██║░░░██████╔╝██║░░██║█████╗░░██║░╚████╔╝░
	██╔══██╗██╔══╝░░░░░██║░░░██╔══██╗██║░░██║██╔══╝░░██║░░╚██╔╝░░
	██║░░██║███████╗░░░██║░░░██║░░██║╚█████╔╝██║░░░░░██║░░░██║░░░
	╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚═╝░░░╚═╝░░░
	2016 client simulator
	
	Developed by Beyond 5D#5878
	https://discord.gg/4rYMxBMQvv
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
local NetworkClient = game:GetService("NetworkClient")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserService = game:GetService("UserService")

CoreGui:WaitForChild("RobloxLoadingGui").Enabled = false

local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.DisplayOrder = 2147483647 -- maybe lower lol
LoadingScreen.IgnoreGuiInset = true
LoadingScreen.Parent = CoreGui
local Background = Instance.new("ImageLabel")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Image = "rbxasset://textures/loading/darkLoadingTexture.png"
Background.ScaleType = Enum.ScaleType.Tile
Background.TileSize = UDim2.new(0, 512, 0, 552)
Background.Parent = LoadingScreen
local Information = Instance.new("Folder")
Information.Parent = Background
local GameInformation = Instance.new("Frame")
GameInformation.BackgroundTransparency = 1
GameInformation.Position = UDim2.new(0, 100, 1, -150)
GameInformation.Size = UDim2.new(0.4, 0, 0, 110)
GameInformation.Parent = Information
local CreatorName = Instance.new("TextLabel")
CreatorName.BackgroundTransparency = 1
CreatorName.Position = UDim2.new(0, 0, 0, 80)
CreatorName.Size = UDim2.new(1, 0, 0, 30)
CreatorName.Font = Enum.Font.SourceSans
CreatorName.Text = ""
CreatorName.TextColor3 = Color3.fromRGB(255, 255, 255)
CreatorName.TextScaled = true
CreatorName.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
CreatorName.TextStrokeTransparency = 0
CreatorName.TextXAlignment = Enum.TextXAlignment.Left
CreatorName.TextYAlignment = Enum.TextYAlignment.Top
CreatorName.Parent = GameInformation
local PlaceName = Instance.new("TextLabel")
PlaceName.BackgroundTransparency = 1
PlaceName.Position = UDim2.new(0, 0, 0, 0)
PlaceName.Size = UDim2.new(1, 0, 0, 80)
PlaceName.Font = Enum.Font.SourceSans
PlaceName.Text = ""
PlaceName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceName.TextScaled = true
PlaceName.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
PlaceName.TextStrokeTransparency = 0
PlaceName.TextXAlignment = Enum.TextXAlignment.Left
PlaceName.TextYAlignment = Enum.TextYAlignment.Bottom
PlaceName.Parent = GameInformation
local CloseButton = Instance.new("ImageButton")
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -37, 0, 5)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Image = "rbxasset://textures/loading/cancelButton.png"
CloseButton.Parent = Information
local Message = Instance.new("TextLabel")
Message.BackgroundTransparency = 1
Message.Position = UDim2.new(0.25, 0, 1, -120)
Message.Size = UDim2.new(0.5, 0, 0, 80)
Message.Visible = false
Message.Font = Enum.Font.SourceSansBold
Message.Text = "Requesting Server..."
Message.TextColor3 = Color3.fromRGB(255, 255, 255)
Message.TextSize = 18
Message.Parent = Information
local Loading = Instance.new("Frame")
Loading.BackgroundTransparency = 1
Loading.Position = UDim2.new(1, -225, 1, -165)
Loading.Size = UDim2.new(0, 120, 0, 120)
Loading.Parent = Information
local LoadingText = Instance.new("TextLabel")
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0, 28, 0, 0)
LoadingText.Size = UDim2.new(1, -56, 1, 0)
LoadingText.Font = Enum.Font.SourceSans
LoadingText.Text = "Loading..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 18
LoadingText.TextWrapped = true
LoadingText.TextXAlignment = Enum.TextXAlignment.Left
LoadingText.Parent = Loading
local LoadingImage = Instance.new("ImageLabel")
LoadingImage.BackgroundTransparency = 1
LoadingImage.Size = UDim2.new(1, 0, 1, 0)
LoadingImage.Image = "rbxasset://textures/loading/loadingCircle.png"
LoadingImage.Parent = Loading

-- This part of the code was just straight up taken from the 2016 client, it doesn't fully work though for some reason and will be optimised and fixed soon :)

local u1 = nil
local u2 = nil
local u3 = "..."

renderSteppedConnection = RunService.RenderStepped:connect(function()
	if not u1 then
		u1 = tick()
		u2 = u1
		return
	end

	local v28 = tick()
	u1 = v28

	LoadingImage.Rotation += (v28 - u1) * 180

	if 0.2 <= v28 - u2 then
		u2 = v28
		u3 = u3 .. "."
		if u3 == "...." then
			u3 = ""
		end
		LoadingText.Text = "Loading" .. u3
	end
end)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local GameInformation = {UserService:GetUserInfosByUserIdsAsync({game.CreatorId})[1].DisplayName, MarketplaceService:GetProductInfo(game.PlaceId).Name}

CreatorName.Text = "By " .. GameInformation[1]
PlaceName.Text = GameInformation[2]

if identifyexecutor():lower():find("krnl") then -- Temporary
	getgenv().sethiddenproperty = function(obj, prop, value)
		setscriptable(obj, prop, true)
		obj[prop] = value
	end
end

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local MaxInteger = 2147483647

local GetAsset = getsynasset or getcustomasset

local OriginalChat

local function ImprovedKeyPress(keys)
	for _, key in pairs(keys) do
		keypress(key)
		keyrelease(key)
	end
end

local function Connect(...)
	return table.concat({...}, "/")
end

local function DownloadFiles(directory)
	local _, Error = pcall(function()
		for _, item in pairs(HttpService:JSONDecode(game:HttpGet(Connect("https://api.github.com/repos/BeyondThe5D/Retrofiy/contents", directory)))) do
			local NewPath = Connect(directory, item["name"])

			if item["type"] == "dir" then
				makefolder(NewPath)
				DownloadFiles(NewPath)
			elseif item["type"] == "file" and not isfile(NewPath) then
				writefile(NewPath, game:HttpGet(item["download_url"]))
			end
		end
	end)

	if Error then
		local Response = Instance.new("BindableFunction")
		Response.OnInvoke = function(answer)
			if answer == "Yes" then
				setclipboard("https://archive.org/details/retrofiy_asset_archive")
			end
			Response:Destroy()
		end

		StarterGui:SetCore("SendNotification", {
			Title = "Retrofiy Error!",
			Text = "Retrofiy couldn't check if you have the most up-to-date assets installed, do you want a download link set to ur clipboard?",
			Duration = math.huge,
			Button1 = "Yes",
			Button2 = "No",
			Callback = Response
		})
	end
end

makefolder("Retrofiy")
makefolder("Retrofiy\\Patches")
DownloadFiles("Retrofiy")

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
	RetroGui.IgnoreGuiInset = true
	RetroGui.Parent = CoreGui

	local Memberships = {
		["33"] = "icon_BC-16.png",
		["67"] = "icon_TBC-16.png",
		["0"] = "icon_OBC-16.png"
	}
	local SpecialPlayers = {
		[2601528367] = "icon_DEV-16.png",
		[3897409161] = "icon_DEV-16.png",
		[2408936922] = "icon_DEV-16.png"
	}

	local CanTogglePlayerlist = true
	local ChosenPlayerlistVisibility = CanTogglePlayerlist

	CoreGui:WaitForChild("ThemeProvider").Enabled = false
	CoreGui.PlayerList.Enabled = false

	local Topbar = Instance.new("Frame")
	Topbar.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Topbar.BackgroundTransparency = Player.PlayerGui:GetTopbarTransparency()
	Topbar.BorderSizePixel = 0
	Topbar.Size = UDim2.new(1, 0, 0, 36)
	Topbar.Parent = RetroGui
	local PlayerlistContainer = Instance.new("ScrollingFrame")
	PlayerlistContainer.AnchorPoint = Vector2.new(1, 0)
	PlayerlistContainer.BackgroundTransparency = 1
	PlayerlistContainer.BorderSizePixel = 0
	PlayerlistContainer.Position = UDim2.new(1, 0, 0, 38)
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
	KickMessage.Position = UDim2.new(0.5, 0, 0, 36)
	KickMessage.Size = UDim2.new(0.5, 0, 0, 80)
	KickMessage.Visible = false
	KickMessage.Font = Enum.Font.SourceSansBold
	KickMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
	KickMessage.TextSize = 14
	KickMessage.Parent = RetroGui
	local FakeMouse = Drawing.new("Image")
	FakeMouse.Data = readfile("Retrofiy/Assets/Textures/ArrowFarCursor.png")
	FakeMouse.Size = Vector2.new(64, 64)
	FakeMouse.Visible = UserInputService.MouseIconEnabled
	
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
		Image.Image = GetAsset("Retrofiy/Assets/Textures/" .. image)
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
	
	local VirtualMouseIconEnabled = UserInputService.MouseIconEnabled
	
	UserInputService.MouseIconEnabled = false
	
	local oldnewindex
	oldnewindex = hookmetamethod(game, "__newindex", newcclosure(function(self, k, v)
		if self == UserInputService and k == "MouseIconEnabled" then
			VirtualMouseIconEnabled = v
			return
		end
		return oldnewindex(self, k, v)
	end))

	local oldindex
	oldindex = hookmetamethod(game, "__index", newcclosure(function(self, k)
		if self == UserInputService and k == "MouseIconEnabled" then
			return VirtualMouseIconEnabled
		end
		return oldindex(self, k)
	end))

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

		spawn(function()
			local SpecialPlayer = SpecialPlayers[player.UserId]

			if player.UserId == game.CreatorId then
				Icon.Image = GetAsset("Retrofiy/Assets/Textures/icon_placeowner.png")
			elseif SpecialPlayer then
				Icon.Image = GetAsset("Retrofiy/Assets/Textures/" .. SpecialPlayer)
			elseif player:IsInGroup(1200769) then
				Icon.Image = GetAsset("Retrofiy/Assets/Textures/icon_admin-16.png")
			elseif player.MembershipType == Enum.MembershipType.Premium then
				if RetrofiyConfig.BCOnly then
					Icon.Image = GetAsset("Retrofiy/Assets/Textures/" .. Memberships["33"])
				else
					Icon.Image = GetAsset("Retrofiy/Assets/Textures/" .. Memberships[tostring(math.round((player.UserId / 3) * 100) * 0.01):split(".")[2] or "0"])
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
			ChatButton.ImageLabel.Image = GetAsset("Retrofiy/Assets/Textures/" .. ChatTextures[Player.PlayerGui.Chat.Frame.Visible])
		end)
	end

	CoreGui.RobloxGui.Backpack.Inventory.Changed:Connect(function()
		BackpackButton.ImageLabel.Image = GetAsset("Retrofiy/Assets/Textures/" .. BackpackTextures[CoreGui.RobloxGui.Backpack.Inventory.Visible])
	end)

	local function ConvertScrollingFrame(scrollingframe) -- Maybe change the thickness of the scrollbar to?
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

	local MessageReplacement = {
		["You have been kicked from the game"] = "You have lost the connection to the game",
		["Player service requests player disconnect"] = "This game has shut down"
	}

	local function DestroyGui(gui)
		if gui ~= OriginalChat then
			gui:Destroy()
		end
	end

	local RemovedGuis = false

	GuiService.ErrorMessageChanged:Connect(function(message)
		if not RemovedGuis then
			RemovedGuis = true

			for _, guis in pairs(Player.PlayerGui:GetChildren()) do
				DestroyGui(guis)
			end

			Player.PlayerGui.ChildAdded:Connect(function(gui)
				DestroyGui(gui)
			end)
		end

		GuiService:ClearError()

		KickMessage.Text = MessageReplacement[message] or message
		KickMessage.Visible = true
	end)

	local HealthBarNamePosition = {
		[true] = UDim2.new(0, 7, 0, 0),
		[false] = UDim2.new(0, 7, 0, 3)
	}

	RunService.RenderStepped:Connect(function()
		local PlayerlistVisibility = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
		local HealthVisibility = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)

		if not PlayerlistVisibility then
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
		HealthBar.Visible = HealthVisibility
		Username.Visible = HealthVisibility or PlayerlistVisibility
		Username.Position = HealthBarNamePosition[HealthVisibility]
		FakeMouse.Position = Vector2.new(Mouse.X, Mouse.Y)
		FakeMouse.Visible = UserInputService.MouseIconEnabled
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
				Studs.Texture = GetAsset("Retrofiy/Assets/Textures/Studs.png")
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

	local WomanLegs = {
		[746826007] = 81628361,
		[746825633] = 81628308
	}

	local function ConvertCharacter(object)
		if object:IsA("Humanoid") then
			if object.HealthDisplayType == Enum.HumanoidHealthDisplayType.DisplayWhenDamaged then
				object.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
			end

			if workspace.CurrentCamera.CameraSubject ~= object and not table.find(Humanoids, object) then
				table.insert(Humanoids, object)
			end
		elseif object:IsA("Sound") and object.SoundId == "rbxasset://sounds/uuhhh.mp3" then
			object.SoundId = GetAsset("Retrofiy/Assets/Sounds/uuhhh.mp3")
		elseif object:IsA("CharacterMesh") then 
			local MeshId = WomanLegs[object.MeshId]

			if MeshId then
				object.MeshId = MeshId
			end
		end
	end

	for _, objects in pairs(workspace:GetDescendants()) do
		ConvertCharacter(objects)
	end

	workspace.DescendantAdded:Connect(ConvertCharacter)

	workspace.DescendantRemoving:Connect(function(object)
		if table.find(Humanoids, object) then
			table.remove(Humanoids, table.find(Humanoids, object))
		end
	end)

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
				humanoids.MaxHealth += 0.1
				RunService.RenderStepped:Wait()
				humanoids.MaxHealth -= 0.1
			end
			RunService.RenderStepped:Wait()
		end
	end)
end

if RetrofiyConfig.RetroChat then
	if Chat.LoadDefaultChat and Player.PlayerGui:FindFirstChild("Chat") then
		OriginalChat = Player.PlayerGui.Chat

		local ChatFrame = OriginalChat.Frame
		ChatFrame.ChatBarParentFrame.Position = UDim2.new(0, 0, 1, -23)
		ChatFrame.ChatBarParentFrame.Size = UDim2.new(1, 0, 0, 32)
		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Position = UDim2.new(0, 7, 0, 5)
		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Size = UDim2.new(1, -14, 1, -10)
		ChatFrame.ChatBarParentFrame.Frame.BoxFrame.Frame.Position = UDim2.new(0, 7, 0, 2)
		local Scroller = ChatFrame.ChatChannelParentFrame["Frame_MessageLogDisplay"].Scroller
		Scroller.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

		ChatFrame.ChatChannelParentFrame.Size = UDim2.new(1, 0, 1, -27)

		for _, messages in pairs(Scroller:GetChildren()) do
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

		Scroller.ChildAdded:Connect(function(object)
			RunService.RenderStepped:Wait()

			if object:FindFirstChildOfClass("TextLabel") then
				local Message = object:FindFirstChildOfClass("TextLabel")

				if not Message:FindFirstChildOfClass("TextButton") then
					if Message.Text:find("Your friend ") then
						object:Destroy()
					end
				end
			end
		end)

		local function UpdateBarThickness()
			if Scroller.ScrollBarThickness == 4 then
				Scroller.ScrollBarThickness = 7
			end
		end

		UpdateBarThickness()

		Scroller:GetPropertyChangedSignal("ScrollBarThickness"):Connect(function(value)
			UpdateBarThickness()
		end)
	end
end

local Patch = "Retrofiy\\Patches\\" .. game.PlaceId .. ".lua"

if isfile(Patch) then
	loadstring(readfile(Patch))()
end

LoadingScreen:Destroy()
