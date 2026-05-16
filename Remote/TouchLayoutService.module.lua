-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.TouchLayoutService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Base64 = require(ReplicatedStorage.Shared.Base64)
local v1 = require(ReplicatedStorage.Common.TouchLayoutService)
local t = {
	DataInited = SimpleSignal.new(),
	DataUpdated = SimpleSignal.new(),
	LayoutSelectChanged = SimpleSignal.new(),
	LayoutChanged = SimpleSignal.new()
}
local v2 = nil
local v3 = setmetatable({
	Inited = false,
	Event = t
}, v1)
function v3.WaitInit() --[[ WaitInit | Line: 28 | Upvalues: v3 (copy), t (copy) ]]
	if not v3.Inited then
		t.DataInited:Wait()
	end
	return v3
end
function v3.OnInit(p1) --[[ OnInit | Line: 35 | Upvalues: v3 (copy), t (copy) ]]
	if v3.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function v3.LoadDefault(p1) --[[ LoadDefault | Line: 43 | Upvalues: v2 (ref), v1 (copy), v3 (copy) ]]
	if not v2.Selected[p1] then
		local v12 = v1.SelectorDefault[p1]
		if v12 then
			v3.SelectLayout(p1, v12, true)
		end
	end
end
function v3.SelectLayout(p1, p2, p3) --[[ SelectLayout | Line: 55 | Upvalues: v1 (copy), v3 (copy), RunService (copy), v2 (ref), t (copy) ]]
	if v1.IsValidSelector(p1) and v1.IsValidLayoutName(p2) then
		if p2 == v3.GetSelectedLayoutName(p1) and not p3 then
			if RunService:IsStudio() then
				warn("duplicated", { debug.traceback() })
			end
		else
			v2.Selected[p1] = p2
			script.SelectLayout:FireServer(p1, p2)
			if not p3 then
				t.LayoutSelectChanged:Fire(p1)
			end
			return true
		end
	end
end
function v3.GetSelectedLayoutName(p1) --[[ GetSelectedLayoutName | Line: 78 | Upvalues: v2 (ref), v1 (copy) ]]
	return v2.Selected[p1] or v1.SelectorDefault[p1]
end
function v3.GetSelectedLayout(p1) --[[ GetSelectedLayout | Line: 82 | Upvalues: v3 (copy) ]]
	return v3.GetLayout(v3.GetSelectedLayoutName(p1))
end
local t2 = {}
function v3.GetLayout(p1) --[[ GetLayout | Line: 88 | Upvalues: v2 (ref), v1 (copy), t2 (copy) ]]
	local v12 = v2.Layout[p1]
	if not v12 then
		v12 = {}
		v2.Layout[p1] = v12
	end
	if typeof(v12) == "buffer" then
		local v22 = v1.Deserialize(v12)
		v2.Layout[p1] = v22
		v12 = v22
	end
	if not t2[p1] then
		t2[p1] = true
		local t = {}
		for v3, v4 in v12 do
			local v5 = v1.LayoutableUiLiteral.literals[tonumber(v3)]
			if v5 and typeof(v4) == "buffer" then
				local v6 = v1.DeserializePosAndSize(v4)
				t[v5] = {
					Pos = Vector2.new(v6.X, v6.Y),
					Size = Vector2.new(v6.W, v6.H)
				}
			end
		end
		v2.Layout[p1] = t
		v12 = t
	end
	return v12
end
function v3.SetLayout(p1, p2, p3, p4) --[[ SetLayout | Line: 117 | Upvalues: v3 (copy), t (copy) ]]
	local v1 = v3.GetLayout(p1)
	if v1 then
		v1[p2] = {
			Pos = p3,
			Size = p4
		}
		script.SetLayout:FireServer(p1, {
			[p2] = { p3, p4 }
		})
		t.LayoutChanged:Fire(p1, {
			Ui = p2
		})
	end
end
function v3.ClearLayout(p1) --[[ ClearLayout | Line: 143 | Upvalues: v2 (ref), t (copy) ]]
	script.SetLayout:FireServer(p1)
	v2.Layout[p1] = nil
	t.LayoutChanged:Fire(p1, {
		Reload = true
	})
end
function v3.Export(p1) --[[ Export | Line: 149 | Upvalues: v3 (copy), v1 (copy), Base64 (copy) ]]
	local t = {}
	for v12, v2 in v3.GetLayout(p1) do
		t[v12] = {
			X = v2.Pos.X,
			Y = v2.Pos.Y,
			W = v2.Size.X,
			H = v2.Size.Y
		}
	end
	return Base64.encode(buffer.tostring((v1.SerializeLayout(t))))
end
function v3.Import(p1, p2) --[[ Import | Line: 163 | Upvalues: v1 (copy), Base64 (copy), v2 (ref), t (copy) ]]
	local t2 = {}
	for v12, v22 in v1.DeserializeLayout(buffer.fromstring(Base64.decode(p2))) do
		t2[v12] = {
			Pos = Vector2.new(v22.X, v22.Y),
			Size = Vector2.new(v22.W, v22.Y)
		}
	end
	v2.Layout[p1] = t2
	local t3 = {}
	for v3, v4 in t2 do
		t3[v3] = { v4.Pos, v4.Size }
	end
	script.SetLayout:FireServer(p1, t3)
	t.LayoutChanged:Fire(p1, {
		Reload = true
	})
end
function v3.Start() --[[ Start | Line: 184 | Upvalues: v2 (ref), v3 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 185 | Upvalues: v2 (ref), v3 (ref), t (ref) ]]
		if p2 then
			v2 = p1
			v3.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return v3