-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameClient.LocalGameClient

-- https://lua.expert/
local LocalPlayer = game:GetService("Players").LocalPlayer
local v2 = setmetatable({}, (require(script.Parent)))
v2.__index = v2
function v2.__tostring(p1) --[[ Line: 11 ]]
	return "LocalGameClient"
end
return v2:new(LocalPlayer)