local ServerStorage = game:GetService("ServerStorage")
local ServerSystems = ServerStorage.Modules.Systems

local Recs = require(game:GetService("ReplicatedStorage").Modules.Recs.Core)
local RunService = game:GetService("RunService")

for _, System in ServerSystems:GetDescendants() do
	if not System:IsA("ModuleScript") then
		continue
	end
	local SystemPassIn = require(System)
	Recs.Workshop:CreateSystem(SystemPassIn)
end

--for _, System in Recs.Workshop:GetSystems() do
--	System:Boot()
--end

RunService.Heartbeat:Connect(function(DeltaTime)
	Recs.Workshop:Update(DeltaTime)
end)