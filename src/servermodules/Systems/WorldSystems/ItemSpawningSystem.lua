local ModelFolder = game:GetService("ServerStorage").Assets.Models
local Trove = require(game.ReplicatedStorage.Modules.Packages.Trove)
local RunClient = require(game.ServerStorage.Modules.Functions.RunClient)
local AddItem = require(game.ServerStorage.Modules.Functions.Items.AddItem)

local ItemSpawningSystem = {
    Name = "ItemSpawningSystem",
    Priority = "Update",
    Tag = {
        "World_No_Tag"
    }
}

local ItemSpawnData = {
    ["Chest"] = {
        ["Model"] = ModelFolder.Chest,
        ["SpawnChance"] = 100, --20,
        ["SpawnTime"] = 5,--2 * 60,
        ["MaxSpawn"] = 20,
        ["CurrentSpawn"] = 0,
        ["Spawned"] = {},
        PromptTriggered = function(self, UserEntity, SpawnTrove)
            if self.Occupied then
                return
            end
            self.Occupied = UserEntity
            local Character = UserEntity:Get("Character").Character

            RunClient("PlaySound", {
                SoundId = 865367121,
                Parent = Character.HumanoidRootPart,
                Volume = 1,
                RemoveOnFinish = true,
            }, "All")

            local Character = UserEntity:Get("Character")
            local Inventory = UserEntity:Get("Inventory")

            Inventory.ChestItems = table.create(10, {
                Name = "None",
                Quantity = 1,
                Rarity = "Common"
            })

            if not self.ItemsGenerated then
                local ItemRotation = {
                    ["None"] = 52, -- must sum to 100
                    ["Common"] = 30,
                    ["Uncommon"] = 15,
                    ["Rare"] = 5,
                    ["Epic"] = 2,
                    ["Legendary"] = 1,
                }

                local TestItems = {
                    ["Common"] = {
                        "Rapier",
                        "Verge Ironbrand",
                        "Rat Helmet",
                        "Rat Chestplate",
                        "Rat Shinguards",
                        "Rat Gauntlets",
                        "Torch"
                    },
                    ["Uncommon"] = {
                        "Shackle"
                    }
                }

                for i = 1, 10 do
                    local Roll = math.random(1, 100)
                    for Rarity, Chance in pairs(ItemRotation) do
                        if Roll <= Chance then
                            if TestItems[Rarity] then
                                AddItem({
                                    UserEntity = UserEntity,
                                    Type = "ChestItems",
                                    ItemName = TestItems[Rarity][math.random(1, #TestItems[Rarity])]
                                })
                            end
                            break
                        end
                    end
                end

                self.ItemsGenerated = UserEntity:Get("Inventory").ChestItems
            end

            Inventory.ChestItems = self.ItemsGenerated
            Inventory.ChestOpen = true

            local function CloseChest()
                Inventory.ChestOpen = false
                self.Occupied = nil
                local ReplicationEntity = ItemSpawningSystem.Workshop:CreateEntity()
                :AddComponent("RunClient", {
                    Call = "UpdateInventory",
                    Arguments = Inventory,
                    Target = UserEntity:Get("Player").Player
                })
                ItemSpawningSystem.Workshop:SpawnEntity(ReplicationEntity)
            end

            SpawnTrove:Add(CloseChest)
            SpawnTrove:Add(UserEntity:Get("HeldInputs").HeldInputChanged:Connect(function(Input, Began)
                if Input == "Tab" and Began then
                    CloseChest()
                end
            end))

            local ReplicationEntity = ItemSpawningSystem.Workshop:CreateEntity()
            :AddComponent("RunClient", {
                Call = "UpdateInventory",
                Arguments = Inventory,
                Target = UserEntity:Get("Player").Player
            })
            ItemSpawningSystem.Workshop:SpawnEntity(ReplicationEntity)
        end
    },
    ["Torch"] = {
        ["Model"] = ModelFolder.Torch,
        ["SpawnChance"] = 100, --20,
        ["SpawnTime"] = 5,--2 * 60,
        ["MaxSpawn"] = 1,
        ["CurrentSpawn"] = 0,
        ["Spawned"] = {},
    },
    ["Rapier"] = {
        ["Model"] = ModelFolder.Rapier,
        ["SpawnChance"] = 100, --20,
        ["SpawnTime"] = 5,--2 * 60,
        ["MaxSpawn"] = 1,
        ["CurrentSpawn"] = 0,
        ["Spawned"] = {},
    },
}

function ItemSpawningSystem:Boot()
    while true do
        local Clock = self.Clock
        if not self.Clock then
            self.Clock = 0
        end
        self.Clock += 1

        for ItemName, ItemData in pairs(ItemSpawnData) do
            if self.Clock % ItemData.SpawnTime == 0 then
                if ItemData.CurrentSpawn < ItemData.MaxSpawn then
                    local ChanceToSpawn = Random.new():NextNumber(0, 100)
                    if ChanceToSpawn > ItemData.SpawnChance then
                        continue
                    end

                    local PossibleSpawns = workspace.ItemSpawns[ItemName]:GetChildren()
                    local ActualSpawns = {}

                    for _, Spawn in ipairs(PossibleSpawns) do
                        if not Spawn:FindFirstChildOfClass("Model") then
                            table.insert(ActualSpawns, Spawn)
                        end
                    end

                    if #ActualSpawns == 0 then
                        continue
                    end

                    local SpawnLocation = ActualSpawns[math.random(1, #ActualSpawns)]
                    if not SpawnLocation then
                        continue
                    end

                    local ItemTrove = Trove.new()

                    local SpawnedItem = ItemTrove:Add(ItemData.Model:Clone())
                    SpawnedItem.Parent = SpawnLocation
                    SpawnedItem:PivotTo(SpawnLocation.CFrame)

                    if ItemData.PromptTriggered then
                        local ProximityPrompt = Instance.new("ProximityPrompt")
                        local ProximityAttachment = Instance.new("Attachment")

                        ProximityPrompt.Parent = ProximityAttachment
                        ProximityPrompt.HoldDuration = 0.5
                        ProximityPrompt.MaxActivationDistance = 10
                        ProximityPrompt.Enabled = true
                        ProximityPrompt.RequiresLineOfSight = false
                        ProximityPrompt.ObjectText = ItemName == "Chest" and "Open" or "Pick up"
                        ProximityAttachment.Parent = SpawnedItem.PrimaryPart

                        local ItemSelf = {}

                        ItemTrove:Add(ProximityPrompt.Triggered:Connect(function(Player)
                            local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")
                            if not UserEntity then
                                return
                            end
                            local Character = UserEntity:Get("Character")

                            if Character and SpawnedItem then
                                if ItemData.PromptTriggered then
                                    ItemData.PromptTriggered(ItemSelf, UserEntity, ItemTrove)
                                end
                            end
                        end))
                    else
                        SpawnedItem.PrimaryPart.Anchored = false
                        SpawnedItem.PrimaryPart.CanCollide = true

                        SpawnedItem.PrimaryPart.Touched:Connect(function(Hit)
                            local UserEntity = self.Workshop:GetEntity(Hit.Parent.Name .. "UserEntity")
                            if not UserEntity then
                                return
                            end
                            local Character = UserEntity:Get("Character")

                            AddItem({
                                UserEntity = UserEntity,
                                Type = "Inventory",
                                ItemName = ItemName
                            })
                            print(UserEntity:Get("Inventory"))
                            ItemTrove:Destroy()
                        end)
                    end

                    ItemData.CurrentSpawn += 1
                    table.insert(ItemData.Spawned, SpawnedItem)

                    ItemTrove:Add(SpawnedItem.AncestryChanged:Connect(function(_, Parent)
                        if not Parent then
                            ItemTrove:Destroy()

                            ItemData.CurrentSpawn -= 1
                            table.remove(ItemData.Spawned, table.find(ItemData.Spawned, SpawnedItem))
                        end
                    end))

                    task.delay(60, function()
                        if ItemTrove and SpawnedItem.Parent then
                            ItemTrove:Destroy()
                        end
                    end)
                end
            end
        end
        task.wait(1)
    end
end

return ItemSpawningSystem