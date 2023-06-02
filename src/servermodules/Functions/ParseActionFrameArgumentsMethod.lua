local TableUtil = require(game.ReplicatedStorage.Modules.Packages.TableUtil)

return function(ParseReference, Arguments)
    local Parser = {
        ["__Attacker"] = ParseReference["Attacker"],
        ["__Target"] = ParseReference["Target"],
        ["__ToolName"] = ParseReference["ToolName"],
        ["__RootPart"] = function()
            if ParseReference["Attacker"] then
                return ParseReference["Attacker"]:FindFirstChild("HumanoidRootPart")
            end
        end,
        ["__RootPart.CFrame"] = function()
            if ParseReference["Attacker"] then
                return ParseReference["Attacker"]:FindFirstChild("HumanoidRootPart").CFrame
            end
        end,
        ["__TargetRootPart"] = function()
            if ParseReference["Target"] then
                return ParseReference["Target"]:FindFirstChild("HumanoidRootPart")
            end
        end,
        ["__TargetRootPart.CFrame"] = function()
            if ParseReference["Target"] then
                return ParseReference["Target"]:FindFirstChild("HumanoidRootPart").CFrame
            end
        end,
        ["__Weapon.CFrame"] = function()
            local Attacker = ParseReference["Attacker"]
            local ToolName = ParseReference["ToolName"]

            if Attacker and ToolName then
                local Tool = Attacker:FindFirstChild(ToolName, true)

                if Tool then
                    return Tool.CFrame
                end
            end
        end,
        ["__Weapon.Size"] = function()
            local Attacker = ParseReference["Attacker"]
            local ToolName = ParseReference["ToolName"]
            if Attacker and ToolName then
                local Tool = Attacker:FindFirstChild(ToolName, true)

                if Tool then
                    return Tool.Size
                end
            end
        end
    }
    if typeof(Arguments) == "table" then
        Arguments = TableUtil.Copy(Arguments)
        for Index, Argument in pairs(Arguments) do
            if typeof(Argument) == "string" then
                local Reference = Parser[Argument]
                if typeof(Reference) == "function" then
                    Arguments[Index] = Reference()
                elseif Reference then
                    Arguments[Index] = Reference
                end
            end
        end
    elseif typeof(Arguments) == "string" then
        local Reference = Parser[Arguments]
        if typeof(Reference) == "function" then
            Arguments = Reference()
        elseif Reference then
            Arguments = Reference
        end
    end
    return Arguments
end