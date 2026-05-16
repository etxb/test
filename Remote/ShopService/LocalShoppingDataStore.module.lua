-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.ShopService.LocalShoppingDataStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommonShoppingDataStore = require(ReplicatedStorage.Common.ShopService.CommonShoppingDataStore)
local v1 = setmetatable({}, CommonShoppingDataStore)
v1.__index = v1
return v1