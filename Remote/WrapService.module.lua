-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WrapService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
RunService:IsStudio()
require(ReplicatedStorage.Config.WrapConfig)
require(ReplicatedStorage.Util.Utils)
require(ReplicatedStorage.Util.TableUtils)
local t = {
	DataInited = require(ReplicatedStorage.Shared.SimpleSignal).new()
}
local LocalWrapStore = require(script.LocalWrapStore)
local v2 = setmetatable({
	Inited = false,
	Event = t,
	LocalWrapStore = LocalWrapStore
}, require(ReplicatedStorage.Common.WrapService))
function v2.WaitInit() --[[ WaitInit | Line: 33 | Upvalues: v2 (copy), t (copy) ]]
	if not v2.Inited then
		t.DataInited:Wait()
	end
	return v2
end
function v2.OnInit(p1) --[[ OnInit | Line: 40 | Upvalues: v2 (copy), t (copy) ]]
	if v2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function v2.Has(p1, p2) --[[ Has | Line: 48 | Upvalues: LocalWrapStore (copy) ]]
	return LocalWrapStore:Has(p1, p2)
end
function v2.Start() --[[ Start | Line: 52 | Upvalues: LocalWrapStore (copy), v2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 53 | Upvalues: LocalWrapStore (ref), v2 (ref), t (ref) ]]
		if LocalWrapStore.Data or not p2 then
			if LocalWrapStore.Data then
				if p1.Add then
					for v1, v22 in p1.Add do
						LocalWrapStore:Add(v22.Wrap, v22.Name, {
							All = v22.All
						})
					end
				end
				if p1.Remove then
					for v3, v4 in p1.Remove do
						LocalWrapStore:Remove(v4.Wrap, v4.Name)
					end
				end
			end
		else
			LocalWrapStore.Data = p1
			v2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return v2