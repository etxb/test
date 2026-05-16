-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.RoomManager.Room

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local MapConfig = require(ReplicatedStorage.Config.MapConfig)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local ConnectionHolder = require(ReplicatedStorage.Util.ConnectionHolder)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(ReplicatedStorage.Common.NetworkHelper)
require(ReplicatedStorage.Remote.EntityService)
local Entity = require(ReplicatedStorage.Remote.EntityService.Entity)
require(ReplicatedStorage.Remote.EntityService.WorldManager)
local World = require(ReplicatedStorage.Remote.EntityService.WorldManager.World)
local GameClient = require(ReplicatedStorage.Remote.GameService.GameClient)
require(ReplicatedStorage.Remote.GameService.MapManager)
local v1 = TableUtils.Array.InstancesToDict(ReplicatedStorage.Assets.Map:GetChildren())
task.spawn(function() --[[ Line: 27 | Upvalues: v1 (copy) ]]
	for v12, v2 in v1 do
		local Preset = v2:FindFirstChild("Preset")
		if Preset then
			Preset.Parent = script
		end
		local GameProps = v2:FindFirstChild("GameProps")
		if GameProps then
			GameProps.Parent = script
		end
		local Dead = v2:FindFirstChild("Dead")
		if Dead then
			Dead.Parent = script
		end
		local Spawn = v2:FindFirstChild("Spawn")
		if Spawn then
			Spawn.Parent = script
		end
		local Replicated = v2:FindFirstChild("Replicated")
		if Replicated then
			Replicated.Parent = script
		end
	end
end)
local GameService = ReplicatedStorage.Remote.GameService
local t = {
	Created = SimpleSignal.new(),
	Loaded = SimpleSignal.new(),
	ClientJoined = SimpleSignal.new(),
	ClientLeaving = SimpleSignal.new(),
	ClientLeft = SimpleSignal.new(),
	Deploy = SimpleSignal.new(),
	Undeploy = SimpleSignal.new(),
	ModeChanged = SimpleSignal.new(),
	MapChanged = SimpleSignal.new(),
	VoteMap = SimpleSignal.new(),
	ShowMap = SimpleSignal.new(),
	TimeChanged = SimpleSignal.new(),
	StateChanged = SimpleSignal.new(),
	GameStarting = SimpleSignal.new(),
	GameStarted = SimpleSignal.new(),
	GameEnding = SimpleSignal.new(),
	GameEnded = SimpleSignal.new(),
	RoundChanged = SimpleSignal.new(),
	RoundStateChanged = SimpleSignal.new(),
	RoundStarting = SimpleSignal.new(),
	RoundStarted = SimpleSignal.new(),
	RoundEnding = SimpleSignal.new(),
	RoundEnded = SimpleSignal.new(),
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new()
}
local t2 = {
	Instance = nil,
	Id = 0,
	Name = "",
	Clients = nil,
	World = nil,
	Mode = nil,
	Round = 0,
	Event = t,
	FocusedEvent = {
		Loaded = SimpleSignal.new(),
		ClientJoined = SimpleSignal.new(),
		ClientLeaving = SimpleSignal.new(),
		ClientLeft = SimpleSignal.new(),
		ModeChanged = SimpleSignal.new(),
		MapChanged = SimpleSignal.new(),
		VoteMap = SimpleSignal.new(),
		ShowMap = SimpleSignal.new(),
		TimeChanged = SimpleSignal.new(),
		StateChanged = SimpleSignal.new(),
		GameStarting = SimpleSignal.new(),
		GameStarted = SimpleSignal.new(),
		GameEnding = SimpleSignal.new(),
		GameEnded = SimpleSignal.new(),
		RoundChanged = SimpleSignal.new(),
		RoundStateChanged = SimpleSignal.new(),
		RoundStarting = SimpleSignal.new(),
		RoundStarted = SimpleSignal.new(),
		RoundEnding = SimpleSignal.new(),
		RoundEnded = SimpleSignal.new()
	},
	State = Constant.RoomState.Waiting,
	RoundState = Constant.RoundState.Waiting
}
t2.__index = t2
function t2.__tostring(p1) --[[ Line: 132 ]]
	return ("Room[%s]"):format(p1.Instance.Name)
