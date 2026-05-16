-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.GameConfig.TDM.TDM_CaptureFlag

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local t = {
	Game = {
		GameTime = 420,
		Round = 1,
		RoundEndTime = 3,
		WinPoint = 3,
		MaxClients = 16,
		MaxBots = 9
	},
	Respawn = {
		Time = 3,
		FastTime = 2
	}
}
TableUtils.Extends(t, (require(script.Parent)))
return t