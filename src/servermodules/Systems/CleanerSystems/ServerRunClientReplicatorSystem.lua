local Net = require(game.ReplicatedStorage.Modules.Packages.Net)

local ServerRunClientReplicator = {
    Name = "ServerRunClientReplicator",
    Priority = "Last",
    Tag = {
        "RunClient"
    }
}

function ServerRunClientReplicator:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessRunClient(TaggedEntity)
        self.Workshop:RemoveEntity(TaggedEntity.Name)
    end
end

function ServerRunClientReplicator:ProcessRunClient(RunClientEntity)
    local Target = RunClientEntity:Get("RunClient").Target
    local Call = RunClientEntity:Get("RunClient").Call
    local Arguments = RunClientEntity:Get("RunClient").Arguments

    if typeof(Target) == "string" then
        if Target == "All" then
            Net:RemoteEvent("RunClient"):FireAllClients(Call, Arguments)
            return
        else
            Target = game.Players:FindFirstChild(Target)
        end
    elseif typeof(Target) == "table" then
        for _, Player in pairs(Target) do
            Net:RemoteEvent("RunClient"):FireClient(Player, Call, Arguments)
        end
        return
    elseif typeof(Target) == "Instance" then
        if Target:IsA("Player") then
            Net:RemoteEvent("RunClient"):FireClient(Target, Call, Arguments)
            return
        end
    else
        error("Invalid Target for RunClient")
    end
end

function ServerRunClientReplicator:Boot()
    Net:RemoteEvent("RunClient")

    self.Workshop.EntityAdded:Connect(function(Entity)
        Net:RemoteEvent("EntityAdded"):FireAllClients(Entity.Name, true)
    end)

    self.Workshop.EntityRemoved:Connect(function(EntityName)
        Net:RemoteEvent("EntityAdded"):FireAllClients(EntityName, false)
    end)
end

return ServerRunClientReplicator