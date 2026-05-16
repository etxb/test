-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.GameConfig.FFA

-- https://lua.expert/
game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage:WaitForChild("Constant"))
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local v1 = require(script.Parent)
local t = {
	Game = {
		GameTime = 360,
		Round = 1,
		RoundEndTime = 3
	},
	GameProp = {
		RefreshTime = {
			Charger = 90,
			Medkit = 90
		}
	},
	Respawn = {
		Time = 3,
		FastTime = 2
	}
}
RunService:IsStudio()
TableUtils.Extends(t, v1)
return t