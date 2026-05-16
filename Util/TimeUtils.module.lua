-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TimeUtils

-- https://lua.expert/
local RunService = game:GetService("RunService")
local t = {
	SECS_OF_DAY = 86400,
	GetYear = function() --[[ GetYear | Line: 7 ]]
		return os.date("!*t").year
	end,
	GetMonth = function() --[[ GetMonth | Line: 12 ]]
		return os.date("!*t").month
	end,
	GetMonthDay = function() --[[ GetMonthDay | Line: 17 ]]
		return os.date("!*t").day
	end
}
function t.GetUniqueMonth() --[[ GetUniqueMonth | Line: 22 | Upvalues: t (copy) ]]
	return t.GetYear() * 12 + t.GetMonth()
end
function t.IsMonthBegin() --[[ IsMonthBegin | Line: 26 | Upvalues: t (copy) ]]
	return t.GetMonthDay() == 1
end
function t.IsLeapYear(p1) --[[ IsLeapYear | Line: 30 | Upvalues: t (copy) ]]
	local v1 = if p1 then p1 else t.GetYear()
	if v1 % 100 == 0 then
		return v1 % 400 == 0
	else
		return v1 % 4 == 0
	end
end
local t2 = {
	31,
	28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31
}
function t.GetMonthDays(p1, p2) --[[ GetMonthDays | Line: 40 | Upvalues: t (copy), t2 (copy) ]]
	local v1 = if p1 then p1 else t.GetMonth()
	local _ = if p2 then p2 else t.GetYear()
	local count = t2[v1]
	if v1 == 2 and t.IsLeapYear() then
		count = count + 1
	end
	return count
end
function t.MonthRemaining() --[[ MonthRemaining | Line: 50 | Upvalues: t (copy) ]]
	workspace:GetServerTimeNow()
	local v1 = t.GetMonthDay()
	local v2 = t.GetMonthDays()
	return t.DayRemaining() + (v2 - v1) * t.SECS_OF_DAY
end
function t.IsWeekend(p1) --[[ IsWeekend | Line: 57 | Upvalues: t (copy) ]]
	local v1 = (t.Today(p1) + 3 - 1) % 7 + 1
	return if v1 == 6 then true else v1 == 7
end
function t.WeekRemaining(p1) --[[ WeekRemaining | Line: 63 | Upvalues: t (copy) ]]
	local v1 = workspace:GetServerTimeNow() + (p1 or 0)
	local v2 = t.GetUniqueDay(v1)
	return (v2 + (7 - ((v2 + 3 - 1) % 7 + 1))) * 86400 - v1
end
function t.NextWeekendRemaining(p1) --[[ NextWeekendRemaining | Line: 71 | Upvalues: t (copy) ]]
	local v1 = workspace:GetServerTimeNow() + (p1 or 0)
	local v2 = t.GetUniqueDay(v1)
	return (v2 + (5 - ((v2 + 3 - 1) % 7 + 1))) * 86400 - v1
end
function t.GetNextWeekDayTime(p1, p2, p3) --[[ GetNextWeekDayTime | Line: 79 | Upvalues: t (copy) ]]
	assert(if typeof(p1) == "number" then true else false, "targetWeekDay must be a number")
	assert(if p1 >= 1 then if p1 <= 7 then true else false else false, "targetWeekDay must be in range [1, 7]")
	local v3 = if p2 then p2 else workspace:GetServerTimeNow()
	local v4 = t.GetUniqueDay(v3)
	local sum = p1 - t.GetWeekDay(v3)
	if sum <= 0 then
		sum = sum + 7
	end
	return (v4 + (sum - 1)) * 86400 - (p3 or 0)
end
function t.NextWeekDayRemaining(p1, p2, p3) --[[ NextWeekDayRemaining | Line: 96 | Upvalues: t (copy) ]]
	local v1 = if p2 then p2 else workspace:GetServerTimeNow()
	return t.GetNextWeekDayTime(p1, v1, p3) - v1
end
function t.GetWeek(p1, p2) --[[ GetWeek | Line: 101 | Upvalues: t (copy) ]]
	return math.ceil((t.GetUniqueDay(p1, p2) + 3) / 7)
end
function t.GetWeekDay(p1, p2) --[[ GetWeekDay | Line: 107 | Upvalues: t (copy) ]]
	return (t.GetUniqueDay(p1, p2) + 3 - 1) % 7 + 1
end
function t.GetUniqueDay(p1, p2) --[[ GetUniqueDay | Line: 112 ]]
	return math.ceil((if p1 then p1 else workspace:GetServerTimeNow() + (p2 or 0)) / 86400)
end
function t.Today(p1) --[[ Today | Line: 118 | Upvalues: t (copy) ]]
	return t.GetUniqueDay(nil, p1)
end
function t.DayRemaining(p1) --[[ DayRemaining | Line: 122 | Upvalues: t (copy) ]]
	return t.Today(p1) * 86400 - (workspace:GetServerTimeNow() + (p1 or 0))
end
local t3 = {}
local v1 = RunService:IsServer()
function t.ExecuteWait(p1) --[[ ExecuteWait | Line: 131 | Upvalues: t3 (copy), v1 (copy), RunService (copy) ]]
	local v2 = coroutine.running()
	local v3 = t3[v2]
	if not v3 then
		local v4 = os.clock()
		t3[v2] = v4
		v3 = v4
	end
	if (p1 or 0.005555555555555556) < os.clock() - v3 then
		local sum
		if v1 then
			sum = task.wait()
		else
			sum = RunService.Heartbeat:Wait()
			for i = 1, math.random(2) do
				sum = sum + RunService.RenderStepped:Wait()
			end
		end
		t3[v2] = os.clock()
		return sum
	else
		return 0
	end
