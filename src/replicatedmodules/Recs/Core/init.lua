local Recs = {
	Workshop = require(script.Workshop),
	Entity = require(script.Entity),
	System = require(script.SystemBase),
	EntityMatchesTagMethod = require(script.EntityMatchesTagMethod),
	TagQueryMethod = require(script.TagQueryMethod),
	SystemsInvokeMethod = require(script.SystemsInvokeMethod)
}

local Access = require(script.Parent.Access)
local Workshop = Recs.Workshop.new(Recs)

Access.AddWorkshop(Workshop)
Recs.Workshop = Workshop

return Recs