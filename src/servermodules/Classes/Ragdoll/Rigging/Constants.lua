local Constants = {}

-- Gravity that joint friction values were tuned under.
Constants.REFERENCE_GRAVITY = 196.2

-- ReferenceMass values from mass of child part. Used to normalized "stiffness" for differently
-- sized avatars (with different mass).
Constants.DEFAULT_MAX_FRICTION_TORQUE = 125

Constants.HEAD_LIMITS = {
	UpperAngle = 45,
	TwistLowerAngle = -40,
	TwistUpperAngle = 40,
	FrictionTorque = 400,
	ReferenceMass = 1.0249234437943,
}

Constants.WAIST_LIMITS = {
	UpperAngle = 20,
	TwistLowerAngle = -40,
	TwistUpperAngle = 20,
	FrictionTorque = 750,
	ReferenceMass = 2.861558675766,
}

Constants.ANKLE_LIMITS = {
	UpperAngle = 10,
	TwistLowerAngle = -10,
	TwistUpperAngle = 10,
	ReferenceMass = 0.43671694397926,
}

Constants.ELBOW_LIMITS = {
	-- Elbow is basically a hinge, but allow some twist for Supination and Pronation
	UpperAngle = 20,
	TwistLowerAngle = 5,
	TwistUpperAngle = 120,
	ReferenceMass = 0.70196455717087,
}

Constants.WRIST_LIMITS = {
	UpperAngle = 30,
	TwistLowerAngle = -10,
	TwistUpperAngle = 10,
	ReferenceMass = 0.69132566452026,
}

Constants.KNEE_LIMITS = {
	UpperAngle = 5,
	TwistLowerAngle = -120,
	TwistUpperAngle = -5,
	ReferenceMass = 0.65389388799667,
}

Constants.SHOULDER_LIMITS = {
	UpperAngle = 110,
	TwistLowerAngle = -85,
	TwistUpperAngle = 85,
	FrictionTorque = 600,
	ReferenceMass = 0.90918225049973,
}

Constants.HIP_LIMITS = {
	UpperAngle = 40,
	TwistLowerAngle = -5,
	TwistUpperAngle = 80,
	FrictionTorque = 600,
	ReferenceMass = 1.9175016880035,
}

Constants.R6_HEAD_LIMITS = {
	UpperAngle = 30,
	TwistLowerAngle = -40,
	TwistUpperAngle = 40,
}

Constants.R6_SHOULDER_LIMITS = {
	UpperAngle = 110,
	TwistLowerAngle = -85,
	TwistUpperAngle = 85,
}

Constants.R6_HIP_LIMITS = {
	UpperAngle = 40,
	TwistLowerAngle = -5,
	TwistUpperAngle = 80,
}

Constants.V3_ZERO = Vector3.new()
Constants.V3_UP = Vector3.new(0, 1, 0)
Constants.V3_DOWN = Vector3.new(0, -1, 0)
Constants.V3_RIGHT = Vector3.new(1, 0, 0)
Constants.V3_LEFT = Vector3.new(-1, 0, 0)

