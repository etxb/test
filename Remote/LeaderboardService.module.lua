-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.LeaderboardService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {}
local t2 = {}
local function queryLeaderboard(p1) --[[ queryLeaderboard | Line: 10 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if v1 then
		v1.Updating = true
	end
	local v2, v3 = pcall(function() --[[ Line: 15 | Upvalues: p1 (copy) ]]
		return script.Query:InvokeServer(p1)
	end)
	if v1 then
		v1.Updating = false
		if v2 and v3 then
			v1.Data = v3
			v1.Time = os.clock()
		elseif v2 and v3 == false then
			v1.Time = os.clock()
		end
	end
	return v2 and v3
end
local t3 = {}
function t2.GetLeaderboard(p1) --[[ GetLeaderboard | Line: 32 | Upvalues: t3 (copy), t (copy), queryLeaderboard (copy), SimpleSignal (copy) ]]
	while t3[p1] do
		t3[p1]:Wait()
	end
	local v1 = t[p1]
	if v1 and v1.Data then
		if os.clock() - v1.Time > 600 and not v1.Updating then
			task.spawn(queryLeaderboard, p1)
		end
		return v1.Data
	else
		local v2 = SimpleSignal.new()
		t3[p1] = v2
		local v3 = queryLeaderboard(p1)
		t3[p1] = nil
		if v3 then
			t[p1] = {
				Data = v3,
				Time = os.clock()
			}
		end
		v2:Fire()
		return v3
	end
end
function t2.RemoveCache(p1) --[[ RemoveCache | Line: 57 | Upvalues: t (copy) ]]
	t[p1] = nil
end
return t2