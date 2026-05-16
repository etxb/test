-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.RoomManager

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(ReplicatedStorage.Remote.EntityService)
local WorldManager = require(ReplicatedStorage.Remote.EntityService.WorldManager)
local World = require(ReplicatedStorage.Remote.EntityService.WorldManager.World)
local GameClient = require(ReplicatedStorage.Remote.GameService.GameClient)
local LocalGameClient = require(ReplicatedStorage.Remote.GameService.GameClient.LocalGameClient)
local Room = require(script.Room)
local v1 = InstanceUtils.LoadModuleScripts(script.Room)
local t = {
	FocusedRoomChanged = SimpleSignal.new(),
	ClientFocus = SimpleSignal.new(),
	ClientUnfocus = SimpleSignal.new()
}
local t2 = {
	Event = t,
	Room = Room,
	GetFocusedRoom = function() --[[ GetFocusedRoom | Line: 38 | Upvalues: LocalGameClient (copy), Room (copy), WorldManager (copy) ]]
		if LocalGameClient.Room then
			return LocalGameClient.Room
		else
			local v1 = Room.GetByWorld(WorldManager.GetFocusedWorld())
			if v1 and (LocalGameClient.Room and LocalGameClient.Room ~= v1) then
				warn("illegal focused room", LocalGameClient.Room, v1)
			end
			return v1
		end
	end,
	SetFocusedRoom = function(p1) --[[ SetFocusedRoom | Line: 51 | Upvalues: WorldManager (copy) ]]
		local v1 = p1 or nil
		WorldManager.SetFocusedWorld(if v1 then v1.World else v1)
	end,
	IsFocusedClient = function(p1) --[[ IsFocusedClient | Line: 56 | Upvalues: WorldManager (copy) ]]
		return if p1 then WorldManager.IsFocusedEntity(p1:GetEntity()) else p1
	end
}
function t2.GetFocusedClients() --[[ GetFocusedClients | Line: 60 | Upvalues: t2 (copy), TableUtils (copy) ]]
	local v1 = t2.GetFocusedRoom()
	if v1 then
		return v1.Clients
	else
		return TableUtils.EMPTY
	end
