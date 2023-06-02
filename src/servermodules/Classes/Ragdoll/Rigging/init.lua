local RunService = game:GetService("RunService")

local Constants = require(script:WaitForChild("Constants"))

local Rigging = {}
Rigging.Constants = Constants

local FFlagOnlyRemoveMotorsForRiggedRagdolls = false

local REFERENCE_GRAVITY = Constants.REFERENCE_GRAVITY

local DEFAULT_MAX_FRICTION_TORQUE = Constants.DEFAULT_MAX_FRICTION_TORQUE

local HEAD_LIMITS = Constants.HEAD_LIMITS
local WAIST_LIMITS = Constants.WAIST_LIMITS
local ANKLE_LIMITS = Constants.ANKLE_LIMITS
local ELBOW_LIMITS = Constants.ELBOW_LIMITS
local WRIST_LIMITS = Constants.WRIST_LIMITS
local KNEE_LIMITS = Constants.KNEE_LIMITS
local SHOULDER_LIMITS = Constants.SHOULDER_LIMITS
local HIP_LIMITS = Constants.HIP_LIMITS

local R6_HEAD_LIMITS = Constants.R6_HEAD_LIMITS
local R6_SHOULDER_LIMITS = Constants.R6_SHOULDER_LIMITS
local R6_HIP_LIMITS = Constants.R6_HIP_LIMITS

local V3_ZERO = Constants.V3_ZERO
local V3_UP = Constants.V3_UP
local V3_DOWN = Constants.V3_DOWN
local V3_RIGHT = Constants.V3_RIGHT
local V3_LEFT = Constants.V3_LEFT

local R15_ADDITIONAL_ATTACHMENTS = Constants.R15_ADDITIONAL_ATTACHMENTS
local R15_RAGDOLL_RIG = Constants.R15_RAGDOLL_RIG
local R15_NO_COLLIDES = Constants.R15_NO_COLLIDES
local R15_MOTOR6DS = Constants.R15_MOTOR6DS

local R6_ADDITIONAL_ATTACHMENTS = Constants.R6_ADDITIONAL_ATTACHMENTS
local R6_RAGDOLL_RIG = Constants.R6_RAGDOLL_RIG
local R6_NO_COLLIDES = Constants.R6_NO_COLLIDES
local R6_MOTOR6DS = Constants.R6_MOTOR6DS

local BALL_SOCKET_NAME = Constants.BALL_SOCKET_NAME
local NO_COLLIDE_NAME = Constants.NO_COLLIDE_NAME

-- Index parts by name to save us from many O(n) FindFirstChild searches
local function indexParts(model)
	local parts = {}
	for _, child in ipairs(model:GetChildren()) do
		if child:IsA("BasePart") then
			local name = child.name
			-- Index first, mimicing FindFirstChild
			if not parts[name] then
				parts[name] = child
			end
		end
	end
	return parts
end

local function getDescendants(model, maxDepth)
	local instances = {}
	local depth = 0
	local maxDepth = maxDepth or 0
	
	local function get(object)
		for i,v in pairs(object:GetChildren()) do
			table.insert(instances, v)
			if v:IsA("Model") and depth < maxDepth then
				get(v)
				depth = depth + 1
			elseif not v:IsA("Model") then
				get(v)
			end
		end
	end
	
	get(model)
	
	return instances
end

