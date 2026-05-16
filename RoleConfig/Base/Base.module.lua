-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.RoleConfig.Base.Base

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local t = {
	FakeArm = nil,
	FakeArmAdapter = nil,
	Health = { 350 },
	WalkSpeed = { 22 },
	JumpHeight = { 3 },
	AddTag = function(p1, p2) --[[ AddTag | Line: 14 ]]
		if p2 then
			if not rawget(p1, "Tags") then
				p1.Tags = p1.Tags
				if p1.Tags then
					p1.Tags = table.clone(p1.Tags)
				else
					p1.Tags = {}
				end
			end
			p1.Tags[p2] = true
		end
		return p1
	end
}
local function getValue(p1, p2) --[[ getValue | Line: 30 ]]
	return if p1 then p1[p2 or 1] else p1
end
function t.GetHealth(p1, p2) --[[ GetHealth | Line: 34 ]]
	local Health = p1.Health
	return if Health then Health[p2 or 1] else Health
end
function t.GetWalkSpeed(p1, p2) --[[ GetWalkSpeed | Line: 38 ]]
	local WalkSpeed = p1.WalkSpeed
	return if WalkSpeed then WalkSpeed[p2 or 1] else WalkSpeed
end
function t.GetJumpHeight(p1, p2) --[[ GetJumpHeight | Line: 42 ]]
	local JumpHeight = p1.JumpHeight
	return if JumpHeight then JumpHeight[p2 or 1] else JumpHeight
end
function t.GetIconImage(p1, p2) --[[ GetIconImage | Line: 46 ]]
	local Image = p1.Image
	if not Image and Image then
		Image = Image.Image
	end
	return if Image then Image else p2 and ""
end
function t.GetIconImageSafe(p1) --[[ GetIconImageSafe | Line: 57 ]]
	return p1:GetIconImage(true)
end
function t.GetSkillImage(p1, p2, p3) --[[ GetSkillImage | Line: 61 | Upvalues: InstanceUtils (copy), ReplicatedStorage (copy) ]]
	local v1 = p2
	while true do
		local v2 = v1:find("%.")
		if not v2 then
			break
		end
		v1 = v1:sub(v2 + 1)
	end
	local v4 = InstanceUtils.FindFirst(ReplicatedStorage.Assets.Image.RoleSkill, ("%s.%s"):format(p1.Name, v1))
	return if v4 then v4.Image else v4 or p3 and ""
end
function t.GetSkillImageReversed(p1, p2, p3) --[[ GetSkillImageReversed | Line: 75 | Upvalues: InstanceUtils (copy), ReplicatedStorage (copy) ]]
	local v1 = p2
	while true do
		local v2 = v1:find("%.")
		if not v2 then
			break
		end
		v1 = v1:sub(v2 + 1)
	end
	local v4 = InstanceUtils.FindFirst(ReplicatedStorage.Assets.Image.RoleSkill, ("%s.Reversed.%s"):format(p1.Name, v1))
	return if v4 then v4.Image else v4 or p3 and ""
end
local t2 = {}
function t.extends(p1, p2) --[[ extends | Line: 91 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1]
	if not v1 then
		local t = {
			__index = p1
		}
		t2[p1] = t
		v1 = t
	end
	return setmetatable(p2, v1)
end
return t