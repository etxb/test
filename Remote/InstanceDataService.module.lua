-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.InstanceDataService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {
	DataUpdated = SimpleSignal.new()
}
local v1 = TableUtils.WrapGet({}, SimpleSignal.new)
local t2 = {
	Event = t,
	GetDataUpdatedSignal = v1.get
}
local t3 = {}
local t4 = {}
local function destroy(p1) --[[ destroy | Line: 23 | Upvalues: t3 (copy), t4 (copy) ]]
	local v1 = t3[p1]
	if v1 then
		t3[p1] = nil
		t4[p1] = nil
		for v2, v3 in v1.Connections do
			v3:Disconnect()
		end
	end
end
local function getInstanceData(p1, p2) --[[ getInstanceData | Line: 35 | Upvalues: t3 (copy), TableUtils (copy), SimpleSignal (copy), t4 (copy) ]]
	local v1 = t3[p1]
	if not v1 and (p1.Parent or p2) then
		local t = {
			Instance = p1,
			Data = {},
			DataSignals = TableUtils.WrapGet({}, SimpleSignal.new),
			Connections = { p1.AncestryChanged:Connect(function() --[[ Line: 43 | Upvalues: p1 (copy), t3 (ref), t4 (ref) ]]
					if not p1.Parent then
						local v1 = p1
						local v2 = t3[v1]
						if v2 then
							t3[v1] = nil
							t4[v1] = nil
							for v3, v4 in v2.Connections do
								v4:Disconnect()
							end
						end
					end
				end), p1.Destroying:Connect(function() --[[ Line: 48 | Upvalues: p1 (copy), t3 (ref), t4 (ref) ]]
					local v1 = p1
					local v2 = t3[v1]
					if v2 then
						t3[v1] = nil
						t4[v1] = nil
						for v3, v4 in v2.Connections do
							v4:Disconnect()
						end
					end
				end) }
		}
		t3[p1] = t
		if not p1.Parent then
			t4[p1] = workspace:GetServerTimeNow()
		end
		v1 = t
	end
	return v1
end
task.spawn(function() --[[ Line: 61 | Upvalues: t4 (copy), t3 (copy) ]]
	while task.wait(5) do
		local v1 = workspace:GetServerTimeNow()
		for v2, v3 in t4 do
			if v2.Parent or v1 - v3 < 5 then
				t4[v2] = nil
				if not v2.Parent then
					local v4 = t3[v2]
					if v4 then
						t3[v2] = nil
						t4[v2] = nil
						for v5, v6 in v4.Connections do
							v6:Disconnect()
						end
					end
				end
			end
		end
	end
end)
function t2.GetDataRoot(p1, p2) --[[ GetDataRoot | Line: 75 | Upvalues: getInstanceData (copy) ]]
	local v1 = getInstanceData(p1, p2)
	return if v1 then v1.Data else v1
end
function t2.GetInstanceDataUpdatedSignal(p1, p2, p3) --[[ GetInstanceDataUpdatedSignal | Line: 80 | Upvalues: getInstanceData (copy) ]]
	local v1 = getInstanceData(p1, p3)
	if v1 then
		return v1.DataSignals.get(p2)
	end
end
if RunService:IsStudio() then
	function t2.GetRoot() --[[ GetRoot | Line: 90 | Upvalues: t3 (copy) ]]
		return t3
	end
end
function t2.GetData(p1, p2) --[[ GetData | Line: 95 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]
	return if v1 then v1.Data[p2] else v1
end
local function fireUpdated(p1, p2, p3) --[[ fireUpdated | Line: 100 | Upvalues: t (copy), v1 (copy) ]]
	t.DataUpdated:Fire(p1.Instance, p2, p3)
	local v12 = v1[p2]
	if v12 then
		v12:Fire(p1.Instance, p2, p3)
	end
	local v2 = p1.DataSignals[p2]
	if v2 then
		v2:Fire(p2, p3)
	end
end
local function setDataValue(p1, p2, p3, p4) --[[ setDataValue | Line: 112 | Upvalues: getInstanceData (copy), t (copy), v1 (copy) ]]
	local v12 = if p1 then getInstanceData(p1, true) else p1
	if v12 then
		v12.Data[p2] = p3
		if not p4 then
			t.DataUpdated:Fire(v12.Instance, p2, p3)
			local v2 = v1[p2]
			if v2 then
				v2:Fire(v12.Instance, p2, p3)
			end
			local v3 = v12.DataSignals[p2]
			if not v3 then
				return
			end
			v3:Fire(p2, p3)
		end
	end
end
local function setData(p1, p2) --[[ setData | Line: 123 | Upvalues: getInstanceData (copy), t (copy), v1 (copy) ]]
	local v12 = if p1 then getInstanceData(p1, true) else p1
	if v12 then
		for v2, v3 in p2 do
			v12.Data[v2] = v3
		end
		for v4, v5 in p2 do
			t.DataUpdated:Fire(v12.Instance, v4, v5)
			local v6 = v1[v4]
			if v6 then
				v6:Fire(v12.Instance, v4, v5)
			end
			local v7 = v12.DataSignals[v4]
			if v7 then
				v7:Fire(v4, v5)
			end
		end
	end
end
({
	REQUEST_LIMIT = 10,
	requestSent = 0,
	requestInterval = 0,
	lastRequestTime = 0
}).Request = function(p1) --[[ Request | Line: 144 ]]
	if not (p1.requestSent >= p1.REQUEST_LIMIT) then
		local v1 = os.clock()
		if not (v1 - p1.lastRequestTime < p1.requestInterval) then
			p1.requestSent = p1.requestSent + 1
			p1.lastRequestTime = v1
			local v2, _ = pcall(function() --[[ Line: 154 ]]
				return script.Request:InvokeServer()
			end)
			p1.requestSent = p1.requestSent - 1
			if v2 and not (os.clock() - p1.lastRequestTime < 0.016) then
				local _2 = os.clock() - v1
			end
		end
	end
end
function t2.Start() --[[ Start | Line: 167 | Upvalues: getInstanceData (copy), t (copy), v1 (copy), setData (copy), RunService (copy) ]]
	script.SetData.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 168 | Upvalues: getInstanceData (ref), t (ref), v1 (ref) ]]
		local v12 = if p1 then getInstanceData(p1, true) else p1
		if v12 then
			v12.Data[p2] = p3
			t.DataUpdated:Fire(v12.Instance, p2, p3)
			local v2 = v1[p2]
			if v2 then
				v2:Fire(v12.Instance, p2, p3)
			end
			local v3 = v12.DataSignals[p2]
			if v3 then
				v3:Fire(p2, p3)
			end
		end
	end)
	script.SetDataBatch.OnClientEvent:Connect(function(p1, p2) --[[ Line: 171 | Upvalues: setData (ref) ]]
		for v1, v2 in p1 do
			setData(v2[1], v2[2])
		end
	end)
	RunService.Heartbeat:Connect(function(p1) --[[ Line: 176 ]] end)
end
return t2