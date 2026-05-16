-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.AnimUtils.AnimationSequence

-- https://lua.expert/
local t = {
	IsPlaying = false
}
local t2 = {
	__index = t
}
function t.Play(p1) --[[ Play | Line: 6 ]] end
function t.Pause(p1) --[[ Pause | Line: 10 ]] end
function t.Resume(p1) --[[ Resume | Line: 14 ]] end
function t.SetTimePosition(p1) --[[ SetTimePosition | Line: 18 ]] end
return {
	new = function() --[[ new | Line: 23 | Upvalues: t2 (copy) ]]
		return setmetatable({}, t2)
	end
}