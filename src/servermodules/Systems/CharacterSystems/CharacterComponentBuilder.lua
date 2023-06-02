--[[
    Purely component system, not intended for use outside of the luau context. (To modify characters in the roblox context, use the CharacterConfigurationSystem)
    System which injects character components into User Entities if they do not have one yet.
--]]
local RunService = game:GetService("RunService")
local Trove = require(game.ReplicatedStorage.Modules.Packages.Trove)
local RagdollMethod = require(game.ServerStorage.Modules.Functions.RagdollMethod)
local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)
local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)

local CharacterBuildSystem = {
    Name = "CharacterBuildSystem",
    Priority = "PreUpdate",
    Tag = {
        "Player",
        "SaveData",
        "!Character",
        "!CharacterComponentSpawning"
    }
}

function CharacterBuildSystem:Update(TaggedEntities)
    for _, EntityObject in pairs(TaggedEntities) do
        self:ProcessUserEntity(EntityObject)
    end
end

function CharacterBuildSystem:GetCharacter(Player)
    local Character
    if Player and Player:IsA("Player") and Player.Character then
        Character = Player.Character
    elseif Player and Player:IsA("Player") and not Player.Character then
        Character = Player.CharacterAdded:Wait()
    elseif Player and Player:IsA("Model") then
        Character = Player
    end
    return Character
end

function CharacterBuildSystem:ProcessUserEntity(UserEntity)
    local Player = UserEntity:Get("Player").Player
    local ExistingCharacter = UserEntity:Get("Character")
    if ExistingCharacter then
        return
    end

    local Character = self:GetCharacter(Player)
    if Character then
        local CharacterTrove = Trove.new()
        local _, ComponentDisconnecter = UserEntity:AddComponent("CharacterComponentSpawning", true)

        CharacterTrove:Add(ComponentDisconnecter)

        RunService.Heartbeat:Wait()

        CharacterTrove:AttachToInstance(Character)

        local _, ComponentDisconnecter = UserEntity:AddComponent("CharacterTrove", CharacterTrove)
        CharacterTrove:Add(ComponentDisconnecter)

        task.defer(function()
            local Humanoid = Character:WaitForChild("Humanoid")
            Humanoid.RequiresNeck = false
            Humanoid.UseJumpPower = true

            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

            Character.Parent = workspace.Characters
            local _, ComponentDisconnecter = UserEntity:AddComponent("Character", {
                Character = Character,
                Humanoid = Character:WaitForChild("Humanoid"),
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            })

            CharacterTrove:Add(HumanoidRootPart.AncestryChanged:Connect(function()
                if HumanoidRootPart.Parent == nil then
                    print("HumanoidRootPart Ancestry Changed")
                    if Character.Parent ~= nil then
                        Character:Destroy()
                    end
                    CharacterTrove:Destroy()
                end
            end))
            CharacterTrove:Add(Character.AncestryChanged:Connect(function()
                if Character.Parent == nil then
                    print("Character Ancestry Changed")
                    CharacterTrove:Destroy()
                end
            end))

            local Inventory = UserEntity:Get("Inventory")
            local Hotbar = Inventory.Hotbar
            local Armor = Inventory.Armor

            if Hotbar then
                for _, Item in pairs(Hotbar) do
                    if Item.Name then
                        Action(Item.Name, "Added", Character)
                    end
                end
            end

            for ArmorName, ArmorPiece in pairs(Armor) do
                if ArmorPiece and ArmorPiece ~= "None" then
                    GetCommon("Rig")({
                        UserEntity = UserEntity,
                    }, CharacterBuildSystem, ArmorPiece)

                    if ArmorName == "Head" then
                        for _, Part in pairs(Character:GetChildren()) do
                            if Part:IsA("Accessory") then
                                for _, Child in pairs(Part:GetChildren()) do
                                    if Child:IsA("BasePart") then
                                        Child:SetAttribute("Transparency", Child.Transparency)
                                        Child.Transparency = 1
                                    end
                                end
                            end
                        end

                        local Connection; Connection = Character.DescendantAdded:Connect(function(Child)
                            if Child:IsA("Accessory") then
                                print("Accessory Added")
                                for _, Child in pairs(Child:GetChildren()) do
                                    if Child:IsA("BasePart") then
                                        Child.Transparency = 1
                                        Child:SetAttribute("Transparency", Child.Transparency)
                                    end
                                end
                            end
                        end)

                        task.delay(5, function()
                            Connection:Disconnect()
                        end)
                    end
                end
            end

            local Died = false
            CharacterTrove:Add(Humanoid.Died:Connect(function()
                if not Died then
                    Died = true

                    local Equipped = Inventory.Equipped
                    local EquippedItem = Inventory.Hotbar[Equipped].Name

                    Action(EquippedItem, "Unequipped", Character)
                    Inventory.Equipped = -1

                    RagdollMethod({
                        Target = {Character = Character},
                        TargetUserEntity = UserEntity,
                        TargetRagdoll = UserEntity:Get("RagdollInstance"),
                        Mode = true
                    })
                end
            end))
            CharacterTrove:Add(ComponentDisconnecter)

            task.delay(4, function()
                if game.Players:GetPlayerFromCharacter(Character) then
                    UserEntity:AddComponent("CharacterCreationSettings", {
                        Race = "Infernus",
                        Variant = "Cinderite"
                    })
                end
            end)
        end)
    end
end

return CharacterBuildSystem