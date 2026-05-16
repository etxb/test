-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.RoleService.LocalWrapCache

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonWrapCache = require(ReplicatedStorage.Common.RoleService.CommonWrapCache)
local v1 = setmetatable({}, CommonWrapCache)
v1.__index = v1
v1.Owned = {}
v1.Unowned = {}
v1.Locked = {}
return v1