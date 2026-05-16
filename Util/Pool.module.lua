-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.Pool

-- https://lua.expert/
game:GetService("RunService")
game:GetService("UserInputService")
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 11 ]]
	local t = {
		_size = 20,
		_lifetime = 10,
		_create = p2
	}
	t._pool = setmetatable({}, {
		__index = table
	})
	t._reverse = {}
	local v1 = setmetatable(t, p1)
	if p3 then
		if p3.Size then
			v1._size = p3.Size
		end
		if p3.OnRelease then
			v1._release = p3.OnRelease
		end
		if p3.OnDestroy then
			v1._destroy = p3.OnDestroy
		end
	end
	return v1
end
function t.Request(p1) --[[ Request | Line: 60 ]]
	local v1 = nil
	local v2, v3
	while true do
		if v1 or not (#p1._pool > 0) then
			v2 = if v1 then v1 else p1._create(p1)
			return v2
		end
		v3 = p1._pool:remove()
		if not v3 then
			break
		end
		if v3 then
			p1._reverse[v3] = nil
		end
		v1 = v3
	end
	v2 = if v3 then v3 else p1._create(p1)
	return v2
end
function t.Release(p1, p2) --[[ Release | Line: 74 ]]
	if p1._release then
		p1._release(p2)
	end
	p1._pool:insert(p2)
	p1._reverse[p2] = true
end
function t.IsInPool(p1, p2) --[[ IsInPool | Line: 82 ]]
	return p1._reverse[p2]
end
local t2 = {}
t2.__index = t2
local function acquireRunnerThread(p1, ...) --[[ acquireRunnerThread | Line: 89 ]]
	p1(...)
end
local function runInFreeThread(p1) --[[ runInFreeThread | Line: 93 | Upvalues: acquireRunnerThread (copy) ]]
	local v1 = coroutine.running()
	while true do
		acquireRunnerThread(coroutine.yield())
		p1:Release(v1)
	end
end
local function newThread(p1) --[[ newThread | Line: 101 | Upvalues: runInFreeThread (copy) ]]
	return task.spawn(runInFreeThread, p1)
end
function t2.new(p1) --[[ new | Line: 105 | Upvalues: t (copy), newThread (copy) ]]
	return setmetatable({
		_pool = t:new(newThread)
	}, p1)
end
function t2.Submit(p1, p2, ...) --[[ Submit | Line: 109 ]]
	local v1 = nil
	while not v1 or coroutine.status(v1) ~= "suspended" do
		v1 = p1._pool:Request()
	end
	return task.spawn(v1, p2, ...)
end
function t2.Delay(p1, p2, p3, ...) --[[ Delay | Line: 117 ]]
	local v1 = nil
	while not v1 or coroutine.status(v1) ~= "suspended" do
		v1 = p1._pool:Request()
	end
	return task.delay(p2, v1, p3, ...)
end
function t2.IsInPool(p1, p2) --[[ IsInPool | Line: 125 ]]
	return p1._pool:IsInPool(p2)
end
return {
	byInstance = function(p1, p2) --[[ byInstance | Line: 130 | Upvalues: t (copy) ]]
		local v1 = if p2 then p2 else {}
		if not v1.OnDestroy then
			v1.OnDestroy = workspace.Destroy
		end
		return t:new(function() --[[ Line: 135 | Upvalues: p1 (copy) ]]
			return p1:Clone()
		end, v1)
	end,
	create = function(p1, p2) --[[ create | Line: 139 | Upvalues: t (copy) ]]
		return t:new(p1, p2)
	end,
	task = function() --[[ task | Line: 142 | Upvalues: t2 (copy) ]]
		return t2:new()
	end
}