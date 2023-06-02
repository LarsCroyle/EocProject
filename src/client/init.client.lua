local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedSystems = ReplicatedStorage.Modules.Systems

local Recs = require(game:GetService("ReplicatedStorage").Modules.Recs.Core)
local RunService = game:GetService("RunService")

for _, System in ReplicatedSystems:GetChildren() do
	local SystemPassIn = require(System)
	Recs.Workshop:CreateSystem(SystemPassIn)
end

--for _, System in Recs.Workshop:GetSystems() do
--	System:Boot()
--end

RunService.RenderStepped:Connect(function(DeltaTime)
	Recs.Workshop:Update(DeltaTime)
end)