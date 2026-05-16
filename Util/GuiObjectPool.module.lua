-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GuiObjectPool

-- https://lua.expert/
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 10 ]]
	local t = {
		_processScheduled = false,
		_size = 20,
		_lifetime = 10,
		_create = p2
	}
	t._pool = setmetatable({}, {
		__index = table
	})
	t._reverse = {}
	t._pendingNilQueue = {}
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
local function v1(p1) --[[ scheduleProcess | Line: 39 | Upvalues: v1 (copy) ]]
	if not p1._processScheduled then
		p1._processScheduled = true
		task.defer(function() --[[ Line: 44 | Upvalues: p1 (copy), v1 (ref) ]]
			p1._processScheduled = false
			local v12 = os.clock()
			for i = #p1._pendingNilQueue, 1, -1 do
				local v2 = p1._pendingNilQueue[i]
				table.remove(p1._pendingNilQueue, i)
				v2.Parent = nil
				p1._pool:insert(v2)
				p1._reverse[v2] = true
				if os.clock() - v12 >= 0.008333333333333333 then
					v1(p1)
					return
				end
			end
		end)
	end
end
function t.Request(p1) --[[ Request | Line: 62 ]]
	if #p1._pendingNilQueue > 0 then
		return table.remove(p1._pendingNilQueue, 1)
	else
		local v1 = nil
		while not v1 and #p1._pool > 0 do
			local v2 = p1._pool:remove()
			if v2 then
				p1._reverse[v2] = nil
			end
			v1 = v2
		end
		if v1 then
			return v1
		else
			return p1._create(p1)
		end
	end
end
function t.Release(p1, p2) --[[ Release | Line: 84 | Upvalues: v1 (copy) ]]
	if not p2 then
		error("object is nil")
	end
	if not p1._reverse[p2] then
		for i = 1, #p1._pendingNilQueue do
			if p1._pendingNilQueue[i] == p2 then
				return
			end
		end
		if p1._release then
			p1._release(p2)
		end
		p1:OnRelease(p2)
		if p2.Visible then
			p2.Visible = false
		end
		table.insert(p1._pendingNilQueue, p2)
		if not p1._processScheduled then
			p1._processScheduled = true
			task.defer(function() --[[ Line: 44 | Upvalues: p1 (copy), v1 (ref) ]]
				p1._processScheduled = false
				local v12 = os.clock()
				for i = #p1._pendingNilQueue, 1, -1 do
					local v2 = p1._pendingNilQueue[i]
					table.remove(p1._pendingNilQueue, i)
					v2.Parent = nil
					p1._pool:insert(v2)
					p1._reverse[v2] = true
					if os.clock() - v12 >= 0.008333333333333333 then
						v1(p1)
						return
					end
				end
			end)
		end
	end
end
function t.OnRelease(p1, p2) --[[ OnRelease | Line: 109 ]] end
function t.IsInPool(p1, p2) --[[ IsInPool | Line: 111 ]]
	if p1._reverse[p2] then
		return true
	else
		for i = 1, #p1._pendingNilQueue do
			if p1._pendingNilQueue[i] == p2 then
				return true
			end
		end
		return false
	end
end
return {
	byInstance = function(p1, p2) --[[ byInstance | Line: 124 | Upvalues: t (copy) ]]
		local v1 = if p2 then p2 else {}
		if not v1.OnDestroy then
			v1.OnDestroy = workspace.Destroy
		end
		local v3 = t:new(function() --[[ Line: 129 | Upvalues: p1 (copy) ]]
			return p1:Clone()
		end, v1)
		v3.BaseInstance = p1
		return v3
	end,
	create = function(p1, p2) --[[ create | Line: 136 | Upvalues: t (copy) ]]
		return t:new(p1, p2)
	end
}