-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameStarterService

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
require(ReplicatedStorage.Shared.SimpleSignal)
local GameStarter = require(script.GameStarter)
return {
	GameStarter = GameStarter,
	Start = function() --[[ Start | Line: 20 | Upvalues: InstanceUtils (copy), GameStarter (copy) ]]
		InstanceUtils.OnTagged("GameStarter", function(p1) --[[ Line: 21 | Upvalues: GameStarter (ref) ]]
			if not GameStarter.Get(p1) then
				GameStarter:new(p1)
			end
		end)
	end
}