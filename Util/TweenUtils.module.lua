-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TweenUtils

-- https://lua.expert/
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local t = {}
local t2 = {
	CancelTweens = function(p1, p2) --[[ CancelTweens | Line: 9 ]]
		if p1 then
			for v1, v2 in p1 do
				if typeof(v2) == "thread" then
					task.cancel(v2)
					if p2 then
						print("cancel task")
					end
					continue
				end
				if typeof(v2) == "RBXScriptConnection" then
					v2:Disconnect()
				end
				v2:Cancel()
				if p2 then
					print("cancel tween")
				end
			end
		end
	end
}
function t2.CancelTweensOf(p1, p2) --[[ CancelTweensOf | Line: 32 | Upvalues: t (copy), t2 (copy) ]]
	local v1 = t[p1]
	if p2 then
		print(v1)
	end
	if v1 then
		t2.CancelTweens(v1)
		t[p1] = nil
	end
	return v1
end
function t2.PlayTweens(p1, p2) --[[ PlayTweens | Line: 44 | Upvalues: t2 (copy), t (copy) ]]
	if p1 and #p1 ~= 0 then
		if p2 then
			if t[p2] then
				t2.CancelTweens(t[p2])
			end
			t[p2] = p1
			local v1 = nil
			for v2, v3 in p1 do
				if typeof(v3) ~= "thread" and (typeof(v3) ~= "RBXScriptConnection" and (not v1 or v1.TweenInfo.Time < v3.TweenInfo.Time)) and v3.TweenInfo.RepeatCount ~= -1 then
					v1 = v3
				end
			end
			if v1 then
				local v4 = nil
				v4 = v1.Completed:Once(function() --[[ Line: 67 | Upvalues: t (ref), p2 (copy), p1 (copy), v4 (ref) ]]
					if t[p2] == p1 then
						t[p2] = nil
					end
					v4:Disconnect()
				end)
			end
		end
		for v5, v6 in p1 do
			if typeof(v6) ~= "thread" and typeof(v6) ~= "RBXScriptConnection" then
				v6:Play()
			end
		end
		return p1
	elseif p2 then
		t2.CancelTweensOf(p2)
	end
end
function t2.WaitTweens(p1) --[[ WaitTweens | Line: 84 ]]
	for v1, v2 in p1 do
		if v2.PlaybackState ~= Enum.PlaybackState.Completed and v2.PlaybackState ~= Enum.PlaybackState.Cancelled then
			v2.Completed:Wait()
		end
	end
end
function t2.PlayAndWait(p1, p2) --[[ PlayAndWait | Line: 93 | Upvalues: t2 (copy) ]]
	t2.PlayTweens(p1)
	t2.WaitTweens(p1)
end
function t2.GetNumberSeq(p1, p2, p3, p4, p5) --[[ GetNumberSeq | Line: 98 | Upvalues: TweenService (copy) ]]
	if #p1.Keypoints ~= #p2.Keypoints then
		error("keypoints length don\'t match!")
	end
	local v4, v5 = TweenService:GetValue(p3, if p4 then p4 else Enum.EasingStyle.Linear, if p5 then p5 else Enum.EasingDirection.Out), {}
	for i = 1, #p1.Keypoints do
		local v6 = p1.Keypoints[i]
		local v7 = p2.Keypoints[i]
		table.insert(v5, NumberSequenceKeypoint.new(v6.Time + (v7.Time - v6.Time) * v4, v6.Value + (v7.Value - v6.Value) * v4, v6.Envelope + (v7.Envelope - v6.Envelope) * v4))
	end
	return NumberSequence.new(v5)
end
function t2.ApplyTransparency(p1, p2) --[[ ApplyTransparency | Line: 115 ]]
	local t = {}
	for v1, v2 in p1.Keypoints do
		table.insert(t, NumberSequenceKeypoint.new(v2.Time, 1 - (1 - v2.Value) * (1 - p2), v2.Envelope))
	end
	return NumberSequence.new(t)
end
function t2.Arc(p1, p2, p3, p4) --[[ Arc | Line: 125 | Upvalues: TweenService (copy) ]]
	local v1 = if p3 then p3 else Enum.EasingStyle.Quad
	local v2 = if p4 then p4 else Enum.EasingDirection.Out
	local v3, v4
	if p1 < p2 then
		v3, v4 = math.clamp(p1 / p2, 0, 1), v1
	else
		v3 = 1 - math.clamp((p1 - p2) / (1 - p2), 0, 1)
		v4 = v1
	end
	return TweenService:GetValue(v3, v4, v2)
