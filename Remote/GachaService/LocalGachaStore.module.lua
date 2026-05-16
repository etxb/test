-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GachaService.LocalGachaStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonGachaStore = require(ReplicatedStorage.Common.GachaService.CommonGachaStore)
return setmetatable({}, CommonGachaStore)