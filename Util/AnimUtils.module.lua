-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.AnimUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
require(ReplicatedStorage.Shared.Promise)
return {
	ConnectWalkAnim = function(p1, p2, p3) --[[ ConnectWalkAnim | Line: 8 | Upvalues: StarterPlayer (copy) ]]
		local t = {}
		local v1 = p2:LoadAnimation(p3)
		local function f2(p1) --[[ Line: 12 | Upvalues: p3 (copy), StarterPlayer (ref), v1 (copy) ]]
			local v12 = (p3:GetAttribute("WalkSpeed") or 16) / StarterPlayer.CharacterWalkSpeed
			local v2 = p1 > 0.1
			if v2 and not v1.IsPlaying then
				v1:Play(0.5, nil, v12)
			elseif not v2 and v1.IsPlaying then
				v1:Stop(0.5)
			end
		end
		table.insert(t, p1.Running:Connect(f2))
		table.insert(t, p1.Jumping:Connect(function(p1) --[[ Line: 21 | Upvalues: v1 (copy) ]]
			if p1 then
				v1:Stop(0.25)
			end
		end))
		return t
	end,
	PlaySeq = function(p1, ...) --[[ PlaySeq | Line: 56 ]]
		local t = { ... }
		for v1, v2 in t do
			if v2:IsA("Animation") then
				t[v1] = p1:LoadAnimation(v2)
			end
		end
	end,
	PlayExact = function(p1, p2, p3, p4, p5) --[[ PlayExact | Line: 66 ]]
		p1:Play(p3, p4, p5)
		local _ = p1.Length > 0
	end
}