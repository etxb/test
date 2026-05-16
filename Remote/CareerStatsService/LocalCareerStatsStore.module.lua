-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.CareerStatsService.LocalCareerStatsStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.SimpleSignal)
local CommonCareerStatsStore = require(ReplicatedStorage.Common.CareerStatsService.CommonCareerStatsStore)
return setmetatable({}, CommonCareerStatsStore)