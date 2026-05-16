-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EquipmentService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("ServerScriptService")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Config.WeaponConfig)
require(ReplicatedStorage.Config.ItemConfig)
require(ReplicatedStorage.Util.Utils)
require(ReplicatedStorage.Util.TableUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local WeaponService = require(ReplicatedStorage.Remote.WeaponService)
local LocalEquipmentStore = require(script.LocalEquipmentStore)
LocalEquipmentStore.WeaponStore = WeaponService.LocalWeaponStore
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalEquipmentStore = LocalEquipmentStore
}
function t2.WaitInit() --[[ WaitInit | Line: 31 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 38 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.GetEquipment(...) --[[ GetEquipment | Line: 46 | Upvalues: LocalEquipmentStore (copy) ]]
	return LocalEquipmentStore:GetEquipment(...)
end
function t2.SetEquip(...) --[[ SetEquip | Line: 50 | Upvalues: LocalEquipmentStore (copy) ]]
	return LocalEquipmentStore:SetEquip(...)
end
function t2.Start() --[[ Start | Line: 54 | Upvalues: LocalEquipmentStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 55 | Upvalues: LocalEquipmentStore (ref), t2 (ref), t (ref) ]]
		if LocalEquipmentStore.Data or not p2 then
			if LocalEquipmentStore.Data then
				local Id = p1.Id
				if Id and p1.SetEquip then
					for v1, v2 in p1.SetEquip do
						LocalEquipmentStore:SetEquip(Id, v1, v2, {
							Server = true
						})
					end
				end
			end
		else
			LocalEquipmentStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return t2