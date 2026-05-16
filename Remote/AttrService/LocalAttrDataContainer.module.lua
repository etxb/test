-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.AttrService.LocalAttrDataContainer

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Util.GameUtils)
require(ReplicatedStorage.Shared.SimpleSignal)
local AttrDataContainer = require(ReplicatedStorage.Common.AttrService.AttrDataContainer)
local v1 = setmetatable({}, AttrDataContainer)
v1.__index = v1
function v1.LoadAttr(p1, p2) --[[ LoadAttr | Line: 14 ]]
	for v1, v2 in p2 do
		for v3, v4 in v2 do
			local v5 = v4.Value
			if v5 == 0 or not v5 then
				v5 = nil
			end
			p1:SetAttr(v1, v3, v5, if v5 then v4.Timeout and {
	Timeout = v4.Timeout
} else v5)
		end
	end
end
return v1:new()