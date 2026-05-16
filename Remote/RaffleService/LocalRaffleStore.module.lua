-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RaffleService.LocalRaffleStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.SimpleSignal)
local CommonRaffleStore = require(ReplicatedStorage.Common.RaffleService.CommonRaffleStore)
return setmetatable({}, CommonRaffleStore)