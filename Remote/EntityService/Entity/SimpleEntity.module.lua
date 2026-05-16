-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.Entity.SimpleEntity

-- https://lua.expert/
local v2 = setmetatable({}, (require(script.Parent)))
v2.__index = v2
function v2.GetRootPart(p1) --[[ GetRootPart | Line: 7 ]]
	return p1.Instance
end
function v2.GetWorkspaceRoot(p1) --[[ GetWorkspaceRoot | Line: 11 ]]
	return p1.Instance.Parent
end
return v2