local function createRigJoints(parts, rig)
	local joints = {}
	for index, params in pairs(rig) do
		local part0Name, part1Name, attachmentName, limits = unpack(params)
		local part0 = parts[part0Name]
		local part1 = parts[part1Name]
		if part0 and part1 then
			local a0 = part0:FindFirstChild(attachmentName)
			local a1 = part1:FindFirstChild(attachmentName)
			if a0 and a1 and a0:IsA("Attachment") and a1:IsA("Attachment") then
				-- Our rigs only have one joint per part (connecting each part to it's parent part), so
				-- we can re-use it if we have to re-rig that part again.
				local constraint = part1:FindFirstChild(BALL_SOCKET_NAME)
				if not constraint then
					constraint = Instance.new("BallSocketConstraint")
					constraint.Name = BALL_SOCKET_NAME
					constraint:SetAttribute("Joint", index)
				end
				constraint.Attachment0 = a0
				constraint.Attachment1 = a1
				constraint.LimitsEnabled = true
				constraint.UpperAngle = limits.UpperAngle
				constraint.TwistLimitsEnabled = true
				constraint.TwistLowerAngle = limits.TwistLowerAngle
				constraint.TwistUpperAngle = limits.TwistUpperAngle
				-- Scale constant torque limit for joint friction relative to gravity and the mass of
				-- the body part.
				local gravityScale = workspace.Gravity / REFERENCE_GRAVITY
				local referenceMass = limits.ReferenceMass
				local massScale = referenceMass and (part1:GetMass() / referenceMass) or 1
				local maxTorque = limits.FrictionTorque or DEFAULT_MAX_FRICTION_TORQUE
				constraint.MaxFrictionTorque = maxTorque * massScale * gravityScale
				constraint.Parent = part1
				
				joints[index] = constraint
			end
		end
	end
	return joints
end

local function createAdditionalAttachments(parts, attachments)
	for _, attachmentParams in ipairs(attachments) do
		local partName, attachmentName, cframe, baseAttachmentName = unpack(attachmentParams)
		local part = parts[partName]
		if part then
			local attachment = part:FindFirstChild(attachmentName)
			-- Create or update existing attachment
			if not attachment or attachment:IsA("Attachment") then
				if baseAttachmentName then
					local base = part:FindFirstChild(baseAttachmentName)
					if base and base:IsA("Attachment") then
						cframe = base.CFrame * cframe
					end
				end
				-- The attachment names are unique within a part, so we can re-use
				if not attachment then
					attachment = Instance.new("Attachment")
					attachment.Name = attachmentName
					attachment.CFrame = cframe
					attachment.Parent = part
				else
					attachment.CFrame = cframe
				end
			end
		end
	end
end

local function createNoCollides(parts, noCollides)
	-- This one's trickier to handle for an already rigged character since a part will have multiple
	-- NoCollide children with the same name. Having fewer unique names is better for
	-- replication so we suck it up and deal with the complexity here.

	-- { [Part1] = { [Part0] = true, ... }, ...}
	local needed = {}
	-- Following the convention of the Motor6Ds and everything else here we parent the NoCollide to
	-- Part1, so we start by building the set of Part0s we need a NoCollide with for each Part1
	for _, namePair in ipairs(noCollides) do
		local part0Name, part1Name = unpack(namePair)
		local p0, p1 = parts[part0Name], parts[part1Name]
		if p0 and p1 then
			local p0Set = needed[p1]
			if not p0Set then
				p0Set = {}
				needed[p1] = p0Set
			end
			p0Set[p0] = true
		end
	end

	-- Go through NoCollides that exist and remove Part0s from the needed set if we already have
	-- them covered. Gather NoCollides that aren't between parts in the set for resue
	local reusableNoCollides = {}
	for part1, neededPart0s in pairs(needed) do
		local reusables = {}
		for _, child in ipairs(part1:GetChildren()) do
			if child:IsA("NoCollisionConstraint") and child.Name == NO_COLLIDE_NAME then
				local p0 = child.Part0
				local p1 = child.Part1
				if p1 == part1 and neededPart0s[p0] then
					-- If this matches one that we needed, we don't need to create it anymore.
					neededPart0s[p0] = nil
				else
					-- Otherwise we're free to reuse this NoCollide
					table.insert(reusables, child)
				end
			end
		end
		reusableNoCollides[part1] = reusables
	end

	-- Create the remaining NoCollides needed, re-using old ones if possible
	for part1, neededPart0s in pairs(needed) do
		local reusables = reusableNoCollides[part1]
		for part0, _ in pairs(neededPart0s) do
			local constraint = table.remove(reusables)
			if not constraint then
				constraint = Instance.new("NoCollisionConstraint")
			end
			constraint.Name = NO_COLLIDE_NAME
			constraint.Part0 = part0
			constraint.Part1 = part1
			constraint.Parent = part1
		end
	end
end

local function isAttachmentInPart(attachment, part)
	return attachment and attachment.Parent == part or false
end

local function checkValidAttachment(part0, part1, attachment0, attachment1)
	if isAttachmentInPart(attachment0, part0) and isAttachmentInPart(attachment1, part1) then
		return true
	end

	if isAttachmentInPart(attachment0, part1) and isAttachmentInPart(attachment1, part0) then
		return true
	end

	return false
end

local function hasValidConstraint(part0, part1)
	for _, child in ipairs(part1:GetChildren()) do
		if child:IsA("BallSocketConstraint") then
			local attachment0 = child.Attachment0
			local attachment1 = child.Attachment1

			if checkValidAttachment(part0, part1, attachment0, attachment1) then
				return true
			end
		end
	end

	return false
end

local function hasRagdollJoint(motor)
	if not FFlagOnlyRemoveMotorsForRiggedRagdolls then
		return true
	end

	local part0 = motor.Part0
	local part1 = motor.Part1

	if hasValidConstraint(part0, part1) then
		return true
	end

	-- Don't enforce ordering for developer created ragdolls
	if hasValidConstraint(part1, part0) then
		return true
	end

	return false
end

local function disableMotorSet(model, motorSet)
	local motors = {}
	-- Destroy all regular joints:
	for _, params in pairs(motorSet) do
		if params[1] and params[2] then
			local part = model:FindFirstChild(params[2])
			if part then
				local motor = part:FindFirstChild(params[1])
				if motor and motor:IsA("Motor6D") and hasRagdollJoint(motor) then
					table.insert(motors, motor)
					motor.Enabled = false
				end
			end
		end
	end
	return motors
end

local function enableMotorSet(model, motorSet)
	local motors = {}
	-- Destroy all regular joints:
	for _, params in pairs(motorSet) do
		if params[1] and params[2] then
			local part = model:FindFirstChild(params[2])
			if part then
				local motor = part:FindFirstChild(params[1])
				if motor and motor:IsA("Motor6D") and hasRagdollJoint(motor) then
					table.insert(motors, motor)
					motor.Enabled = true
				end
			end
		end
	end
	return motors
end

function Rigging.createRagdollJoints(model, rigType, rigData, collisionData)
	local parts = indexParts(model)
	if rigType == Enum.HumanoidRigType.R6 then
		createAdditionalAttachments(parts, R6_ADDITIONAL_ATTACHMENTS)
		local Joints = createRigJoints(parts, rigData or R6_RAGDOLL_RIG)
		createNoCollides(parts, collisionData or R6_NO_COLLIDES)
		return Joints
	elseif rigType == Enum.HumanoidRigType.R15 then
		createAdditionalAttachments(parts, R15_ADDITIONAL_ATTACHMENTS)
		local Joints = createRigJoints(parts, rigData or R15_RAGDOLL_RIG)
		createNoCollides(parts, collisionData or R15_NO_COLLIDES)
		return Joints
	else
		error("unknown rig type", 2)
	end
end

function Rigging.removeRagdollJoints(model, whitelist)
	local Joints = {}
	for _, descendant in pairs(getDescendants(model)) do
		-- Remove BallSockets and NoCollides, leave the additional Attachments
		if (descendant:IsA("BallSocketConstraint") and descendant.Name == BALL_SOCKET_NAME)
			or (descendant:IsA("NoCollisionConstraint") and descendant.Name == NO_COLLIDE_NAME)
		then
			local joint = descendant:GetAttribute("Joint")
			if (whitelist == nil) or (joint and typeof(whitelist) == "table" and whitelist[joint]) then
				if joint then
					Joints[joint] = true
				end
				descendant:Destroy()
			end
		end
	end
	return Joints
end

function Rigging.disableMotors(model, rigType, motorData)
	-- Note: We intentionally do not disable the root joint so that the mechanism root of the
	-- character stays consistent when we break joints on the client. This avoid the need for the client to wait
	-- for re-assignment of network ownership of a new mechanism, which creates a visible hitch.

	local motors
	if rigType == Enum.HumanoidRigType.R6 then
		if not motorData then
			motorData = R6_MOTOR6DS
		end
		motors = disableMotorSet(model, motorData)
	elseif rigType == Enum.HumanoidRigType.R15 then
		if not motorData then
			motorData = R15_MOTOR6DS
		end
		motors = disableMotorSet(model, motorData)
	else
		error("unknown rig type", 2)
	end

	-- Set the root part to non-collide
	if motorData.RootPart then
		local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
		if rootPart and rootPart:IsA("BasePart") then
			rootPart.CanCollide = false
		end
	end

	return motors
end

function Rigging.enableMotors(model, rigType, motorData)
	-- Note: We intentionally do not disable the root joint so that the mechanism root of the
	-- character stays consistent when we break joints on the client. This avoid the need for the client to wait
	-- for re-assignment of network ownership of a new mechanism, which creates a visible hitch.

	local motors
	if rigType == Enum.HumanoidRigType.R6 then
		motors = enableMotorSet(model, motorData or R6_MOTOR6DS)
	elseif rigType == Enum.HumanoidRigType.R15 then
		motors = enableMotorSet(model, motorData or R15_MOTOR6DS)
	else
		error("unknown rig type", 2)
	end

	-- Set the root part to non-collide
	if motorData.RootPart then
		local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
		if rootPart and rootPart:IsA("BasePart") then
			rootPart.CanCollide = true
		end
	end
	
	return motors
end

function Rigging.disableParticleEmittersAndFadeOut(character, duration)
	if RunService:IsServer() then
		-- This causes a lot of unnecesarry replicated property changes
		error("disableParticleEmittersAndFadeOut should not be called on the server.", 2)
	end

	local descendants = getDescendants(character) --character:GetDescendants()
	local transparencies = {}
	for _, instance in pairs(descendants) do
		if instance:IsA("BasePart") or instance:IsA("Decal") then
			transparencies[instance] = instance.Transparency
		elseif instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		end
	end
	local t = 0
	while t < duration do
		-- Using heartbeat because we want to update just before rendering next frame, and not
		-- block the render thread kicking off (as RenderStepped does)
		local dt = RunService.Heartbeat:Wait()
		t = t + dt
		local alpha = math.min(t / duration, 1)
		for part, initialTransparency in pairs(transparencies) do
			part.Transparency = (1 - alpha) * initialTransparency + alpha
		end
	end
end

function Rigging.easeJointFriction(character, duration)
	local descendants = getDescendants(character)
	-- { { joint, initial friction, end friction }, ... }
	local frictionJoints = {}
	for _, v in pairs(descendants) do
		if v:IsA("BallSocketConstraint") and v.Name == BALL_SOCKET_NAME then
			local current = v.MaxFrictionTorque
			-- Keep the torso and neck a little stiffer...
			local parentName = v.Parent.Name
			local scale = (parentName == "UpperTorso" or parentName == "Head") and 0.5 or 0.05
			local nextTorque = current * scale
			frictionJoints[v] = { v, current, nextTorque }
		end
	end
	local t = 0
	while t < duration do
		-- Using stepped because we want to update just before physics sim
		local _, dt = RunService.Stepped:Wait()
		t = t + dt
		local alpha = math.min(t / duration, 1)
		for _, tuple in pairs(frictionJoints) do
			local ballSocket, a, b = unpack(tuple)
			ballSocket.MaxFrictionTorque = (1 - alpha) * a + alpha * b
		end
	end
end

return Rigging
