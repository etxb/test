-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WeaponService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
require(ReplicatedStorage.Config.ItemConfig)
require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local TableUtil = require(ReplicatedStorage.Shared.RbxUtil.TableUtil)
local RewardHelper = require(ReplicatedStorage.Common.RewardHelper)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local NetworkHelper = require(ReplicatedStorage.Common.NetworkHelper)
require(ReplicatedStorage.Remote.ItemService)
local WrapService = require(ReplicatedStorage.Remote.WrapService)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
local PermissionService = require(ReplicatedStorage.Remote.PermissionService)
local PlayerMarketService = require(ReplicatedStorage.Remote.PlayerMarketService)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new(),
	GlobalCountUpdated = SimpleSignal.new()
}
local LocalWeaponStore = require(script.LocalWeaponStore)
LocalWeaponStore.WrapStore = WrapService.LocalWrapStore
local v2 = setmetatable({
	Inited = false,
	GlobalCountReady = false,
	Event = t,
	LocalWeaponStore = LocalWeaponStore
}, require(ReplicatedStorage.Common.WeaponService))
local v3 = TableUtils.AutoTable()
local v4 = TableUtils.AutoTable()
function v2.WaitInit() --[[ WaitInit | Line: 49 | Upvalues: v2 (copy), t (copy) ]]
	if not v2.Inited then
		t.DataInited:Wait()
	end
	return v2
end
function v2.OnInit(p1) --[[ OnInit | Line: 56 | Upvalues: v2 (copy), t (copy) ]]
	if v2.Inited then
		p1()
	else
		t.DataInited:Once(p1)
	end
end
function v2.WaitGlobalCountReady() --[[ WaitGlobalCountReady | Line: 64 | Upvalues: v2 (copy), t (copy) ]]
	if not v2.GlobalCountReady then
		t.GlobalCountUpdated:Wait()
	end
	return v2
end
function v2.OnGlobalCountReady(p1) --[[ OnGlobalCountReady | Line: 71 | Upvalues: v2 (copy), t (copy) ]]
	if v2.GlobalCountReady then
		p1()
	else
		t.GlobalCountUpdated:Once(p1)
	end
end
function v2.GetContent() --[[ GetContent | Line: 79 | Upvalues: LocalWeaponStore (copy) ]]
	return LocalWeaponStore:GetContent()
end
function v2.GetWeapon(p1) --[[ GetWeapon | Line: 83 | Upvalues: LocalWeaponStore (copy) ]]
	return LocalWeaponStore:GetWeapon(p1)
end
function v2.Unlock(p1) --[[ Unlock | Line: 87 | Upvalues: StatusService (copy), Constant (copy), Config (copy), ResultUtils (copy), WeaponConfig (copy) ]]
	local v1 = StatusService.GetStatus(Constant.Status.Killed)
	local v2 = Config.Weapon.KilledUnlock[p1]
	if v2 and not (v1 < v2) then
		local v3, v4 = pcall(function() --[[ Line: 93 | Upvalues: p1 (copy) ]]
			return script.Unlock:InvokeServer(p1)
		end)
		if v3 then
			if v4 then
				return ResultUtils.success(Constant.Message.Weapon.UnlockSuccess:format(WeaponConfig[p1].Display), {
					WeaponKey = v4
				})
			end
		else
			return ResultUtils.error(v4)
		end
	end
end
function v2.HasWeapon(...) --[[ HasWeapon | Line: 108 | Upvalues: LocalWeaponStore (copy) ]]
	return LocalWeaponStore:GetWeapon(...) and true
end
function v2.SetWrap(...) --[[ SetWrap | Line: 112 ]] end
function v2.SetLock(...) --[[ SetLock | Line: 116 | Upvalues: LocalWeaponStore (copy) ]]
	return LocalWeaponStore:SetLock(...)
end
function v2.SetFavorite(...) --[[ SetFavorite | Line: 120 | Upvalues: LocalWeaponStore (copy) ]]
	return LocalWeaponStore:SetFavorite(...)
