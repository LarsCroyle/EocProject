local ParseActionFrameArguments = require(game.ServerStorage.Modules.Functions.ParseActionFrameArgumentsMethod)

return function(HitboxData)
    local QueryResult = {}
    local QueryType = HitboxData.Type
    local QuerySize = HitboxData.Size
    local QueryOffset = HitboxData.Offset
    local QueryOrigin = HitboxData.Origin
    local QueryIgnore = HitboxData.Ignore
    local QueryUserEntity = HitboxData.UserEntity
    local Character = QueryUserEntity:Get("Character").Character

    if typeof(QueryOrigin) == "string" then
        local Inventory = QueryUserEntity:Get("Inventory")
        local Equipped = Inventory.Equipped
        local Hotbar = Inventory.Hotbar
        local ToolName = Hotbar[Equipped].Name

        local ParseData = {
            ["Attacker"] = Character,
            ["ToolName"] = ToolName
        }

        QueryOrigin = ParseActionFrameArguments(ParseData, QueryOrigin)
        QuerySize = ParseActionFrameArguments(ParseData, QuerySize)
    end

    if typeof(QueryOrigin) == "Instance" then
        QueryOrigin = QueryOrigin.CFrame
    end
    if typeof(QueryOrigin) == "Vector3" then
        QueryOrigin = CFrame.new(QueryOrigin)
    end

    if typeof(QueryOffset) == "Vector3" then
        QueryOffset = CFrame.new(QueryOffset)
    end

    local Overlap = OverlapParams.new()
    Overlap.FilterType = Enum.RaycastFilterType.Include
    Overlap.FilterDescendantsInstances = {workspace.Characters}

    --local Part = Instance.new("Part")
    --Part.Anchored = true
    --Part.CanCollide = false
    --Part.Material = Enum.Material.ForceField
    --Part.Color = Color3.new(1, 0, 0)
    --Part.CFrame = QueryOrigin * QueryOffset
    --Part.Size = QuerySize
    --Part.CastShadow = false
    --Part.Parent = workspace.Effects
    --game.Debris:AddItem(Part, 1)

    if QueryType == "Box" then
        if typeof(QuerySize) ~= "Vector3" then
            QuerySize = Vector3.one * QuerySize
        end
        QueryResult = workspace:GetPartBoundsInBox(QueryOrigin * QueryOffset, QuerySize, Overlap)
    elseif QueryType == "Sphere" then
        if typeof(QuerySize) ~= "number" then
            QuerySize = QuerySize.Magnitude
        end
        QueryResult = workspace:GetPartsInSphere(QueryOrigin * QueryOffset, QuerySize, Overlap)
    end

    local QueryResults = {}

    for _, Part in pairs(QueryResult) do
        if Part:IsA("BasePart") then
            local Character = Part:FindFirstAncestorOfClass("Model")
            if Character and not table.find(QueryIgnore, Character) then
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then
                    table.insert(QueryResults, Character)
                    table.insert(QueryIgnore, Character)
                end
            end
        end
    end

    return QueryResults
end