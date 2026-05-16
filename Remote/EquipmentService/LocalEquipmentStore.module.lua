-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EquipmentService.LocalEquipmentStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonEquipmentStore = require(ReplicatedStorage.Common.EquipmentService.CommonEquipmentStore)
local v1 = setmetatable({}, CommonEquipmentStore)
v1.__index = v1
function v1.SetEquip(p1, p2, p3, p4, p5) --[[ SetEquip | Line: 10 | Upvalues: CommonEquipmentStore (copy) ]]
	if p5 and p5.Server then
		return CommonEquipmentStore.SetEquip(p1, p2, p3, p4)
	elseif CommonEquipmentStore.SetEquip(p1, p2, p3, p4, {
		Test = true
	}) then
		local v1, v2 = pcall(function() --[[ Line: 18 | Upvalues: p2 (copy), p3 (copy), p4 (copy) ]]
			return script.Parent.SetEquip:InvokeServer(p2, p3, p4)
		end)
		if v1 and v2 then
			return CommonEquipmentStore.SetEquip(p1, p2, p3, p4)
		end
	end
end
return v1