end
function v2.Sell(p1) --[[ Sell | Line: 124 | Upvalues: LocalWeaponStore (copy), v2 (copy), ResultUtils (copy), Constant (copy) ]]
	if #p1 == 0 then
	else
		local v1 = LocalWeaponStore:GetContent()
		local t = {}
		for v22, v3 in p1 do
			local v4 = v1[v3]
			if not v4 or (not v2.CanSell(v4) or t[v3]) then
				return
			end
			t[v3] = true
		end
		local v5, v6 = pcall(function() --[[ Line: 140 | Upvalues: p1 (copy) ]]
			return script.Sell:InvokeServer(p1)
		end)
		if v5 then
			if v6 then
				LocalWeaponStore:Remove(p1)
				return ResultUtils.success(Constant.Message.Weapon.SellSuccess, v6)
			end
		else
			return ResultUtils.error(v6)
		end
	end
end
function v2.SetBackpack(p1, p2, p3, p4) --[[ SetBackpack | Line: 155 | Upvalues: v2 (copy), WeaponConfig (copy), Constant (copy), t (copy) ]]
	local v1 = v2.GetContent()
	local v22 = if v1 then v1[p1] else v1
	if v22 and (v22.EquippedOn or p2) then
		if p4 and p4.Charm then
			local v3 = v1[p1]
			local v4 = v3 and v3.EquippedOn and v3.EquippedOn.Key or p4.Backpack[p4.Charm.CharmSlot]
			local v5 = v1[v4]
			if not v5.Charm then
				v5.Charm = {}
			end
			local v6 = p4.Charm.CharmIndex or v5.Charm[p1] and v5.Charm[p1].Index
			local v7 = WeaponConfig[v5.Name]
			if v7 and (v7.CharmSlotCount and not (p2 and v7.CharmSlotCount < (v6 or 0))) then
				v5.Charm[p1] = p2 and {
					Index = v6,
					Name = v3.Name
				} or nil
				v22.EquippedOn = p2 and {
					Id = p2,
					Slot = Constant.EquipmentSlot.Charm,
					Key = v4
				} or nil
			else
				return
			end
		else
			v22.EquippedOn = p2 and {
				Id = p2,
				Slot = p3
			} or nil
		end
		t.DataUpdated:Fire({
			UpdateEquip = true,
			Content = {
				[p1] = v22
			}
		})
		return true
	end
end
function v2.CalcPrice(p1) --[[ CalcPrice | Line: 191 | Upvalues: PermissionService (copy), Constant (copy), Config (copy) ]]
	if PermissionService.HasPermission(Constant.Permission.VIP) then
		return p1 * (1 + Config.VIP.WeaponSellExtraRate)
	else
		return p1
	end
end
function v2.IsBaseWeaponNeedly(p1, p2) --[[ IsBaseWeaponNeedly | Line: 198 | Upvalues: Constant (copy) ]]
	if p1 then
		if p1:HasTag(Constant.WeaponTag.Accessory) or p1:HasTag(Constant.WeaponTag.BaseWeapon) and not p2 then
			return false
		else
			return if p1.WeaponType == Constant.WeaponType.Sniper then p1.BaseWeaponNeedly else false
		end
	else
		return true
	end
end
local function track(p1, p2, p3, p4) --[[ track | Line: 208 | Upvalues: WeaponConfig (copy), v4 (copy), v3 (copy) ]]
	local v1 = WeaponConfig[p2.Name]
	if v1 then
		local v2 = if p3 then nil else true
		if p4 then
			print("tack", v1.Name, p2, v2)
		end
		v4[v1.Name][p1] = v2
		if v1 then
			if v1.Family then
				v3[v1.Family][p1] = v2
			end
			if not v1.SecondFamily then
				return
			end
			v3[v1.SecondFamily][p1] = v2
		end
	end
