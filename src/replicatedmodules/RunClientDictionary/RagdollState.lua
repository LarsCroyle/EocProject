local RagdollCache = {}
return function(Arguments)
    local CharacterInstance = Arguments.Character
    local State = Arguments.Mode

	local HumanoidInstance = CharacterInstance:FindFirstChild("Humanoid")
    local Torso = CharacterInstance:FindFirstChild("Torso")
	if HumanoidInstance then
		if not RagdollCache[CharacterInstance] then
			RagdollCache[CharacterInstance] = true
		end
		-- --
		if State == "Ragdolled" then
			repeat task.wait()
				if HumanoidInstance:GetState() == Enum.HumanoidStateType.Dead then
					RagdollCache[CharacterInstance] = nil
					break
				end
				HumanoidInstance:ChangeState(Enum.HumanoidStateType.Physics)
			until not RagdollCache[CharacterInstance]
		elseif State == "Normal" then
			RagdollCache[CharacterInstance] = nil
			-- -
			repeat task.wait()
				HumanoidInstance:ChangeState(Enum.HumanoidStateType.GettingUp)
			until HumanoidInstance:GetState() == Enum.HumanoidStateType.GettingUp
		end
	end
end;