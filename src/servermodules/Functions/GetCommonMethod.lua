local Common = game.ServerStorage.Modules.Common
return function(ActionName)
    if not ActionName then
        return
    end
    local FrameArgumentFunctionModule = Common:FindFirstChild(ActionName)
    return require(FrameArgumentFunctionModule)
end