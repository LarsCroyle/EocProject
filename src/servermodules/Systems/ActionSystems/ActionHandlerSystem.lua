local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)
local Sequence = require(game.ServerStorage.Modules.Classes.Sequence)
local Trove = require(game.ReplicatedStorage.Modules.Packages.Trove)
local ParseActionFrameArguments = require(game.ServerStorage.Modules.Functions.ParseActionFrameArgumentsMethod)
local GetUserEntityFromCharacter = require(game.ServerStorage.Modules.Functions.GetUserEntityFromCharacter)
local RunClient = require(game.ServerStorage.Modules.Functions.RunClient)

--[[
    effectively an enhancement of Sequence classes. this is because it will parse a sequence-like table and create a sequence from it using strings as keys. (also accepts functions).
    this is used in tools, weapons, and techniques
--]]

local ActionHandlerSystem = {
    Name = "ActionHandlerSystem",
    Priority = "Update",
    Tag = {
        "Action",
        "Character"
    }
}

function Sequence:Trigger(...)
    return ActionHandlerSystem:GetCommonAction(self, ...)
end

function Sequence:PlaySequence(FrameData, ...)
    if typeof(FrameData) == "string" then
        local SequenceFrameData = self.Action.ActionMetaData.ActionInformation[FrameData]

        FrameData = self.Action.ActionMetaData.ActionInformation[FrameData]
    end
    if not FrameData then
        return
    end

    local ParsedFrameData = ActionHandlerSystem:ParseAction(FrameData)
    if not self.SubSequences then
        self.SubSequences = {}
    end
    local NewSequence = Sequence.new({
        Name = self.Name,
        Speed = self:GetSpeed(),
        Frames = ParsedFrameData,
    })
    NewSequence.UserEntity = self.UserEntity
    NewSequence.Action = self.Action

    table.insert(self.SubSequences, NewSequence)

    NewSequence:Play(...)

    return NewSequence
end

function ActionHandlerSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAction(TaggedEntity)
    end
end

function ActionHandlerSystem:ProcessAction(ActionEntity)
    local Action = ActionEntity:Get("Action")
    local Character = ActionEntity:Get("Character")
    local UserEntity = GetUserEntityFromCharacter(Character)

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        self.Workshop:RemoveEntity(ActionEntity)
        return
    end
    if Humanoid.Health <= 0 then
        self.Workshop:RemoveEntity(ActionEntity)
        return
    end

    local ActionInProgress = UserEntity:Get("ActionInProgress")
    if ActionInProgress and Action.ActionInformation and Action.ActionInformation.Active ~= false then
        -- drop the event if the user is already performing an action and this action is subjected to the active action constraints
        self.Workshop:RemoveEntity(ActionEntity)
        return
    end

    if UserEntity:Get(Action.Name .. "Cooldown") then
        self.Workshop:RemoveEntity(ActionEntity)
        return
    end

    if UserEntity:Get("StunCountdown") and not Action.ActionInformation.IgnoreStun then
        self.Workshop:RemoveEntity(ActionEntity)
        return
    end

    if UserEntity:Get("Knockdowned") then
        self.Workshop:RemoveEntity(ActionEntity)
        return
    end

    local ParsedFrameData = self:ParseAction(Action.Action)

    if not Action.ActionMetaData then
        Action.ActionMetaData = {}
    end

    if not Action.ActionMetaData.Trove then
        Action.ActionMetaData.Trove = Trove.new()
        Action.ActionMetaData.Trove:AttachToInstance(Character)
    end

    if not Action.ActionInformation.Interruptable and Action.Name ~= "Equipped" and Action.Name ~= "Unequipped" then
        local Highlight : Highlight = Action.ActionMetaData.Trove:Add(Instance.new("Highlight"))
        Highlight.Adornee = Character
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillTransparency = 1
        Highlight.OutlineColor = Color3.fromRGB(255, 238, 0)
        Highlight.OutlineTransparency = 0.2
        Highlight.Parent = Character
    end

    if Action.ActionInformation and Action.ActionInformation.Active ~= false then
        local _, ComponentHandler = UserEntity:AddComponent("ActionInProgress", true)
        Action.ActionMetaData.Trove:Add(ComponentHandler)

        RunClient(
            "ActivateTool",
            {
                Index = UserEntity:Get("Inventory").Equipped
            },
            UserEntity:Get("Player").Player
        )
    end

    if Action.ActionInformation.Cooldown then
        Action.ActionMetaData.Trove:Add(function()
            UserEntity:AddComponent(Action.Name .. "Cooldown", true)

            task.delay(Action.ActionInformation.Cooldown, function()
                UserEntity:RemoveComponent(Action.Name .. "Cooldown")
                warn(Action.Name .. " cooldown removed")
            end)
        end)
    end

    Action.ActionMetaData.Attacker = Character
    Action.ActionMetaData.ToolName = Action.ActionDataSetName
    Action.ActionMetaData.Speed = Action.Speed
    Action.ActionMetaData.ActionInformation = Action.ActionInformation

    local ActionSequence = Sequence.new({
        Name = Action.Name,
        Speed = Action.Speed,
        Frames = ParsedFrameData,
    })
    ActionSequence.UserEntity = UserEntity
    ActionSequence.Action = Action
    ActionSequence:Play()

    UserEntity:AddComponent("ActionSequence", ActionSequence)

    task.spawn(function()
        while ActionSequence:IsPlaying() do
            task.wait()
        end
        Action.ActionMetaData.Trove:Destroy()

        game:GetService("RunService").Heartbeat:Wait()

        UserEntity:RemoveComponent("ActionSequence")
    end)

    self.Workshop:RemoveEntity(ActionEntity)
end

function ActionHandlerSystem:ParseAction(Action)
    local NewSequence = {}
    for _, v in pairs(Action) do
        local Frame = {}

        for SequenceIndex, SequenceValue in pairs(v) do
            local Halt = false
            if typeof(SequenceValue) == "string" then
                local ActionName = SequenceValue
                SequenceValue = function(_SequenceSelf)
                    v = ParseActionFrameArguments(_SequenceSelf.Action.ActionMetaData, v)
                    self:GetCommonAction(_SequenceSelf, ActionName, select(SequenceIndex + 1, unpack(v)))
                end
                Halt = true
            end
            table.insert(Frame, SequenceValue)
            if Halt then
                break
            end
        end

        table.insert(NewSequence, Frame)
    end
    return NewSequence
end

function ActionHandlerSystem:GetCommonAction(Sequence, ActionName, ...)
    local FrameArgumentFunction = GetCommon(ActionName)
    if not FrameArgumentFunction then
        return
    end
    return FrameArgumentFunction(Sequence, self, ...)
end

return ActionHandlerSystem