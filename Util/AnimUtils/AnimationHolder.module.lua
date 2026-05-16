-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.AnimUtils.AnimationHolder

-- https://lua.expert/
game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 14 | Upvalues: TableUtils (copy), SimpleSignal (copy) ]]
	assert(p2, "root instance can\'t be nil")
	assert(p4, "animProvider is required")
	if not p5 then
		p5 = function(p1) --[[ Line: 18 | Upvalues: p3 (copy) ]]
			return p3:LoadAnimation(p1)
		end
	end
	return setmetatable({
		Instance = p2,
		Animator = p3,
		animFadeTime = {},
		animLoadRequired = {},
		animProvider = p4,
		animLoader = p5,
		anims = {},
		animsPlayingByTrack = {},
		animsPlaying = {},
		animsPlayingTagged = TableUtils.AutoTable(),
		animsOverride = {},
		animsDisabled = {},
		animsPaused = {},
		Signals = {
			AnimLoaded = TableUtils.WrapGet({}, SimpleSignal.new),
			AnimPlayed = TableUtils.WrapGet({}, SimpleSignal.new),
			AnimEnded = TableUtils.WrapGet({}, SimpleSignal.new),
			AnimStopped = TableUtils.WrapGet({}, SimpleSignal.new)
		}
	}, p1)
end
function t.fireSignal(p1, p2, p3, ...) --[[ fireSignal | Line: 54 ]]
	local v1 = p1.Signals[p2]
	local v2 = if v1 then v1[p3] else v1
	if v2 then
		v2:Fire(...)
	end
end
function t.SetFadeTime(p1, p2, p3) --[[ SetFadeTime | Line: 69 ]]
	for v1, v2 in p2 do
		p1.animFadeTime[v2] = p3
	end
	return p1
end
function t.SetLoadRequired(p1, p2) --[[ SetLoadRequired | Line: 76 ]]
	for v1, v2 in p2 do
		p1.animLoadRequired[v2] = true
	end
	return p1
end
function t.FindAnim(p1, p2, p3) --[[ FindAnim | Line: 83 ]]
	local v1 = p1.animProvider and p1.animProvider(p2, p3)
	return if v1 then if #v1.AnimationId > 0 then v1 else false else v1
end
function t.GetAnim(p1, p2, p3) --[[ GetAnim | Line: 88 | Upvalues: TableUtils (copy) ]]
	local v1 = TableUtils.OrEmpty(p3)
	local Anim = v1.Anim
	local v2
	if v1.Anims then
		v2 = v1
		for v3, v4 in v1.Anims do
			if p1:FindAnim(v4) then
				Anim = v4
				break
			end
		end
	else
		v2 = v1
	end
	local v5 = if Anim then Anim else p1.animsOverride[p2] or p2
	if p1.dbg and v5 == p1.animsOverride[p2] then
		print("\229\138\168\231\148\187\232\166\134\229\134\153", p2, v5)
	end
	local v6 = v5
	local v7 = p1:FindAnim(v6, v2)
	if not v7 and v6 ~= p2 then
		if p1.dbg then
			print("\230\156\170\230\137\190\229\136\176\229\138\168\231\148\187", v6)
		end
		v7 = p1:FindAnim(p2, v2)
	end
	if v7 then
		local v8 = p1.anims[v7]
		if not v8 and v7 then
			v8 = p1.animLoader(v7)
			if v8 then
				p1:fireSignal("AnimLoaded", p2, v8)
				p1.anims[v7] = v8
				v8.Stopped:Connect(function() --[[ Line: 121 | Upvalues: p1 (copy), p2 (copy), v8 (ref) ]]
					p1:fireSignal("AnimStopped", p2, v8)
				end)
				v8.Ended:Connect(function() --[[ Line: 125 | Upvalues: p1 (copy), v8 (ref), p2 (copy) ]]
					local v1 = p1.animsPlayingByTrack[v8]
					if v1 and p1.animsPlaying[v1.PlayName] == v1 then
						p1.animsPlaying[v1.PlayName] = nil
						if v1.Tags then
							for v2, v3 in v1.Tags do
								p1.animsPlayingTagged[v3][v1.PlayName] = nil
							end
						end
					end
					p1.animsPlayingByTrack[v8] = nil
					p1:fireSignal("AnimEnded", p2, v8)
				end)
			end
		end
		return v8
	end
