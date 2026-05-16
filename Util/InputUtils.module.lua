-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.InputUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local v1 = TableUtils.Bid({
	Enum.KeyCode.ButtonX,
	Enum.KeyCode.ButtonY,
	Enum.KeyCode.ButtonA,
	Enum.KeyCode.ButtonB,
	Enum.KeyCode.ButtonL1,
	Enum.KeyCode.ButtonL2,
	Enum.KeyCode.ButtonL3,
	Enum.KeyCode.ButtonR1,
	Enum.KeyCode.ButtonR2,
	Enum.KeyCode.ButtonR3,
	Enum.KeyCode.DPadLeft,
	Enum.KeyCode.DPadRight,
	Enum.KeyCode.DPadUp,
	Enum.KeyCode.DPadDown
})
local t = {
	[Enum.KeyCode.LeftControl] = "L Ctrl",
	[Enum.KeyCode.LeftShift] = "L Shift",
	[Enum.KeyCode.LeftAlt] = "L Alt",
	[Enum.KeyCode.RightControl] = "R Ctrl",
	[Enum.KeyCode.RightShift] = "R Shift",
	[Enum.KeyCode.RightAlt] = "R Alt",
	[Enum.KeyCode.Backspace] = "Back",
	[Enum.KeyCode.Return] = "Enter",
	[Enum.KeyCode.Delete] = "Del",
	[Enum.KeyCode.KeypadEnter] = "Enter",
	[Enum.KeyCode.KeypadEquals] = "=",
	[Enum.KeyCode.PageUp] = "PgUp",
	[Enum.KeyCode.PageDown] = "PgDown"
}
local function simple(p1, p2) --[[ simple | Line: 41 | Upvalues: RunService (copy), t (copy) ]]
	pcall(function() --[[ Line: 42 | Upvalues: p1 (copy), RunService (ref), p2 (copy), t (ref) ]]
		local v1 = Enum.KeyCode:FromValue(p1)
		if v1 then
			t[v1] = p2
		elseif RunService:IsStudio() then
			print("unknown keycode", p1, p2)
		end
	end)
end
for v2, v3 in { string.byte("\"#$%&\'()*+,-./0123456789:;<=>?@", 1, -1) } do
	local v4 = 33 + v2
	local v5 = string.char(v3)
	pcall(function() --[[ Line: 42 | Upvalues: v4 (copy), RunService (copy), v5 (copy), t (copy) ]]
		local v1 = Enum.KeyCode:FromValue(v4)
		if v1 then
			t[v1] = v5
		elseif RunService:IsStudio() then
			print("unknown keycode", v4, v5)
		end
	end)
end
for v6, v7 in { 91 } do
	local v8 = 90 + v6
	local v9 = string.char(v7)
	pcall(function() --[[ Line: 42 | Upvalues: v8 (copy), RunService (copy), v9 (copy), t (copy) ]]
		local v1 = Enum.KeyCode:FromValue(v8)
		if v1 then
			t[v1] = v9
		elseif RunService:IsStudio() then
			print("unknown keycode", v8, v9)
		end
	end)
end
for v10, v11 in { string.byte("0123456789./*-+", 1, -1) } do
	local v12 = 255 + v10
	local v13 = string.char(v11)
	pcall(function() --[[ Line: 42 | Upvalues: v12 (copy), RunService (copy), v13 (copy), t (copy) ]]
		local v1 = Enum.KeyCode:FromValue(v12)
		if v1 then
			t[v1] = v13
		elseif RunService:IsStudio() then
			print("unknown keycode", v12, v13)
		end
	end)
end
return TableUtils.Protect({
	GetKeyName = function(p1) --[[ GetKeyName | Line: 65 | Upvalues: t (copy), UserInputService (copy) ]]
		local v1 = t[p1] or UserInputService:GetStringForKeyCode(p1)
		if not v1 or (#v1 == 0 or v1 == " ") then
			v1 = p1.Name
		end
		return v1
	end,
	IsGamepadKey = function(p1) --[[ IsGamepadKey | Line: 73 | Upvalues: v1 (copy) ]]
		return v1[p1] and true
	end
})