end
function v2.Start() --[[ Start | Line: 230 | Upvalues: v2 (copy), LocalWeaponStore (copy), WeaponConfig (copy), v4 (copy), v3 (copy), t (copy), NetworkHelper (copy) ]]
	task.spawn(function() --[[ Line: 231 | Upvalues: v2 (ref) ]]
		v2.GetGlobalCount()
	end)
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 235 | Upvalues: LocalWeaponStore (ref), v2 (ref), WeaponConfig (ref), v4 (ref), v3 (ref), t (ref) ]]
		if LocalWeaponStore.Data or not p2 then
			if LocalWeaponStore.Data then
				if p1.Add then
					for v1, v22 in p1.Add do
						local v32 = WeaponConfig[v22.Name]
						if v32 then
							v4[v32.Name][v1] = true
							if v32 then
								if v32.Family then
									v3[v32.Family][v1] = true
								end
								if v32.SecondFamily then
									v3[v32.SecondFamily][v1] = true
								end
							end
						end
					end
					LocalWeaponStore:AddMore(p1.Add)
				end
				if p1.Remove then
					local v42 = LocalWeaponStore:Remove(p1.Remove)
					for v5, v6 in v42 do
						local v7 = WeaponConfig[v6.Name]
						if v7 then
							v4[v7.Name][v5] = nil
							if v7 then
								if v7.Family then
									v3[v7.Family][v5] = nil
								end
								if v7.SecondFamily then
									v3[v7.SecondFamily][v5] = nil
								end
							end
						end
					end
					p1.Removed = v42
				end
				t.DataUpdated:Fire(p1)
			end
		else
			LocalWeaponStore.Data = p1
			v2.Inited = true
			for v8, v9 in p1.Content do
				local _ = WeaponConfig[v9.Name]
				local v10 = WeaponConfig[v9.Name]
				if v10 then
					v4[v10.Name][v8] = true
					if v10 then
						if v10.Family then
							v3[v10.Family][v8] = true
						end
						if v10.SecondFamily then
							v3[v10.SecondFamily][v8] = true
						end
					end
				end
				LocalWeaponStore:UpdateIndex(v9.Name, v8)
			end
			t.DataInited:Fire()
		end
	end)
	script.SetData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 271 | Upvalues: LocalWeaponStore (ref) ]]
		if LocalWeaponStore.Data then
			LocalWeaponStore:SetCustomData(p1, p2)
		end
	end)
	NetworkHelper.Packets.WeaponService.Packets.packets.SetStat.listen(function(p1) --[[ Line: 276 | Upvalues: LocalWeaponStore (ref) ]]
		for v1, v2 in p1 do
			for v3, v4 in v2.Changed do
				LocalWeaponStore:SetStat(v2.Key, v3, v4)
			end
		end
	end)
end
function v2.GetKeysByFamily(p1) --[[ GetKeysByFamily | Line: 285 | Upvalues: v3 (copy), TableUtils (copy) ]]
	return rawget(v3, p1) or TableUtils.empty()
end
function v2.GetKeysByName(p1) --[[ GetKeysByName | Line: 289 | Upvalues: v4 (copy), TableUtils (copy) ]]
	return rawget(v4, p1) or TableUtils.empty()
end
function v2.GetWeaponCount(p1) --[[ GetWeaponCount | Line: 293 | Upvalues: LocalWeaponStore (copy) ]]
	return LocalWeaponStore:GetCountByName(p1)
