-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TaskHolder

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local v1 = require(ReplicatedStorage.Util.Pool).task()
local v2 = table.freeze({})
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 17 | Upvalues: TableUtils (copy) ]]
	return setmetatable({
		tasks = {},
		tasksByGroup = TableUtils.AutoTable(),
		tasksByName = {}
	}, p1)
end
function t.SimpleTask(p1, p2, ...) --[[ SimpleTask | Line: 26 ]]
	return p1:SpawnTask(nil, p2, ...)
end
function t.DelayTask(p1, p2, p3, ...) --[[ DelayTask | Line: 30 ]]
	return p1:SpawnTask({
		Delay = p2
	}, p3, ...)
end
function t.SpawnTask(p1, p2, p3, ...) --[[ SpawnTask | Line: 34 | Upvalues: TableUtils (copy), Utils (copy), v1 (copy), v2 (copy) ]]
	if p1.HasDestroyed then
		error("task manager destroyed")
	end
	local v12 = TableUtils.OrEmpty(p2)
	if v12.Name then
		p1:CancelTaskByName(v12.Name)
	end
	local v22 = v12
	local OnFinished = v22.OnFinished
	local OnStopped = v22.OnStopped
	local function f3(...) --[[ Line: 47 | Upvalues: p3 (copy), Utils (ref), OnFinished (copy), OnStopped (copy), p1 (copy) ]]
		local v1 = coroutine.running()
		local v2, v3 = xpcall(p3, Utils.xpcallErrTrack, ...)
		if not v2 then
			warn(v3)
		end
		if v2 and OnFinished then
			OnFinished(v1)
		end
		if OnStopped then
			OnStopped(v1)
		end
		p1:CancelTask(v1, true)
	end
	local v4 = if v22.Delay then v1:Delay(v22.Delay, f3, ...) else v1:Submit(f3, ...)
	if v4 and not v1:IsInPool(v4) then
		local t = {
			Task = v4,
			Name = v22.Name
		}
		t.Group = v22.Group or v2
		t.OnCancelled = v22.OnCancelled
		t.OnStopped = OnStopped
		p1.tasks[v4] = t
		if t.Name then
			p1.tasksByName[t.Name] = t
		end
		p1.tasksByGroup[t.Group][v4] = t
	end
	return v4
end
function t.CancelTask(p1, p2, p3) --[[ CancelTask | Line: 90 ]]
	local v1 = p1.tasks[p2]
	if v1 then
		p1.tasks[p2] = nil
		if v1.Name then
			p1.tasksByName[v1.Name] = nil
		end
		p1.tasksByGroup[v1.Group][p2] = nil
		if not p3 then
			if coroutine.status(p2) == "suspended" then
				task.cancel(p2)
			end
			if v1.OnCancelled then
				task.spawn(v1.OnCancelled, p2)
			end
			if not v1.OnStopped then
				return
			end
			task.spawn(v1.OnStopped, p2)
		end
	end
end
function t.CancelTaskByName(p1, p2) --[[ CancelTaskByName | Line: 115 ]]
	local v1 = p1.tasksByName[p2]
	if v1 then
		p1:CancelTask(v1.Task)
	end
end
function t.CancelTaskGroup(p1, p2) --[[ CancelTaskGroup | Line: 122 ]]
	local v1 = rawget(p1.tasksByGroup, p2)
	if v1 then
		p1.tasksByGroup[p2] = {}
		for v2, v3 in v1 do
			p1:CancelTask(v2)
		end
	end
end
function t.CancelTasksUngrouped(p1) --[[ CancelTasksUngrouped | Line: 133 | Upvalues: v2 (copy) ]]
	p1:CancelTaskGroup(v2)
end
function t.Destroy(p1) --[[ Destroy | Line: 137 ]]
	p1.HasDestroyed = true
	for v1, v2 in p1.tasks do
		p1:CancelTask(v1)
	end
	table.clear(p1.tasks)
	table.clear(p1.tasksByName)
	table.clear(p1.tasksByGroup)
	p1.HasDestroyed = true
end
return t