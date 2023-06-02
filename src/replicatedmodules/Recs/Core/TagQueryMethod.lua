return function(Workshop, Tag)
	local TaggedEntities = {}
	for _, Entity in Workshop:GetEntities() do
		local PassedEqualityTest = Workshop.Recs.EntityMatchesTagMethod(Entity, Tag)
		if PassedEqualityTest then
			table.insert(TaggedEntities, Entity)
		end
	end
	return TaggedEntities
end