end
RewardHelper.RegisterValidater("Weapon", function(p1) --[[ Line: 297 | Upvalues: WeaponConfig (copy) ]]
	return WeaponConfig[p1.Weapon] and true
end)
ConditionHelper.RegisterCondition("Weapon", function(p1) --[[ Line: 301 | Upvalues: v2 (copy), LocalWeaponStore (copy) ]]
	local Weapon = p1.Weapon
	if Weapon then
		v2.WaitInit()
		local v1 = LocalWeaponStore:GetCountByName(Weapon) > 0
		if p1.Unowned then
			return not v1
		else
			return v1
		end
	end
end)
PlayerMarketService.SetProductHandler("Weapon", {
	OnListingPre = function(p1) --[[ OnListingPre | Line: 316 | Upvalues: v2 (copy), PlayerMarketService (copy) ]]
		local v1 = nil
		if typeof(p1) == "string" then
			v1 = p1
		elseif typeof(p1) == "table" then
			v1 = p1.WeaponKey
		end
		if v1 then
			local v22 = v2.GetContent()
			local v3 = if v22 then v22[v1] else v22
			if v3 and v2.CanTrade(v3) then
				if PlayerMarketService.Search("Weapon", v1) then
				else
					return true
				end
			end
		end
	end,
	OnListing = function(p1) --[[ OnListing | Line: 342 | Upvalues: v2 (copy), LocalWeaponStore (copy) ]]
		local v1 = v2.GetContent()
		if if v1 then v1[p1.WeaponKey] else v1 then
			if not LocalWeaponStore.WeaponSearch then
				LocalWeaponStore.WeaponSearch = {}
			end
			LocalWeaponStore.WeaponSearch[p1.WeaponKey] = p1
			return true
		end
	end,
	OnListingRemove = function(p1) --[[ OnListingRemove | Line: 355 | Upvalues: LocalWeaponStore (copy) ]]
		if LocalWeaponStore.WeaponSearch then
			LocalWeaponStore.WeaponSearch[p1.WeaponKey] = nil
		end
	end,
	OnPurchasePre = function(p1, p2) --[[ OnPurchasePre | Line: 360 | Upvalues: LocalWeaponStore (copy), Constant (copy) ]]
		return LocalWeaponStore:HasSpace(), Constant.Message.Weapon.InventoryNotEnough
	end,
	OnQuery = function(p1) --[[ OnQuery | Line: 363 | Upvalues: v2 (copy), TableUtil (copy) ]]
		local v1 = v2.GetContent()
		local v22 = if v1 then v1[p1.WeaponKey] else v1
		if v22 then
			local v3 = TableUtil.Copy(v22, true)
			v2.CleanData({ v3 })
			return v3
		end
	end,
	OnSearch = function(p1) --[[ OnSearch | Line: 374 | Upvalues: LocalWeaponStore (copy) ]]
		if LocalWeaponStore.WeaponSearch then
			local v1 = nil
			if typeof(p1) == "string" then
				v1 = p1
			elseif typeof(p1) == "table" then
				v1 = p1.WeaponKey
			end
			if v1 then
				return LocalWeaponStore.WeaponSearch[v1]
			end
		end
	end
})
local t2 = {
	data = nil,
	at = 0
}
local v5 = false
local function fetchSummary() --[[ fetchSummary | Line: 397 | Upvalues: v5 (ref), t2 (ref), v2 (copy), t (copy) ]]
	if not v5 then
		v5 = true
		local v1, v22 = pcall(function() --[[ Line: 402 ]]
			local count = 1
			local v1 = nil
			local t = {}
			while true do
				local v2, v3, v4, v5 = pcall(function() --[[ Line: 407 | Upvalues: count (ref) ]]
					return script.GetGlobalCounts:InvokeServer(count)
				end)
				if not (v2 and v3) then
					break
				end
				if v3 == -1 then
					task.wait(3)
				else
					if v1 and v1 ~= v3 then
						count = 1
						v1 = v3
						t = {}
					end
					v1 = v3
					for v6, v7 in v4 do
						t[v6] = v7
					end
					if not v5 then
						break
					end
					count = count + 1
				end
			end
			return t
		end)
		v5 = false
		if v1 then
			t2 = {
				data = v22,
				at = os.clock()
			}
			v2.GlobalCountReady = true
			t.GlobalCountUpdated:Fire(t2.data)
		else
			warn(v22)
		end
	end
end
local function getSummary() --[[ getSummary | Line: 447 | Upvalues: t2 (ref), v5 (ref), fetchSummary (copy) ]]
	if t2 then
		if os.clock() - t2.at > 180 and not v5 then
			task.spawn(fetchSummary)
		end
		return t2.data
	else
		if not v5 then
			task.spawn(fetchSummary)
		end
		return -1
	end
end
function v2.GetGlobalCount(p1) --[[ GetGlobalCount | Line: 460 | Upvalues: t2 (ref), v5 (ref), fetchSummary (copy) ]]
	local v1
	if t2 then
		if os.clock() - t2.at > 180 and not v5 then
			task.spawn(fetchSummary)
		end
		v1 = t2.data
	else
		if not v5 then
			task.spawn(fetchSummary)
		end
		v1 = -1
	end
	if v1 then
		if p1 then
			return v1[p1] or 0
		else
			return v1
		end
	else
		return nil
	end
end
return v2