-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.GameConfig.Lobby

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local t = {
	Game = {
		RoundStartTime = 0
	},
	GameProp = {
		RefreshTime = {
			Charger = 3,
			Medkit = 3
		}
	},
	Respawn = {
		Time = 3
	}
}
TableUtils.Extends(t, (require(script.Parent)))
return t