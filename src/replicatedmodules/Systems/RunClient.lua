local Net = require(game.ReplicatedStorage.Modules.Packages.Net)
local RunClientDictionary = require(game.ReplicatedStorage.Modules.RunClientDictionary)

local RunClientSystem = {
    Name = "RunClientSystem",
    Priority = "Update",
    Tag = {
        "TAG_NO_TAG"
    }
}

function RunClientSystem:Boot()
    Net:RemoteEvent("RunClient").OnClientEvent:Connect(function(Call, Arguments)
        self:RunClient(Call, Arguments)
    end)
end

function RunClientSystem:RunClient(Call: string, Arguments: any)
    if RunClientDictionary[Call] then
        RunClientDictionary[Call](Arguments)
    end
end

local RunClient_Event = Instance.new("BindableEvent")
RunClient_Event.Name = "RunClient"
RunClient_Event.Parent = game.ReplicatedStorage
RunClient_Event.Event:Connect(function(Call, Arguments)
    RunClientSystem:RunClient(Call, Arguments)
end)

return RunClientSystem