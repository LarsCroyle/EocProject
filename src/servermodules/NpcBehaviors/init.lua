local NpcBehaviorDictionary = {}

local function CompileNpcBehaviorFileToNpcBehaviorDataSet(NpcBehaviorFile)
    local NpcBehaviorDataSet = {
        Name = NpcBehaviorFile.Name,
        Behavior = require(NpcBehaviorFile)
    }

    return NpcBehaviorDataSet
end

local function GetNpcBehaviorDataSet(NpcBehaviorDataSetName)
    return NpcBehaviorDictionary[NpcBehaviorDataSetName]
end

local function CompileNpcBehaviorFiles()
    if NpcBehaviorDictionary.Compiled then
        return
    end
    for _, NpcBehaviorFile in pairs(script:GetChildren()) do
        if NpcBehaviorFile:IsA("ModuleScript") then
            NpcBehaviorDictionary[NpcBehaviorFile.Name] = CompileNpcBehaviorFileToNpcBehaviorDataSet(NpcBehaviorFile)
        end
    end
    NpcBehaviorDictionary.Compiled = true
end

CompileNpcBehaviorFiles()

NpcBehaviorDictionary.GetNpcBehaviorDataSet = GetNpcBehaviorDataSet

return NpcBehaviorDictionary