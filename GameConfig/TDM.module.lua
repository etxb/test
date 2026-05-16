-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.GameConfig.TDM

-- https://lua.expert/
game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage:WaitForChild("Constant"))
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local v1 = require(script.Parent)
local t = {
	Game = {
		GameTime = 420,
		Round = 1,
		RoundEndTime = 3,
		WinPoint = 200,
		MaxClients = 16,
		MaxBots = 9
	},
	Respawn = {
		Time = 3,
		FastTime = 2
	},
	ExchangeTeam = {
		CheckTime = 10,
		TipTime = 5
	}
}
if game.RunService:IsStudio() then
	t.Game.WinPoint = 10
end
TableUtils.Extends(t, v1)
return t