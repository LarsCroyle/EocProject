local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(ActionName)
    return ActionDictionary.GetActionDataSet(ActionName)
end