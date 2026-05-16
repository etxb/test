-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.Any

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.WeaponConfig)
require(ReplicatedStorage.Config.GachaConfig)
require(ReplicatedStorage.Util.RewardUtils)
local t = {
	VIP = {
		Reward = {
			RewardType = "Permission",
			Reward = {
				Permission = Constant.Permission.VIP
			}
		},
		Condition = {
			ConditionType = "Permission",
			Not = true,
			Condition = {
				Permission = Constant.Permission.VIP
			}
		},
		Price = {
			Eco = Constant.Robux
		}
	},
	StarterPack = {
		Reward = (function() --[[ Line: 42 | Upvalues: Constant (copy) ]]
			return {
				RewardType = "All",
				Reward = {
					{
						RewardType = "Weapon",
						Reward = {
							Untradeable = true,
							RandomMelee = true
						}
					},
					{
						RewardType = "Status",
						Reward = {
							SetValue = -1,
							Status = Constant.Status.StarterPackTime
						}
					}
				}
			}
		end)(),
		Condition = {
			ConditionType = "Status",
			Condition = {
				Mode = ">",
				Value = 0,
				Status = Constant.Status.StarterPackTime
			}
		},
		Price = {
			Eco = Constant.Robux
		}
	},
	SniperMergePack = {
		Display = "Full Sniper Bundle",
		Reward = {
			RewardType = "Status",
			Reward = {
				Value = 1,
				HideValue = true,
				Status = Constant.Status.SniperMergePack
			}
		},
		Condition = {
			ConditionType = "Status",
			Condition = {
				Mode = "=",
				Value = 0,
				Status = Constant.Status.SniperMergePack
			}
		},
		Price = {
			Eco = Constant.Robux
		}
	},
	SniperMergePack_TradeToken = {
		Display = "Full Sniper Bundle",
		Reward = {
			RewardType = "Status",
			Reward = {
				Value = 1,
				HideValue = true,
				Status = Constant.Status.SniperMergePack
			}
		},
		Condition = {
			ConditionType = "Status",
			Condition = {
				Mode = "=",
				Value = 0,
				Status = Constant.Status.SniperMergePack
			}
		},
		Price = {
			Value = 9990,
			Eco = Constant.Status.Eco_TradeToken
		}
	},
	MeleeMergePack = {
		Display = "Full Knife Bundle",
		Reward = {
			RewardType = "Status",
			Reward = {
				Value = 1,
				HideValue = true,
				Status = Constant.Status.MeleeMergePack
			}
		},
		Condition = {
			ConditionType = "Status",
			Condition = {
				Mode = "=",
				Value = 0,
				Status = Constant.Status.MeleeMergePack
			}
		},
		Price = {
			Eco = Constant.Robux
		}
	},
	MeleeMergePack_TradeToken = {
		Display = "Full Knife Bundle",
		Reward = {
			RewardType = "Status",
			Reward = {
				Value = 1,
				HideValue = true,
				Status = Constant.Status.MeleeMergePack
			}
		},
		Condition = {
			ConditionType = "Status",
			Condition = {
				Mode = "=",
				Value = 0,
				Status = Constant.Status.MeleeMergePack
			}
		},
		Price = {
			Value = 24990,
			Eco = Constant.Status.Eco_TradeToken
		}
	},
	RestoreWinning = {
		Reward = {
			RewardType = "RestoreWinning"
		},
		Price = {
			Value = 500,
			Eco = Constant.Status.Eco_Coin
		}
	}
}
local FreeKukriEvent = ReplicatedStorage.Config.Event:FindFirstChild("FreeKukriEvent")
if FreeKukriEvent then
	require(FreeKukriEvent)
	t.SkipFreeKukri = {
		Reward = {
			RewardType = "SkipFreeKukri"
		},
		Price = {
			Eco = Constant.Robux
		}
	}
end
return t