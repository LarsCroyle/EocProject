local ActionDictionary = {}
local CompileActionFileToActionDataSet

local function CompileActionFiles(Parent)
    for _, ActionFile in pairs(Parent:GetChildren()) do
        if ActionFile:IsA("Folder") then
            local ActionDataSet = CompileActionFileToActionDataSet(ActionFile)
            if ActionDataSet then
                ActionDictionary[ActionFile.Name] = ActionDataSet
            else
                CompileActionFiles(ActionFile)
            end
        elseif ActionFile:IsA("ModuleScript") then
            local PreCompiledActionDataSet = require(ActionFile)
            for ActionDataSetName, ActionDataSet in pairs(PreCompiledActionDataSet) do
                if not ActionDataSet.Config then
                    ActionDataSet.Config = {
                        Rarity = "Common"
                    }
                end
                ActionDictionary[ActionDataSetName] = ActionDataSet
            end
        end
    end
end

-- an ActionFile is a folder that contains children that are all child actions of the file.
-- for example, Greatsword is an ActionFile, and it contains all the actions that are children of Greatsword. this includes the Greatsword's children, such as GreatswordSwing, but also common
-- actions, like an Equip or Unequip action. some common actions are injected automatically if not found in the ActionFile.
function CompileActionFileToActionDataSet(ActionFile)
    if not ActionFile:FindFirstChild("Assets") and not ActionFile:FindFirstChild("Techniques") then
        return
    end

    local ActionDataSet = {
        Name = ActionFile.Name,
        Actions = {},
        Assets = {}
    }
    local ChildActions = ActionFile:GetDescendants()
    local AssetDirectory = game.ServerStorage.Assets:FindFirstChild(ActionFile.Name)

    local function AddAction(ActionName, ActionData)
        ActionDataSet.Actions[ActionName] = ActionData
    end

    local function AddAsset(AssetName, AssetData)
        ActionDataSet.Assets[AssetName] = AssetData
    end

    local function HandleModule(ModuleScript)
        local ActionData = require(ModuleScript)
        if ModuleScript.Parent.Name == "Assets" then
            AddAsset(ModuleScript.Name, ActionData)
        elseif ModuleScript.Name == "Config" then
            ActionDataSet.Config = ActionData
        else
            AddAction(ModuleScript.Name, ActionData)
        end
    end

    for _, ChildAction in pairs(ChildActions) do
        if ChildAction:IsA("ModuleScript") then
            HandleModule(ChildAction)
        end
    end
    if not ActionDataSet.Config then
        ActionDataSet.Config = {
            Rarity = "Common"
        }
    end
    if AssetDirectory then
        for _, Asset in pairs(AssetDirectory:GetChildren()) do
            AddAsset(Asset.Name, Asset)
        end
    end

    return ActionDataSet
end

local function GetActionDataSet(ActionDataSetName)
    return ActionDictionary[ActionDataSetName]
end

CompileActionFiles(script)

ActionDictionary.GetActionDataSet = GetActionDataSet

return ActionDictionary