end
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
t2.RoomsByWorld = t6
function t2.Get(p1) --[[ Get | Line: 145 | Upvalues: t3 (copy) ]]
	return t3[p1]
end
function t2.GetByName(p1) --[[ GetByName | Line: 149 | Upvalues: t4 (copy) ]]
	return t4[p1]
end
function t2.GetById(p1) --[[ GetById | Line: 153 | Upvalues: t5 (copy) ]]
	return t5[p1]
end
function t2.GetByWorld(p1) --[[ GetByWorld | Line: 157 | Upvalues: t6 (copy) ]]
	return if p1 then t6[p1.Instance] else p1
end
function t2.new(p1, p2) --[[ new | Line: 161 | Upvalues: TableUtils (copy), ConnectionHolder (copy), InstanceUtils (copy), SimpleSignal (copy), RunService (copy), World (copy), t6 (copy), t (copy), t3 (copy), t5 (copy), t4 (copy) ]]
	local v1 = setmetatable({
		Instance = p2,
		Id = p2:GetAttribute("Id"),
		Name = p2.Name,
		Clients = TableUtils.NewDict(),
		ClientsByTeam = TableUtils.AutoTable({}, TableUtils.NewDict),
		Players = TableUtils.NewDict(),
		Connections = ConnectionHolder:new()
	}, p1)
	local v2 = Instance.new("Folder")
	v2.Name = p2.Name .. "Map"
	v2.Parent = workspace.Map
	v1.MapHolder = v2
	local v3 = false
	local v4 = task.spawn(function() --[[ Line: 189 | Upvalues: InstanceUtils (ref), p2 (copy), SimpleSignal (ref), RunService (ref), World (ref), v1 (copy), t6 (ref), v3 (ref), t (ref) ]]
		local v12 = InstanceUtils.WaitFor(p2, "World")
		if v12 then
			if not v12.Value then
				print("wait world")
				local v2 = SimpleSignal.combine(p2.Destroying, v12.Changed)
				v2:Wait()
				RunService.Heartbeat:Wait()
				v2:Destroy()
				while not World.Get(v12.Value) and p2.Parent do
					RunService.Heartbeat:Wait()
				end
				if not (v12.Value and p2.Parent) then
					return
				end
			end
			if p2.Parent then
				v1.World = World.Get(v12.Value)
				if v1.World then
					t6[v1.World.Instance] = v1
				end
				local v32 = InstanceUtils.WaitFor(p2, "Data")
				if v32 then
					v1.DataInstance = v32
					v1.State = v32.State.Value
					v1.RoundState = v32.RoundState.Value
					v1.Round = v32.Round.Value
					v1.Rounds = v32.Rounds.Value
					if v3 then
						t.StateChanged:Fire(v1)
						t.RoundStateChanged:Fire(v1)
						t.RoundChanged:Fire(v1)
					end
					v1.Connections:AddConnection("time", v32.Time.Changed:Connect(function() --[[ Line: 236 | Upvalues: t (ref), v1 (ref) ]]
						t.TimeChanged:Fire(v1)
					end))
					v1.Connections:AddConnection("roomState", v32.State.Changed:Connect(function() --[[ Line: 239 | Upvalues: v1 (ref), v32 (copy), t (ref) ]]
						v1.State = v32.State.Value
						t.StateChanged:Fire(v1)
					end))
					v1.Connections:AddConnection("roundState", v32.RoundState.Changed:Connect(function() --[[ Line: 243 | Upvalues: v1 (ref), v32 (copy), t (ref) ]]
						v1.RoundState = v32.RoundState.Value
						t.RoundStateChanged:Fire(v1)
					end))
					v1.Connections:AddConnection("round", v32.Round.Changed:Connect(function() --[[ Line: 247 | Upvalues: v1 (ref), v32 (copy), t (ref) ]]
						v1.Round = v32.Round.Value
						t.RoundChanged:Fire(v1)
					end))
					v1.Connections:AddConnection("rounds", v32.Rounds.Changed:Connect(function() --[[ Line: 251 | Upvalues: v1 (ref), v32 (copy), t (ref) ]]
						v1.Rounds = v32.Rounds.Value
						t.RoundChanged:Fire(v1)
					end))
					v1.Connections:AddConnection("mode", v32.Mode.Changed:Connect(function() --[[ Line: 255 | Upvalues: v1 (ref), t (ref) ]]
						v1:LoadMode()
						t.ModeChanged:Fire(v1)
					end))
					local Map = v32.Map
					v1.Connections:AddConnection("map", Map.Changed:Connect(function() --[[ Line: 260 | Upvalues: v1 (ref), t (ref) ]]
						v1:LoadMap()
						t.MapChanged:Fire(v1)
					end))
					v1.Connections:AddConnection("mapCFrame", Map:GetAttributeChangedSignal("CFrame"):Connect(function() --[[ Line: 264 | Upvalues: v1 (ref), Map (copy) ]]
						if v1.MapModel and v1.MapModel.Parent == v1.MapHolder then
							v1.MapModel:PivotTo(Map:GetAttribute("CFrame") or CFrame.identity)
						end
					end))
					v1:LoadMode()
					v1:LoadMap()
					v1.Loaded = true
					if v3 then
						t.Loaded:Fire(v1)
					end
				end
			end
		end
	end)
	if coroutine.status(v4) == "suspended" then
		v3 = true
	end
	v1.Connections:AddConnection("destroy", p2.Destroying:Connect(function() --[[ Line: 283 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end))
	t3[p2] = v1
	t5[v1.Id] = v1
	t4[v1.Name] = v1
	t.Created:Fire(v1)
	return v1
end
function t2.LoadMode(p1) --[[ LoadMode | Line: 300 | Upvalues: Config (copy), Constant (copy), GameUtils (copy), Entity (copy) ]]
	p1.Mode = p1.DataInstance.Mode.Value
	p1.ModeSet = Config.GameModeSetReverse[p1.Mode]
	if p1.ModeHandler then
		for v1, v2 in p1.Clients do
			p1.ModeHandler:OnClientLeft(v2)
		end
		p1.ModeHandler:Destroy()
		p1.ModeHandler = nil
		p1.World:SetFriendlyHook()
	end
	if Constant.GameMode[p1.Mode] then
		local v3 = GameUtils.FindModule(script.Parent.Parent.GameMode, p1.Mode, p1.ModeSet, "\230\184\184\230\136\143\230\168\161\229\157\151"):new(p1, p1.Mode)
		p1.ModeHandler = v3
		p1.World:SetFriendlyHook({
			Team = function(p1, p2) --[[ Team | Line: 319 | Upvalues: v3 (copy) ]]
				return v3:IsFriendlyTeam(p1, p2)
			end,
			Entity = function(p1, p2) --[[ Entity | Line: 322 | Upvalues: v3 (copy) ]]
				return v3:IsFriendly(p1, p2)
			end
		})
		for v4, v5 in p1.World.Entities do
			Entity.Event.TeamChanged:Fire(v5)
		end
		if v3 then
			for v6, v7 in p1.Clients do
				v3:OnClientJoined(v7)
			end
		end
	end
end
function t2.LoadMap(p1) --[[ LoadMap | Line: 337 | Upvalues: ReplicatedStorage (copy), v1 (copy) ]]
	local Map = p1.DataInstance.Map
	local v12 = Map.Value
	if v12 ~= p1.Map then
		if p1.MapModel and p1.MapModel.Parent == p1.MapHolder then
			p1.MapModel.Parent = ReplicatedStorage.Assets.Map
		end
		p1.Map = v12
		p1.MapModel = v1[p1.Map]
		if p1.MapModel and p1.Deployed then
			p1.MapModel.Parent = p1.MapHolder
			p1.MapModel:PivotTo(Map:GetAttribute("CFrame"), CFrame.identity)
		end
	end
end
function t2.GetState(p1) --[[ GetState | Line: 354 ]]
	return p1.State
end
function t2.setState(p1, p2) --[[ setState | Line: 358 | Upvalues: t (copy) ]]
	p1.State = p2
	t.StateChanged:Fire(p1)
end
function t2.GetCurrentTimeRemaining(p1, p2) --[[ GetCurrentTimeRemaining | Line: 363 ]]
	if p1.DataInstance then
		local v1 = p1.DataInstance.Time.Value - workspace:GetServerTimeNow()
		if not p2 then
			v1 = math.max(v1, 0)
		end
		return v1
	else
		return 0
	end
end
function t2.IsStarting(p1) --[[ IsStarting | Line: 374 | Upvalues: Constant (copy) ]]
	local isStarting = p1:GetState() == Constant.GameState.Starting
	return isStarting
end
function t2.IsStarted(p1) --[[ IsStarted | Line: 378 | Upvalues: Constant (copy) ]]
	local isStarted = p1:GetState() == Constant.GameState.Started
	return isStarted
end
local v2 = TableUtils.SwapKV({ Constant.GameState.Starting, Constant.GameState.Started, Constant.GameState.Ending })
function t2.IsGaming(p1) --[[ IsGaming | Line: 388 | Upvalues: v2 (copy) ]]
	return v2[p1:GetState()] and true
end
function t2.IsEnding(p1) --[[ IsEnding | Line: 392 | Upvalues: Constant (copy) ]]
	local isEnding = p1:GetState() == Constant.GameState.Ending
	return isEnding
end
function t2.IsEnded(p1) --[[ IsEnded | Line: 396 | Upvalues: Constant (copy) ]]
	local isEnded = p1:GetState() == Constant.GameState.Ended
	return isEnded
end
function t2.GetRoundState(p1) --[[ GetRoundState | Line: 400 ]]
	return p1.RoundState
end
function t2.setRoundState(p1, p2) --[[ setRoundState | Line: 404 | Upvalues: t (copy) ]]
	p1.RoundState = p2
	t.RoundStateChanged:Fire(p1)
end
function t2.IsRoundStarting(p1) --[[ IsRoundStarting | Line: 409 | Upvalues: Constant (copy) ]]
	local isStarting = p1:GetRoundState() == Constant.RoundState.Starting
	return isStarting
end
function t2.IsRoundStarted(p1) --[[ IsRoundStarted | Line: 413 | Upvalues: Constant (copy) ]]
	local isStarted = p1:GetRoundState() == Constant.RoundState.Started
	return isStarted
end
local v3 = TableUtils.SwapKV({ Constant.RoundState.Starting, Constant.RoundState.Started, Constant.RoundState.Ending })
function t2.IsRoundGaming(p1) --[[ IsRoundGaming | Line: 423 | Upvalues: v3 (copy) ]]
	return v3[p1:GetRoundState()] and true
end
function t2.IsRoundEnding(p1) --[[ IsRoundEnding | Line: 427 | Upvalues: Constant (copy) ]]
	local isEnding = p1:GetRoundState() == Constant.RoundState.Ending
	return isEnding
end
function t2.IsRoundEnded(p1) --[[ IsRoundEnded | Line: 431 | Upvalues: Constant (copy) ]]
	local isEnded = p1:GetRoundState() == Constant.RoundState.Ended
	return isEnded
end
function t2.GetRoundStartRemaining(p1) --[[ GetRoundStartRemaining | Line: 435 ]]
	return if p1:IsStarting() then p1:GetCurrentTimeRemaining() or -1 else -1
end
function t2.GetRoundGameRemaining(p1) --[[ GetRoundGameRemaining | Line: 439 ]]
	if p1:IsGaming() and not p1:IsEnding() then
		if p1.DataInstance.GameTime.Value == -1 then
			return -1
		else
			local Time = p1.DataInstance.Time.Value
			if p1:IsStarting() then
				Time = Time + p1.DataInstance.GameTime.Value
			end
			return math.max(0, Time - workspace:GetServerTimeNow())
		end
	else
		return 0
	end
end
function t2.GetGameConfig(p1) --[[ GetGameConfig | Line: 454 ]]
	return p1.ModeHandler and p1.ModeHandler.Config
end
function t2._UpdateClientTeam(p1, p2, p3, p4) --[[ _UpdateClientTeam | Line: 458 ]]
	if p4 then
		p1.ClientsByTeam[p4][p2.Instance] = nil
	end
	if p3 then
		p1.ClientsByTeam[p3][p2.Instance] = p2
	end
end
function t2.Join(p1, p2) --[[ Join | Line: 468 | Upvalues: t (copy), GameClient (copy) ]]
	if p2.Room ~= p1 then
		if p2.Room then
			p2.Room:Leave(p2)
		end
		p2.Room = p1
		p1.Clients[p2.Instance] = p2
		if p2.Player then
			p1.Players[p2.Player] = p2
		end
		p1:_UpdateClientTeam(p2, p2:GetTeam())
		if p1.ModeHandler then
			p1.ModeHandler:OnClientJoined(p2)
		end
		t.ClientJoined:Fire(p1, p2)
		GameClient.Event.Joined:Fire(p2, p1)
	end
end
function t2.Leave(p1, p2) --[[ Leave | Line: 493 | Upvalues: t (copy), GameClient (copy) ]]
	if p2.Room == p1 then
		t.ClientLeaving:Fire(p1, p2)
		GameClient.Event.Leaving:Fire(p2, p1)
		p2.Room = nil
		p2.GameConnections:DisconnectAll()
		if p1.ModeHandler then
			p1.ModeHandler:OnClientLeft(p2)
		end
		p1:_UpdateClientTeam(p2, nil, p2:GetTeam())
		p1.Clients[p2.Instance] = nil
		if p2.Player then
			p1.Players[p2.Player] = nil
		end
		t.ClientLeft:Fire(p1, p2)
		GameClient.Event.Left:Fire(p2)
	end
end
function t2.Deploy(p1) --[[ Deploy | Line: 518 | Upvalues: t (copy) ]]
	if not p1.Deployed then
		p1.Deployed = true
		p1.Instance.Parent = workspace.Room
		task.spawn(function() --[[ Line: 524 | Upvalues: p1 (copy) ]]
			if p1.MapModel then
				p1.MapModel.Parent = p1.MapHolder
				p1.MapModel:PivotTo(p1.DataInstance.Map:GetAttribute("CFrame"), CFrame.identity)
			end
		end)
		t.Deploy:Fire(p1)
	end
end
function t2.Undeploy(p1) --[[ Undeploy | Line: 533 | Upvalues: ReplicatedStorage (copy), t (copy) ]]
	if p1.Deployed then
		p1.Deployed = nil
		if p1.MapModel and p1.MapModel.Parent == p1.MapHolder then
			p1.MapModel.Parent = ReplicatedStorage.Assets.Map
		end
		if p1.Instance.Parent and not p1.Destroying then
			p1.Instance.Parent = ReplicatedStorage.Assets.Temp
		end
		t.Undeploy:Fire(p1)
	end
end
function t2.GetClientsByTeam(p1, p2) --[[ GetClientsByTeam | Line: 547 | Upvalues: TableUtils (copy) ]]
	local v1 = rawget(p1.ClientsByTeam, p2)
	return if v1 then v1 else TableUtils.EMPTY
end
function t2.CanSelectRole(p1, p2) --[[ CanSelectRole | Line: 552 ]]
	return p1.ModeHandler and p1.ModeHandler:CanSelectRole(p2)
end
function t2.CanSelectRoleBypass(p1) --[[ CanSelectRoleBypass | Line: 556 ]]
	return p1.ModeHandler and p1.ModeHandler:CanSelectRoleBypass()
end
function t2.GetModeDisplay(p1) --[[ GetModeDisplay | Line: 561 ]]
	return if p1.ModeHandler then p1.ModeHandler:GetModeDisplay() or "" else ""
end
function t2.GetMapDisplay(p1) --[[ GetMapDisplay | Line: 565 | Upvalues: MapConfig (copy) ]]
	return MapConfig[p1.Map] and MapConfig[p1.Map].Display or (p1.Map or "")
end
function t2.IsMode(p1, ...) --[[ IsMode | Line: 570 ]]
	for v1, v2 in { ... } do
		if v2 == p1.Mode then
			return true
		end
	end
end
function t2.IsModeSet(p1, ...) --[[ IsModeSet | Line: 578 ]]
	for v1, v2 in { ... } do
		if v2 == p1.ModeSet then
			return true
		end
	end
end
function t2.Destroy(p1) --[[ Destroy | Line: 585 | Upvalues: t (copy), ReplicatedStorage (copy), t3 (copy), t5 (copy), t4 (copy), t6 (copy) ]]
	if not p1.Destroying then
		p1.Destroying = true
		p1:Undeploy()
		for v1, v2 in p1.Clients do
			p1:Leave(v2)
		end
		t.Destroying:Fire(p1)
		p1.Connections:Destroy()
		if p1.MapModel and p1.MapModel.Parent == p1.MapHolder then
			p1.MapModel.Parent = ReplicatedStorage.Assets.Temp
		end
		p1.MapHolder:Destroy()
		p1.MapModel = nil
		if p1.ModeHandler then
			p1.ModeHandler:Destroy()
			p1.ModeHandler = nil
			p1.World:SetFriendlyHook()
		end
		t3[p1.Instance] = nil
		t5[p1.Id] = nil
		t4[p1.Name] = nil
		if p1.World then
			t6[p1.World.Instance] = nil
		end
		t.Destroyed:Fire(p1)
	end
end
function t2.onStart() --[[ onStart | Line: 624 | Upvalues: TableUtils (copy), GameClient (copy), t2 (copy), t (copy) ]]
	local v1 = TableUtils.AutoTable()
	local function loadRoom(p1) --[[ loadRoom | Line: 627 | Upvalues: v1 (copy), GameClient (ref) ]]
		local v3 = rawget(v1, p1.Name)
		v1[p1.Name] = nil
		if v3 then
			for v4, v5 in v3 do
				local v6 = GameClient.Get(v4)
				if v6 then
					p1:Join(v6)
				end
			end
		end
	end
	t2.Event.Created:Connect(function(p1) --[[ Line: 640 | Upvalues: loadRoom (copy) ]]
		if p1.Loaded then
			loadRoom(p1)
		end
	end)
	t2.Event.Loaded:Connect(function(p1) --[[ Line: 645 | Upvalues: loadRoom (copy) ]]
		loadRoom(p1)
	end)
	local function listenClientRoom(p1) --[[ listenClientRoom | Line: 649 | Upvalues: t2 (ref), v1 (copy) ]]
		local v12 = nil
		local function updateJoinRoom() --[[ updateJoinRoom | Line: 653 | Upvalues: p1 (copy), v12 (ref), t2 (ref), v1 (ref) ]]
			if p1.Room then
				p1.Room:Leave(p1)
			end
			if v12 then
				v12[p1.Instance] = nil
			end
			v12 = nil
			local v13 = p1.Instance:GetAttribute("GameRoom")
			local v2 = t2.GetByName(v13)
			if v2 then
				v2:Join(p1)
			elseif v13 then
				v12 = v1[v13]
				v12[p1.Instance] = true
			end
		end
		p1.Connections:AddConnection("room", p1.Instance:GetAttributeChangedSignal("GameRoom"):Connect(updateJoinRoom))
		updateJoinRoom()
	end
	GameClient.Event.Created:Connect(listenClientRoom)
	for v2, v3 in GameClient.GetAll() do
		task.spawn(listenClientRoom, v3)
	end
	GameClient.Event.TeamChanged:Connect(function(p1, p2, p3) --[[ Line: 683 ]]
		local Room = p1.Room
		if Room then
			Room:_UpdateClientTeam(p1, p2, p3)
		end
	end)
	GameClient.Event.Destroying:Connect(function(p1) --[[ Line: 690 ]]
		if p1.Room then
			p1.Room:Leave(p1)
		end
	end)
	local function wrapFn(p1) --[[ wrapFn | Line: 696 | Upvalues: t2 (ref) ]]
		return function(p12, ...) --[[ Line: 697 | Upvalues: t2 (ref), p1 (copy) ]]
			local v1 = t2.Get(p12)
			if v1 then
				p1(v1, ...)
			end
		end
	end
	local function f4(p1, p2) --[[ Line: 705 | Upvalues: t (ref) ]]
		t.GameStarting:Fire(p1, p2)
	end
	script.GameStart.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f4 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f4(v1, ...)
		end
	end)
	local function f5(p1, p2) --[[ Line: 709 | Upvalues: t (ref) ]]
		t.GameStarted:Fire(p1, p2)
	end
	script.GameStarted.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f5 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f5(v1, ...)
		end
	end)
	local function f6(p1, p2) --[[ Line: 713 | Upvalues: t (ref) ]]
		t.GameEnding:Fire(p1, p2)
	end
	script.GameEnd.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f6 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f6(v1, ...)
		end
	end)
	local function f7(p1, p2) --[[ Line: 717 | Upvalues: t (ref) ]]
		t.GameEnded:Fire(p1, p2)
	end
	script.GameEnded.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f7 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f7(v1, ...)
		end
	end)
	local function f8(p1, p2) --[[ Line: 722 | Upvalues: t (ref) ]]
		t.RoundStarting:Fire(p1, p2)
	end
	script.RoundStart.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f8 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f8(v1, ...)
		end
	end)
	local function f9(p1, p2) --[[ Line: 726 | Upvalues: t (ref) ]]
		t.RoundStarted:Fire(p1, p2)
	end
	script.RoundStarted.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f9 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f9(v1, ...)
		end
	end)
	local function f10(p1, p2) --[[ Line: 730 | Upvalues: t (ref) ]]
		t.RoundEnding:Fire(p1, p2)
	end
	script.RoundEnd.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f10 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f10(v1, ...)
		end
	end)
	local function f11(p1, p2) --[[ Line: 734 | Upvalues: t (ref) ]]
		t.RoundEnded:Fire(p1, p2)
	end
	script.RoundEnded.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f11 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f11(v1, ...)
		end
	end)
	local function f12(p1, p2, p3) --[[ Line: 739 | Upvalues: t (ref) ]]
		p1.VotingMaps = {
			Maps = p2,
			Timeout = p3
		}
		t.VoteMap:Fire(p1)
	end
	script.VoteMap.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f12 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f12(v1, ...)
		end
	end)
	local function f13(p1, p2, p3, p4) --[[ Line: 745 | Upvalues: t (ref) ]]
		t.ShowMap:Fire(p1, p4)
	end
	script.ShowMap.OnClientEvent:Connect(function(p1, ...) --[[ Line: 697 | Upvalues: t2 (ref), f13 (copy) ]]
		local v1 = t2.Get(p1)
		if v1 then
			f13(v1, ...)
		end
	end)
end
return t2