-- To model shoulder cone and twist limits correctly we really need the primary axis of the UpperArm
-- to be going down the limb. the waist and neck joints attachments actually have the same problem
-- of non-ideal axis orientation, but it's not as noticable there since the limits for natural
-- motion are tighter for those joints anyway.
Constants.R15_ADDITIONAL_ATTACHMENTS = {
	{"UpperTorso", "RightShoulderRagdollAttachment", CFrame.fromMatrix(Constants.V3_ZERO, Constants.V3_RIGHT, Constants.V3_UP), "RightShoulderRigAttachment"},
	{"RightUpperArm", "RightShoulderRagdollAttachment", CFrame.fromMatrix(Constants.V3_ZERO, Constants.V3_DOWN, Constants.V3_RIGHT), "RightShoulderRigAttachment"},
	{"UpperTorso", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(Constants.V3_ZERO, Constants.V3_LEFT, Constants.V3_UP), "LeftShoulderRigAttachment"},
	{"LeftUpperArm", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(Constants.V3_ZERO, Constants.V3_DOWN, Constants.V3_LEFT), "LeftShoulderRigAttachment"},
}
-- { { Part0 name (parent), Part1 name (child, parent of joint), attachmentName, limits }, ... }
Constants.R15_RAGDOLL_RIG = {
	RootPart = {},
	Head = {"UpperTorso", "Head", "NeckRigAttachment", Constants.HEAD_LIMITS},

	UpperTorso = {"LowerTorso", "UpperTorso", "WaistRigAttachment", Constants.WAIST_LIMITS},

	LeftUpperArm = {"UpperTorso", "LeftUpperArm", "LeftShoulderRagdollAttachment", Constants.SHOULDER_LIMITS},
	LeftLowerArm = {"LeftUpperArm", "LeftLowerArm", "LeftElbowRigAttachment", Constants.ELBOW_LIMITS},
	LeftHand = {"LeftLowerArm", "LeftHand", "LeftWristRigAttachment", Constants.WRIST_LIMITS},

	RightUpperArm = {"UpperTorso", "RightUpperArm", "RightShoulderRagdollAttachment", Constants.SHOULDER_LIMITS},
	RightLowerArm = {"RightUpperArm", "RightLowerArm", "RightElbowRigAttachment", Constants.ELBOW_LIMITS},
	RightHand = {"RightLowerArm", "RightHand", "RightWristRigAttachment", Constants.WRIST_LIMITS},

	LeftUpperLeg = {"LowerTorso", "LeftUpperLeg", "LeftHipRigAttachment", Constants.HIP_LIMITS},
	LeftLowerLeg = {"LeftUpperLeg", "LeftLowerLeg", "LeftKneeRigAttachment", Constants.KNEE_LIMITS},
	LeftFoot = {"LeftLowerLeg", "LeftFoot", "LeftAnkleRigAttachment", Constants.ANKLE_LIMITS},

	RightUpperLeg = {"LowerTorso", "RightUpperLeg", "RightHipRigAttachment", Constants.HIP_LIMITS},
	RightLowerLeg = {"RightUpperLeg", "RightLowerLeg", "RightKneeRigAttachment", Constants.KNEE_LIMITS},
	RightFoot = {"RightLowerLeg", "RightFoot", "RightAnkleRigAttachment", Constants.ANKLE_LIMITS},
}
-- { { Part0 name, Part1 name }, ... }
Constants.R15_NO_COLLIDES = {
	{"LowerTorso", "LeftUpperArm"},
	{"LeftUpperArm", "LeftHand"},

	{"LowerTorso", "RightUpperArm"},
	{"RightUpperArm", "RightHand"},

	{"LeftUpperLeg", "RightUpperLeg"},

	{"UpperTorso", "RightUpperLeg"},
	{"RightUpperLeg", "RightFoot"},

	{"UpperTorso", "LeftUpperLeg"},
	{"LeftUpperLeg", "LeftFoot"},

	-- Support weird R15 rigs
	{"UpperTorso", "LeftLowerLeg"},
	{"UpperTorso", "RightLowerLeg"},
	{"LowerTorso", "LeftLowerLeg"},
	{"LowerTorso", "RightLowerLeg"},

	{"UpperTorso", "LeftLowerArm"},
	{"UpperTorso", "RightLowerArm"},

	{"Head", "LeftUpperArm"},
	{"Head", "RightUpperArm"},
}
-- { { Motor6D name, Part name }, ...}, must be in tree order, important for ApplyJointVelocities
Constants.R15_MOTOR6DS = {
	RootPart = {},
	UpperTorso = {"Waist", "UpperTorso"},

	Head = {"Neck", "Head"},

	LeftUpperArm = {"LeftShoulder", "LeftUpperArm"},
	LeftLowerArm = {"LeftElbow", "LeftLowerArm"},
	LeftHand = {"LeftWrist", "LeftHand"},

	RightUpperArm = {"RightShoulder", "RightUpperArm"},
	RightLowerArm = {"RightElbow", "RightLowerArm"},
	RightHand = {"RightWrist", "RightHand"},

	LeftUpperLeg = {"LeftHip", "LeftUpperLeg"},
	LeftLowerLeg = {"LeftKnee", "LeftLowerLeg"},
	LeftFoot = {"LeftAnkle", "LeftFoot"},

	RightUpperLeg = {"RightHip", "RightUpperLeg"},
	RightLowerLeg = {"RightKnee", "RightLowerLeg"},
	RightFoot = {"RightAnkle", "RightFoot"},
}

-- R6 has hard coded part sizes and does not have a full set of rig Attachments.
Constants.R6_ADDITIONAL_ATTACHMENTS = {
	{"Head", "NeckAttachment", CFrame.new(0, -0.5, 0)},

	{"Torso", "RightShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(1, 0.5, 0), Constants.V3_RIGHT, Constants.V3_UP)},
	{"Right Arm", "RightShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(-0.5, 0.5, 0), Constants.V3_DOWN, Constants.V3_RIGHT)},

	{"Torso", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(-1, 0.5, 0), Constants.V3_LEFT, Constants.V3_UP)},
	{"Left Arm", "LeftShoulderRagdollAttachment", CFrame.fromMatrix(Vector3.new(0.5, 0.5, 0), Constants.V3_DOWN, Constants.V3_LEFT)},

	{"Torso", "RightHipAttachment", CFrame.new(0.5, -1, 0)},
	{"Right Leg", "RightHipAttachment", CFrame.new(0, 1, 0)},

	{"Torso", "LeftHipAttachment", CFrame.new(-0.5, -1, 0)},
	{"Left Leg", "LeftHipAttachment", CFrame.new(0, 1, 0)},
}
-- R6 rig tables use the same table structures as R15.
Constants.R6_RAGDOLL_RIG = {
	RootPart = {},
	Head = {"Torso", "Head", "NeckAttachment", Constants.R6_HEAD_LIMITS},

	LeftLeg = {"Torso", "Left Leg", "LeftHipAttachment", Constants.R6_HIP_LIMITS},
	RightLeg = {"Torso", "Right Leg", "RightHipAttachment", Constants.R6_HIP_LIMITS},

	LeftArm = {"Torso", "Left Arm", "LeftShoulderRagdollAttachment", Constants.R6_SHOULDER_LIMITS},
	RightArm = {"Torso", "Right Arm", "RightShoulderRagdollAttachment", Constants.R6_SHOULDER_LIMITS},
}
Constants.R6_NO_COLLIDES = {
	{"Left Leg", "Right Leg"},
	{"Head", "Right Arm"},
	{"Head", "Left Arm"},
	{"Torso", "Left Arm"},
	{"Torso", "Right Arm"},
}
Constants.R6_MOTOR6DS = {
	RootPart = {},
	Head = {"Neck", "Torso"},
	LeftArm = {"Left Shoulder", "Torso"},
	RightArm = {"Right Shoulder", "Torso"},
	LeftLeg = {"Left Hip", "Torso"},
	RightLeg = {"Right Hip", "Torso"},
}

Constants.BALL_SOCKET_NAME = "RagdollBallSocket"
Constants.NO_COLLIDE_NAME = "RagdollNoCollision"

return Constants