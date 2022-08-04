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
	
	[R] - Recommended
	[B] - Buggy
	[L] - Low compatibility (May not work perfectly on all games)
--]]

local RetrofiyConfig = {
	RetroLighting = true, -- [R] -- Force disables lighting properties that weren't in 2016, uses compatibility Techology and deletes effects not seen in 2016
	RetroCoreGui = true, -- [R] -- Replaces the Core Gui with a 2016 Core Gui (Playerlist, topbar, etc)
	RetroWorkspace = true -- [R] -- Disables terrain decoration and uses old materials
}

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local Teams = game:GetService("Teams")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local MaxInteger = 2147483647

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
		RunService.RenderStepped:Wait()
		for _, restricted in pairs(RestrictedEffects) do
			if effect:IsA(restricted) then
				effect:Destroy()
			end
		end
	end

	sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)

	for property, value in pairs(RestrictedLighting) do
		Lighting[property] = value
	end

	for _, effects in pairs(Lighting:GetDescendants()) do
		RemoveEffect(effects)
	end

	Lighting.DescendantAdded:Connect(function(effect)
		RemoveEffect(effect)
	end)

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
	local SpecialPlayers = {
		[2601528367] = 10476529431,
		[3456503282] = 10476529431
	}
	
	CoreGui.ThemeProvider.Enabled = false
	
	local Topbar = Instance.new("Frame")
	Topbar.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Topbar.BackgroundTransparency = 0.5
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
	
	Humanoid.HealthChanged:Connect(function()
		HealthFill.Size = UDim2.new(Humanoid.Health / Humanoid.MaxHealth, 0, 1, 0)
	end)
	
	local TeamsOrderd = {}
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
			Instance.new("BoolValue", Button)
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
						teams:Destroy()
					end
				end
			end
		end)

		local SpecialPlayer = SpecialPlayers[player.UserId]

		if SpecialPlayer then
			--Icon.Image = "rbxassetid://" .. SpecialPlayer
		elseif player.MembershipType == Enum.MembershipType.Premium then
			--Icon.Image = "rbxassetid://" .. Memberships[tostring(math.round((player.UserId / 3) * 100) * 0.01):split(".")[2] or "0"]
		end
	end

	for _, teams in pairs(Teams:GetChildren()) do
		AddTeamToPlayerlist(teams.Name, teams.TeamColor.Color)
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
end

if RetrofiyConfig.RetroWorkspace then
	sethiddenproperty(workspace.Terrain, "Decoration", false)
	MaterialService.Use2022Materials = false
end

RunService:Set3dRenderingEnabled(true)