end
function t._PlayAnim(p1, p2, p3, p4, p5, p6) --[[ _PlayAnim | Line: 143 ]]
	local Animation = p3.Animation
	if p3.Length ~= 0 or not (p5.RequireLoaded or p1.animLoadRequired[p2]) then
		local v1 = (p5.Rate or 1) * (Animation:GetAttribute("Rate") or 1)
		local sum = 0
		if p5.StartKeyframe and p3.Length > 0 then
			pcall(function() --[[ Line: 158 | Upvalues: sum (ref), p3 (copy), p5 (copy) ]]
				sum = p3:GetTimeOfKeyframe(p5.StartKeyframe)
			end)
		end
		local v2 = Animation:GetAttribute("FakeLength") or p3.Length + (Animation:GetAttribute("ExtraLength") or 0)
		local Duration = p5.Duration
		if Duration and not Animation:GetAttribute("FixedRate") then
			if Duration <= 0 then
				return
			end
			local v3 = Duration + (p5.ExtraDuration or 0)
			if p3.Length > 0 then
				local v4 = v2
				if p5.DurationKeyframe then
					pcall(function() --[[ Line: 176 | Upvalues: v4 (ref), p3 (copy), p5 (copy) ]]
						v4 = p3:GetTimeOfKeyframe(p5.DurationKeyframe)
					end)
				end
				if v4 <= 0 then
					v4 = v2
				end
				v1 = v1 * ((v4 - sum) / v3)
			end
		end
		local v5 = v1 or 1
		local v6 = p5.MinRate or Animation:GetAttribute("MinRate") or 0
		local v8 = math.clamp(v5, v6, p5.MaxRate or (Animation:GetAttribute("MaxRate") or math.max(v5, v6)))
		local IsPlaying = p3.IsPlaying
		local v9
		if p3.Length > 0 and not p3.Looped then
			local v10 = p5.Time or workspace:GetServerTimeNow()
			local v11 = v2 / math.abs(v8) - sum
			local v13 = v11 - math.max(0, workspace:GetServerTimeNow() - v10 - 0.1)
			if v13 <= 0 then
				return
			end
			sum = sum + (v11 - v13) * math.abs(v8)
			v9 = v8
		else
			v9 = v8
		end
		if p5.Reverse then
			v9 = -v9
		end
		if p1.dbg then
			print("\230\146\173\230\148\190\229\138\168\231\148\187", p2, p5, "\233\128\159\229\186\166", v9, "\233\135\141\230\146\173", p5.Replay, p3.Animation)
		end
		if p3.IsPlaying and (p3.Looped or not p5.Replay) then
			p3:AdjustSpeed(v9)
		elseif p3.Looped or (not p3.IsPlaying or (p3.Length == 0 or not (p3.TimePosition / v2 < (Animation:GetAttribute("ReplayAfter") or -1)))) then
			p3:Stop(0.001)
			p3:Play(if p6 then p6 else p5.FadeTime or (Animation:GetAttribute("FadeTime") or p1.animFadeTime[p2]), nil, v9)
			p1:fireSignal("AnimPlayed", p2, p3)
		else
			return
		end
		local v15 = if p1.animsDisabled[p2] then 0 else p5.Weight
		if v15 then
			p3:AdjustWeight(v15, if v15 == 0 then 0.001 else nil)
		end
		if not p3.Looped and (sum > 0 and p3.Length > 0) then
			p3.TimePosition = sum
		end
	end
