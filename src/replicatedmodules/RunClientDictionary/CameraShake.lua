local CameraShaker = require(game.ReplicatedStorage.Modules.Packages.CameraShaker)
local Camera = workspace.CurrentCamera

local CamShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	Camera.CFrame = Camera.CFrame * shakeCFrame
end)

CamShake:Start()

return function(Arguments)
    CamShake:ShakeOnce(Arguments.Magnitude, Arguments.Roughness, Arguments.FadeInTime, Arguments.FadeOutTime, Arguments.PositionInfluence, Arguments.RotationInfluence)
end