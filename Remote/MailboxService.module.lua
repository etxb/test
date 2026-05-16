-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.MailboxService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local ResultUtils = require(ReplicatedStorage.Util.ResultUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local RewardHelper = require(ReplicatedStorage.Common.RewardHelper)
local LocalMailboxStore = require(script.LocalMailboxStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalMailboxStore = LocalMailboxStore
}
function t2.WaitInit() --[[ WaitInit | Line: 24 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 31 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.HasUnread() --[[ HasUnread | Line: 39 | Upvalues: LocalMailboxStore (copy) ]]
	for v1, v2 in LocalMailboxStore:GetMails() do
		if not (v2.ExpireTime and v2.ExpireTime < workspace:GetServerTimeNow() or v2.Read) then
			return true
		end
	end
end
function t2.HasUnreadOrUnclaimed() --[[ HasUnreadOrUnclaimed | Line: 50 | Upvalues: LocalMailboxStore (copy) ]]
	for v1, v2 in LocalMailboxStore:GetMails() do
		if not (v2.ExpireTime and v2.ExpireTime < workspace:GetServerTimeNow()) then
			if not v2.Read then
				return true
			end
			if v2.Reward and not v2.Claimed then
				return true
			end
		end
	end
end
function t2.MarkRead(p1) --[[ MarkRead | Line: 64 | Upvalues: LocalMailboxStore (copy) ]]
	return LocalMailboxStore:MarkRead(p1)
end
function t2.RemoveMail(p1) --[[ RemoveMail | Line: 68 | Upvalues: LocalMailboxStore (copy) ]]
	return LocalMailboxStore:RemoveMail(p1)
end
function t2.Claim(p1) --[[ Claim | Line: 72 | Upvalues: LocalMailboxStore (copy), RewardHelper (copy), ResultUtils (copy), Constant (copy) ]]
	local v1 = LocalMailboxStore:GetMail(p1)
	if v1 and (not v1.Claimed and v1.Reward) and RewardHelper.Validate(v1.Reward) then
		local v2, v3 = pcall(function() --[[ Line: 81 | Upvalues: p1 (copy) ]]
			return script.Claim:InvokeServer(p1)
		end)
		if v2 then
			if v3 then
				LocalMailboxStore:MarkClaimed(p1)
				return ResultUtils.success(Constant.Message.Mail.ClaimSuccess, v3)
			end
		else
			return ResultUtils.error(v3)
		end
	end
end
function t2.Start() --[[ Start | Line: 96 | Upvalues: LocalMailboxStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 97 | Upvalues: LocalMailboxStore (ref), t2 (ref), t (ref) ]]
		if LocalMailboxStore.Data or not p2 then
			if LocalMailboxStore.Data then
				if p1.Add then
					LocalMailboxStore:AddMails(p1.Add, {
						KeyGenerated = true
					})
				end
				if p1.Remove then
					LocalMailboxStore:RemoveMails(p1.Remove)
				end
			end
		else
			LocalMailboxStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
			LocalMailboxStore.OnInited()
		end
	end)
end
return t2