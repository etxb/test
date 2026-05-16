-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.GameConfig.Duel

-- https://lua.expert/
game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage:WaitForChild("Constant"))
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local v1 = require(script.Parent)
local t = {
	Respawn = false,
	Game = {
		GameTime = 120,
		Round = -1,
		RoundEndTime = 3,
		RoundWin = true,
		WinPoint = 5
	}
}
if RunService:IsStudio() then
	t.Game.WinPoint = 2
end
TableUtils.Extends(t, v1)
return t