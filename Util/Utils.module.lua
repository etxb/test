-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.Utils

-- https://lua.expert/
game:GetService("CollectionService")
game:GetService("Debris")
game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local AbbNumber = require(ReplicatedStorage.Shared.AbbNumber)
local t = {}
local t2 = {
	HoldLock = function(p1) --[[ HoldLock | Line: 19 | Upvalues: t (copy) ]]
		if t[p1] then
			return false
		else
			t[p1] = true
			return true
		end
	end,
	IsLocking = function(p1) --[[ IsLocking | Line: 27 | Upvalues: t (copy) ]]
		return t[p1]
	end,
	ReleaseLock = function(p1) --[[ ReleaseLock | Line: 31 | Upvalues: t (copy) ]]
		t[p1] = nil
	end
}
function t2.NonBlockingRemoteInvoke(p1, ...) --[[ NonBlockingRemoteInvoke | Line: 35 | Upvalues: t2 (copy) ]]
	if t2.HoldLock(p1) then
		local v1, v2 = pcall(p1.InvokeServer, p1, ...)
		t2.ReleaseLock(p1)
		return v1, v2
	end
end
function t2.DistanceWithouY(p1, p2, p3) --[[ DistanceWithouY | Line: 44 ]]
	local v1 = p1 - p2
	if v1.Y < 0 then
		v1 = v1 * Vector3.new(1, -1, 1)
	end
	local Magnitude = (v1 - math.min(v1.Y, if p3 then p3 else v1.Y) * Vector3.new(0, 1, 0)).Magnitude
	return if Magnitude == Magnitude and Magnitude then Magnitude else 0
end
function t2.Shuffle(p1) --[[ Shuffle | Line: 54 ]]
	for i = 1, #p1 - 1 do
		local v1 = math.random(i + 1, #p1)
		local v3 = p1[i]
		p1[i] = p1[v1]
		p1[v1] = v3
	end
	return p1
end
function t2.IsConsole() --[[ IsConsole | Line: 62 | Upvalues: GuiService (copy) ]]
	return GuiService:IsTenFootInterface()
end
function t2.IsMobile() --[[ IsMobile | Line: 66 | Upvalues: t2 (copy), UserInputService (copy), RunService (copy) ]]
	return not t2.IsConsole() and (UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or (not UserInputService.MouseEnabled or RunService:IsStudio())))
end
function t2.IsDesktop() --[[ IsDesktop | Line: 70 | Upvalues: t2 (copy) ]]
	return not t2.IsConsole() and not t2.IsMobile()