end
function t2.Start() --[[ Start | Line: 68 | Upvalues: Room (copy), InstanceUtils (copy), Constant (copy), v1 (copy), GameUtils (copy), t2 (copy), GameClient (copy), LocalPlayer (copy), LocalGameClient (copy), t (copy), WorldManager (copy), World (copy) ]]
	task.spawn(Room.onStart)
	InstanceUtils.OnTagged(Constant.Tag.GameRoom, function(p1) --[[ Line: 71 | Upvalues: v1 (ref), Room (ref) ]]
		(v1[p1:GetAttribute("Room")] or Room):new(p1)
	end)
	GameUtils.Forward(Room.Event, Room.FocusedEvent, function(p1) --[[ Line: 76 | Upvalues: t2 (ref) ]]
		return p1 == t2.GetFocusedRoom()
	end)
	GameUtils.Forward(GameClient.Event, GameClient.FocusedEvent, t2.IsFocusedClient)
	local v12 = script.Parent.GameMode:GetDescendants()
	table.insert(v12, 1, script.Parent.GameMode)
	for v2, v3 in v12 do
		if v3:IsA("ModuleScript") then
			task.spawn(function() --[[ Line: 89 | Upvalues: v3 (copy), GameUtils (ref), t2 (ref) ]]
				local v1 = require(v3)
				if v1 then
					if v1.Event and v1.FocusedEvent then
						GameUtils.Forward(v1.Event, v1.FocusedEvent, function(p1) --[[ Line: 95 | Upvalues: t2 (ref) ]]
							local isRoom = p1.Room == t2.GetFocusedRoom()
							return isRoom
						end)
					end
					if v1.onLoad then
						v1:onLoad()
					end
				end
			end)
		end
	end
	local function updateSpectate() --[[ updateSpectate | Line: 105 | Upvalues: Room (ref), LocalPlayer (ref), LocalGameClient (ref), t2 (ref) ]]
		local v1 = Room.GetByName(LocalPlayer:GetAttribute("SpectateRoom"))
		if LocalGameClient.Room then
			v1 = nil
		end
		if not (v1 and LocalGameClient.Room) then
			t2.SetFocusedRoom(v1)
		end
	end
	Room.Event.Created:Connect(function(p1) --[[ Line: 115 | Upvalues: t2 (ref), t (ref) ]]
		if p1 == t2.GetFocusedRoom() then
			t.FocusedRoomChanged:Fire(p1)
			if not p1.Loaded or (not p1.World.Deployed or p1.Deployed) then
				return
			end
			p1:Deploy()
		end
	end)
	Room.FocusedEvent.ClientJoined:Connect(function(p1, p2) --[[ Line: 124 | Upvalues: t (ref) ]]
		t.ClientFocus:Fire(p2)
	end)
	Room.FocusedEvent.Loaded:Connect(function(p1) --[[ Line: 128 | Upvalues: t (ref) ]]
		t.FocusedRoomChanged:Fire(p1)
		if p1.World.Deployed and not p1.Deployed then
			p1:Deploy()
		end
	end)
	WorldManager.Event.FocusedWorldChanged:Connect(function(p1, p2) --[[ Line: 135 | Upvalues: Room (ref), t (ref) ]]
		local v1 = if p2 then Room.GetByWorld(p2) else p2
		t.FocusedRoomChanged:Fire(if p1 then Room.GetByWorld(p1) else p1, v1)
	end)
	WorldManager.Event.EntityFocus:ConnectEarly(function(p1) --[[ Line: 145 | Upvalues: GameClient (ref), t2 (ref), t (ref) ]]
		local v1 = GameClient.Get(p1.Instance)
		if v1 and v1.Room == t2.GetFocusedRoom() then
			t.ClientFocus:Fire(v1)
		else
			local Player = p1.Player
		end
	end)
	WorldManager.Event.EntityUnfocus:ConnectLater(function(p1) --[[ Line: 154 | Upvalues: GameClient (ref), t (ref) ]]
		local v1 = GameClient.Get(p1.Instance)
		if v1 then
			t.ClientUnfocus:Fire(v1)
		end
	end)
	local v4 = nil
	t.FocusedRoomChanged:ConnectEarly(function() --[[ Line: 163 | Upvalues: v4 (ref), LocalGameClient (ref) ]]
		v4 = LocalGameClient.Room or nil
	end)
	LocalGameClient.LocalEvent.Joined:Connect(function() --[[ Line: 166 | Upvalues: LocalGameClient (ref), t2 (ref), v4 (ref), t (ref) ]]
		if LocalGameClient.Room then
			t2.SetFocusedRoom()
		end
		if v4 ~= (LocalGameClient.Room or nil) then
			t.FocusedRoomChanged:Fire()
		end
	end)
	LocalPlayer:GetAttributeChangedSignal("SpectateRoom"):Connect(updateSpectate)
	local v5 = Room.GetByName(LocalPlayer:GetAttribute("SpectateRoom"))
	if LocalGameClient.Room then
		v5 = nil
	end
	if not (v5 and LocalGameClient.Room) then
		t2.SetFocusedRoom(v5)
	end
	World.Event.Deploy:Connect(function(p1) --[[ Line: 191 | Upvalues: Room (ref) ]]
		local v1 = Room.GetByWorld(p1)
		if v1 then
			v1:Deploy()
		end
	end)
	World.Event.Undeploy:Connect(function(p1) --[[ Line: 197 | Upvalues: Room (ref) ]]
		local v1 = Room.GetByWorld(p1)
		if v1 then
			v1:Undeploy()
		end
	end)
end
return t2