end
function t.PlayAnim(p1, p2, p3, p4) --[[ PlayAnim | Line: 236 | Upvalues: TableUtils (copy) ]]
	if p1.Instance.Parent then
		local v1 = TableUtils.OrEmpty(p3)
		local v2 = p1:GetAnim(p2, v1)
		local v3 = if v2 then v2.Animation else v2
		local v5 = p1:GetPlaying(p2, v1.StopFade or if v3 then v3:GetAttribute("StopFade") else v3)
		local v6 = nil
		local v7, v8
		if v5 and v5.Anim ~= v2 then
			if v1.KeepPlayAs then
				v5.PlayName = v1.KeepPlayAs
				p1.animsPlaying[v1.KeepPlayAs] = v5
				if v5.Tags then
					v7 = v1
					for v9, v10 in v5.Tags do
						p1.animsPlayingTagged[v10][v1.KeepPlayAs] = v5
						p1.animsPlayingTagged[v10][p2] = nil
					end
				else
					v7 = v1
				end
				v6 = v5
			else
				local v11, v12
				if p1.dbg then
					local v13 = print
					local v14 = "\232\166\134\231\155\150\229\143\150\230\182\136\229\138\168\231\148\187"
					local PlayArgs = v5.PlayArgs
					local Animation = v5.Anim.Animation
					local v15, v16, v17
					if p4 then
						v15 = p2
						v16 = v1
						v17 = p4
						v7 = v1
					else
						v17 = v1.FadeTime
						if v17 then
							v15 = p2
							v16 = v1
							v7 = v1
						else
							if v3 then
								v17 = v3:GetAttribute("FadeTime")
								if v17 then
									v15 = p2
									v16 = v1
									v7 = v1
								end
								v13(v14, v15, PlayArgs, Animation, v16, v17)
								v11 = if p4 then p4 else v7.FadeTime or if v3 then v3:GetAttribute("FadeTime") or 0 else 0
								v12 = math.max(v11, 0.001)
								if not v5.Anim.IsPlaying and v5.Anim.WeightCurrent ~= 0 then
									v5.Anim:Play(0, 0, 0)
								end
								v5.Anim:AdjustWeight(0, v12)
								v5.Anim:Stop(v12)
								if p1.dbg then
									print(v12, v5.Anim.IsPlaying, v5.Anim.WeightTarget, v5.Anim.WeightCurrent)
								end
								p1.animsPlayingByTrack[v5.Anim] = nil
								if v5.Tags then
									for v18, v19 in v5.Tags do
										p1.animsPlayingTagged[v19][p2] = nil
									end
								end
								v8 = if v2 then {
	Anim = v2,
	PlayName = p2,
	PlayArgs = v7,
	Tags = v7.Tags,
	Time = os.clock()
} else v2
								p1.animsPlaying[p2] = v8
								p1.animsPaused[p2] = nil
								if v8 and v8.Tags then
									for v20, v21 in v8.Tags do
										p1.animsPlayingTagged[v21][p2] = v8
									end
								end
								if v2 then
									p1.animsPlayingByTrack[v2] = nil
									p1:_PlayAnim(p2, v2, v8, v7, p4)
									p1.animsPlayingByTrack[v2] = v8
									return v2, v8, v6
								else
									if p1.dbg then
										print("\229\138\168\231\148\187", p2, v7, "\228\184\141\229\173\152\229\156\168, \228\184\141\232\191\155\232\161\140\230\146\173\230\148\190", p1.Instance)
									end
									return
								end
							end
							v15 = p2
							v16 = v1
							v17 = 0
							v7 = v1
						end
					end
					v13(v14, v15, PlayArgs, Animation, v16, v17)
				else
					v7 = v1
				end
				v11 = if p4 then p4 else v7.FadeTime or if v3 then v3:GetAttribute("FadeTime") or 0 else 0
				v12 = math.max(v11, 0.001)
				if not v5.Anim.IsPlaying and v5.Anim.WeightCurrent ~= 0 then
					v5.Anim:Play(0, 0, 0)
				end
				v5.Anim:AdjustWeight(0, v12)
				v5.Anim:Stop(v12)
				if p1.dbg then
					print(v12, v5.Anim.IsPlaying, v5.Anim.WeightTarget, v5.Anim.WeightCurrent)
				end
				p1.animsPlayingByTrack[v5.Anim] = nil
				if v5.Tags then
					for v18, v19 in v5.Tags do
						p1.animsPlayingTagged[v19][p2] = nil
					end
				end
			end
		else
			v7 = v1
		end
		v8 = if v2 then {
	Anim = v2,
	PlayName = p2,
	PlayArgs = v7,
	Tags = v7.Tags,
	Time = os.clock()
} else v2
		p1.animsPlaying[p2] = v8
		p1.animsPaused[p2] = nil
		if v8 and v8.Tags then
			for v20, v21 in v8.Tags do
				p1.animsPlayingTagged[v21][p2] = v8
			end
		end
		if v2 then
			p1.animsPlayingByTrack[v2] = nil
			p1:_PlayAnim(p2, v2, v8, v7, p4)
			p1.animsPlayingByTrack[v2] = v8
			return v2, v8, v6
		elseif p1.dbg then
			print("\229\138\168\231\148\187", p2, v7, "\228\184\141\229\173\152\229\156\168, \228\184\141\232\191\155\232\161\140\230\146\173\230\148\190", p1.Instance)
		end
	end
