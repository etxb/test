-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.ConditionUtils

-- https://lua.expert/
local Builder = require(script.Builder)
return {
	builder = function() --[[ builder | Line: 6 | Upvalues: Builder (copy) ]]
		return Builder.new()
	end,
	status = function(p1, p2) --[[ status | Line: 10 ]]
		return {
			ConditionType = "Status",
			Condition = {
				Status = p1,
				Value = p2
			}
		}
	end,
	weapon = function(p1, p2) --[[ weapon | Line: 14 ]]
		return {
			ConditionType = "Weapon",
			Condition = {
				Weapon = p1,
				Count = p2
			}
		}
	end,
	unownWeapon = function(p1, p2) --[[ unownWeapon | Line: 18 ]]
		return {
			ConditionType = "Weapon",
			Not = true,
			Condition = {
				Weapon = p1,
				Count = p2
			}
		}
	end,
	all = function(...) --[[ all | Line: 22 ]]
		return {
			ConditionType = "All",
			Condition = { ... }
		}
	end,
	any = function(...) --[[ any | Line: 26 ]]
		return {
			ConditionType = "Any",
			Condition = { ... }
		}
	end
}