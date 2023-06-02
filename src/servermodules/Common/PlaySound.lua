local GetSound = require(game.ServerStorage.Modules.Functions.GetSound)
local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

--[[
    Acts as a shorthand way to play multiple sounds for a move via autoparser.
    {0, "Play_Sound", "Sound1", "Sound2", "Sound3"}
--]]
return function(self, SequenceSystem, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character")

    local SoundIds = {...}

    for _, SoundId in pairs(SoundIds) do
        if typeof(SoundId) == "string" then
            SoundId = GetSound({
                UserEntity = UserEntity,
                SoundId = SoundId
            })
        end

        local ReplicationEntity = Workshop:CreateEntity()
        :AddComponent("RunClient", {
            Call = "PlaySound",
            Arguments = {
                SoundId = SoundId.SoundId,
                Parent = Character.HumanoidRootPart,
                Volume = SoundId.Volume or 1,
                Pitch = 1,
                Loop = false,
                RemoveOnFinish = true,
            },
            Target = "All"
        })
        Workshop:SpawnEntity(ReplicationEntity)

    end
end