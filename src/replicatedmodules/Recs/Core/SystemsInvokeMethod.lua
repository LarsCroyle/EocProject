return function(Workshop, Systems, TagQueryMethod, DeltaTime)
	for _, System in Systems do
		local Tag = System.Tag
		if not Tag.Name then
			Tag.Name = System.Name
		end
		if table.find(Tag, "TAG_NO_TAG") then
			continue
		end
		if table.find(Tag, "Diagnostics") then
			task.spawn(System.Update, System, Workshop.Entities, DeltaTime)
			continue
		end
		local TaggedEntities = TagQueryMethod(Workshop, Tag)

		if not TaggedEntities then
			TaggedEntities = {}
		end

		task.spawn(System.Update, System, TaggedEntities, DeltaTime)
		--System:Update(TaggedEntities, DeltaTime)
	end
end