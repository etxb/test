-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.CombatService.CombatDataContainer

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local _ = {
	WeaponMessage = SimpleSignal.new(),
	WeaponDataUpdated = SimpleSignal.new(),
	WeaponChanged = SimpleSignal.new(),
	WeaponsChanged = SimpleSignal.new(),
	SlotSwitched = SimpleSignal.new()
}
local _2 = {
	WeaponMessage = SimpleSignal.new(),
	WeaponDataUpdated = SimpleSignal.new(),
	WeaponChanged = SimpleSignal.new(),
	WeaponsChanged = SimpleSignal.new(),
	SlotSwitchPre = SimpleSignal.new(),
	SlotSwitched = SimpleSignal.new()
}
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 26 | Upvalues: Constant (copy) ]]
	return setmetatable({
		Weapons = {},
		Slot = Constant.EquipmentSlot.Primary
	}, p1)
end
return t