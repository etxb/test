-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.ABTest

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Remote.Server)
require(ReplicatedStorage.Remote.StatusService)
local PlayerConfigService = require(ReplicatedStorage.Remote.PlayerConfigService)
local t = {
	UseNewPlayStyle = function() --[[ UseNewPlayStyle | Line: 13 ]] end,
	UseGamemodeLimit = function() --[[ UseGamemodeLimit | Line: 17 | Upvalues: PlayerConfigService (copy) ]]
		return PlayerConfigService.WaitValue("GamemodeLimit")
	end,
	UseNewMobileLayout = function() --[[ UseNewMobileLayout | Line: 21 ]] end,
	GetAssistMode = function() --[[ GetAssistMode | Line: 25 ]]
		return 2
	end,
	CanAutoShoot = function() --[[ CanAutoShoot | Line: 30 ]]
		return false
	end
}
function t.IsNewAssist() --[[ IsNewAssist | Line: 35 | Upvalues: t (copy) ]]
	return t.GetAssistMode() <= 2
end
function t.GetAssistStrength() --[[ GetAssistStrength | Line: 39 | Upvalues: t (copy) ]]
	if t.GetAssistMode() == 1 then
		return 1
	else
		return 2
	end
end
function t.GetCameraSpeedOffset() --[[ GetCameraSpeedOffset | Line: 43 | Upvalues: t (copy) ]]
	if t.GetAssistMode() == 3 then
		return 0
	else
		return 20
	end
end
function t.GetSlideAdjust() --[[ GetSlideAdjust | Line: 47 | Upvalues: PlayerConfigService (copy) ]]
	return PlayerConfigService.LazyGet("SlideAdjust")
end
return t