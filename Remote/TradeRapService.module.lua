-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.TradeRapService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Query = script.Query
local t = {}
local function cacheGet(p1, p2) --[[ cacheGet | Line: 15 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if v1 and os.clock() - v1.at < (p2 or 900) then
		return true, v1.data
	else
		return false, nil
	end
end
local function cacheSet(p1, p2) --[[ cacheSet | Line: 23 | Upvalues: t (copy) ]]
	if p2 then
		t[p1] = {
			data = p2,
			at = os.clock()
		}
	end
end
local t2 = {
	Event = {
		SummaryUpdated = SimpleSignal.new("TradeRapService.SummaryUpdated")
	}
}
local v1 = nil
local v2 = 0
local v3 = false
local function doFetchSummary() --[[ doFetchSummary | Line: 42 | Upvalues: v3 (ref), Query (copy), v1 (ref), v2 (ref), t2 (copy) ]]
	if v3 then
		return nil
	end
	v3 = true
	local v12 = 0
	local t = {}
	local v32 = nil
	repeat
		local v4, v5, v6 = pcall(function() --[[ Line: 52 | Upvalues: Query (ref), v12 (ref) ]]
			return Query:InvokeServer("GetRapSummary", v12)
		end)
		if v5 ~= -1 then
			if v4 and type(v5) == "table" then
				local _ = type(v5.Items) == "table"
			end
			if v4 and type(v6) == "number" then
				v32 = v6
			end
			break
		end
		task.wait(10)
	until v12 > 20
	v3 = false
	return v32
end
local function fetchSummaryIfNeeded() --[[ fetchSummaryIfNeeded | Line: 86 | Upvalues: v1 (ref), v2 (ref), v3 (ref), doFetchSummary (copy) ]]
	if v1 and os.clock() - v2 < 180 then
		return v1, nil
	elseif v1 then
		if not v3 then
			task.spawn(doFetchSummary)
		end
		return v1, nil
	else
		if not (v1 or v3) then
			task.spawn(doFetchSummary)
		end
		return nil
	end
end
local v4 = table.clone(Config.PlayerMarket.WearFactorSuffix)
v4.WW = ""
local function parseItemKey(p1, p2) --[[ parseItemKey | Line: 108 | Upvalues: WeaponConfig (copy), Config (copy), v4 (copy) ]]
	if typeof(p2) == "table" then
		local WF = p2.WF
		if WF == -1 then
			local v1 = WeaponConfig[p1]
			WF = if v1 and v1:IsExotic() then "FN" else "MC"
		end
		if p2.Data then
			local v2 = Config.Weapon.WearFactor.FetchRange(p2.Data.WearFactor)
			WF = if v2 then v2.Key else v2
		end
		local v42 = v4[WF]
		if v42 then
			return p1 .. v42
		else
			return p1
		end
	else
		return p1
	end
end
function t2.GetRap(p1, p2, p3) --[[ GetRap | Line: 136 | Upvalues: v1 (ref), fetchSummaryIfNeeded (copy), parseItemKey (copy) ]]
	if type(p1) == "string" and #p1 ~= 0 then
		if p3 and not v1 then
			return nil
		else
			local v12, v2 = fetchSummaryIfNeeded()
			if v12 then
				local v3 = v12[parseItemKey(p1, p2)] or v12[p1]
				if type(v3) == "number" then
					return v3, nil
				end
			end
			return nil, v2
		end
	else
		return nil
	end
end
function t2.GetRecentRaps(p1, p2) --[[ GetRecentRaps | Line: 153 | Upvalues: parseItemKey (copy), t (copy), Query (copy) ]]
	if type(p1) == "string" and #p1 ~= 0 then
		local v1 = "RRs:" .. parseItemKey(p1, p2)
		local v2 = t[v1]
		local v3, v4
		if v2 and os.clock() - v2.at < 900 then
			v3 = v2.data
			v4 = true
		else
			v4 = false
			v3 = nil
		end
		if v4 then
			return v3
		else
			local v5, v6, v7 = pcall(function() --[[ Line: 161 | Upvalues: Query (ref), p1 (copy), p2 (copy) ]]
				return Query:InvokeServer("GetRecentRaps", p1, p2)
			end)
			if v6 == -1 then
				return nil, 1
			elseif v5 and type(v6) == "table" then
				if v6 then
					t[v1] = {
						data = v6,
						at = os.clock()
					}
				end
				return v6 or v3, v7
			end
		end
	end
end
function t2.GetRapSummary() --[[ GetRapSummary | Line: 176 | Upvalues: fetchSummaryIfNeeded (copy) ]]
	return fetchSummaryIfNeeded()
end
function t2.IsSummaryReady() --[[ IsSummaryReady | Line: 180 | Upvalues: v1 (ref) ]]
	return v1 ~= nil
end
function t2.WaitSummaryReady() --[[ WaitSummaryReady | Line: 184 | Upvalues: v1 (ref), t2 (copy) ]]
	if not v1 then
		t2.Event.SummaryUpdated:Wait()
	end
	return t2
end
function t2.OnSummaryReady(p1) --[[ OnSummaryReady | Line: 191 | Upvalues: v1 (ref), t2 (copy) ]]
	if v1 then
		p1(v1)
	else
		t2.Event.SummaryUpdated:Once(p1)
	end
end
function t2.Start() --[[ Start | Line: 199 | Upvalues: doFetchSummary (copy) ]]
	task.spawn(doFetchSummary)
end
function t2.InvalidateCache(p1) --[[ InvalidateCache | Line: 203 | Upvalues: v1 (ref), v2 (ref), t (copy) ]]
	v1 = nil
	v2 = 0
	if p1 == nil then
		table.clear(t)
	else
		for k in pairs(t) do
			if string.find(k, p1, 1, true) then
				t[k] = nil
			end
		end
	end
end
return t2