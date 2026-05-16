-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GuiUtils.TipHolder

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Util.TableUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 10 | Upvalues: SimpleSignal (copy) ]]
	return setmetatable({
		HasTip = false,
		Changed = SimpleSignal.new(),
		Values = {},
		Children = {}
	}, p1)
end
function t.Set(p1, p2, p3) --[[ Set | Line: 20 ]]
	local v1 = if next(p1.Values) then true else false
	p1.Values[p2] = p3 or nil
	local v2 = if next(p1.Values) then true else false
	if v2 ~= v1 then
		p1.HasTip = v2
		p1.Changed:Fire()
	end
end
function t.AddChild(p1, p2) --[[ AddChild | Line: 31 ]]
	if not p1.Children[p2] then
		p1.Children[p2] = p2.Changed:Connect(function() --[[ Line: 35 | Upvalues: p1 (copy), p2 (copy) ]]
			p1:Set(p2, p2.HasTip)
		end)
		p1:Set(p2, p2.HasTip)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 41 ]]
	for v1, v2 in p1.Children do
		v2:Disconnect()
	end
	p1.Children = nil
	p1.Changed:Destroy()
end
return t