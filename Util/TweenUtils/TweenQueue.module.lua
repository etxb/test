-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.TweenUtils.TweenQueue

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {}
t.__index = t
function t.new() --[[ new | Line: 8 | Upvalues: SimpleSignal (copy), t (copy) ]]
	return setmetatable({
		Completed = SimpleSignal.new()
	}, t)
end
function t.Play(p1, p2) --[[ Play | Line: 12 ]]
	local v1 = p1[1]
	if v1 then
		table.remove(p1, 1)
		v1:Play()
		v1.Completed:Connect(function() --[[ Line: 22 | Upvalues: p1 (copy), v1 (copy) ]]
			if p1.Tweening == v1 then
				p1.Tweening = nil
			end
		end)
		p1.Tweening = v1
	elseif p2 then
		p1.Completed:Fire()
	end
end
function t.Add(p1, p2) --[[ Add | Line: 30 ]]
	p2.Completed:Connect(function(p12) --[[ Line: 31 | Upvalues: p1 (copy) ]]
		if p12 == Enum.PlaybackState.Completed then
			p1:Play(true)
		end
	end)
	table.insert(p1, p2)
end
function t.Cancel(p1) --[[ Cancel | Line: 39 ]]
	if p1.Tweening then
		p1.Tweening:Cancel()
		p1.Tweening = nil
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 46 ]]
	p1:Cancel()
	table.clear(p1)
end
return t