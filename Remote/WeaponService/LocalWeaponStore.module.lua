-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WeaponService.LocalWeaponStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonWeaponStore = require(ReplicatedStorage.Common.WeaponService.CommonWeaponStore)
local v1 = setmetatable({}, CommonWeaponStore)
v1.__index = v1
v1.Index = {}
function v1.SetWrap(p1, p2, p3) --[[ SetWrap | Line: 12 | Upvalues: CommonWeaponStore (copy) ]]
	if CommonWeaponStore.SetWrap(p1, p2, p3, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 16 | Upvalues: p2 (copy), p3 (copy) ]]
			return script.Parent.SetWrap:InvokeServer(p2, p3)
		end)
		if v1 and v2 then
			return CommonWeaponStore.SetWrap(p1, p2, p3)
		end
	end
end
function v1.SetSkin(p1, p2, p3) --[[ SetSkin | Line: 25 | Upvalues: CommonWeaponStore (copy) ]]
	if CommonWeaponStore.SetSkin(p1, p2, p3, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 29 | Upvalues: p2 (copy), p3 (copy) ]]
			return script.Parent.SetSkin:InvokeServer(p2, p3)
		end)
		if v1 and v2 then
			return CommonWeaponStore.SetSkin(p1, p2, p3)
		end
	end
end
function v1.SetLock(p1, p2, p3) --[[ SetLock | Line: 38 | Upvalues: CommonWeaponStore (copy) ]]
	if CommonWeaponStore.SetLock(p1, p2, p3, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 42 | Upvalues: p2 (copy), p3 (copy) ]]
			return script.Parent.SetLock:InvokeServer(p2, p3)
		end)
		if v1 and v2 then
			return CommonWeaponStore.SetLock(p1, p2, p3)
		end
	end
end
function v1.SetFavorite(p1, p2, p3) --[[ SetFavorite | Line: 51 | Upvalues: CommonWeaponStore (copy) ]]
	if CommonWeaponStore.SetFavorite(p1, p2, p3, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 55 | Upvalues: p2 (copy), p3 (copy) ]]
			return script.Parent.SetFavorite:InvokeServer(p2, p3)
		end)
		if v1 and v2 then
			return CommonWeaponStore.SetFavorite(p1, p2, p3)
		end
	end
end
return v1