local SystemsBase = {}
SystemsBase.__index = SystemsBase

function SystemsBase.new(SystemPassIn)
	--return setmetatable({
	--	Tag = {"ComponentName1", "ComponentName2", "Etc"},
	--	SystemType = {"Constant", "Or", "Reactive"}
	--}, SystemsBase)
	return setmetatable(SystemPassIn, SystemsBase)
end

function SystemsBase:TaggedEntityAdded(TaggedEntity)
end

function SystemsBase:Update(DeltaTime)
end

function SystemsBase:Boot(Workshop)
end

return SystemsBase