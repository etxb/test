-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.BoostService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local v1 = SimpleSignal.new()
local v2 = SimpleSignal.new()
local v3 = nil
local t = {
	Inited = false,
	DataUpdated = v1,
	DataInited = v2,
	GetBoostData = function() --[[ GetBoostData | Line: 18 | Upvalues: v3 (ref) ]]
		return v3
	end,
	HasBoost = function(p1) --[[ HasBoost | Line: 22 | Upvalues: v3 (ref) ]]
		local v1 = v3[p1]
		return if v1 then workspace:GetServerTimeNow() < v1 else v1
	end
}
function t.WaitInit() --[[ WaitInit | Line: 27 | Upvalues: t (copy), v2 (copy) ]]
	if not t.Inited then
		v2:Wait()
	end
	return t
end
function t.OnInit(p1) --[[ OnInit | Line: 34 | Upvalues: t (copy), v2 (copy) ]]
	if t.Inited then
		p1()
	else
		v2:Connect(p1)
	end
end
function t.Start() --[[ Start | Line: 42 | Upvalues: v3 (ref), t (copy), v2 (copy), v1 (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 43 | Upvalues: v3 (ref), t (ref), v2 (ref), v1 (ref) ]]
		if v3 or not p2 then
			if v3 then
				for v12, v22 in p1 do
					v3[v12] = v22
				end
				v1:Fire(p1)
			end
		else
			v3 = p1
			t.Inited = true
			v2:Fire()
		end
	end)
	task.spawn(function() --[[ Line: 59 | Upvalues: v3 (ref), t (ref), v1 (ref) ]]
		while task.wait(1) do
			if v3 then
				local t2 = {}
				for v12, v2 in v3 do
					if not t.HasBoost(v12) then
						t2[v12] = true
					end
				end
				for v32, v4 in t2 do
					v3[v32] = false
				end
				if next(t2) then
					v1:Fire(t2)
				end
			end
		end
	end)
end
return t