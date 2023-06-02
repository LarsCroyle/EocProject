local RunClientDictionary = {}

for _, ModuleScript in ipairs(script:GetDescendants()) do
    if not ModuleScript:IsA("ModuleScript") then
        continue
    end
    RunClientDictionary[ModuleScript.Name] = require(ModuleScript)
end

return RunClientDictionary