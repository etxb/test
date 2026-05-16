-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TaskUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = RunService:IsStudio()
local v2 = RunService:IsServer()
local Utils = require(ReplicatedStorage.Util.Utils)
local t = {}
local t2 = {}
function t.ResetExecuteTime() --[[ ResetExecuteTime | Line: 14 | Upvalues: t2 (copy) ]]
	t2[coroutine.running()] = os.clock()
end
function t.ExecuteWait(p1, p2, p3, p4) --[[ ExecuteWait | Line: 19 | Upvalues: t2 (copy), v2 (copy), RunService (copy), v1 (copy) ]]
	local v22 = coroutine.running()
	local v3 = t2[v22]
	if not v3 then
		local v4 = os.clock()
		t2[v22] = v4
		v3 = v4
	end
	if (p1 or 0.1) < os.clock() - v3 then
		if p2 then
			p2()
		end
		local v5 = os.clock() - v3
		local sum
		if p4 then
			sum = p4()
		else
			sum = task.wait()
			if not v2 then
				for i = 1, math.random(2) do
					sum = sum + RunService.PreRender:Wait()
				end
			end
		end
		if not p3 and v1 then
			warn("execute time limit", v5, sum, debug.traceback("", 2))
		end
		t2[v22] = os.clock()
		return sum
	else
		return 0
	end
end
function t.ForEachWithLimited(p1, p2, p3) --[[ ForEachWithLimited | Line: 52 | Upvalues: t (copy) ]]
	local sum = 0
	for v1, v2 in p1 do
		sum = sum + t.ExecuteWait(p3)
		p2(v1, v2)
	end
	return sum
end
task.spawn(function() --[[ Line: 61 | Upvalues: t2 (copy) ]]
	while task.wait(5) do
		table.clear(t2)
	end
end)
local t3 = {}
function t.CancelTask(p1) --[[ CancelTask | Line: 69 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]
	if v1 and coroutine.status(v1) == "suspended" then
		task.cancel(v1)
	end
	t3[p1] = nil
end
function t.RunTask(p1, p2, ...) --[[ RunTask | Line: 77 | Upvalues: t (copy), t3 (copy), Utils (copy) ]]
	t.CancelTask(p1)
	t3[p1] = task.spawn(function(...) --[[ Line: 79 | Upvalues: p2 (copy), Utils (ref), p1 (copy), t3 (ref) ]]
		local v1, v2 = xpcall(p2, Utils.xpcallErrTrack, ...)
		if not v1 then
			warn(p1, v2)
		end
		t3[p1] = nil
	end, ...)
end
function t.RunTaskDelay(p1, p2, p3, ...) --[[ RunTaskDelay | Line: 88 | Upvalues: t (copy), t3 (copy), Utils (copy) ]]
	t.CancelTask(p1)
	t3[p1] = task.delay(p2, function(...) --[[ Line: 90 | Upvalues: p3 (copy), Utils (ref), p1 (copy), t3 (ref) ]]
		local v1, v2 = xpcall(p3, Utils.xpcallErrTrack, ...)
		if not v1 then
			warn(p1, v2)
		end
		t3[p1] = nil
	end, ...)
end
function t.CancelTasks(p1) --[[ CancelTasks | Line: 99 ]]
	for v1, v2 in p1 do
		if v2 and coroutine.status(v2) == "suspended" then
			task.cancel(v2)
		end
	end
end
function t.SafeCancel(p1) --[[ SafeCancel | Line: 107 ]]
	if p1 then
		if coroutine.status(p1) == "suspended" then
			task.cancel(p1)
			return
		end
		if coroutine.status(p1) ~= "normal" then
			return
		end
		task.defer(task.cancel, p1)
	end
end
function t.SimpleJoin(p1) --[[ SimpleJoin | Line: 138 ]]
	for v1, v2 in p1 do
		while coroutine.status(v2) ~= "dead" do
			task.wait()
		end
	end
end
local function runUntilTimer(p1, p2, ...) --[[ runUntilTimer | Line: 162 ]]
	local v1 = nil
	while not v1 do
		if p2(p1(...)) then
			v1 = true
		end
		if not v1 then
			task.wait()
		end
	end
end
function t.RunUntil(p1, p2, ...) --[[ RunUntil | Line: 174 | Upvalues: runUntilTimer (copy) ]]
	local v1 = task.spawn(runUntilTimer, p1, p2, ...)
	if coroutine.status(v1) == "suspended" then
		return v1
	end
end
local function isTrue(p1) --[[ isTrue | Line: 181 ]]
	return p1
end
function t.RunUntilRetrunTrue(p1, ...) --[[ RunUntilRetrunTrue | Line: 185 | Upvalues: t (copy), isTrue (copy) ]]
	return t.RunUntil(p1, isTrue, ...)
end
function t.RunTasksUntilComplete(p1, p2, p3) --[[ RunTasksUntilComplete | Line: 189 | Upvalues: Utils (copy) ]]
	if #p1 == 0 then
		return {}
	else
		local v1 = if p3 then p3 else {}
		local v2 = v1.StepToWait or 10
		local v3 = v1.WaitDuration or 1
		local PreSpawn = v1.PreSpawn
		local PostSpawn = v1.PostSpawn
		local v4 = coroutine.running()
		local v5 = false
		local t = {}
		local v6 = 0
		local t2 = {}
		local v7 = false
		local function cancel() --[[ cancel | Line: 217 | Upvalues: v7 (ref) ]]
			v7 = true
		end
		local function exector(p12) --[[ exector | Line: 221 | Upvalues: Utils (ref), p2 (copy), cancel (copy), t2 (copy), v6 (ref), v7 (ref), t (copy), p1 (copy), v5 (ref), v4 (copy) ]]
			local v1, v2 = Utils.xpcallSilent(p2, p12, cancel)
			table.insert(t2, {
				Success = v1,
				Result = v2
			})
			v6 = v6 + 1
			if if v7 then v6 == #t else v6 == #p1 and v5 then
				task.spawn(v4)
			end
		end
		for v8, v9 in p1 do
			if v7 then
				break
			end
			if PreSpawn then
				PreSpawn(v8, v9, cancel)
				if v7 then
					break
				end
			end
			table.insert(t, true)
			local v10 = task.spawn(exector, v9)
			t[#t] = v10
			if PostSpawn then
				PostSpawn(v8, v9, v10, cancel)
			end
			if v7 then
				break
			end
			if v8 % v2 == 0 then
				task.wait(v3)
			end
		end
		if v6 ~= #t then
			v5 = true
			coroutine.yield()
		end
		return t2
	end
end
return t