end
function t.ParseSeconds(p1) --[[ ParseSeconds | Line: 155 ]]
	if typeof(p1) == "number" then
		return p1
	else
		assert(typeof(p1) == "table", "not a table!")
		local sum = 0
		if p1.Second then
			sum = sum + p1.Second
		end
		if p1.Minute then
			sum = sum + p1.Minute * 60
		end
		if p1.Hour then
			sum = sum + p1.Hour * 60 * 60
		end
		if p1.Day then
			sum = sum + p1.Day * 86400
		end
		return sum
	end
end
function t.TimeToString(p1, p2) --[[ TimeToString | Line: 176 ]]
	if p1 == -1 then
		return "Permanent"
	elseif p1 == 0 then
		return "0 Sec"
	else
		local v1 = p2 or 999
		local v2 = math.floor(p1)
		local v3 = v2 // 60
		local v4 = v3 // 60
		local v5 = v4 // 24
		local v6 = v3 % 60
		local v7 = v2 % 60
		local v8 = v4 % 24
		local t = {}
		if v5 > 0 then
			table.insert(t, ("%d %s"):format(v5, if v5 > 1 then "Days" else "Day"))
		end
		if (v8 > 0 or #t > 0) and #t < v1 then
			table.insert(t, ("%d %s"):format(v8, if v8 > 1 then "Hours" else "Hour"))
		end
		if (v6 > 0 or #t > 0) and #t < v1 then
			table.insert(t, ("%d %s"):format(v6, if v6 > 1 then "Min" else "Mins"))
		end
		if #t < v1 then
			table.insert(t, ("%s %s"):format(v7, if v7 > 1 then "Secs" else "Sec"))
		end
		return table.concat(t, " ")
	end
end
function t.TimeToSimpleString(p1, p2) --[[ TimeToSimpleString | Line: 207 ]]
	if p1 == -1 then
		return "Permanent"
	elseif p1 == 0 then
		return "0 Sec"
	else
		local v1 = p2 or 999
		local v2 = math.floor(p1)
		local v3 = v2 // 60
		local v4 = v3 // 60
		local v5 = v4 // 24
		local v6 = v3 % 60
		local v7 = v2 % 60
		local v8 = v4 % 24
		local t = {}
		if v5 > 0 then
			table.insert(t, ("%d %s"):format(v5, if v5 > 1 then "Days" else "Day"))
		end
		if (v8 > 0 or #t > 0) and (#t < v1 and #t > 0) then
			table.insert(t, (" %d"):format(v8))
		elseif (v8 > 0 or #t > 0) and #t < v1 then
			table.insert(t, ("%d"):format(v8))
		end
		if (v6 > 0 or #t > 0) and (#t < v1 and #t > 0) then
			table.insert(t, (":%d"):format(v6))
		elseif (v6 > 0 or #t > 0) and #t < v1 then
			table.insert(t, ("%d"):format(v6))
		end
		if #t < v1 and #t > 0 then
			table.insert(t, (":%s"):format(v7))
		elseif #t < v1 then
			table.insert(t, ("%s"):format(v7))
		end
		return table.concat(t, "")
	end
end
function t.TimeToShortString(p1) --[[ TimeToShortString | Line: 250 ]]
	local v1 = p1 // 60
	local v2 = v1 // 60
	local v3 = v1 % 60
	local v4 = p1 % 60
	if v2 > 0 then
		return ("%d %s"):format(v2, if v2 > 1 then "Hours" else "Hour")
	elseif v3 > 0 then
		return ("%d %s"):format(v3, if v3 > 1 then "Min" else "Mins")
	elseif v4 > 0 then
		return ("%s %s"):format(v4, if v4 > 1 then "Secs" else "Sec")
	else
		return "0 Sec"
	end
end
function t.FormatTime(p1, p2, p3) --[[ FormatTime | Line: 268 ]]
	if not p2 then
		p2 = "%h:%m:%s"
	end
	local v2 = math.max(math.floor(p1), 0)
	local v3 = v2 // 60
	local v4 = v3 // 60
	local v5 = if p3 then v4 // 24 else p3
	local v6 = v3 % 60
	local v7 = v2 % 60
	if p3 then
		v4 = v4 % 24
	end
	return (if p3 then p2:gsub("%%%%d", ("%02d"):format(p3)):gsub("%%d", (tostring(v5))) else p2):gsub("%%%%h", ("%02d"):format(v4)):gsub("%%h", (tostring(v4))):gsub("%%%%m", ("%02d"):format(v6)):gsub("%%m", (tostring(v6))):gsub("%%%%s", ("%02d"):format(v7)):gsub("%%s", (tostring(v7)))
end
function t.ExecAtNewDay(p1) --[[ ExecAtNewDay | Line: 291 | Upvalues: t (copy) ]]
	return task.spawn(function() --[[ Line: 292 | Upvalues: t (ref), p1 (copy) ]]
		while task.wait(t.DayRemaining() + 1) do
			p1()
		end
	end)
end
function t.StartTimer(p1, p2, p3, p4) --[[ StartTimer | Line: 301 ]] end
return t