-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WishlistService.LocalWishlistStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utils = require(ReplicatedStorage.Util.Utils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local WeaponService = require(ReplicatedStorage.Remote.WeaponService)
local CommonWishlistStore = require(ReplicatedStorage.Common.WishlistService.CommonWishlistStore)
local v1 = script.Parent
local v2 = setmetatable({}, CommonWishlistStore)
v2.__index = v2
v2.WeaponStore = WeaponService.LocalWeaponStore
function v2.Add(p1, p2, p3) --[[ Add | Line: 17 | Upvalues: CommonWishlistStore (copy), Utils (copy), v1 (copy), ResultUtils (copy) ]]
	if not (p3 and p3.Remote) then
		if CommonWishlistStore.Add(p1, p2, {
			Test = true
		}) then
			local v12, v2 = Utils.pcall(function() --[[ Line: 22 | Upvalues: v1 (ref), p2 (copy) ]]
				return v1.SetWish:InvokeServer(p2, true)
			end)
			if not (v12 and v2) and v12 then
				return
			elseif not (v12 and v2) then
				return ResultUtils.error(v2)
			end
		else
			return
		end
	end
	return CommonWishlistStore.Add(p1, p2)
end
function v2.Remove(p1, p2, p3) --[[ Remove | Line: 35 | Upvalues: CommonWishlistStore (copy), Utils (copy), v1 (copy), ResultUtils (copy) ]]
	if not (p3 and p3.Remote) then
		if CommonWishlistStore.Remove(p1, p2, {
			Test = true
		}) then
			local v12, v2 = Utils.pcall(function() --[[ Line: 40 | Upvalues: v1 (ref), p2 (copy) ]]
				return v1.SetWish:InvokeServer(p2)
			end)
			if not (v12 and v2) and v12 then
				return
			elseif not (v12 and v2) then
				return ResultUtils.error(v2)
			end
		else
			return
		end
	end
	return CommonWishlistStore.Remove(p1, p2)
end
return v2