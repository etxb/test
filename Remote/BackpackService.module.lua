-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.BackpackService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("ServerScriptService")
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
require(ReplicatedStorage.Config.ItemConfig)
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local WeaponService = require(ReplicatedStorage.Remote.WeaponService)
local ItemService = require(ReplicatedStorage.Remote.ItemService)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
require(ReplicatedStorage.Remote.PermissionService)
local v1 = nil
local v2 = SimpleSignal.new()
local v3 = SimpleSignal.new()
local t = {
	Inited = false,
	DataInited = v2,
	DataUpdated = v3,
	BackpackChanged = SimpleSignal.new(),
	GetBackpacks = function() --[[ GetBackpacks | Line: 33 | Upvalues: v1 (ref) ]]
		return v1 and v1.Backpacks
	end
}
function t.GetBackpack(p1) --[[ GetBackpack | Line: 37 | Upvalues: t (copy) ]]
	local v1 = t.GetBackpacks()
	if p1 then
		if #v1 < p1 then
			for i = #v1 + 1, p1 do
				table.insert(v1, {})
			end
		end
		return if v1 then v1[p1] else v1
	else
		return v1
	end
end
local function equipCharm(p1, p2, p3, p4) --[[ equipCharm | Line: 50 ]] end
local function v4(p1, p2, p3, p4, p5) --[[ setEquip | Line: 54 | Upvalues: t (copy), WeaponService (copy), v4 (copy), v3 (copy) ]]
	local v1 = if p5 then p5 else {}
	local v2 = t.GetBackpack(p1)
	local v32 = WeaponService.GetContent()
	local v42 = v2[p2]
	local v5
	if v1.Charm then
		local v6
		if p3 then
			v6 = p3
			v5 = v1
		else
			v6 = v1.Charm.Key
			v5 = v1
		end
		local v7 = v32[v6]
		local v8 = if v7 then v7.EquippedOn and v7.EquippedOn.Key else v7
		local v9 = if v8 then if p3 then p3 else v5.Charm.Key or nil else v8
		if v9 then
			WeaponService.SetBackpack(v9, nil, nil, v5)
		end
		v42 = v9
		local v10 = v32[v2[v5.Charm.CharmSlot]]
		local v11 = if v10 then v10.Charm else v10
		if v11 then
			for v12, v13 in v11 do
				if v13.Index == v5.Charm.CharmIndex then
					v42 = v12
					break
				end
			end
		end
	else
		v5 = v1
	end
	if v42 or p3 then
		if v42 and not p4 then
			WeaponService.SetBackpack(v42, nil, nil, v5)
		end
		if p3 and not p4 then
			local v14 = WeaponService.GetContent()[p3]
			if v14 and v14.EquippedOn then
				v4(v14.EquippedOn.Id, v14.EquippedOn.Slot)
			end
			v5.Backpack = v5.Charm and v2
			WeaponService.SetBackpack(p3, p1, p2, v5)
		end
		v2[p2] = p3
		local t2 = {}
		if p3 then
			t2[p3] = true
		end
		if v42 then
			t2[v42] = true
		end
		v3:Fire(p1, {
			UpdateEquip = true,
			UpdateSlot = p2,
			UpdateKeys = t2
		})
	end
end
function t.TryEquip(p1, p2, p3, p4) --[[ TryEquip | Line: 107 | Upvalues: Constant (copy), WeaponService (copy), WeaponConfig (copy), ResultUtils (copy), v4 (copy) ]]
	if Constant.EquipmentSlot[p2] then
		local v1 = WeaponService.GetContent()[p3]
		if v1 then
			local v2 = WeaponConfig[v1.Name]
			if v2 then
				if not v2:HasTag(Constant.WeaponTag.Accessory) then
					local v3 = WeaponConfig.GetFamilyBaseWeapon(v2.Family)
					if WeaponService.IsBaseWeaponNeedly(v2) and WeaponService.GetWeaponCount(v3) == 0 then
						local v42 = WeaponConfig[v3]
						if v42 then
							return ResultUtils.failed(Constant.Message.Equipment.UnownedBaseWeapon:format(v42.Display))
						else
							return
						end
					end
				end
				local v5, v6 = pcall(function() --[[ Line: 131 | Upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy) ]]
					return script.TryEquip:InvokeServer(p1, p2, p3, p4)
				end)
				if v5 and v6 == true then
					v4(p1, p2, p3, nil, p4)
					return ResultUtils.success()
				else
					return v5 and v6
				end
			end
		end
	end
