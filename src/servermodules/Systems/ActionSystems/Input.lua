local Net = require(game.ReplicatedStorage.Modules.Packages.Net)
local Signal = require(game.ReplicatedStorage.Modules.Packages.Signal)

local InputSystem = {
    Name = "InputSystem",
    Tag = {"TAG_NO_TAG"},
    Priority = "First",
}

function InputSystem:Boot()
    Net:RemoteEvent("Input").OnServerEvent:Connect(function(Player, InputEntityData)
        local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")
        if not UserEntity then
            warn("INPUT_SYS_WARNING: UserEntity not found")
            return
        end
        local Character = UserEntity:Get("Character")
        if Character and InputEntityData.Type == "Began" then
            UserEntity:AddComponent("Input", {
                Input = InputEntityData.Input
            })
        end
        local HeldInputs = UserEntity:Get("HeldInputs")
        if not HeldInputs then
            HeldInputs = {
                HeldInputChanged = Signal.new()
            }
            UserEntity:AddComponent("HeldInputs", HeldInputs)
        end
        local Began = InputEntityData.Type == "Began"
        UserEntity:Get("HeldInputs")[InputEntityData.Input] = Began
        HeldInputs.HeldInputChanged:Fire(InputEntityData.Input, Began)
    end)
end

return InputSystem