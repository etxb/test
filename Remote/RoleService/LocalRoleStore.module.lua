-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RoleService.LocalRoleStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonRoleStore = require(ReplicatedStorage.Common.RoleService.CommonRoleStore)
local v1 = setmetatable({}, CommonRoleStore)
v1.__index = v1
function v1.SelectRole(p1, p2, p3) --[[ SelectRole | Line: 10 | Upvalues: CommonRoleStore (copy) ]]
	if p3 and p3.Server then
		return CommonRoleStore.SelectRole(p1, p2)
	elseif CommonRoleStore.SelectRole(p1, p2, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 18 | Upvalues: p2 (copy) ]]
			return script.Parent.SelectRole:InvokeServer(p2)
		end)
		if v1 and v2 then
			return CommonRoleStore.SelectRole(p1, p2)
		end
	end
end
function v1.SetWrap(p1, p2, p3, p4) --[[ SetWrap | Line: 28 | Upvalues: CommonRoleStore (copy) ]]
	if p4 and p4.Server then
		return CommonRoleStore.SetWrap(p1, p2, p3)
	elseif CommonRoleStore.SetWrap(p1, p2, p3, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 35 | Upvalues: p2 (copy), p3 (copy) ]]
			return script.Parent.SetWrap:InvokeServer(p2, p3)
		end)
		if v1 and v2 then
			return CommonRoleStore.SetWrap(p1, p2, p3)
		else
			print("set wrap remote false")
		end
	end
end
function v1.SetSkin(p1, p2, p3, p4) --[[ SetSkin | Line: 45 | Upvalues: CommonRoleStore (copy) ]]
	if p4 and p4.Server then
		return CommonRoleStore.SetSkin(p1, p2, p3)
	elseif CommonRoleStore.SetSkin(p1, p2, p3, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 52 | Upvalues: p2 (copy), p3 (copy) ]]
			return script.Parent.SetSkin:InvokeServer(p2, p3)
		end)
		if v1 and v2 then
			return CommonRoleStore.SetSkin(p1, p2, p3)
		end
	end
end
return v1