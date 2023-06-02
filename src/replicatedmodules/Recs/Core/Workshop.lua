local Workshop = {}
Workshop.__index = Workshop

local RunPriorities = require(script.Parent.Parent.RunPriorities)
local Signal = require(game.ReplicatedStorage.Modules.Packages.Signal)

function Workshop.new(Recs)
	local self = setmetatable({}, Workshop)

	self.Recs = Recs
	self.Entities = {}
	self.Systems = {}
	self.EntityCount = 0
	self.KnownComponents = {}
	self.EntityAdded = Signal.new()
	self.EntityRemoved = Signal.new()

	return self
end

function Workshop:GetEntities()
	return self.Entities
end

function Workshop:GetSystems()
	return self.Systems
end

function Workshop:CreateEntity(EntityData)
	if not EntityData then
		EntityData = {}
	end
	self.EntityCount += 1
	local EntityName = EntityData.EntityName
	local AutoSpawn = EntityData.AutoSpawn
	if not EntityName then
		EntityName = "Entity" .. self.EntityCount
	end

	local Entity = self.Recs.Entity.new(EntityName, Workshop)
	if AutoSpawn then
		self:SpawnEntity(Entity)
	end

	return Entity
end

function Workshop:GetEntity(EntityName)
	return self.Entities[EntityName]
end

function Workshop:SpawnEntity(EntityObject)
	local ExistingEntity = self.Entities[EntityObject.Name]
	if ExistingEntity then
		EntityObject.Name = EntityObject.Name .. self.EntityCount
	end

	self.EntityAdded:Fire(EntityObject)
	self.Entities[EntityObject.Name] = EntityObject
	self:OnEntityAddedSystemQuery(EntityObject)
end

function Workshop:OnEntityAddedSystemQuery(Entity)
	for _, System in pairs(self.Systems) do
		if System.Tag then
			local PassedEqualityTest = self.Recs.EntityMatchesTagMethod(Entity, System.Tag)
			if PassedEqualityTest and System.EntityAdded then
				System:EntityAdded(Entity)
			end
		end
	end
end

function Workshop:RemoveEntity(EntityName)
	--local Entity = self.Entities[EntityName]
	if typeof(EntityName) == "table" then
		EntityName = EntityName.Name
	end
	self.Entities[EntityName] = nil
	self.EntityRemoved:Fire(EntityName)

	--Entity:Destroy()
end

function Workshop:SortSystems()
	table.sort(self.Systems, function(A, B)
		return A.Priority < B.Priority
	end)
end

function Workshop:HandleSystemPriority(System)
	if System.Priority then
		if typeof(System.Priority) == "string" then
			System.Priority = RunPriorities[System.Priority]
		end
	else
		System.Priority = RunPriorities.First
	end
end

function Workshop:CreateSystem(SystemPassIn)
	local System = self.Recs.System.new(SystemPassIn)
	self:HandleSystemPriority(System)

	System.Workshop = self

	self.Systems[System.Name] = System
	self:SortSystems()

	if System.Boot then
		task.spawn(System.Boot, System)
	end

	return System
end

function Workshop:Update(DeltaTime)
	self.Recs.SystemsInvokeMethod(
		self,
		self.Systems,
		self.Recs.TagQueryMethod,
		DeltaTime
	)
end

return Workshop