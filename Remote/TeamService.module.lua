-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.TeamService

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {
	DataUpdated = SimpleSignal.new(),
	Invited = SimpleSignal.new(),
	BeInvited = SimpleSignal.new(),
	MemberJoined = SimpleSignal.new(),
	MemberLeft = SimpleSignal.new()
}
local t2 = { LocalPlayer }
local t3 = {
	Event = t,
	GetMembers = function() --[[ GetMembers | Line: 29 | Upvalues: t2 (ref) ]]
		return t2
	end,
	IsLeader = function(p1) --[[ IsLeader | Line: 33 | Upvalues: t2 (ref), LocalPlayer (copy) ]]
		return t2[1] == if p1 then p1 else LocalPlayer
	end,
	IsTeamed = function() --[[ IsTeamed | Line: 37 | Upvalues: t2 (ref) ]]
		return #t2 > 1
	end,
	IsMember = function(p1) --[[ IsMember | Line: 41 | Upvalues: t2 (ref) ]]
		return table.find(t2, p1) and true
	end,
	Start = function() --[[ Start | Line: 45 | Upvalues: t2 (ref), t (copy) ]]
		script.UpdateData.OnClientEvent:Connect(function(p1) --[[ Line: 46 | Upvalues: t2 (ref), t (ref) ]]
			local v1 = t2
			t2 = p1
			t.DataUpdated:Fire(p1, v1)
		end)
		script.InviteNotify.OnClientEvent:Connect(function(p1) --[[ Line: 52 | Upvalues: t (ref) ]]
			t.BeInvited:Fire(p1)
		end)
		script.KickNotify.OnClientEvent:Connect(function() --[[ Line: 55 ]] end)
		script.JoinNotify.OnClientEvent:Connect(function(p1) --[[ Line: 58 | Upvalues: t (ref) ]]
			t.MemberJoined:Fire(p1)
		end)
		script.LeaveNotify.OnClientEvent:Connect(function(p1) --[[ Line: 61 | Upvalues: t (ref) ]]
			t.MemberLeft:Fire(p1)
		end)
	end
}
local v1 = nil
local function canSendGameInvite() --[[ canSendGameInvite | Line: 68 | Upvalues: v1 (ref), SocialService (copy), LocalPlayer (copy) ]]
	if v1 == nil then
		local v12, v2 = pcall(function() --[[ Line: 70 | Upvalues: SocialService (ref), LocalPlayer (ref) ]]
			return SocialService:CanSendGameInviteAsync(LocalPlayer)
		end)
		if not v12 then
			return v1
		end
		v1 = v2 or false
	end
	return v1
end
function t3.Invite(p1) --[[ Invite | Line: 80 | Upvalues: Players (copy), LocalPlayer (copy), v1 (ref), SocialService (copy), t3 (copy), Config (copy), ResultUtils (copy), HttpService (copy) ]]
	local v12, v2
	if typeof(p1) == "number" then
		v12, v2 = Players:GetPlayerByUserId(p1), p1
	else
		v2 = p1.UserId
		v12 = p1
	end
	if v12 or LocalPlayer:IsFriendsWith(v2) then
		if not v12 then
			if v1 == nil then
				local v4, v5 = pcall(function() --[[ Line: 70 | Upvalues: SocialService (ref), LocalPlayer (ref) ]]
					return SocialService:CanSendGameInviteAsync(LocalPlayer)
				end)
				if v4 then
					v1 = v5 or false
				end
			end
			if not v1 then
				return
			end
		end
		if v12 and v12:GetAttribute("Teamed") then
		elseif #t3.GetMembers() >= Config.Team.MaxSize then
			return ResultUtils.failed("Team is full")
		elseif v12 then
			script.Invite:InvokeServer(v12 or v2)
			return true
		else
			local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")
			ExperienceInviteOptions.InviteMessageId = "877a23c3-1b09-c342-9fa9-e96c192fcde6"
			ExperienceInviteOptions.InviteUser = v2
			ExperienceInviteOptions.LaunchData = HttpService:JSONEncode({})
			ExperienceInviteOptions.PromptMessage = "Invite your friend to fight together!"
			pcall(function() --[[ Line: 113 | Upvalues: SocialService (ref), LocalPlayer (ref), ExperienceInviteOptions (copy) ]]
				SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions)
			end)
		end
	end
end
function t3.AcceptInvite(p1) --[[ AcceptInvite | Line: 126 ]]
	local _, _2 = pcall(function() --[[ Line: 127 | Upvalues: p1 (copy) ]]
		return script.Accept:InvokeServer(p1)
	end)
end
function t3.Kick(p1) --[[ Kick | Line: 132 | Upvalues: t3 (copy), LocalPlayer (copy) ]]
	if t3.IsMember(p1) and (t3.IsLeader() and p1 ~= LocalPlayer) then
		local _, _2 = pcall(function() --[[ Line: 136 | Upvalues: p1 (copy) ]]
			return script.Kick:InvokeServer(p1)
		end)
	end
end
function t3.Leave() --[[ Leave | Line: 141 | Upvalues: t3 (copy) ]]
	if t3.IsTeamed() then
		local _, _2 = pcall(function() --[[ Line: 145 ]]
			return script.Leave:InvokeServer()
		end)
	end
end
return t3