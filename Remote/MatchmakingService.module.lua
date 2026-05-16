-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.MatchmakingService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Config = require(ReplicatedStorage.Config.Config)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local TeamService = require(ReplicatedStorage.Remote.TeamService)
local t = {
	Changed = SimpleSignal.new()
}
local t2 = {
	Queue = nil,
	Matching = false,
	Event = t,
	Values = script.Values
}
function t2.Match(p1) --[[ Match | Line: 26 | Upvalues: t2 (copy), Config (copy), TeamService (copy), t (copy) ]]
	if t2.Matching or not Config.Matchmaking.Queues[p1] then
	elseif TeamService.IsLeader() then
		if not script._Ready.Value then
			script._Ready.Changed:Wait()
		end
		local v1 = script.Match:InvokeServer(p1)
		if v1 and v1 ~= -1 then
			t2.Matching = true
			t2.Queue = p1
			t.Changed:Fire()
		end
		return v1
	end
end
function t2.Cancel() --[[ Cancel | Line: 45 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Matching then
		local v1 = script.Cancel:InvokeServer()
		if v1 and v1 ~= -1 then
			t2.Matching = false
			t2.Queue = nil
			t.Changed:Fire()
		end
	end
end
function t2.Start() --[[ Start | Line: 57 | Upvalues: t2 (copy), t (copy) ]]
	script.Cancelled.OnClientEvent:Connect(function(p1) --[[ Line: 58 | Upvalues: t2 (ref), t (ref) ]]
		if t2.Matching == true then
			t2.Matching = false
			t2.Queue = nil
			t.Changed:Fire(p1)
		end
	end)
end
return t2