local UserInputService = game:GetService("UserInputService")
local Player = game:GetService("Players").LocalPlayer
local Net = require(game.ReplicatedStorage.Modules.Packages.Net)

local ClientInputSystem = {
	Name = "ClientInputSystem",
	Tag = {"Player", "Input"},
	Priority = "Last",
}

function ClientInputSystem:Update(TaggedEntities)
	if not TaggedEntities then
		return
	end
	for _, InputEntity in TaggedEntities do
		self:ProcessInput(InputEntity)
		task.defer(function()
			self.Workshop:RemoveEntity(InputEntity.Name)
		end)
	end
end

function ClientInputSystem:ProcessInput(InputEntity)
    local Input = InputEntity:Get("Input")
    if not Input then
        return
	end

    local Type = Input.InputType
    local Player = InputEntity:Get("Player")
    local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")
    if not UserEntity then
        return
    end

    local HeldInputs = UserEntity:Get("HeldInputs")
    if not HeldInputs then
        HeldInputs = {}
        UserEntity:AddComponent("HeldInputs", HeldInputs)
    end

    if Type == "Began" then
        HeldInputs[Input.Input] = true
    else
        HeldInputs[Input.Input] = nil
    end

    Net:RemoteEvent("Input"):FireServer({
        Input = Input.Input,
        Type = Input.InputType
    })
end

function ClientInputSystem:ParseInput(InputObject)
    if typeof(InputObject) == "string" then
        return InputObject
    end
    if InputObject.KeyCode and InputObject.KeyCode ~= Enum.KeyCode.Unknown then
		return InputObject.KeyCode.Name
	end
	return InputObject.UserInputType.Name
end

function ClientInputSystem:Input(InputObject, Type)
    local Input = self:ParseInput(InputObject)
    -- check if the ability has a move on that input here
    if not Input then
        return
    end

    if Input == "MouseMovement" then
        return
    end
    if Input == "MouseWheel" then
        return
    end
    if Input == "Focus" then
        return
    end

    self:CreateInputEntity(Input, Type)
end

function ClientInputSystem:CreateInputEntity(Input, InputType)
    local InputEntity = self.Workshop:CreateEntity()
        :AddComponent("Player", Player)
        :AddComponent("Input", {
            Input = Input,
            InputType = InputType
        })
    self.Workshop:SpawnEntity(InputEntity)
end

function ClientInputSystem:Boot()
    UserInputService.InputBegan:Connect(function(InputObject, GameProcessedEvent)
        if GameProcessedEvent then
            return
        end
        self:Input(InputObject, "Began")
    end)

    UserInputService.InputEnded:Connect(function(InputObject, GameProcessedEvent)
        if GameProcessedEvent then
            return
        end
        self:Input(InputObject, "Ended")
    end)
end

return ClientInputSystem