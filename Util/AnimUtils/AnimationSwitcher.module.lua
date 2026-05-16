-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.AnimUtils.AnimationSwitcher

-- https://lua.expert/
local t = {}
local t2 = {
	__index = t
}
function t.Switch(p1, p2) --[[ Switch | Line: 4 ]]
	local v1 = p1._anims[p2]
	if v1 ~= p1._current then
		if v1 then
			if p1._current then
				if p1._current.IsPlaying then
					v1:Play(p1._fadeTime, p1._current.WeightTarget, p1._current.Speed)
				end
				p1._current:Stop(p1._fadeTime)
			end
			p1._current = v1
		else
			p1._current:Stop()
			p1._current = nil
		end
	end
end
function t.Stop(p1, p2) --[[ Stop | Line: 23 ]]
	if p1._current then
		p1._current:Stop(p2)
	end
end
function t.Play(p1, p2, p3, p4) --[[ Play | Line: 29 ]]
	if p1._current and not p1._current.IsPlaying then
		p1._current:Play(p2, p3, p4)
	end
end
function t.AdjustSpeed(p1, p2) --[[ AdjustSpeed | Line: 35 ]]
	if p1._current then
		p1._current:AdjustSpeed(p2)
	end
end
function t.IsPlaying(p1) --[[ IsPlaying | Line: 41 ]]
	return p1._current and p1._current.IsPlaying
end
function t.Destroy(p1) --[[ Destroy | Line: 45 ]]
	if not p1.HasDestroyed then
		for v1, v2 in p1._connections do
			v2:Disconnect()
		end
		table.clear(p1)
		p1.HasDestroyed = true
	end
end
return {
	new = function(p1, p2) --[[ new | Line: 56 | Upvalues: t2 (copy) ]]
		local v2 = setmetatable({
			_anims = p1,
			_fadeTime = p2 or 0.5,
			_connections = {}
		}, t2)
		for v3, v4 in p1 do

		end
		return v2
	end
}