local Player = game.Players.LocalPlayer
return function()
	local Character = Player.Character
	local RootPart = Character.HumanoidRootPart
	local Humanoid = Character.Humanoid

	RootPart.CFrame = CFrame.new(RootPart.CFrame.Position + Vector3.new(0, 5, 0))
end