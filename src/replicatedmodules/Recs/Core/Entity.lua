local Entity = {}
Entity.__index = Entity

function Entity.new(EntityName)
	local self = setmetatable({}, Entity)

	self.Name = EntityName
	self.Components = {}

	return self
end

function Entity:AddComponent(ComponentName, ComponentData)
	self.Components[ComponentName] = ComponentData
	return self, {
		Destroy = function()
			self:RemoveComponent(ComponentName)
		end
	}
end

function Entity:GetComponents()
	return self.Components
end

function Entity:GetComponentsList()
	local List = {}
	for ComponentName in self.Components do
		table.insert(List, ComponentName)
	end
	return List
end

function Entity:Get(ComponentName)
	return self.Components[ComponentName]
end

function Entity:RemoveComponent(ComponentName)
	self.Components[ComponentName] = nil
end

function Entity:SetComponent(ComponentName, ComponentData)
	self.Components[ComponentName] = ComponentData
end

function Entity:Set(ComponentName, ComponentIndex, ComponentData)
	if not self.Components[ComponentName] then
		self.Components[ComponentName] = {}
	end
	self.Components[ComponentName][ComponentIndex] = ComponentData
end

function Entity:Destroy()
	setmetatable(self, nil)
	table.clear(self.Components)
	table.clear(self)
	self = nil
end

return Entity