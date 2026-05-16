-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameStarterService.GameStarter

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local MatchmakingService = require(ReplicatedStorage.Remote.MatchmakingService)
local EntityService = require(ReplicatedStorage.Remote.EntityService)
local v1 = script.Parent
local t = {
	Created = SimpleSignal.new(),
	PlayerJoined = SimpleSignal.new(),
	PlayerLeft = SimpleSignal.new(),
	TimeChanged = SimpleSignal.new()
}
local t2 = {
	Joined = SimpleSignal.new(),
	Left = SimpleSignal.new()
}
local t3 = {
	Instance = nil,
	StartTime = -1,
	TeamSize = 1,
	LocalJoining = nil,
	LocalJoined = nil,
	Event = t,
	LocalEvent = t2
}
t3.__index = t3
local t4 = {}
local t5 = {}
function t3.GetAll() --[[ GetAll | Line: 49 | Upvalues: t4 (copy) ]]
	return t4
end
function t3.Get(p1) --[[ Get | Line: 53 | Upvalues: t4 (copy) ]]
	return t4[p1]
end
function t3.new(p1, p2) --[[ new | Line: 57 | Upvalues: t (copy), t4 (copy) ]]
	local v1 = setmetatable({
		Instance = p2,
		JoinParts = {}
	}, p1)
	local function onChildAdded(p1) --[[ onChildAdded | Line: 63 | Upvalues: v1 (copy) ]]
		if p1:IsA("BasePart") then
			v1:SetupPart(p1)
		end
	end
	p2.ChildAdded:Connect(onChildAdded)
	for v2, v3 in p2:GetChildren() do
		task.spawn(onChildAdded, v3)
	end
	v1.StartTime = p2:GetAttribute("StartTime") or -1
	p2:GetAttributeChangedSignal("StartTime"):Connect(function() --[[ Line: 74 | Upvalues: v1 (copy), p2 (copy), t (ref) ]]
		v1.StartTime = p2:GetAttribute("StartTime") or -1
		t.TimeChanged:Fire(v1)
	end)
	t4[p2] = v1
	v1.TeamSize = p2:GetAttribute("TeamSize") or 1
	t.Created:Fire(v1)
	return v1
end
local t6 = {
	Joining = nil,
	Joined = {}
}
function t6.Update() --[[ Update | Line: 92 | Upvalues: t6 (copy), t3 (copy), v1 (copy), t5 (copy), MatchmakingService (copy) ]]
	local v12 = t6.Joined[1]
	local Joining = t6.Joining
	if Joining ~= v12 then
		if t3.LocalJoining and t3.LocalJoining.Part == Joining then
			t3.LocalJoining = nil
			v1.Leave:FireServer()
		end
		local v2 = t5[v12]
		if v2 then
			t3.LocalJoining = {
				Starter = v2,
				Part = v12
			}
			task.spawn(MatchmakingService.Cancel)
			v1.Join:FireServer(v12)
		end
		t6.Joining = v12
	end
end
function t6.Join(p1) --[[ Join | Line: 113 | Upvalues: t6 (copy), t5 (copy) ]]
	local v1 = table.find(t6.Joined, p1)
	if v1 and v1 == 1 then
		t6.Leave(p1)
	elseif v1 then
		table.remove(t6.Joined, v1)
	end
	if t5[p1] then
		table.insert(t6.Joined, p1)
		if #t6.Joined == 1 then
			t6.Update()
		end
	end
end
function t6.Leave(p1) --[[ Leave | Line: 132 | Upvalues: t6 (copy) ]]
	local v1 = table.find(t6.Joined, p1)
	if v1 then
		table.remove(t6.Joined, v1)
		if v1 == 1 then
			t6.Update()
		end
	end
end
LocalPlayer.CharacterRemoving:Connect(function() --[[ Line: 143 | Upvalues: t6 (copy) ]]
	table.clear(t6.Joined)
	t6.Update()
end)
function t3.SetupPart(p1, p2) --[[ SetupPart | Line: 173 | Upvalues: TableUtils (copy), LocalPlayer (copy), t3 (copy), t2 (copy), t (copy), EntityService (copy), t6 (copy), t5 (copy) ]]
	if not p1.JoinParts[p2] then
		local v1 = p2.Name
		local t4 = {
			Values = TableUtils.NewDict()
		}
		p1.JoinParts[p2] = t4
		local function onChildAdded(p12) --[[ onChildAdded | Line: 184 | Upvalues: t4 (copy), LocalPlayer (ref), t3 (ref), p1 (copy), t2 (ref), v1 (copy), t (ref) ]]
			if p12:IsA("ObjectValue") and p12.Value then
				t4.Values[p12] = true
				if p12.Value == LocalPlayer then
					t3.LocalJoined = p1
					t2.Joined:Fire(p1, v1)
				end
				t.PlayerJoined:Fire(p1, p12.Value, v1)
			end
		end
		p2.ChildAdded:Connect(onChildAdded)
		for v2, v3 in p2:GetChildren() do
			task.spawn(onChildAdded, v3)
		end
		p2.ChildRemoved:Connect(function(p12) --[[ Line: 199 | Upvalues: t4 (copy), LocalPlayer (ref), t3 (ref), p1 (copy), t2 (ref), v1 (copy), t (ref) ]]
			t4.Values[p12] = false
			if p12:IsA("ObjectValue") and p12.Value then
				if p12.Value == LocalPlayer then
					if t3.LocalJoined == p1 then
						t3.LocalJoined = nil
					end
					t2.Left:Fire(p1, v1)
				end
				t.PlayerLeft:Fire(p1, p12.Value, v1)
			end
		end)
		p2.Touched:Connect(function(p1) --[[ Line: 212 | Upvalues: LocalPlayer (ref), EntityService (ref), t6 (ref), p2 (copy) ]]
			if p1.Parent == LocalPlayer.Character and p1.Name == "HumanoidRootPart" and not EntityService.LocalEntity:HasFlag(EntityService.Entity.Flag.Frozen) then
				t6.Join(p2)
			end
		end)
		p2.TouchEnded:Connect(function(p1) --[[ Line: 223 | Upvalues: LocalPlayer (ref), t6 (ref), p2 (copy) ]]
			if p1.Parent == LocalPlayer.Character and p1.Name == "HumanoidRootPart" then
				t6.Leave(p2)
			end
		end)
		t5[p2] = p1
	end
end
function t3.GetJoinedPlayers(p1) --[[ GetJoinedPlayers | Line: 254 ]]
	local t = {}
	for v1, v2 in p1.JoinParts do
		local t2 = {}
		for v3, v4 in v1:GetChildren() do
			if v4:IsA("ObjectValue") and (v4.Value and v4.Value.Parent) then
				table.insert(t2, v4.Value)
			end
		end
		t[v1.Name] = t2
	end
	return t
end
function t3.IsStarting(p1) --[[ IsStarting | Line: 268 ]]
	return p1.StartTime ~= -1
end
function t3.GetJoinParts(p1) --[[ GetJoinParts | Line: 272 ]]
	return p1.JoinParts
end
return t3