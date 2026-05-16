-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.StatusService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local TimeUtils = require(ReplicatedStorage.Util.TimeUtils)
local ConditionHelper = require(ReplicatedStorage.Common.ConditionHelper)
local v1 = workspace:GetServerTimeNow()
local v2 = 0
local v3 = 0
local v4 = 0
local v5 = 0
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {
	DataUpdated = SimpleSignal.new(),
	DataInited = SimpleSignal.new()
}
local v6 = nil
local t2 = {}
local t3 = {
	Inited = false,
	Event = t,
	DataUpdated = t.DataUpdated,
	DataInited = t.DataInited
}
local t4 = {}
function t3.RegisterPreHandler(p1, p2) --[[ RegisterPreHandler | Line: 38 | Upvalues: t4 (copy) ]]
	assert(if p1 then if #p1 > 0 then true else false else p1, "statusName can\'t be nil or empty")
	if t4[p1] then
		error(("status pre handler duplicated! %s"):format(p1))
	end
	t4[p1] = p2
end
local function updateOnlined() --[[ updateOnlined | Line: 46 | Upvalues: t3 (copy), v2 (ref), Constant (copy) ]]
	local v1 = t3.GetSessionOnlined()
	local v22 = v2
	v2 = v1
	t3.AddStatus(Constant.Status.Onlined, v1 - v22)
end
local function updateDayOnlined() --[[ updateDayOnlined | Line: 54 | Upvalues: t3 (copy), TimeUtils (copy), Constant (copy), v6 (ref), v3 (ref) ]]
	local v1 = t3.GetSessionOnlined()
	local v2 = TimeUtils.Today()
	if t3.GetStatus(Constant.Status.Day) < v2 then
		v6[Constant.Status.Day] = v2
		v6[Constant.Status.DayOnlined] = 0
		v3 = v1
	end
	local v32 = v3
	v3 = v1
	t3.AddStatus(Constant.Status.DayOnlined, v1 - v32)
end
local function updateWeeklyOnlined() --[[ updateWeeklyOnlined | Line: 68 | Upvalues: t3 (copy), TimeUtils (copy), Constant (copy), v6 (ref), v4 (ref) ]]
	local v1 = t3.GetSessionOnlined()
	local v2 = TimeUtils.GetWeek()
	if t3.GetStatus(Constant.Status.Week) < v2 then
		v6[Constant.Status.Week] = v2
		v6[Constant.Status.WeeklyOnlined] = 0
		v4 = v1
	end
	local v3 = v4
	v4 = v1
	t3.AddStatus(Constant.Status.WeeklyOnlined, v1 - v3)
end
local function updateMonthOnlined() --[[ updateMonthOnlined | Line: 82 | Upvalues: t3 (copy), TimeUtils (copy), Constant (copy), v6 (ref), v5 (ref) ]]
	local v1 = t3.GetSessionOnlined()
	local v2 = TimeUtils.GetUniqueMonth()
	if t3.GetStatus(Constant.Status.Month) < v2 then
		v6[Constant.Status.Month] = v2
		v6[Constant.Status.MonthOnlined] = 0
		v5 = v1
	end
	local v3 = v5
	v5 = v1
	t3.AddStatus(Constant.Status.MonthOnlined, v1 - v3)
end
t3.RegisterPreHandler(Constant.Status.Onlined, updateOnlined)
t3.RegisterPreHandler(Constant.Status.DayOnlined, updateDayOnlined)
t3.RegisterPreHandler(Constant.Status.WeeklyOnlined, updateWeeklyOnlined)
t3.RegisterPreHandler(Constant.Status.MonthOnlined, updateMonthOnlined)
local t5 = {}
function t3.GetStatus(p1) --[[ GetStatus | Line: 103 | Upvalues: t4 (copy), t5 (copy), v6 (ref) ]]
	local v1 = t4[p1]
	if v1 and not t5[p1] then
		t5[p1] = true
		task.spawn(v1)
		t5[p1] = false
	end
	return if v6 then v6[p1] or 0 else 0
end
function t3.SetStatus(p1, p2) --[[ SetStatus | Line: 114 | Upvalues: v6 (ref), t2 (copy), t (copy) ]]
	if v6 then
		local v1 = p2 - (v6[p1] or 0)
		v6[p1] = p2
		if t2[p1] then
			t2[p1]:Fire(v6[p1], v1)
		end
		t.DataUpdated:Fire({
			[p1] = v1
		})
	end
end
function t3.AddStatus(p1, p2) --[[ AddStatus | Line: 124 | Upvalues: v6 (ref), t2 (copy), t (copy) ]]
	if v6 then
		v6[p1] = (v6[p1] or 0) + p2
		if t2[p1] then
			t2[p1]:Fire(v6[p1], p2)
		end
		t.DataUpdated:Fire({
			[p1] = p2
		})
	end
end
function t3.Has(p1, p2) --[[ Has | Line: 133 | Upvalues: t3 (copy) ]]
	return p2 <= t3.GetStatus(p1)
end
function t3.WaitInit() --[[ WaitInit | Line: 137 | Upvalues: t3 (copy), t (copy) ]]
	if not t3.Inited then
		t.DataInited:Wait()
	end
	return t3
end
function t3.OnInit(p1) --[[ OnInit | Line: 144 | Upvalues: t3 (copy), t (copy) ]]
	if t3.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t3.GetSessionOnlined() --[[ GetSessionOnlined | Line: 152 | Upvalues: v1 (ref) ]]
	return workspace:GetServerTimeNow() - v1
end
function t3.GetStatusUpdatedSignal(p1) --[[ GetStatusUpdatedSignal | Line: 156 | Upvalues: t2 (copy), SimpleSignal (copy) ]]
	if not p1 then
		error("statusName must be not nil")
	end
	local v1 = t2[p1]
	if not v1 then
		local v2 = SimpleSignal.new(("StatusUpdatedSignal [%s]"):format(p1 or "NIL"))
		t2[p1] = v2
		v1 = v2
	end
	return v1
end
function t3.Start() --[[ Start | Line: 168 | Upvalues: v6 (ref), v1 (ref), t3 (copy), t (copy), t2 (copy), ConditionHelper (copy), updateDayOnlined (copy), updateWeeklyOnlined (copy), updateMonthOnlined (copy), TimeUtils (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 169 | Upvalues: v6 (ref), v1 (ref), t3 (ref), t (ref), t2 (ref) ]]
		if v6 or not p2 then
			if v6 then
				local t4 = {}
				for v12, v2 in p1 do
					if typeof(v2) == "number" then
						local v3 = v6[v12] or 0
						t4[v12] = v2 - v3
						v6[v12] = v2
						if t2[v12] then
							t2[v12]:Fire(v2, v3, t4[v12])
						end
					end
				end
				t.DataUpdated:Fire(t4)
			end
		else
			v1 = workspace:GetServerTimeNow()
			v6 = p1
			t3.Inited = true
			t.DataInited:Fire()
		end
	end)
	local t4 = {
		[">="] = function(p1, p2) --[[ Line: 196 ]]
			return p2 <= p1
		end,
		[">"] = function(p1, p2) --[[ Line: 199 ]]
			return p2 < p1
		end,
		["="] = function(p1, p2) --[[ Line: 202 ]]
			return p1 == p2
		end,
		["<"] = function(p1, p2) --[[ Line: 205 ]]
			return p1 < p2
		end,
		["<="] = function(p1, p2) --[[ Line: 208 ]]
			return p1 <= p2
		end
	}
	ConditionHelper.RegisterCondition("Status", function(p1) --[[ Line: 211 | Upvalues: v6 (ref), t3 (ref), t4 (copy) ]]
		if not v6 then
			t3.WaitInit()
		end
		if p1.Status then
			local v2 = t4[p1.Mode or ">="]
			return if v2 then v2(t3.GetStatus(p1.Status), p1.Value or 0) else v2
		end
	end)
	task.spawn(function() --[[ Line: 222 | Upvalues: t3 (ref), updateDayOnlined (ref), updateWeeklyOnlined (ref), updateMonthOnlined (ref), TimeUtils (ref) ]]
		t3.WaitInit()
		while true do
			updateDayOnlined()
			updateWeeklyOnlined()
			updateMonthOnlined()
			task.wait((TimeUtils.DayRemaining()))
		end
	end)
end
return t3