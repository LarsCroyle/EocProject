local AccessModule = {}

function AccessModule.AddWorkshop(Workshop)
	AccessModule.Workshop = Workshop
end

function AccessModule.GetWorkshop()
	return AccessModule.Workshop
end

function AccessModule.GetEntity(EntityName)
	return AccessModule.Workshop:GetEntity(EntityName)
end

return AccessModule