local Ragdoll = {}
Ragdoll.__index = Ragdoll

local Rigging = require(script:WaitForChild("Rigging"))

function Ragdoll.new(Character)
	local self = setmetatable({}, Ragdoll)

	self.Character = Character
	self.Humanoid = Character:WaitForChild("Humanoid")

	self.Active = {}

	self.Rigging = require(script.Rigging)

	return self
end

function Ragdoll:GetRigData(Parts, IsActive)
	local RagdollRig = nil
	local MotorRig = nil

	if self.Humanoid.RigType == Enum.HumanoidRigType.R6 then
		RagdollRig = Rigging.Constants.R6_RAGDOLL_RIG
		MotorRig = Rigging.Constants.R6_MOTOR6DS
	elseif self.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		RagdollRig = Rigging.Constants.R15_RAGDOLL_RIG
		MotorRig = Rigging.Constants.R15_MOTOR6DS
	end

	local RigData = {}
	local MotorData = {}

	if Parts then
		for i,v in pairs(RagdollRig) do
			if table.find(Parts, i) and (self.Active[i] ~= nil) == IsActive then
				RigData[i] = v
			end
		end
		for i,v in pairs(MotorRig) do
			if table.find(Parts, i) and (self.Active[i] ~= nil) == IsActive then
				MotorData[i] = v
			end
		end
	else
		for i,v in pairs(RagdollRig) do
			if (self.Active[i] ~= nil) == IsActive then
				RigData[i] = v
			end
		end
		for i,v in pairs(MotorRig) do
			if (self.Active[i] ~= nil) == IsActive then
				MotorData[i] = v
			end
		end
	end

	return RigData, MotorData
end

function Ragdoll:Enable(Parts)
	local RigData, MotorData = self:GetRigData(Parts, false)
	Rigging.disableMotors(self.Character, self.Humanoid.RigType, MotorData)

	for i,v in pairs(Rigging.createRagdollJoints(self.Character, self.Humanoid.RigType, RigData)) do
		self.Active[i] = v
	end
end

function Ragdoll:Disable(Parts)
	local RigData, MotorData = self:GetRigData(Parts, true)
	Rigging.enableMotors(self.Character, self.Humanoid.RigType, MotorData)
	for i,v in pairs(Rigging.removeRagdollJoints(self.Character, RigData)) do
		self.Active[i] = nil
	end
end

function Ragdoll:Destroy()
	self:Disable()
	setmetatable(self, nil)
end

return Ragdoll