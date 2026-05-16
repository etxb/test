-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.ConnectionHolder

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local t = {}
t.__index = t
local v1 = newproxy(true)
getmetatable(v1).__tostring = "_default"
function t.new(p1) --[[ new | Line: 13 | Upvalues: TableUtils (copy) ]]
	return setmetatable({
		ConnectionsUnnamed = {},
		Connections = {},
		ConnectionsByGroup = TableUtils.AutoTable()
	}, p1)
end
function t.AddConnection(p1, p2, p3, p4) --[[ AddConnection | Line: 22 | Upvalues: v1 (copy) ]]
	if typeof(p2) == "RBXScriptConnection" then
		p3, p2 = p2, nil
	end
	if p1.Destroyed then
		p3:Disconnect()
		return p3
	elseif p2 == nil then
		table.insert(p1.ConnectionsUnnamed, p3)
	else
		local v12 = p1:Disconnect(p2)
		local t = {
			Cn = p3
		}
		t.Group = if p4 then p4 else v1
		p1.Connections[p2] = t
		p1.ConnectionsByGroup[t.Group][p2] = t
		return v12
	end
end
function t.Disconnect(p1, p2) --[[ Disconnect | Line: 44 ]]
	local v1 = p1.Connections[p2]
	if v1 then
		v1.Cn:Disconnect()
		p1.Connections[p2] = nil
		p1.ConnectionsByGroup[v1.Group][p2] = nil
		table.clear(v1)
	end
	return if v1 then v1.Cn else v1
end
function t.DisconnectGroup(p1, p2) --[[ DisconnectGroup | Line: 55 ]]
	local v1 = rawget(p1.ConnectionsByGroup, p2)
	if v1 then
		for v2, v3 in v1 do
			p1:Disconnect(v2)
		end
		table.clear(v1)
		p1.ConnectionsByGroup[p2] = nil
	end
end
function t.DisconnectUngrouped(p1) --[[ DisconnectUngrouped | Line: 67 | Upvalues: v1 (copy) ]]
	p1:DisconnectGroup(v1)
end
function t.DisconnectAll(p1) --[[ DisconnectAll | Line: 71 ]]
	for v1, v2 in p1.ConnectionsUnnamed do
		v2:Disconnect()
	end
	table.clear(p1.ConnectionsUnnamed)
	for v3, v4 in p1.Connections do
		v4.Cn:Disconnect()
	end
	table.clear(p1.Connections)
	for v5, v6 in p1.ConnectionsByGroup do
		table.clear(v6)
	end
	table.clear(p1.ConnectionsByGroup)
end
function t.Destroy(p1) --[[ Destroy | Line: 86 ]]
	p1.Destroyed = true
	p1:DisconnectAll()
end
return t