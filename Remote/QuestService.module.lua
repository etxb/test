-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.QuestService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Types)
require(ReplicatedStorage.Constant)
local QuestConfig = require(ReplicatedStorage.Config.QuestConfig)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local v1 = SimpleSignal.new()
local v2 = SimpleSignal.new()
local v3 = TableUtils.WrapGet({}, SimpleSignal.new)
local v4 = SimpleSignal.new()
local v5 = TableUtils.WrapGet({}, SimpleSignal.new)
local v6 = SimpleSignal.new()
local v7 = TableUtils.WrapGet({}, SimpleSignal.new)
local v8 = SimpleSignal.new()
local v9 = nil
local t = {
	Inited = false,
	DataInited = v1,
	DataUpdated = v2,
	QuestFinished = v4,
	QuestsAllFinished = v6,
	QuestsStarted = v8,
	GetDataUpdatedSignal = v3.GetOrCreate,
	GetQuestFinishedSignal = v5.GetOrCreate,
	GetQuestsAllFinishedSignal = v7.GetOrCreate,
	GetData = function(p1, p2) --[[ GetData | Line: 36 | Upvalues: v9 (ref) ]]
		if v9 and not (v9[p1] or p2) then
			v9[p1] = {
				Quests = {}
			}
		end
		return v9 and v9[p1]
	end
}
function t.GetQuestData(p1, p2, p3) --[[ GetQuestData | Line: 43 | Upvalues: t (copy) ]]
	local v1 = t.GetData(p1, p3)
	if v1 and not (v1.Quests[p2] or p3) then
		v1.Quests[p2] = {
			Value = 0
		}
	end
	return if v1 then v1.Quests[p2] else v1
end
function t.HasStarted(p1) --[[ HasStarted | Line: 51 | Upvalues: t (copy) ]]
	local v1 = t.GetData(p1, true)
	return if v1 then v1.Quests and (next(v1.Quests) and true) else v1
end
function t.GetAllFinishedTime(p1) --[[ GetAllFinishedTime | Line: 56 | Upvalues: t (copy) ]]
	local v1 = t.GetData(p1)
	local v2 = if v1 then v1.Finished else v1
	if v2 == true then
		v2 = 0
	end
	return v2
end
function t.IsClaimed(p1, p2) --[[ IsClaimed | Line: 65 | Upvalues: t (copy) ]]
	local v1 = t.GetQuestData(p1, p2, true)
	return if v1 then v1.Rewarded else v1
end
function t.IsAllFinished(p1) --[[ IsAllFinished | Line: 70 | Upvalues: t (copy) ]]
	return t.GetAllFinishedTime(p1) and true
end
function t.IsFinished(p1, p2) --[[ IsFinished | Line: 74 | Upvalues: t (copy) ]]
	if t.IsAllFinished(p1) then
		return true
	else
		local v1 = t.GetQuestData(p1, p2, true)
		return if v1 then v1.Finished else v1
	end
end
local function testAllFinished(p1) --[[ testAllFinished | Line: 82 | Upvalues: t (copy), QuestConfig (copy), v6 (copy), v7 (copy) ]]
	local v1 = t.GetData(p1)
	if v1 and (not v1.Finished and next(v1.Quests)) then
		local v2 = QuestConfig[p1]
		local QuestToFinish = v2.QuestToFinish
		local count = 0
		for v3, v4 in v1.Quests do
			local v5 = v2.Quests[v3]
			if v5 and not v5.Disabled then
				if v4.Finished then
					count = count + 1
				end
				if not QuestToFinish then
					return
				end
			end
		end
		if not (QuestToFinish and count < QuestToFinish) then
			v1.Finished = workspace:GetServerTimeNow()
			v6:Fire(p1)
			local v62 = v7[p1]
			if v62 then
				v62:Fire()
			end
		end
	end
end
function t.ClaimReward(p1, p2) --[[ ClaimReward | Line: 114 | Upvalues: QuestConfig (copy), t (copy), ResultUtils (copy), v3 (copy), v2 (copy) ]]
	local v1 = QuestConfig[p1]
	if v1 then
		if p2 then
			local v22 = v1.Quests[p2]
			if v22 and (v22.Reward and v22.ManualReward) and t.IsFinished(p1, p2) then
				local v32 = t.GetQuestData(p1, p2)
				if not v32 or v32.Rewarded then
					return
				end
			else
				return
			end
		elseif v1.Reward and v1.ManualReward and t.IsAllFinished(p1) then
			local v4 = t.GetData(p1)
			if not v4 or v4.Rewarded then
				return
			end
		else
			return
		end
		local v5, v6 = pcall(function() --[[ Line: 143 | Upvalues: p1 (copy), p2 (copy) ]]
			return script.ClaimReward:InvokeServer(p1, p2)
		end)
		if v5 then
			if v6 then
				local v7
				if p2 then
					local v8 = t.GetQuestData(p1, p2)
					v8.Rewarded = true
					v7 = {
						Quest = {
							[p2] = v8
						}
					}
				else
					local v9 = t.GetData(p1)
					v9.Rewarded = true
					v7 = v9
				end
				local v10 = v3[p1]
				if v10 then
					v10:Fire(v7)
				end
				v2:Fire(p1, v7)
				return ResultUtils.success("Claim successfully!", v6)
			end
		else
			return ResultUtils.error(v6)
		end
	end
end
function t.Start() --[[ Start | Line: 175 | Upvalues: v9 (ref), t (copy), v1 (copy), v2 (copy), v5 (copy), v4 (copy), testAllFinished (copy), v3 (copy), v8 (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 176 | Upvalues: v9 (ref), t (ref), v1 (ref), v2 (ref), v5 (ref), v4 (ref), testAllFinished (ref), v3 (ref) ]]
		if v9 or not p2 then
			if v9 then
				for v12, v22 in p1 do
					if v22 then
						local v32 = t.GetData(v12)
						local v42 = false
						for v52, v6 in v22 do
							local v7 = v32.Quests[v52]
							v32.Quests[v52] = v6
							if v6 and (v6.Finished and not (v7 and v7.Finished)) then
								local v8 = v5[v12]
								if v8 then
									v8:Fire(v52)
								end
								v4:Fire(v12, v52)
								v42 = true
							end
						end
						if v42 then
							testAllFinished(v12)
						end
						local v92 = v3[v12]
						if v92 then
							v92:Fire(v22)
						end
						v2:Fire(v12, v22)
					end
					v9[v12] = nil
					v2:Fire(v12, v22)
				end
			end
		else
			v9 = p1
			t.Inited = true
			v1:Fire()
		end
	end)
	script.QuestsStarted.OnClientEvent:Connect(function(p1) --[[ Line: 216 | Upvalues: v8 (ref) ]]
		v8:Fire(p1)
	end)
end
function t.WaitInit() --[[ WaitInit | Line: 221 | Upvalues: t (copy), v1 (copy) ]]
	if not t.Inited then
		v1:Wait()
	end
	return t
end
function t.OnInit(p1) --[[ OnInit | Line: 228 | Upvalues: t (copy), v1 (copy) ]]
	if t.Inited then
		p1()
	else
		v1:Connect(p1)
	end
end
return t