end
function t.TryUnequip(p1, p2, p3) --[[ TryUnequip | Line: 141 | Upvalues: Constant (copy), t (copy), Utils (copy), v4 (copy), ResultUtils (copy) ]]
	if Constant.EquipmentSlot[p2] and (t.GetBackpack(p1)[p2] or p3 and p3.Charm) then
		local v1, v2 = Utils.NonBlockingRemoteInvoke(script.TryUnequip, p1, p2, p3)
		if v1 and v2 == true then
			v4(p1, p2, nil, nil, p3)
			return ResultUtils.success()
		end
	end
end
function t.IsUnlocked(p1) --[[ IsUnlocked | Line: 157 | Upvalues: Config (copy), ItemService (copy) ]]
	return not Config.Backpack.Locked[p1] or ItemService.Has(Config.Backpack.Locked[p1])
end
function t.GetBackpackIdSelected() --[[ GetBackpackIdSelected | Line: 161 | Upvalues: StatusService (copy), Constant (copy), Config (copy) ]]
	local v1 = StatusService.GetStatus(Constant.Status.Backpack) or 1
	return math.clamp(v1, 1, Config.Backpack.Count)
end
function t.SelectBackpack(p1, p2) --[[ SelectBackpack | Line: 170 | Upvalues: Config (copy), StatusService (copy), Constant (copy) ]]
	if typeof(p1) == "number" then
		local v1 = math.clamp(p1, 1, Config.Backpack.Count)
		if v1 ~= StatusService.GetStatus(Constant.Status.Backpack) then
			StatusService.SetStatus(Constant.Status.Backpack, v1)
			script.SetBackpack:FireServer(v1, p2)
		end
	end
end
function t.WaitInit() --[[ WaitInit | Line: 182 | Upvalues: t (copy), v2 (copy) ]]
	if not t.Inited then
		v2:Wait()
	end
	return t
end
function t.OnInit(p1) --[[ OnInit | Line: 189 | Upvalues: t (copy), v2 (copy) ]]
	if t.Inited then
		p1()
	else
		v2:Connect(p1)
	end
end
function t.Start() --[[ Start | Line: 199 | Upvalues: v1 (ref), t (copy), v2 (copy), TableUtils (copy), Constant (copy), v3 (copy), v4 (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 200 | Upvalues: v1 (ref), t (ref), v2 (ref), TableUtils (ref), Constant (ref), v3 (ref), v4 (ref) ]]
		if v1 or not p2 then
			if v1 and p1.Id then
				local Id = p1.Id
				local _ = v1.Backpacks[Id]
				if p1.Backpack then
					local v12 = v1.Backpacks[Id] or TableUtils.empty()
					local v22 = p1.Backpack or {}
					v1.Backpacks[Id] = v22
					local v32 = v22
					for v42, v5 in Constant.EquipmentSlot do
						if v12[v42] ~= v32[v42] then
							local t2 = {}
							if v12[v42] then
								t2[v12[v42]] = true
							end
							if v32[v42] then
								t2[v32[v42]] = true
							end
							v3:Fire(Id, {
								UpdateEquip = true,
								UpdateSlot = v42,
								UpdateKeys = t2
							})
						end
					end
				elseif p1.SetEquip then
					for v6, v7 in p1.SetEquip do
						v4(Id, v6, v7)
					end
				elseif p1.SetUnequip then
					for v8, v9 in p1.SetUnequip do
						v4(Id, v8)
					end
				end
			end
		else
			v1 = p1
			t.Inited = true
			v2:Fire()
		end
	end)
end
return t