end
t2.Queue = require(script.TweenQueue)
function t2.GetOutInValue(p1, p2) --[[ GetOutInValue | Line: 139 | Upvalues: TweenService (copy) ]]
	if p1 < 0.5 then
		return TweenService:GetValue(p1 / 0.5, p2, Enum.EasingDirection.Out) * 0.5
	else
		return TweenService:GetValue((p1 - 0.5) / 0.5, p2, Enum.EasingDirection.In) * 0.5 + 0.5
	end
end
local function lerp(p1, p2, p3) --[[ lerp | Line: 147 ]]
	if typeof(p1) == "number" then
		return p1 + (p2 - p1) * p3
	else
		return p1:Lerp(p2, p3)
	end
end
function t2.PlayMoonAnim(p1, p2, p3, p4, p5, p6) --[[ PlayMoonAnim | Line: 154 | Upvalues: RunService (copy), lerp (copy) ]]
	local v1 = p4 or 1
	local v2 = p5 or 0
	local t = {}
	local Relative = p3.Relative.Value
	local v3 = false
	local v4 = p6 and p6.PropSetter
	for v5, v6 in p3:GetChildren() do
		if v6:IsA("Folder") then
			local function f8() --[[ Line: 168 | Upvalues: v6 (copy), p1 (copy), Relative (copy), v4 (copy), p2 (copy), v2 (ref), v1 (ref), v3 (ref), RunService (ref), lerp (ref) ]]
				local v12 = v6:FindFirstChild("default") or v6:FindFirstChild("0")
				if v12 then
					local v22 = if v6.Name == "CFrame" then p1:ToWorldSpace(v12.Value:ToObjectSpace(Relative):Inverse()) else v12.Value
					if v4 then
						v4(p2, v6.Name, v22)
					else
						p2[v6.Name] = v12.Value
					end
				end
				local t = {}
				for v42, v5 in v6:GetChildren() do
					if v5:IsA("Folder") then
						local t2 = {}
						t2.frameTime = tonumber(v5.Name)
						t2.value = v5.Values["0"].Value
						table.insert(t, t2)
					end
					if v5:IsA("ValueBase") then
						local t2 = {}
						t2.frameTime = tonumber(v5.Name)
						t2.value = v5.Value
						table.insert(t, t2)
					end
				end
				table.sort(t, function(p1, p2) --[[ Line: 192 ]]
					return p1.frameTime < p2.frameTime
				end)
				if v6.Name == "CFrame" then
					for v8, v9 in t do
						v9.value = p1:ToWorldSpace(v9.value:ToObjectSpace(Relative):Inverse())
					end
				end
				local sum = 0
				local v10 = 0
				for i = 1, #t do
					local v11 = i == 1 and t[i].frameTime or t[i].frameTime - t[i - 1].frameTime
					sum = sum + t[i].frameTime
					if not (t[i].frameTime < v2) then
						local v13 = math.min(sum - v2, v11) / (60 * v1)
						local v14 = p2[v6.Name]
						if i > 1 then
							v14 = t[i - 1].value
						end
						local value = t[i].value
						local sum_2 = v10
						while sum_2 < v13 and not v3 do
							local v15
							sum_2 = sum_2 + RunService.RenderStepped:Wait()
							if v4 then
								v4(p2, v6.Name, lerp(v14, value, (math.clamp(sum_2 / v13, 0, 1))))
							else
								local v18 = math.clamp(sum_2 / v13, 0, 1)
								v15 = if typeof(v14) == "number" then v14 + (value - v14) * v18 else v14:Lerp(value, v18)
								p2[v6.Name] = v15
							end
						end
						local v20 = math.max(sum_2 - v13, 0)
						if not v3 and i == #t and v4 then
							v4(p2, v6.Name, value)
						elseif not v3 and i == #t then
							p2[v6.Name] = value
						end
						if v3 then
							break
						end
						v10 = v20
					end
				end
			end
			table.insert(t, task.spawn(f8))
		end
	end
	return {
		WaitComplete = function() --[[ waitComplete | Line: 245 | Upvalues: t (copy) ]]
			for v1, v2 in t do
				while coroutine.status(v2) ~= "dead" do
					task.wait()
				end
			end
		end,
		Cancel = function() --[[ cancel | Line: 253 | Upvalues: t (copy), v3 (ref) ]]
			for v1, v2 in t do
				if coroutine.status(v2) ~= "dead" then
					task.cancel(v2)
				end
			end
			v3 = true
		end
	}
end
return t2