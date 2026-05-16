-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Event.NewWeapon2Event

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local t = {
	Weapon = "NTW20",
	Timeout = DateTime.fromUniversalTime(2026, 5, 11).UnixTimestamp,
	Product = Constant.Product.NewWeapon2Event_Skip,
	Quest2Spent = {
		Coin = 60000,
		TradeToken = 10000
	},
	Quest3Spent = {
		Robux = 1999
	}
}
t.Quest = ("NewWeapon_%s"):format(t.Weapon)
t.Quest2 = ("NewWeapon_%s_2"):format(t.Weapon)
t.Quest3 = ("NewWeapon_%s_3"):format(t.Weapon)
t.Quests = { t.Quest, t.Quest2, t.Quest3 }
return t