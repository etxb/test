-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.StatsService.LocalStatsStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonStatsStore = require(ReplicatedStorage.Common.StatsService.CommonStatsStore)
return setmetatable({}, CommonStatsStore)