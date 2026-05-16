-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.ReplicateService

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Config = require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Shared.SimpleSignal)
local chrono = require(ReplicatedStorage.Shared.chrono)
local t = {
	Event = {},
	GetVelocity = function(p1) --[[ GetVelocity | Line: 19 | Upvalues: Config (copy), chrono (copy) ]]
		local v1 = p1.Character and p1.Character:FindFirstChild("HumanoidRootPart")
		if v1 then
			if Config.Feature.ReplicateSystem then
				return chrono.ChronoClient.GetVelocity(p1)
			else
				return v1.AssemblyLinearVelocity
			end
		else
			return Vector3.new(0, 0, 0)
		end
	end,
	GetReplicateTime = function() --[[ GetReplicateTime | Line: 30 | Upvalues: Config (copy), chrono (copy) ]]
		if Config.Feature.ReplicateSystem then
			return chrono.ChronoClient.GetReplicateTime()
		else
			return workspace:GetServerTimeNow()
		end
	end
}
local t2 = {}
function t.PauseReplication(p1, p2) --[[ PauseReplication | Line: 39 | Upvalues: Config (copy), t2 (copy), chrono (copy) ]]
	if Config.Feature.ReplicateSystem then
		t2[p1] = if p2 then true else nil
		if next(t2) then
			chrono.ChronoClient.ToggleReplication(false)
		else
			chrono.ChronoClient.ToggleReplication(true)
		end
	end
end
local t3 = {}
function t.SetAnchored(p1, p2) --[[ SetAnchored | Line: 53 | Upvalues: Config (copy), t3 (copy), chrono (copy) ]]
	if Config.Feature.ReplicateSystem then
		t3[p1] = if p2 then true else nil
		if next(t3) then
			chrono.ChronoClient.ToggleAnchored(true)
		else
			chrono.ChronoClient.ToggleAnchored(false)
		end
	end
end
function t.Start() --[[ Start | Line: 65 | Upvalues: Config (copy), ReplicatedStorage (copy), LocalPlayer (copy), chrono (copy) ]]
	if Config.Feature.ReplicateSystem then
		chrono.Start()
	else
		local Interface = require(ReplicatedStorage.Shared.BetterReplication.Interface)
		Interface.startInterpolater()
		task.spawn(function() --[[ Line: 70 | Upvalues: LocalPlayer (ref), Interface (copy) ]]
			if LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() then
				Interface.startReplication()
			end
		end)
	end
end
return t