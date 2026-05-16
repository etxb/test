-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Config.Matchmaking

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local Feature = require(script.Parent.Feature)
local function newDuelQueue(p1, p2) --[[ newDuelQueue | Line: 6 | Upvalues: Constant (copy) ]]
	local t = {
		GameMode = Constant.GameMode.Duel,
		Teams = { Constant.Team.Team1, Constant.Team.Team2 },
		TeamSize = p1,
		Players = p1 * 2
	}
	t.Display = ("%s%dv%d"):format(if p2 then "Ranked " else "Duel ", p1, p1)
	t.Ranked = p2
	return t
end
local t = {
	Queues = {}
}
if Feature.Duel then
	t.Queues.Duel_1v1 = newDuelQueue(1)
	t.Queues.Duel_2v2 = newDuelQueue(2)
	t.Queues.Duel_3v3 = newDuelQueue(3)
	t.Queues.Ranked_1v1 = newDuelQueue(1, true)
	t.Queues.Ranked_2v2 = newDuelQueue(2, true)
	t.Queues.Ranked_3v3 = newDuelQueue(3, true)
end
for v1, v2 in t.Queues do
	v2.Name = v1
end
return t