end
function t.OverrideAnim(p1, p2, p3) --[[ OverrideAnim | Line: 304 ]]
	p1.animsOverride[p2] = p3
	p1:Refresh(p2)
end
function t.SetAnimDisabled(p1, p2, p3) --[[ SetAnimDisabled | Line: 309 ]]
	local v1 = p3 or nil
	if p1.animsDisabled[p2] ~= v1 then
		p1.animsDisabled[p2] = v1
		p1:Refresh(p2)
	end
end
function t.GetPlaying(p1, p2, p3) --[[ GetPlaying | Line: 318 ]]
	local v1 = p1.animsPlaying[p2]
	if v1 then
		if v1.Anim.IsPlaying or v1.Anim.WeightCurrent ~= 0 then
			if p3 or v1.Anim.IsPlaying then
				return v1
			end
		else
			p1.animsPlaying[p2] = nil
			if v1.Tags then
				for v2, v3 in v1.Tags do
					p1.animsPlayingTagged[v3][p2] = nil
				end
			end
		end
	end
end
function t.GetPlayingAnim(p1, p2) --[[ GetPlayingAnim | Line: 338 ]]
	local v1 = p1:GetPlaying(p2)
	return if v1 then v1.Anim else v1
end
function t.GetPlayingAnimsTagged(p1, p2) --[[ GetPlayingAnimsTagged | Line: 343 ]] end
function t.AdjustSpeed(p1, p2, p3) --[[ AdjustSpeed | Line: 347 ]]
	local v1 = p1:GetPlayingAnim(p2)
	if v1 then
		v1:AdjustSpeed(p3)
	end
end
function t.PauseAnim(p1, p2) --[[ PauseAnim | Line: 354 ]]
	local v1 = p1:GetPlayingAnim(p2)
	if v1 and v1.Speed ~= 0 then
		p1.animsPaused[p2] = v1.Speed
		v1:AdjustSpeed(0)
	end
end
function t.ResumeAnim(p1, p2) --[[ ResumeAnim | Line: 363 ]]
	local v1 = p1:GetPlayingAnim(p2)
	if v1 and v1.Speed == 0 then
		local v2 = p1.animsPaused[p2]
		p1.animsPaused[p2] = nil
		v1:AdjustSpeed(if v2 then v2 else v1.Animation:GetAttribute("FixedRate") or 1)
	end
end
function t.StopAnim(p1, p2, p3) --[[ StopAnim | Line: 373 ]]
	local v1 = p1:GetPlaying(p2, true)
	p1.animsPaused[p2] = nil
	if v1 then
		if p1.dbg then
			print("\229\129\156\230\173\162\229\138\168\231\148\187", p2, p3, v1.Anim.Animation)
		end
		if v1.Anim.IsPlaying or v1.Anim.WeightCurrent ~= 0 then
			local v2 = p3 and p3.FadeTime or v1.Anim.Animation:GetAttribute("FadeTime")
			if v2 then
				v2 = math.max(v2, 0.001)
			end
			if v2 then
				if v2 == 0.001 and not v1.Anim.IsPlaying then
					v1.Anim:Play(0, 0, 0)
				end
				v1.Anim:AdjustWeight(0, v2)
			end
			v1.Anim:Stop(v2)
		end
		if not v1.Anim.IsPlaying and v1.Anim.WeightCurrent == 0 then
			p1.animsPlaying[p2] = nil
			p1.animsPlayingByTrack[v1.Anim] = nil
			if v1.Tags then
				for v4, v5 in v1.Tags do
					p1.animsPlayingTagged[v5][p2] = nil
				end
			end
		end
		return v1.Anim
	end
end
function t.StopAnims(p1, p2, p3) --[[ StopAnims | Line: 415 ]]
	for v1, v2 in p2 do
		p1:StopAnim(v2, p3)
	end
