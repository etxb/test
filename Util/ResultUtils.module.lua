-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.ResultUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local t = {
	success = function(p1, p2) --[[ success | Line: 23 ]]
		return {
			Success = true,
			Message = p1,
			Data = p2
		}
	end,
	failed = function(p1, p2) --[[ failed | Line: 27 ]]
		return {
			Failed = true,
			Message = p1,
			Data = p2
		}
	end,
	error = function(p1) --[[ error | Line: 31 | Upvalues: Constant (copy) ]]
		return {
			Error = true,
			Message = Constant.Message.Common.Error,
			Data = p1
		}
	end,
	networkError = function() --[[ networkError | Line: 35 | Upvalues: Constant (copy) ]]
		return {
			Error = true,
			Message = Constant.Message.Common.NetworkError
		}
	end
}
function t.ecoNotEnough(p1, p2) --[[ ecoNotEnough | Line: 39 | Upvalues: t (copy), Constant (copy) ]]
	return t.failed(Constant.Message.Eco.NotEnough[p1] or Constant.Message.Eco.NotEnough._Default:format(p1 or "#unknown"), {
		EcoNotEnough = {
			Eco = p1,
			Value = p2
		}
	})
end
function t.coinNotEnough(p1) --[[ coinNotEnough | Line: 43 | Upvalues: t (copy), Constant (copy) ]]
	return t.ecoNotEnough(Constant.Status.Eco_Coin, p1)
end
return t