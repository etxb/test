-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.BattlepassService.LocalBattlepassStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonBattlepassStore = require(ReplicatedStorage.Common.BattlepassService.CommonBattlepassStore)
return setmetatable({}, CommonBattlepassStore)