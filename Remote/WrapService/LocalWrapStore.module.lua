-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WrapService.LocalWrapStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonWrapStore = require(ReplicatedStorage.Common.WrapService.CommonWrapStore)
local v1 = setmetatable({}, CommonWrapStore)
v1.__index = v1
return v1