end
function t.StopAllAnims(p1, p2) --[[ StopAllAnims | Line: 421 ]]
	for v1, v2 in p1.animsPlaying do
		if not (p2 and table.find(p2, v1)) then
			if not v2.Anim.IsPlaying and v2.Anim.WeightCurrent ~= 0 then
				v2.Anim:Play(0, 0, 0)
			end
			if v2.Anim.IsPlaying then
				v2.Anim:AdjustWeight(0, 0.001)
				v2.Anim:Stop(0.001)
			end
			p1.animsPlaying[v1] = nil
			p1.animsPlayingByTrack[v2.Anim] = nil
			if v2.Tags then
				for v3, v4 in v2.Tags do
					p1.animsPlayingTagged[v4][v1] = nil
				end
			end
		end
	end
end
function t.StopTagged(p1, p2, p3, p4) --[[ StopTagged | Line: 444 ]]
	local v1 = rawget(p1.animsPlayingTagged, p2)
	if v1 then
		local v2 = if p4 then p4.Exclude else p4
		local v3 = if p4 then p4.ExcludeTags else p4
		for v4, v5 in v1 do
			if not (v2 and table.find(v2, v4)) then
				if v3 and v5.Tags then
					local v6 = nil
					for v7, v8 in v5.Tags do
						if table.find(v3, v8) then
							v6 = true
							break
						end
					end
					if v6 then
						continue
					end
				end
				p1:StopAnim(v4, p3)
			end
		end
	end
end
function t.Refresh(p1, p2) --[[ Refresh | Line: 470 ]]
	local v1 = p1.animsPlaying[p2]
	if v1 and v1.Anim.IsPlaying then
		local v2 = v1.Anim.TimePosition / v1.Anim.Length
		local v5 = p1:PlayAnim(p2, v1.PlayArgs, (math.max((v1.PlayArgs.FadeTime or 0.1) - v1.Time, 0)))
		if v5 and v5.Length > 0 then
			v5.TimePosition = v5.Length * v2
		end
	elseif v1 then
		if v1.Anim.WeightCurrent == 0 then
			return
		end
		v1.Anim:Play(0, 0, 0)
		v1.Anim:AdjustWeight(0, 0.001)
		v1.Anim:Stop(0.001)
	end
end
function t.RefreshTagged(p1, p2) --[[ RefreshTagged | Line: 489 ]]
	local v1 = rawget(p1.animsPlayingTagged, p2)
	if v1 then
		for v2, v3 in v1 do
			if v3.Anim.IsPlaying then
				local TimePosition = v3.Anim.TimePosition
				if p1.dbg then
					print("\229\136\183\230\150\176\229\138\168\231\148\187...", v2, v3.Anim.Animation)
				end
				local v4 = p1:PlayAnim(v2, v3.PlayArgs)
				if v4 and v4.Length > 0 then
					v4.TimePosition = TimePosition
					if p1.dbg then
						print("\229\136\183\230\150\176\229\138\168\231\148\187", v2, v3.PlayArgs, v4.Animation, v4.Speed)
					end
				end
				continue
			end
			v3.Anim:Play(0, 0, 0)
			v3.Anim:AdjustWeight(0, 0.001)
			v3.Anim:Stop(0.001)
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 515 ]]
	for v1, v2 in p1.anims do
		v2:Play(0, 0, 0)
		v2:AdjustWeight(0, 0.001)
		v2:Stop(0.001)
	end
	table.clear(p1.anims)
	table.clear(p1.animsPlaying)
end
function t.setDebug(p1, p2) --[[ setDebug | Line: 525 ]]
	p1.dbg = p2 or nil
end
local t2 = {}
t2.__index = t2
function t2.new(p1, p2) --[[ new | Line: 532 | Upvalues: TableUtils (copy) ]]
	return setmetatable({
		_Parent = p2,
		animsPlaying = {},
		animsPlayingTagged = TableUtils.AutoTable(),
		animsOverride = {},
		animsDisabled = {}
	}, p1)
end
function t2.FindAnim(p1, p2, p3) --[[ FindAnim | Line: 544 ]]
	return p1._Parent:FindAnim(p2, p3)
end
function t2.GetAnim(p1, p2, p3) --[[ GetAnim | Line: 548 ]]
	return p1._Parent:GetAnim(p2, p3)
