local Net = require(game.ReplicatedStorage.Modules.Packages.Net)
local DataTemplate = require(game.ServerStorage.Modules.DataTemplate)
local ProfileService = require(game.ServerStorage.Modules.ProfileService)

local DataSystem = {
	Name = "DataSystem",
	Priority = "First",
	Tag = {
		"Player",
		"DataEntry"
	}
}

local ProfileStore = ProfileService.GetProfileStore("PlayerData", DataTemplate)

function DataSystem:CreateProfile(Player)
	if not Player then return end
	local Profile = ProfileStore:LoadProfileAsync("Player_"..Player.UserId)
	if Profile then
		return DataSystem:SetupProfile(Player, Profile)
	else
		warn("Data failed to load")
		local RunClient = self.Workshop:CreateEntity()
		RunClient:AddComponent("RunClient", {
			Call = "WarnData",
			Arguments = {
				Message = "Your data failed to load, please rejoin the game."
			},
			Target = Player
		})
		self.Workshop:SpawnEntity(RunClient)
	end
end

function DataSystem:SetupProfile(Player, Profile)
	Profile:AddUserId(Player.UserId)
	Profile:Reconcile()
	Profile:ListenToRelease(function()
		Player:Kick("Released")
	end)
	if Player:IsDescendantOf(game.Players) then
		DataSystem:ClientReplicateData(Player, Profile)
		return Profile
	end
end

function DataSystem:ReleaseProfile(Player)
	local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")
	if not UserEntity then
		return
	end

	local Profile = UserEntity:Get("Profile")

	if not Profile then return end

	Profile:Release()
end

function DataSystem:ClientReplicateData(Player, Profile)
	if not Profile then
		local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")
		Profile = UserEntity:Get("Profile")
	end

	Net:RemoteEvent("SetData"):FireClient(Player, Profile.Data)
end

function DataSystem:Update(TaggedEntities)
	for _, DataEntryEntity in pairs(TaggedEntities) do
		self.Workshop:RemoveEntity(DataEntryEntity.Name)
		self:ProcessDataEntry(DataEntryEntity)
	end
end

function DataSystem:ProcessDataEntry(DataEntryEntity)
	local Player = DataEntryEntity:Get("Player").Player
	local Profile = DataSystem:CreateProfile(Player)
	local Data = Profile.Data

	local UserEntity = self.Workshop:CreateEntity({
		EntityName = Player.Name .. "UserEntity"
	})
	:AddComponent("Player", {
		Player = Player
	})
	:AddComponent("Profile", Profile)
	:AddComponent("SaveData", {
		SaveData = Data,
	})

	self.Workshop:SpawnEntity(UserEntity)
end

function DataSystem:PlayerAdded(Player)
	if self.Workshop:GetEntity(Player.Name .. "DataEntryEntity") then return end
	local DataEntryEntity = self.Workshop:CreateEntity({
		EntityName = Player.Name .. "DataEntryEntity"
	})
	:AddComponent("Player", {
		Player = Player,
	})
	:AddComponent("DataEntry", true)
	self.Workshop:SpawnEntity(DataEntryEntity)
end

function DataSystem:PlayerRemoving(Player)
	DataSystem:ReleaseProfile(Player)

	local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")

	if UserEntity then
		self.Workshop:RemoveEntity(UserEntity.Name)
	end

	local DataEntryEntity = self.Workshop:GetEntity(Player.Name .. "DataEntryEntity")

	if DataEntryEntity then
		self.Workshop:RemoveEntity(DataEntryEntity.Name)
	end
end

function DataSystem:Boot()
	Net:RemoteEvent("SetData")
	Net:Handle("FetchData", function(Player)
		DataSystem.ClientReplicateData(Player)
	end)

	game.Players.PlayerAdded:Connect(function(Player)
		DataSystem:PlayerAdded(Player)
	end)

	game.Players.PlayerRemoving:Connect(function(Player)
		DataSystem:PlayerRemoving(Player)
	end)

	for _, Player in pairs(game.Players:GetPlayers()) do
		DataSystem:PlayerAdded(Player)
	end
end

return DataSystem