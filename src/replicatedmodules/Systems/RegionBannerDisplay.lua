local TweenService = game:GetService("TweenService")

local RegionBannerDisplaySystem = {
    Name = "RegionBannerDisplay",
    Priority = "Update",
    Tag = {
        "Character"
    }
}

local WorldRegionsParamaters = OverlapParams.new()
WorldRegionsParamaters.FilterDescendantsInstances = {workspace.WorldRegions}
WorldRegionsParamaters.FilterType = Enum.RaycastFilterType.Include

local function GetRegionNameFromCharacter(Character)
    local Parts = workspace:GetPartsInPart(Character.HumanoidRootPart, WorldRegionsParamaters)
    if #Parts > 0 then
        local Region = Parts[1]
        return Region.Name
    end
end

function RegionBannerDisplaySystem:Update(TaggedEntities)
    for _, TaggedEntity in TaggedEntities do
        self:ProcessEntity(TaggedEntity)
    end
end

function RegionBannerDisplaySystem:ProcessEntity(TaggedEntity)
    local Character = TaggedEntity:Get("Character").Character
    local RegionName = GetRegionNameFromCharacter(Character)

    if not RegionName then
        return
    end

    local LastVisibleRegionName = TaggedEntity:Get("LastVisibleRegionName")
    if LastVisibleRegionName ~= RegionName then
        TaggedEntity:SetComponent("LastVisibleRegionName", RegionName)
        self:UpdateRegionBanner(Character, RegionName)

        return
    end
end

function RegionBannerDisplaySystem:UpdateRegionBanner(Character, RegionName)
    local RegionBanner = Character:FindFirstChild("RegionBanner")
    if not RegionBanner then
        RegionBanner = Instance.new("ScreenGui")
        RegionBanner.Name = "RegionBanner"
        RegionBanner.DisplayOrder = 10
        RegionBanner.IgnoreGuiInset = true
        RegionBanner.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    end
    local RegionNameLabel = RegionBanner:FindFirstChild("RegionName")
    if not RegionNameLabel then
        RegionNameLabel = Instance.new("TextLabel")
        RegionNameLabel.Name = "RegionName"
        RegionNameLabel.BackgroundTransparency = 1
        RegionNameLabel.Size = UDim2.new(0.5, 0, 0.3, 0)
        RegionNameLabel.Position = UDim2.new(0.5, 0, 0.1, 0)
        RegionNameLabel.AnchorPoint = Vector2.new(0.5, 0)
        RegionNameLabel.Font = Enum.Font.Bodoni
        RegionNameLabel.Text = RegionName
        RegionNameLabel.TextColor3 = Color3.new(1, 1, 1)
        RegionNameLabel.TextScaled = true
        RegionNameLabel.TextStrokeTransparency = 0
        RegionNameLabel.TextWrapped = true
        RegionNameLabel.Parent = RegionBanner
    else
        RegionNameLabel.Text = RegionName
    end

    RegionNameLabel.TextTransparency = 1
    TweenService:Create(RegionNameLabel, TweenInfo.new(1.5), {
        TextTransparency = 0
    }):Play()

    print("RegionBannerDisplaySystem:UpdateRegionBanner", RegionName)
    task.wait(4)

    print("RegionBannerDisplaySystem:UpdateRegionBanner", RegionName)
    TweenService:Create(RegionNameLabel, TweenInfo.new(2), {
        TextTransparency = 1
    }):Play()
end

return RegionBannerDisplaySystem