end
function t2.PlayAnim(p1, p2, p3) --[[ PlayAnim | Line: 552 ]]
	if not p1.PlayPre or p1.PlayPre(p2, p3) ~= false then
		local v1 = p1.animsPlaying[p2]
		local v2, v3, v4 = p1._Parent:PlayAnim(p2, p3)
		if v4 and v4 == v1 then
			p1.animsPlaying[p3.KeepPlayAs] = v1
			if v1.Tags then
				for v5, v6 in v1.Tags do
					p1.animsPlayingTagged[v6][p3.KeepPlayAs] = v1
					p1.animsPlayingTagged[v6][p2] = nil
				end
			end
		elseif v1 and v1.Anim ~= v2 then
			p1.animsPlaying[p2] = nil
			if v1.Tags then
				for v7, v8 in v1.Tags do
					p1.animsPlayingTagged[v8][p2] = nil
				end
			end
		end
		if v2 then
			p1.animsPlaying[p2] = v3
			if v3.Tags then
				for v9, v10 in v3.Tags do
					p1.animsPlayingTagged[v10][p2] = v3
				end
			end
		end
	end
end
function t2.GetPlayingAnim(p1, p2) --[[ GetPlayingAnim | Line: 592 ]]
	local v1 = p1.animsPlaying[p2]
	return if v1 then v1.Anim.IsPlaying and v1.Anim else v1
end
function t2.PauseAnim(p1, p2) --[[ PauseAnim | Line: 597 ]]
	p1._Parent:PauseAnim(p2)
end
function t2.ResumeAnim(p1, p2) --[[ ResumeAnim | Line: 601 ]]
	p1._Parent:ResumeAnim(p2)
end
function t2.StopAnim(p1, p2, p3) --[[ StopAnim | Line: 605 ]]
	p1._Parent:StopAnim(p2, p3)
	local v1 = p1.animsPlaying[p2]
	if v1 and (not v1.Anim.IsPlaying and v1.Anim.WeightCurrent == 0) then
		p1.animsPlaying[p2] = nil
		if not v1.Tags then
			return
		end
		for v2, v3 in v1.Tags do
			p1.animsPlayingTagged[v3][p2] = nil
		end
	end
end
function t2.StopAnims(p1, p2, p3) --[[ StopAnims | Line: 621 ]]
	for v1, v2 in p2 do
		p1:StopAnim(v2, p3)
	end
end
function t2.StopAllAnims(p1, p2) --[[ StopAllAnims | Line: 627 ]]
	for v1, v2 in p1.animsPlaying do
		if not (p2 and table.find(p2, v1)) then
			p1:StopAnim(v1, {
				FadeTime = 0
			})
		end
	end
end
function t2.StopTagged(p1, p2, p3, p4) --[[ StopTagged | Line: 636 ]]
	local v1 = rawget(p1.animsPlayingTagged, p2)
	if v1 then
		local v2 = if p4 then p4.Exclude else p4
		local v3 = if p4 then p4.ExcludeTags else p4
		for v4, v5 in v1 do
			if not (v2 and table.find(v2, v4)) then
				if v3 and v5.Tags then
					local v6 = nil
					for v7, v8 in v5.Tags do
						if table.find(v3, v8) then
							v6 = true
							break
						end
					end
					if v6 then
						continue
					end
				end
				p1:StopAnim(v4, p3)
			end
		end
	end
end
function t2.OverrideAnim(p1, p2, p3) --[[ OverrideAnim | Line: 662 ]]
	p1.animsOverride[p2] = p3 or nil
	p1._Parent:OverrideAnim(p2, p3)
end
function t2.SetAnimDisabled(p1, p2, p3) --[[ SetAnimDisabled | Line: 667 ]]
	p1.animsDisabled[p2] = p3 or nil
	p1._Parent:SetAnimDisabled(p2, p3)
end
function t2.Destroy(p1) --[[ Destroy | Line: 672 ]]
	p1:StopAllAnims()
	for v1, v2 in p1.animsOverride do
		p1._Parent:OverrideAnim(v1)
	end
	for v3, v4 in p1.animsDisabled do
		p1._Parent:SetAnimDisabled(v3)
	end
	p1._Parent = nil
end
function t.newSubHolder(p1) --[[ newSubHolder | Line: 683 | Upvalues: t2 (copy) ]]
	return t2:new(p1)
end
return t