-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WeeklyRaffleService.LocalRaffleStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.SimpleSignal)
local CommonRaffleStore = require(ReplicatedStorage.Common.WeeklyRaffleService.CommonRaffleStore)
return setmetatable({}, CommonRaffleStore)