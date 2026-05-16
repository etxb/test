-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.MailboxService.LocalMailboxStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TaskUtils = require(ReplicatedStorage.Util.TaskUtils)
local CommonMailboxStore = require(ReplicatedStorage.Common.MailboxService.CommonMailboxStore)
local v1 = setmetatable({}, CommonMailboxStore)
v1.__index = v1
function v1.MarkRead(p1, p2) --[[ MarkRead | Line: 10 | Upvalues: CommonMailboxStore (copy) ]]
	local v1 = CommonMailboxStore.MarkRead(p1, p2)
	if v1 then
		script.Parent.MarkRead:FireServer(p2)
	end
	return v1
end
function v1.RemoveMail(p1, p2) --[[ RemoveMail | Line: 18 | Upvalues: CommonMailboxStore (copy) ]]
	local v1 = CommonMailboxStore.RemoveMail(p1, p2)
	if v1 then
		script.Parent.RemoveMail:FireServer(p2)
	end
	return v1
end
function v1.RemoveMails(p1, p2) --[[ RemoveMails | Line: 26 | Upvalues: CommonMailboxStore (copy) ]]
	local v1 = CommonMailboxStore.RemoveMails(p1, p2)
	if v1 then
		local t = {}
		for v2, v3 in v1 do
			table.insert(t, v2)
		end
		script.Parent.RemoveMail:FireServer(t)
	end
	return v1
end
local function expireTimer() --[[ expireTimer | Line: 38 | Upvalues: v1 (copy) ]]
	while v1.NextToExpire do
		task.wait(v1.NextToExpire.ExpireTime - workspace:GetServerTimeNow())
		v1:RemoveExpiredMails()
	end
	v1.ExpireTimer = nil
end
local function refreshExpireTimer() --[[ refreshExpireTimer | Line: 47 | Upvalues: v1 (copy), TaskUtils (copy), expireTimer (copy) ]]
	if v1.ExpireTimer then
		TaskUtils.SafeCancel(v1.ExpireTimer)
	end
	v1.ExpireTimer = task.defer(expireTimer)
end
function v1.OnMailsAdded(p1, p2, p3) --[[ OnMailsAdded | Line: 54 | Upvalues: CommonMailboxStore (copy), v1 (copy), TaskUtils (copy), expireTimer (copy) ]]
	CommonMailboxStore.OnMailsAdded(p1, p2, p3)
	local v12 = nil
	for v2, v3 in p2 do
		if v3.ExpireTime and (not v12 or v12.ExpireTime > v3.ExpireTime) then
			v12 = {
				Key = v2,
				ExpireTime = v3.ExpireTime
			}
		end
	end
	if v12 and (not p1.NextToExpire or p1.NextToExpire.ExpireTime > v12.ExpireTime) then
		p1.NextToExpire = v12
		if v1.ExpireTimer then
			TaskUtils.SafeCancel(v1.ExpireTimer)
		end
		v1.ExpireTimer = task.defer(expireTimer)
	end
end
function v1.RemoveExpiredMails(p1) --[[ RemoveExpiredMails | Line: 73 | Upvalues: CommonMailboxStore (copy), v1 (copy), TaskUtils (copy), expireTimer (copy) ]]
	p1.NextToExpire = CommonMailboxStore.RemoveExpiredMails(p1)
	if not p1.ExpireTimer then
		if v1.ExpireTimer then
			TaskUtils.SafeCancel(v1.ExpireTimer)
		end
		v1.ExpireTimer = task.defer(expireTimer)
	end
	return p1.NextToExpire
end
function v1.OnInited() --[[ OnInited | Line: 81 | Upvalues: v1 (copy), TaskUtils (copy), expireTimer (copy) ]]
	if not v1.ExpireTimer then
		if v1.ExpireTimer then
			TaskUtils.SafeCancel(v1.ExpireTimer)
		end
		v1.ExpireTimer = task.defer(expireTimer)
	end
end
return v1