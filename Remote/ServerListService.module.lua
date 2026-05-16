-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.ServerListService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local v1 = SimpleSignal.new()
local v2 = SimpleSignal.new()
local t = {
	Inited = false,
	DataInited = v1,
	DataUpdated = v2
}
local t2 = {}
function t.GetServers() --[[ GetServers | Line: 16 | Upvalues: t2 (ref) ]]
	return t2
end
function t.Join(p1, p2) --[[ Join | Line: 20 | Upvalues: t2 (ref) ]]
	if t2 and (t2[p1] and t2[p1][p2]) then
		local v2, v3 = pcall(function() --[[ Line: 25 | Upvalues: p1 (copy), p2 (copy) ]]
			return script.Join:InvokeServer(p1, p2)
		end)
		return v2 and v3
	end
end
function t.JoinAny(p1) --[[ JoinAny | Line: 31 | Upvalues: t2 (ref) ]]
	if t2[p1] then
		local v1, v2 = pcall(function() --[[ Line: 35 | Upvalues: p1 (copy) ]]
			return script.JoinAny:InvokeServer(p1)
		end)
		return v1 and v2
	end
end
function t.Cancel() --[[ Cancel | Line: 41 ]]
	local v1, v2 = pcall(function() --[[ Line: 42 ]]
		return script.Cancel:InvokeServer()
	end)
	return v1 and v2
end
function t.GetRefreshRemaining() --[[ GetRefreshRemaining | Line: 48 ]]
	return math.max((script:GetAttribute("RefreshTime") or 0) - workspace:GetServerTimeNow(), 0)
end
function t.Start() --[[ Start | Line: 52 | Upvalues: t2 (ref), t (copy), v1 (copy), v2 (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 53 | Upvalues: t2 (ref), t (ref), v1 (ref), v2 (ref) ]]
		if p1 then
			local t3 = {}
			if p2 then
				for v12, v22 in t2 do
					for v3, v4 in v22 do
						if not (p1[v12] and p1[v12].List[v3]) then
							if not t3[v12] then
								t3[v12] = {}
							end
							t3[v12][v3] = v4
						end
					end
				end
				t2 = {}
				for v5, v6 in p1 do
					t2[v5] = v6.List
				end
				p1 = t2
			else
				for v7, v8 in p1 do
					if not t2[p3] then
						t2[p3] = {}
					end
					t2[p3][v7] = v8
				end
			end
			if t.Inited then
				if p3 then
					p1 = {
						[p3] = p1
					}
				end
				v2:Fire({
					Removed = t3,
					Updated = p1,
					UpdateAll = p2
				})
			else
				t.Inited = true
				v1:Fire()
			end
		end
	end)
end
function t.WaitInit() --[[ WaitInit | Line: 95 | Upvalues: t (copy), v1 (copy) ]]
	if not t.Inited then
		v1:Wait()
	end
	return t
end
function t.OnInit(p1) --[[ OnInit | Line: 102 | Upvalues: t (copy), v1 (copy) ]]
	if t.Inited then
		p1()
	else
		v1:Connect(p1)
	end
end
return t