-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.CombatService

-- https://lua.expert/
game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
local Utils = require(ReplicatedStorage.Util.Utils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local StreamingUtils = require(ReplicatedStorage.Util.StreamingUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Squash = require(ReplicatedStorage.Shared.Squash)
require(ReplicatedStorage.Common.NetworkHelper)
require(ReplicatedStorage.Common.CombatService.Networker)
local CombatService = require(ReplicatedStorage.Common.CombatService)
require(ReplicatedStorage.Common.CombatService.CommonWeapon)
require(ReplicatedStorage.Remote.AttrService)
require(ReplicatedStorage.Remote.InstanceDataService)
local EntityService = require(ReplicatedStorage.Remote.EntityService)
local Entity = require(ReplicatedStorage.Remote.EntityService.Entity)
local t = {
	WeaponMessage = SimpleSignal.new(),
	WeaponChanged = SimpleSignal.new(),
	WeaponsChanged = SimpleSignal.new(),
	SlotSwitched = SimpleSignal.new()
}
local t2 = {
	WeaponMessage = SimpleSignal.new(),
	WeaponChanged = SimpleSignal.new(),
	WeaponsChanged = SimpleSignal.new(),
	SlotSwitched = SimpleSignal.new()
}
local t3 = {
	WeaponMessage = SimpleSignal.new(),
	WeaponChanged = SimpleSignal.new(),
	WeaponsChanged = SimpleSignal.new(),
	SlotSwitchPre = SimpleSignal.new(),
	SlotSwitched = SimpleSignal.new(),
	PrivateMessage = SimpleSignal.new()
}
GameUtils.Forward(t, t2, EntityService.WorldManager.IsFocusedEntity)
GameUtils.ForwardLocal(t, t3, {
	LocalFilter = EntityService.IsLocalEntity
})
local t4 = {
	Event = t,
	FocusedEvent = t2,
	LocalEvent = t3,
	GetCombatDataContainer = function(p1) --[[ GetCombatDataContainer | Line: 67 | Upvalues: EntityService (copy), Constant (copy) ]]
		local v1 = if p1 then p1 else EntityService.GetLocalEntity()
		if v1 then
			local CombatDataContainer = v1.CombatDataContainer
			if not CombatDataContainer then
				local t = {
					Weapons = {},
					WeaponSlot = Constant.EquipmentSlot.Primary
				}
				v1.CombatDataContainer = t
				CombatDataContainer = t
			end
			return CombatDataContainer
		end
	end
}
function t4.GetWeapons(p1) --[[ GetWeapons | Line: 80 | Upvalues: EntityService (copy), t4 (copy) ]]
	local v1 = if p1 then p1 else EntityService.GetLocalEntity()
	if v1 then
		local v2 = t4.GetCombatDataContainer(v1)
		return if v2 then v2.Weapons else v2
	end
end
function t4.GetWeapon(p1, p2) --[[ GetWeapon | Line: 88 | Upvalues: EntityService (copy), t4 (copy) ]]
	local v1 = if p2 then p2 else EntityService.GetLocalEntity()
	if v1 then
		local v2 = t4.GetCombatDataContainer(v1)
		return v2 and v2.Weapons[if p1 then p1 else v2.WeaponSlot]
	end
end
function t4.GetCurrentWeapon(p1) --[[ GetCurrentWeapon | Line: 96 | Upvalues: EntityService (copy), t4 (copy) ]]
	local v1 = if p1 then p1 else EntityService.GetLocalEntity()
	if v1 then
		local v2 = t4.GetCombatDataContainer(v1)
		return if v2 then v2.Weapons[v2.WeaponSlot] else v2
	end
end
function t4.GetWeaponSlot(p1) --[[ GetWeaponSlot | Line: 104 | Upvalues: EntityService (copy), t4 (copy) ]]
	local v1 = if p1 then p1 else EntityService.GetLocalEntity()
	if v1 then
		local v2 = t4.GetCombatDataContainer(v1)
		return if v2 then v2.WeaponSlot else v2
	end
end
local v1 = false
function t4.PauseSwitch(p1) --[[ PauseSwitch | Line: 114 | Upvalues: v1 (ref) ]]
	v1 = os.clock() + p1
end
function t4.ResumeSwitch() --[[ ResumeSwitch | Line: 118 | Upvalues: v1 (ref) ]]
	v1 = false
end
function t4.CanSwitch() --[[ CanSwitch | Line: 122 | Upvalues: v1 (ref), EntityService (copy) ]]
	return if v1 and not (v1 < os.clock()) then false else EntityService.LocalEntity:IsActive(true)
end
function t4.IsAvailable(p1) --[[ IsAvailable | Line: 126 | Upvalues: t4 (copy) ]]
	local v2 = t4.GetWeapon(if p1 then p1 else t4.GetWeaponSlot())
	return if v2 then v2:IsAvailable() else v2
end
function t4.FindAvailable(...) --[[ FindAvailable | Line: 131 | Upvalues: t4 (copy) ]]
	local t = { ... }
	if typeof(t[1]) == "table" then
		t = t[1]
	end
	for v2, v3 in t do
		if t4.IsAvailable(v3) then
			return v3
		end
	end
end
local function switchSlot(p1, p2) --[[ switchSlot | Line: 143 | Upvalues: t4 (copy), v1 (ref), TableUtils (copy), t3 (copy), t (copy), EntityService (copy) ]]
	local v12 = t4.GetCombatDataContainer()
	v1 = false
	local v2 = TableUtils.OrEmpty(p2)
	local v3 = if p1 then p1 else v12.Weapons[v12.WeaponSlot] and v12.WeaponSlot
	if v3 and t4.IsAvailable(v3) then
		local WeaponSlot = v12.WeaponSlot
		t3.SlotSwitchPre:Fire(v3, WeaponSlot)
		v12.WeaponSlot = v3
		local v4 = t4.GetWeapon(v3)
		local v5 = if v4 and not v2.FastSwitch then v4:GetConfigValue("SwitchTime", 1) else nil
		if v4 and v5 then
			v4.SwitchStopTime = os.clock() + v5
		end
		t.SlotSwitched:Fire(EntityService.GetLocalEntity(), v3, WeaponSlot, {
			Duration = v5
		})
	end
end
function t4.SwitchSlot(p1, p2) --[[ SwitchSlot | Line: 168 | Upvalues: t4 (copy), EntityService (copy), TableUtils (copy), Config (copy), Constant (copy), switchSlot (copy) ]]
	if t4.CanSwitch() and EntityService.LocalEntity:IsAlive() then
		local v1 = TableUtils.OrEmpty(p2)
		if not (p1 and t4.IsAvailable(p1)) then
			p1 = v1.Fallback
		end
		local v2 = v1
		local v3 = t4.GetCombatDataContainer()
		local v4 = if p1 then p1 else v3.Weapons[v3.WeaponSlot] and v3.WeaponSlot
		local v5
		if v4 and t4.IsAvailable(v4) then
			v5 = v4
		else
			v5 = v4
			for i = 1, #Config.Combat.SlotOrder do
				v5 = Config.Combat.SlotOrder[i]
				if t4.IsAvailable(v5) then
					break
				end
				v5 = nil
			end
		end
		if t4.IsAvailable(v5) and (Constant.EquipmentSlot[v5] and v3.WeaponSlot ~= v5) then
			local v6 = t4.GetWeapon(v5)
			if v6 and v6:CanSwitchIn() then
				local v7 = t4.GetWeapon()
				if not v7 or v7:CanSwitchOut() then
					for v8, v9 in Config.Combat.SkillSlot do
						local v10 = t4.GetWeapon(v9)
						if v10 then
							v10:Abort()
						end
					end
					script.SwitchSlot:FireServer(workspace:GetServerTimeNow(), v5, {
						FastSwitch = v2.FastSwitch
					})
					switchSlot(v5, v2)
				end
			end
		end
	end
end
function t4.SendLocalMessage(p1, p2, p3, p4, ...) --[[ SendLocalMessage | Line: 217 | Upvalues: t4 (copy), EntityService (copy), t (copy) ]]
	local v1 = t4.GetWeapon(p1)
	local v2 = EntityService.GetLocalEntity()
	if v2 and (v1 and not v1.Destroying) then
		t.WeaponMessage:Fire(v2, v1, p2, workspace:GetServerTimeNow(), p3, p4, true, ...)
	end
end
function t4.SendLocalPrivateMessage(p1, p2, p3, p4, ...) --[[ SendLocalPrivateMessage | Line: 226 | Upvalues: t4 (copy), t3 (copy) ]]
	local v1 = t4.GetWeapon(p1)
	if v1 and not v1.Destroying then
		t3.PrivateMessage:Fire(v1, p2, workspace:GetServerTimeNow(), p3, p4, true, ...)
	end
end
function t4.InvokeAction(p1, p2, p3) --[[ InvokeAction | Line: 234 | Upvalues: CombatService (copy), Squash (copy), Utils (copy) ]]
	if p1.Destroying then
	else
		assert(p2, "action Nil")
		local v1, v2 = xpcall(function() --[[ Line: 250 | Upvalues: p1 (copy), CombatService (ref), Squash (ref), p2 (copy), p3 (copy) ]]
			local v1 = p1:GetNetworker()
			local v2 = CombatService.Network.Packets.queries.Action.invoke({
				AtTime = workspace:GetServerTimeNow(),
				Action = Squash.serOne(v1.ActionLiteral, p2),
				Args = v1:SerializeAction(p2, p3),
				Slot = p1.Slot
			})
			if v2 then
				v2 = v1:DeserializeActionResponse(p2, v2)
			end
			return v2
		end, Utils.xpcallErrTrack)
		if not v1 then
			warn(v2, p3)
		end
		return v1, v2
	end
end
function t4.FireAction(p1, p2, p3) --[[ FireAction | Line: 272 | Upvalues: CombatService (copy), Squash (copy) ]]
	if not p1.Destroying then
		assert(p2, "action Nil")
		local v1 = p1:GetNetworker()
		CombatService.Network.Packets.packets.ActionEvent.send({
			AtTime = workspace:GetServerTimeNow(),
			Action = Squash.serOne(v1.ActionLiteral, p2),
			Args = v1:SerializeAction(p2, p3),
			Slot = p1.Slot
		})
	end
end
function t4.FireUnreliableAction(p1, p2, p3) --[[ FireUnreliableAction | Line: 292 | Upvalues: CombatService (copy), Squash (copy) ]]
	assert(p2, "action Nil")
	local v1 = p1:GetNetworker()
	CombatService.Network.Packets.packets.UnreliableActionEvent.send({
		AtTime = workspace:GetServerTimeNow(),
		Action = Squash.serOne(v1.ActionLiteral, p2),
		Args = v1:SerializeAction(p2, p3),
		Slot = p1.Slot
	})
end
function t4.Start() --[[ Start | Line: 305 | Upvalues: EntityService (copy), StreamingUtils (copy), LocalPlayer (copy), t4 (copy), WeaponConfig (copy), t (copy), TableUtils (copy), Entity (copy), switchSlot (copy), RunService (copy), CombatService (copy), Squash (copy), t3 (copy) ]]
	script.SetSimpleWeapon.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 306 | Upvalues: EntityService (ref), StreamingUtils (ref), LocalPlayer (ref), t4 (ref), WeaponConfig (ref), t (ref) ]]
		local v1 = EntityService.GetOrCreateEntity(StreamingUtils.Fetch(p1))
		if v1 and p1 ~= LocalPlayer then
			local v2 = t4.GetCombatDataContainer(v1)
			local v3 = v2.Weapons[p2]
			if p3 then
				p3.Slot = p2
				p3.Config = WeaponConfig[p3.Name]
				p3.Holder = p1
				p3.HolderEntity = v1
			end
			v2.Weapons[p2] = p3
			t.WeaponChanged:Fire(v1, p2, p3, v3)
		end
	end)
	script.SetSimpleWeapons.OnClientEvent:Connect(function(p1, p2) --[[ Line: 323 | Upvalues: EntityService (ref), StreamingUtils (ref), LocalPlayer (ref), t4 (ref), TableUtils (ref), WeaponConfig (ref), t (ref) ]]
		local v1 = EntityService.GetOrCreateEntity(StreamingUtils.Fetch(p1))
		if v1 and p1 ~= LocalPlayer then
			local v2 = t4.GetCombatDataContainer(v1)
			local v3 = TableUtils.OrEmpty(v2.Weapons)
			v2.Weapons = p2
			for v4, v5 in p2 do
				v5.Slot = v4
				v5.Config = WeaponConfig[v5.Name]
				v5.Holder = p1
				v5.HolderEntity = v1
			end
			t.WeaponsChanged:Fire(v1, v2.Weapons, v3)
		end
	end)
	script.SlotSwitched.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 342 | Upvalues: Entity (ref), StreamingUtils (ref), LocalPlayer (ref), t4 (ref), t (ref) ]]
		local v1 = Entity.Get(StreamingUtils.Fetch(p1))
		if v1 and p1 ~= LocalPlayer then
			local v2 = t4.GetCombatDataContainer(v1)
			local WeaponSlot = v2.WeaponSlot
			v2.WeaponSlot = p2
			local v3 = t4.GetWeapon(p2, v1)
			if v3 and (p3 and p3.Duration) then
				v3.SwitchStopTime = os.clock() + p3.Duration
			end
			t.SlotSwitched:Fire(v1, p2, WeaponSlot, p3)
		end
	end)
	local function confirmWeapon(p1) --[[ confirmWeapon | Line: 358 ]]
		local t = {}
		for v1, v2 in p1 do
			t[v1] = v2.Token
		end
		script.Confirm:FireServer(t)
	end
	script.SetWeapon.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 367 | Upvalues: t4 (ref), t (ref), EntityService (ref) ]]
		local v1 = t4.GetCombatDataContainer()
		if p2 or v1.Weapons[p1] then
			local v2 = v1.Weapons[p1]
			v1.Weapons[p1] = p2
			local t2 = {}
			for v3, v4 in {
				[p1] = p2
			} do
				t2[v3] = v4.Token
			end
			script.Confirm:FireServer(t2)
			t.WeaponChanged:Fire(EntityService.LocalEntity, p1, p2, v2)
		end
	end)
	script.SetWeapons.OnClientEvent:Connect(function(p1) --[[ Line: 378 | Upvalues: t4 (ref), t (ref), EntityService (ref) ]]
		local v1 = t4.GetCombatDataContainer()
		local Weapons = v1.Weapons
		v1.Weapons = if p1 then p1 else {}
		local t2 = {}
		for v3, v4 in v1.Weapons do
			t2[v3] = v4.Token
		end
		script.Confirm:FireServer(t2)
		t.WeaponsChanged:Fire(EntityService.LocalEntity, p1, Weapons)
	end)
	script.SwitchSlot.OnClientEvent:Connect(function(p1, p2) --[[ Line: 387 | Upvalues: switchSlot (ref) ]]
		if not (p2 and p2.Client) then
			switchSlot(p1, {
				Server = true
			})
		end
	end)
	local function onWeaponMessage(p1, p2, p3, p4, p5, p6, ...) --[[ onWeaponMessage | Line: 395 | Upvalues: Entity (ref), t4 (ref), RunService (ref), LocalPlayer (ref), CombatService (ref), TableUtils (ref), Squash (ref), t (ref) ]]
		local v1 = Entity.Get(p1)
		local v2 = if v1 then t4.GetWeapon(p2, v1) else v1
		if v2 then
			local v3 = p4 + v2.CreateTime
			local v4 = if p1 == LocalPlayer then v2 elseif v2.Weapons then CombatService.API.GetMultipleModule(v2.Name) else CombatService.API.GetModule(v2.Name)
			if p6 then
				p6 = if p1 == LocalPlayer then v4:DeserializeMessageArgs(p6) else v4:deserializeMessageArgs(v2, p6)
			end
			local v9 = TableUtils.OrEmpty(p6)
			local v10, v11
			if p1 == LocalPlayer then
				v10, v11 = v2:GetNetworker(v9), v9
			else
				v10, v11 = v4:networker(v2, v9), v9
			end
			if v10 then
				local v14 = Squash.desOne(v10.MessageChannelLiteral, p3)
				local v15 = v10:DeserializeMessage(v14, p5)
				if p1 ~= LocalPlayer and (v2.Weapons and (v14 == "Switch" and not v11.MultipleIndex)) then
					v2.Current = v15.Target
				end
				v16 = v14
				v17 = v15
				t.WeaponMessage:Fire(v1, v2, v16, v3, v17, v11, false)
			else
				warn("networker lost")
			end
		else
			RunService:IsStudio()
		end
	end
	local function onPrivateMessage(p1, p2, p3, p4, p5, ...) --[[ onPrivateMessage | Line: 455 | Upvalues: t4 (ref), TableUtils (ref), Squash (ref), t3 (ref) ]]
		local v1 = t4.GetWeapon(p1)
		if v1 then
			if p5 then
				p5 = v1:DeserializeMessageArgs(p5)
			end
			local v4 = TableUtils.OrEmpty(p5)
			local v5 = v1:GetNetworker(v4)
			local v6 = Squash.desOne(v5.PrivateChannelLiteral, p2)
			t3.PrivateMessage:Fire(v1, v6, p3 + v1.CreateTime, v5:DeserializePrivateMessage(v6, p4), v4, false, ...)
		end
	end
	script.WeaponMessage.OnClientEvent:Connect(onWeaponMessage)
	script.PrivateMessage.OnClientEvent:Connect(onPrivateMessage)
	CombatService.Network.Packets.packets.WeaponMessage.listen(function(p1) --[[ Line: 478 | Upvalues: onWeaponMessage (copy) ]]
		onWeaponMessage(p1.Source, p1.Slot, p1.Channel, p1.AtTime, p1.Message, p1.Args)
	end)
	CombatService.Network.Packets.packets.PrivateMessage.listen(function(p1) --[[ Line: 481 | Upvalues: onPrivateMessage (copy), TableUtils (ref) ]]
		onPrivateMessage(p1.Slot, p1.Channel, p1.AtTime, p1.Message, TableUtils.OrEmpty(p1.Args))
	end)
end
return t4