end
function t2.RandomItem(p1) --[[ RandomItem | Line: 74 ]]
	return p1[math.random(#p1)]
end
function t2.Dec2Str(p1, p2, p3, p4) --[[ Dec2Str | Line: 78 | Upvalues: AbbNumber (copy) ]]
	if p1 == 0 then
		return "0"
	else
		local count = p2 or 1
		if 6 - count <= math.floor((math.log10(p1))) then
			return AbbNumber.AbbreviateNumber(p1)
		else
			local v6, v7 = math.floor(math.round(math.abs(p1) * 10 ^ count * 100) / 100), {}
			while v6 > 0 do
				table.insert(v7, 1, (tostring(v6 % 10)))
				v6 = v6 // 10
			end
			while #v7 <= count do
				table.insert(v7, 1, "0")
			end
			if not p3 then
				while v7[#v7] == "0" and count > 0 do
					table.remove(v7)
					count = count - 1
				end
			end
			local sum = #v7 + 1
			if count > 0 then
				sum = sum - count
				table.insert(v7, sum, ".")
			end
			while sum > 4 do
				sum = sum - 3
				table.insert(v7, sum, ",")
			end
			if if p1 < 0 then true else false then
				table.insert(v7, 1, "-")
			elseif p4 then
				table.insert(v7, 1, "+")
			end
			return table.concat(v7)
		end
	end
end
function t2.ScaleNumberSeq(p1, p2) --[[ ScaleNumberSeq | Line: 134 ]]
	local t = {}
	for v1, v2 in p1.Keypoints do
		table.insert(t, NumberSequenceKeypoint.new(v2.Time, v2.Value * p2, v2.Envelope * p2))
	end
	return NumberSequence.new(t)
end
function t2.SetSeqNum(p1, p2, p3) --[[ SetSeqNum | Line: 142 ]]
	local t = {}
	for v1, v2 in p1.Keypoints do
		table.insert(t, NumberSequenceKeypoint.new(v2.Time, p2, if p3 then p3 else v2.Envelope))
	end
	return NumberSequence.new(t)
end
function t2.ScalePartileEmitter(p1, p2) --[[ ScalePartileEmitter | Line: 150 | Upvalues: t2 (copy) ]]
	local Speed = p1.Speed
	p1.Speed = NumberRange.new(Speed.Min * p2, Speed.Max * p2)
	p1.Size = t2.ScaleNumberSeq(p1.Size, p2)
end
local v1 = RaycastParams.new()
v1.CollisionGroup = "CanCollide"
function t2.FindFloorByRay(p1, p2, p3) --[[ FindFloorByRay | Line: 159 | Upvalues: v1 (copy) ]]
	local v12, v2, v3, v4, v5, v6, v7, v8
	if p3 then
		v12 = p3.FindHeight or p3.Height or 20
		v2 = if p3 then p3.Safe else p3
		v3 = workspace
		v4 = p1 + Vector3.new(0, 2, 0)
		v5 = Vector3.new(-0, -1, -0) * (v12 + 2)
		v6 = if p2 then p2 else v1
		v7 = v3:Raycast(v4, v5, v6)
		v8 = if v7 then v7.Position or v2 and p1 else v2 and p1
		return v8
	end
	v12 = 20
	v2 = if p3 then p3.Safe else p3
	v3 = workspace
	v4 = p1 + Vector3.new(0, 2, 0)
	v5 = Vector3.new(-0, -1, -0) * (v12 + 2)
	v6 = if p2 then p2 else v1
	v7 = v3:Raycast(v4, v5, v6)
	v8 = if v7 then v7.Position or v2 and p1 else v2 and p1
	return v8
end
function t2.FindFloorByBlock(p1, p2, p3, p4) --[[ FindFloorByBlock | Line: 166 | Upvalues: v1 (copy) ]]
	local v12, v2, v3, v4, v5, v6, v7, v8
	if p4 then
		v12 = p4.FindHeight or p4.Height or 20
		v2 = if p4 then p4.Safe else p4
		v3 = workspace
		v4 = p1 * CFrame.new(0, 2, 0)
		v5 = Vector3.new(-0, -1, -0) * (v12 + 2)
		v6 = if p3 then p3 else v1
		v7 = v3:Blockcast(v4, p2, v5, v6)
		v8 = v3:Blockcast(v4, p2, v5, v6) and v7.Position * Vector3.new(0, 1, 0) + p1.Position * Vector3.new(1, 0, 1) or if v2 then p1.Position else v2
		return v8
	end
	v12 = 20
	v2 = if p4 then p4.Safe else p4
	v3 = workspace
	v4 = p1 * CFrame.new(0, 2, 0)
	v5 = Vector3.new(-0, -1, -0) * (v12 + 2)
	v6 = if p3 then p3 else v1
	v7 = v3:Blockcast(v4, p2, v5, v6)
	v8 = v3:Blockcast(v4, p2, v5, v6) and v7.Position * Vector3.new(0, 1, 0) + p1.Position * Vector3.new(1, 0, 1) or if v2 then p1.Position else v2
	return v8
end
function t2.FindCollideByRay(p1, p2, p3, p4, p5) --[[ FindCollideByRay | Line: 173 | Upvalues: v1 (copy) ]]
	if p3 == -1 then
		p3 = p2.Magnitude
		p2 = p2.Unit
	end
	local v4 = workspace:Raycast(p1, p2 * (p3 or 600), if p4 then p4 else v1)
	return if v4 then v4.Position or p5 and p1 else p5 and p1
end
function t2.FindCollideByBlock(p1, p2, p3, p4, p5, p6) --[[ FindCollideByBlock | Line: 182 | Upvalues: v1 (copy) ]]
	local v12 = workspace
	local v2 = p3 * (p4 or 600)
	local v3 = if p5 then p5 else v1
	local v4 = v12:Blockcast(p1, p2, v2, v3)
	return v12:Blockcast(p1, p2, v2, v3) and p1.Position + p3 * v4.Distance or if p6 then p1.Position else p6
end
local Model = Instance.new("Model")
Model.Parent = ReplicatedStorage.Assets.Temp
function t2.ScaleTo(p1, p2) --[[ ScaleTo | Line: 191 | Upvalues: Model (copy) ]]
	local v1 = p1.Parent
	Model:ScaleTo(1)
	p1.Parent = Model
	Model:ScaleTo(p2)
	p1.Parent = v1
end
function t2.OnPlayerAdded(p1) --[[ OnPlayerAdded | Line: 199 | Upvalues: Players (copy) ]]
	local v1 = Players.PlayerAdded:Connect(p1)
	for v2, v3 in Players:GetPlayers() do
		task.spawn(p1, v3)
	end
	return v1
end
function t2.SplitNumber(p1) --[[ SplitNumber | Line: 210 ]]
	if p1 % 1 ~= 0 then
		error("decimal is not support!")
	end
	if p1 > 9007199254740992 then
		error("number is too big! (will be lost precision)")
	end
	if p1 < 0 then
		error("neg")
	end
	local t = {}
	while true do
		table.insert(t, p1 % 10)
		local v1 = math.floor(p1 / 10)
		if v1 == 0 then
			break
		end
		p1 = v1
	end
	return t
end
function t2.GetClosest(p1, p2, p3) --[[ GetClosest | Line: 229 ]]
	local v1 = nil
	local v2 = nil
	for v4, v5 in p2 do
		local v3
		v3 = if p3 then p3(v5) else v5
		if typeof(v3) == "Vector3" then
			local Magnitude = (p1 - v3).Magnitude
			if not v1 or Magnitude < v2 then
				v1 = v5
				v2 = Magnitude
			end
		end
	end
	return v1, v2
end
function t2.Min(p1, p2) --[[ Min | Line: 247 ]]
	local v1 = nil
	for v2, v3 in p1 do
		if not v1 or p2(v1, v3) < 0 then
			v1 = v3
		end
	end
	return v1
end
function t2.ConnectsAndExecute(p1, p2) --[[ ConnectsAndExecute | Line: 257 ]]
	local t = {}
	for v1, v2 in p1 do
		table.insert(t, v2:Connect(p2))
	end
	task.spawn(p2)
	return t
end
function t2.ConnectAndExecute(p1, p2) --[[ ConnectAndExecute | Line: 266 ]]
	local v1 = p1:Connect(p2)
	task.spawn(p2)
	return v1
end
function t2.ConnectAndExecWith(p1, p2, p3) --[[ ConnectAndExecWith | Line: 272 | Upvalues: t2 (copy) ]]
	return t2.ConnectAndExecuteWiths(p1, p2, if p3 then { p3 } else p3)
end
function t2.ConnectAndExecuteWiths(p1, p2, p3) --[[ ConnectAndExecuteWiths | Line: 276 ]]
	local v1 = p1:Connect(p2)
	if p3 then
		for v2, v3 in p3 do
			task.spawn(p2, v3)
		end
	end
	return v1
end
function t2.Disconnect(p1) --[[ Disconnect | Line: 286 ]]
	if p1 then
		for v1, v2 in p1 do
			v2:Disconnect()
		end
	end
end
function t2.GetPivotOffset(p1) --[[ GetPivotOffset | Line: 295 ]]
	return p1.PrimaryPart.CFrame:ToObjectSpace(p1:GetPivot())
end
function t2.FunctionFilter(p1, p2) --[[ FunctionFilter | Line: 299 ]]
	return function(...) --[[ Line: 300 | Upvalues: p1 (copy), p2 (copy) ]]
		return p1(...) and p2(...)
	end
end
function t2.ToBool(p1) --[[ ToBool | Line: 305 ]]
	return p1 and true or false
end
function t2.ToBoolOrNil(p1) --[[ ToBoolOrNil | Line: 309 ]]
	if p1 then
		return true
	else
		return nil
	end
end
function t2.SafeStr(p1, p2) --[[ SafeStr | Line: 313 ]]
	if typeof(p1) == "string" then
		if p2 and p2 < #p1 then
		else
			return utf8.len(p1) and p1
		end
	end
end
function t2.SafeCancel(p1) --[[ SafeCancel | Line: 323 ]]
	if p1 and coroutine.status(p1) == "suspended" then
		task.cancel(p1)
	end
end
local TimeUtils = require(script.Parent.TimeUtils)
t2.ResetExecuteTime = TimeUtils.ResetExecuteTime
t2.ExecuteWait = TimeUtils.ExecuteWait
t2.ForEachWithLimited = TimeUtils.ForEachWithLimited
t2.ParseSeconds = TimeUtils.ParseSeconds
t2.TimeToString = TimeUtils.TimeToString
t2.TimeToShortString = TimeUtils.TimeToShortString
t2.FormatTime = TimeUtils.FormatTime
function t2.xpcallErrTrack(p1) --[[ xpcallErrTrack | Line: 357 ]]
	return ("%s\n%s"):format(p1, debug.traceback(nil, 2))
end
function t2.xpcall(p1, ...) --[[ xpcall | Line: 361 | Upvalues: t2 (copy) ]]
	local v1 = table.pack(xpcall(p1, t2.xpcallErrTrack, ...))
	if not v1[1] then
		warn(v1[2])
	end
	return table.unpack(v1)
end
function t2.xpcallSilent(p1, ...) --[[ xpcallSilent | Line: 369 | Upvalues: t2 (copy) ]]
	return xpcall(p1, t2.xpcallErrTrack, ...)
end
function t2.pcall(p1, ...) --[[ pcall | Line: 373 ]]
	local v1 = table.pack(pcall(p1, ...))
	if not v1[1] then
		warn(v1[2])
	end
	return table.unpack(v1)
end
function t2.StringStartsWith(p1, p2) --[[ StringStartsWith | Line: 381 ]]
	if #p1 < #p2 then
		return false
	else
		for i = 1, #p2 do
			if p1:byte(i, i) ~= p2:byte(i, i) then
				return false
			end
		end
		return true
	end
end
function t2.StringEndsWith(p1, p2) --[[ StringEndsWith | Line: 394 ]]
	if #p1 < #p2 then
		return false
	else
		for i = 1, #p2 do
			if p1:byte(-i, -i) ~= p2:byte(-i, -i) then
				return false
			end
		end
		return true
	end
end
function t2.FormatNumber(p1, p2) --[[ FormatNumber | Line: 406 | Upvalues: AbbNumber (copy) ]]
	local v1 = math.floor(p1)
	if (p2 or 6) <= math.floor((math.log10(v1))) then
		return AbbNumber.AbbreviateNumber(v1)
	else
		v3 = v1
		v4 = {}
		while v3 > 0 do
			local v5 = v3 % 1000
			if v5 == v3 then
				table.insert(v4, 1, ("%d"):format(v5))
			else
				table.insert(v4, 1, ("%03d"):format(v5))
			end
			v3 = v3 // 1000
		end
		if not v4[1] then
			v4 = { 0 }
		end
		return table.concat(v4, ",")
	end
end
function t2.IsSaveableString(p1) --[[ IsSaveableString | Line: 429 ]]
	return utf8.len(p1) and not p1:find("[%z\1-\31\127]")
end
function t2.SubString(p1, p2, p3) --[[ SubString | Line: 433 ]]
	local v1 = p3 or -1
	return string.sub(p1, utf8.offset(p1, p2 or 1), if v1 == -1 then #p1 else utf8.offset(p1, v1 + 1) and utf8.offset(p1, v1 + 1) - 1 or #p1)
end
function t2.DistanceToPart(p1, p2, p3) --[[ DistanceToPart | Line: 449 ]]
	local v1 = p2:GetClosestPointOnSurface(p1)
	if p3 then
		p3 = v1
	end
	return (v1 - p1).Magnitude, p3
end
function t2.DistanceToBox(p1, p2, p3, p4) --[[ DistanceToBox | Line: 459 ]]
	local v1 = p2:PointToObjectSpace(p1)
	local Unit = v1.Unit
	if Unit == Unit then
		local Magnitude = Vector3.max(Vector3.new(math.abs(v1.X), math.abs(v1.Y), (math.abs(v1.Z))) - p3 / 2, Vector3.new(0, 0, 0)).Magnitude
		if p4 and Magnitude == 0 then
			p4 = p1
		elseif p4 then
			local v6 = p3 / 2
			p4 = p2:PointToWorldSpace((Vector3.min(v6, Vector3.max(-v6, v1))))
		end
		return Magnitude, p4
	else
		return 0, p1
	end
end
function t2.Lerp(p1, p2, p3) --[[ Lerp | Line: 485 ]]
	if typeof(p1) == "number" then
		return p1 + (p2 - p1) * p3
	else
		return p1:Lerp(p2, p3)
	end
end
function t2.LerpColorHSV(p1, p2, p3) --[[ LerpColorHSV | Line: 492 | Upvalues: t2 (copy) ]]
	local v1, v2, v3 = p1:ToHSV()
	local v4, v5, v6 = p2:ToHSV()
	return Color3.fromHSV(t2.Lerp(v1, v4, p3), t2.Lerp(v2, v5, p3), t2.Lerp(v3, v6, p3))
end
function t2.IsNumber(p1) --[[ IsNumber | Line: 519 ]]
	return if typeof(p1) == "number" then p1 else false
end
function t2.OnCharacterAdded(p1, p2, p3) --[[ OnCharacterAdded | Line: 566 | Upvalues: RunService (copy) ]]
	local v1 = nil
	local function onCharacterAdded(p12, p22) --[[ onCharacterAdded | Line: 569 | Upvalues: v1 (ref), RunService (ref), p2 (copy), p1 (copy) ]]
		v1 = p12
		local v12 = nil
		while p12 == p12 and p12.Parent do
			if not v12 then
				v12 = p12:FindFirstChild("Humanoid")
			end
			if v12 and v12:FindFirstChild("Animator") then
				break
			end
			RunService.Heartbeat:Wait()
		end
		if p12 == p12 then
			p2(p12, p1, p22)
		end
	end
	if p1.Character and not p3 then
		task.spawn(onCharacterAdded, p1.Character, true)
	end
	return p1.CharacterAdded:Connect(onCharacterAdded)
end
function t2.ConfigName(p1) --[[ ConfigName | Line: 594 ]]
	if typeof(p1) == "table" then
		p1 = p1.name
	end
	return p1
end
function t2.NilOrNaN(...) --[[ NilOrNaN | Line: 601 ]]
	if select("#", ...) == 0 then
		return true
	else
		for v1, v2 in { ... } do
			if not v2 or v2 ~= v2 then
				return true
			end
		end
	end
end
local t3 = {}
t3.__index = t3
function t3.new(p1) --[[ new | Line: 615 ]]
	return setmetatable({
		Order = 0
	}, p1)
end
function t3.Get(p1) --[[ Get | Line: 619 ]]
	p1.Order = p1.Order + 1
	return p1.Order
end
t2.OrderGenerator = t3
function t2.GetTeleportData(p1) --[[ GetTeleportData | Line: 634 | Upvalues: RunService (copy), TeleportService (copy) ]]
	RunService:IsStudio()
	if RunService:IsClient() then
		return TeleportService:GetLocalPlayerTeleportData()
	else
		local v1 = p1:GetJoinData()
		return if v1 then v1.TeleportData else v1
	end
end
local t4 = {}
for i = 1, 62 do
	t4[i] = ("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):sub(i, i)
end
local function divmod(p1, p2) --[[ divmod | Line: 653 ]]
	local v1 = p1 // p2
	return v1, p1 - v1 * p2
end
function t2.Int2Base62(p1) --[[ Int2Base62 | Line: 658 | Upvalues: t4 (copy) ]]
	local t = {}
	while true do
		local v1 = #t4
		local v2 = p1 // v1
		table.insert(t, 1, t4[p1 - v2 * v1 + 1])
		if v2 == 0 then
			break
		end
		p1 = v2
	end
	return table.concat(t)
end
local Base64 = require(ReplicatedStorage.Shared.Base64)
local function getUuidChrValue(p1, p2) --[[ getUuidChrValue | Line: 673 ]]
	local v1 = p1:byte(p2)
	if v1 >= 97 then
		local v2 = v1 - 97 + 10
		assert(if v2 >= 10 then if v2 <= 15 then true else false else false)
		return v2
	elseif v1 >= 65 then
		local v4 = v1 - 65 + 10
		assert(if v4 >= 10 then if v4 <= 15 then true else false else false)
		return v4
	elseif v1 >= 48 then
		local v6 = v1 - 48
		assert(if v6 >= 0 then if v6 <= 9 then true else false else false)
		return v6
	else
		error("illegal value")
	end
end
function t2.UUID2Base64(p1) --[[ UUID2Base64 | Line: 692 | Upvalues: getUuidChrValue (copy), Base64 (copy) ]]
	local v1 = p1:gsub("-", "")
	local v2, v3 = v1, {}
	for i = 1, #v1 / 2 do
		local v4 = i * 2
		table.insert(v3, getUuidChrValue(v2, v4 - 1) * 16 + getUuidChrValue(v2, v4))
	end
	return Base64.encodeBytes(v3)
end
function t2.HashString(p1) --[[ HashString | Line: 705 ]]
	local v1 = 5381
	for i = 1, #p1 do
		v1 = (v1 * 33 + string.byte(p1, i)) % 281474976710655
	end
	return v1
end
function t2.LazyHash(p1, p2) --[[ LazyHash | Line: 713 | Upvalues: t2 (copy) ]]
	if (p2 or 45) < #p1 then
		return string.format("%x", t2.HashString(p1))
	else
		return p1
	end
end
function t2.WaitRender(p1) --[[ WaitRender | Line: 720 | Upvalues: RunService (copy) ]]
	local sum = 0
	while sum < p1 do
		sum = sum + RunService.PreRender:Wait()
	end
	return sum
end
return require(ReplicatedStorage.Util.TableUtils).Protect(t2)