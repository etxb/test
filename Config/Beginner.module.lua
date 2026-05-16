-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Config.Beginner

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
return {
	ToBeginnerServer = {
		ConditionType = "All",
		Not = true,
		Condition = {
			{
				ConditionType = "Status",
				Condition = {
					Value = 50,
					Status = Constant.Status.Killed
				}
			},
			{
				ConditionType = "Status",
				Condition = {
					Value = 2,
					Status = Constant.Status.GamePlayed
				}
			}
		}
	}
}