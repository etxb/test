-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RankedService.LocalRankedStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonRankedStore = require(ReplicatedStorage.Common.RankedService.CommonRankedStore)
local v1 = setmetatable({}, CommonRankedStore)
v1.__index = v1
return v1