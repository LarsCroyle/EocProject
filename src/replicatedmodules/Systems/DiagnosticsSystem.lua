local EntityUi = require(game.ReplicatedStorage.Modules.Fusion.Components.EntityUi)
local RecsDiagnostics = require(game.ReplicatedStorage.Modules.Fusion.Components.RecsDiagnostics)
local Net = require(game.ReplicatedStorage.Modules.Packages.Net)

local DiagnosticsSystem = {
    Name = "DiagnosticsSystem",
    Priority = "First",
    Tag = {
        "Diagnostics"
    }
}

function DiagnosticsSystem:Update(Entities)
    for _, Entity in Entities do
        self:ProcessEntity(Entity)
    end
end

function DiagnosticsSystem:ProcessEntity(Entity)
    local EntityName = Entity.Name
    local EntityComponents = Entity.Components

    local Player = game.Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local MainOverlay = PlayerGui:WaitForChild("MainOverlay")
    local Main = MainOverlay:WaitForChild("Main")
    local RecsDiagnostics = Main:WaitForChild("RecsDiagnostics")

    local EntityUiExists = RecsDiagnostics.EntityList:FindFirstChild(EntityName)

    if EntityUiExists then
        return
    end

    local EntityUi = EntityUi({
        EntityName = EntityName,
        EntityComponents = EntityComponents
    })
    EntityUi.Name = EntityName
    EntityUi.Parent = RecsDiagnostics.EntityList

    local Connection; Connection = self.Workshop.EntityRemoved:Connect(function(DestroyedEntityName)
        if DestroyedEntityName == EntityName then
            EntityUi:Destroy()
            Connection:Disconnect()
        end
    end)
end

function DiagnosticsSystem:Boot()
    RecsDiagnostics.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainOverlay"):WaitForChild("Main")

    Net:RemoteEvent("EntityAdded").OnClientEvent:Connect(function(EntityName, Adding)
        if Adding then
            if RecsDiagnostics.ServerEntityList:FindFirstChild(EntityName) then
                return
            end
            local EntityUi = EntityUi({
                EntityName = EntityName,
                EntityComponents = {},
                TextColor = Color3.fromRGB(153, 142, 255)
            })
            EntityUi.Name = EntityName
            EntityUi.Parent = RecsDiagnostics.ServerEntityList
        else
            local EntityUi = RecsDiagnostics.ServerEntityList:FindFirstChild(EntityName)
            if EntityUi then
                EntityUi:Destroy()
            end
        end
    end)
end

return DiagnosticsSystem