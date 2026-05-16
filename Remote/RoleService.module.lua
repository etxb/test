-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RoleService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local RoleConfig = require(ReplicatedStorage.Config.RoleConfig)
require(ReplicatedStorage.Util.Utils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local StatusService = require(ReplicatedStorage.Remote.StatusService)
local WrapService = require(ReplicatedStorage.Remote.WrapService)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local LocalRoleStore = require(script.LocalRoleStore)
LocalRoleStore.WrapStore = WrapService.LocalWrapStore
local LocalWrapCache = require(script.LocalWrapCache)
LocalWrapCache.WrapStore = WrapService.LocalWrapStore
LocalWrapCache.RoleStore = LocalRoleStore
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalRoleStore = LocalRoleStore,
	LocalWrapCache = LocalWrapCache
}
function t2.WaitInit() --[[ WaitInit | Line: 38 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 45 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Once(p1)
	end
end
function t2.HasRole(...) --[[ HasRole | Line: 53 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:HasRole(...)
end
function t2.HasSkin(...) --[[ HasSkin | Line: 57 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:HasSkin(...)
end
function t2.GetRole(...) --[[ GetRole | Line: 61 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:GetRole(...)
end
function t2.GetRoleSelected() --[[ GetRoleSelected | Line: 65 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:GetRoleSelected()
end
function t2.SelectRole(...) --[[ SelectRole | Line: 69 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:SelectRole(...)
end
function t2.SetWrap(...) --[[ SetWrap | Line: 73 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:SetWrap(...)
end
function t2.SetSkin(...) --[[ SetSkin | Line: 77 | Upvalues: LocalRoleStore (copy) ]]
	return LocalRoleStore:SetSkin(...)
end
function t2.Unlock(p1) --[[ Unlock | Line: 81 | Upvalues: RoleConfig (copy), RunService (copy), LocalRoleStore (copy), ResultUtils (copy), Constant (copy), StatusService (copy) ]]
	local v1 = RoleConfig[p1]
	if v1 and not v1.Disabled then
		if v1.Limited or v1.Test and not RunService:IsStudio() then
		elseif v1.UnlockCost then
			if LocalRoleStore:HasRole(p1) then
				return ResultUtils.failed(Constant.Message.Role.Owned)
			elseif StatusService.Has(Constant.Status.Eco_Coin, v1.UnlockCost) then
				local v2, v3 = pcall(function() --[[ Line: 99 | Upvalues: p1 (copy) ]]
					return script.Unlock:InvokeServer(p1)
				end)
				if v2 then
					return ResultUtils.success()
				else
					return ResultUtils.error(v3)
				end
			else
				return ResultUtils.failed(Constant.Message.Common.CoinNotEnough)
			end
		end
	end
end
function t2.Start() --[[ Start | Line: 108 | Upvalues: LocalRoleStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 109 | Upvalues: LocalRoleStore (ref), t2 (ref), t (ref) ]]
		if LocalRoleStore.Data or not p2 then
			if LocalRoleStore.Data then
				if p1.Add then
					for v1, v2 in p1.Add do
						LocalRoleStore:Add(v1, v2)
					end
				end
				if p1.Remove then
					for v3, v4 in p1.Remove do
						LocalRoleStore:Remove(v4)
					end
				end
				if p1.SelectRole then
					LocalRoleStore:SelectRole(p1.SelectRole, {
						Server = true
					})
				end
				if p1.AddSkin then
					for v5, v6 in p1.AddSkin do
						for v7, v8 in v6 do
							LocalRoleStore:AddSkin(v5, v7)
						end
					end
				end
			end
		else
			LocalRoleStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
	t2.OnInit(function() --[[ Line: 140 ]] end)
end
return t2