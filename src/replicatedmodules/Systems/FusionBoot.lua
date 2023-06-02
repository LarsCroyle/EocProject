-- System to boot and load default fusion modules
local StarterGui = game:GetService("StarterGui")
local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local FusionModules = game.ReplicatedStorage.Modules.Fusion
local FusionBootSystem = {
    Name = "FusionBootSystem",
    Priority = "Update",
    Tag = {
        "TAG_NO_TAG"
    }
}

function FusionBootSystem:Boot()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

    for _, Module in pairs(FusionModules:GetChildren()) do
        if Module:IsA("ModuleScript") then
            require(Module)(Fusion)
        end
    end
end

return FusionBootSystem