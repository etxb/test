-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GuiUtils

-- https://lua.expert/
game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
require(ReplicatedStorage.Util.InstanceUtils)
require(ReplicatedStorage.Util.TableUtils)
local TipHolder = require(script.TipHolder)
local t = {}
local function defaultVisibleUpdater(p1, p2) --[[ defaultVisibleUpdater | Line: 19 ]]
	p1.Frame.Visible = p2 and true or false
end
function t.SetupTabLayout(p1, p2, p3, p4) --[[ SetupTabLayout | Line: 23 | Upvalues: defaultVisibleUpdater (copy), TipHolder (copy) ]]
	local v2 = p3 or {}
	local t = {}
	local v3 = nil
	local t2 = {}
	local v4 = v2.VisibleUpdater or defaultVisibleUpdater
	function t.Open(p1, ...) --[[ Open | Line: 44 | Upvalues: t2 (copy), v3 (ref), v4 (copy), v2 (ref), p4 (copy) ]]
		local v1 = t2[p1] or v3
		if v1 then
			if v1 ~= v3 then
				if v1.Module and (v1.Module.CanOpen and not v1.Module.CanOpen(...)) then
					return
				end
				if v3 then
					v4(v3, false)
					if v2.OnTabUnSelected then
						v2.OnTabUnSelected(v3)
					end
					local Module = v3.Module
					if Module and Module.OnClose then
						if Module.__index then
							Module:OnClose()
						else
							Module.OnClose()
						end
					end
				end
				v3 = v1
			end
			v4(v1, true)
			if v2.OnTabSelected then
				v2.OnTabSelected(v1, ...)
			end
			local Module = v1.Module
			local v22
			if Module and Module.OnOpen then
				if p4 then
					print("invoke tab onopen", Module)
				end
				if Module.__index then
					if p4 then
						print("__index")
					end
					v22 = Module:OnOpen(...)
				else
					v22 = Module.OnOpen(...)
				end
			else
				v22 = nil
			end
			if v2.OnOpen then
				v2.OnOpen()
			end
			return v22
		end
	end
	function t.Close() --[[ Close | Line: 94 | Upvalues: v3 (ref), v2 (ref) ]]
		if v3 and (v3.Module and v3.Module.OnClose) then
			v3.Module.OnClose()
		end
		if v2.OnClose then
			v2.OnClose()
		end
	end
	function t.GetCurrent() --[[ GetCurrent | Line: 103 | Upvalues: v3 (ref) ]]
		return v3 and v3.Name
	end
	function t.GetCurrentTab() --[[ GetCurrentTab | Line: 107 | Upvalues: v3 (ref) ]]
		return v3 and v3.Tab
	end
	function t.GetCurrentTabFrame() --[[ GetCurrentTabFrame | Line: 111 | Upvalues: v3 (ref) ]]
		return v3 and v3.Frame
	end
	function t.GetModule(p1) --[[ GetModule | Line: 115 | Upvalues: t2 (copy) ]]
		return t2[p1] and t2[p1].Module
	end
	for v5, v6 in p2 do
		if v6:IsA("GuiObject") and (not v2.TabFrameFilter or v2.TabFrameFilter(v6)) then
			local t3 = {
				Name = v6.Name,
				Frame = v6
			}
			if p4 then
				print("load tab", t3.Name)
			end
			local v7, v8 = xpcall(function() --[[ Line: 125 | Upvalues: v6 (copy), t3 (copy), t (copy) ]]
				if v6:FindFirstChild("ModuleScript") then
					t3.Module = require(v6.ModuleScript)
					t3.Module.ParentLayout = t
					t3.Module.Tab = t3
				end
			end, function(p1) --[[ Line: 131 ]]
				return p1 .. "\n" .. debug.traceback()
			end)
			if v7 then
				t3.TipHolder = TipHolder:new()
				if v2.OnTipChanged then
					t3.TipHolder.Changed:Connect(function() --[[ Line: 141 | Upvalues: v2 (ref), t3 (copy) ]]
						v2.OnTipChanged(t3)
					end)
				end
				t2[v6.Name] = t3
				local _ = v6.Visible
				if v6:FindFirstChild("Close") and v6.Close:IsA("GuiButton") then
					v6.Close.Activated:Connect(t.Close)
				end
				continue
			end
			warn("ui module load failed", v6.Name, v8)
		end
	end
	if p4 then
		print("tab layout load completed")
	end
	for v9, v10 in p1 do
		local v11 = v10
		if not v11:IsA("GuiButton") then
			v11 = v11:FindFirstChild("ImageButton") or v11:FindFirstChild("Inner")
		end
		if v11 and (v11:IsA("GuiButton") and (t2[v10.Name] and (not v2.TabFilter or v2.TabFilter(v10)))) then
			t2[v10.Name].Tab = v10
			v11.Activated:Connect(function() --[[ Line: 165 | Upvalues: v2 (ref), v10 (copy), t (copy) ]]
				if v2.OnTabActivated then
					v2.OnTabActivated(v10.Name)
				else
					t.Open(v10.Name)
				end
			end)
		end
	end
	t.Tabs = t2
	for v13, v14 in t2 do
		if v14.Module and v14.Module.OnLoad then
			v14.Module.OnLoad()
		end
	end
	return t
end
function t.GetRowCapacity(p1, p2) --[[ GetRowCapacity | Line: 186 ]]
	local X = p1.AbsoluteSize.X
	local UIPadding = p1:FindFirstChildOfClass("UIPadding")
	if UIPadding then
		local PaddingLeft = UIPadding.PaddingLeft
		local PaddingRight = UIPadding.PaddingRight
		X = X - ((PaddingLeft.Scale + PaddingRight.Scale) * X + PaddingLeft.Offset + PaddingRight.Offset)
	end
	local v1 = math.floor(X)
	local UIListLayout = p1:FindFirstChildOfClass("UIListLayout")
	return math.max(math.floor(v1 / math.floor(p2.AbsoluteSize.X + if UIListLayout then v1 * UIListLayout.Padding.Scale + UIListLayout.Padding.Offset else 0)), 1)
end
function t.GetColumnCapactiy(p1, p2) --[[ GetColumnCapactiy | Line: 206 ]]
	local Y = p1.AbsoluteSize.Y
	local UIPadding = p1:FindFirstChildOfClass("UIPadding")
	if UIPadding then
		local PaddingTop = UIPadding.PaddingTop
		local PaddingBottom = UIPadding.PaddingBottom
		Y = Y - ((PaddingTop.Scale + PaddingBottom.Scale) * Y + PaddingTop.Offset + PaddingBottom.Offset)
	end
	local UIListLayout = p1:FindFirstChildOfClass("UIListLayout")
	return math.max(math.floor(Y / (Y * p2.Size.Y.Scale + p2.Size.Y.Offset + if UIListLayout then Y * UIListLayout.Padding.Scale + UIListLayout.Padding.Offset else 0)), 1)
end
local VisibleDetector = require(script.VisibleDetector)
t.VisibleDetector = VisibleDetector
t.SetupVisibleDetector = VisibleDetector.SetupVisibleDetector
t.UIRecycler = require(script.UIRecycler)
function t.UpdateScrollingCanvasSize(p1, p2, p3, p4, p5, p6) --[[ UpdateScrollingCanvasSize | Line: 269 | Upvalues: t (copy) ]]
	local v1 = p5 or p1
	local UIListLayout = v1:FindFirstChildOfClass("UIListLayout")
	if UIListLayout and (p2.Parent and v1.Parent) then
		local v2 = p6 and p6.ExtraSize or 0
		if p1.AutomaticCanvasSize == Enum.AutomaticSize.X then
			local v5 = math.max(math.floor(v1.AbsoluteSize.Y / p2.AbsoluteSize.Y), 1)
			if UIListLayout.VerticalFlex == Enum.UIFlexAlignment.Fill then
				v5 = t.GetColumnCapactiy(v1, p2)
			end
			local v7 = math.ceil(p3 / v5) + (p4 or 0)
			p1.CanvasSize = UDim2.fromScale(v7 / (v1.AbsoluteSize.X / p2.AbsoluteSize.X) + (v7 - 1) * UIListLayout.Padding.Scale + v2, 0) + UDim2.fromOffset((v7 - 1) * UIListLayout.Padding.Offset, 0)
		elseif p1.AutomaticCanvasSize == Enum.AutomaticSize.Y then
			local v11 = math.max(math.floor(v1.AbsoluteSize.X / p2.AbsoluteSize.X), 1)
			if UIListLayout.HorizontalFlex == Enum.UIFlexAlignment.Fill then
				v11 = t.GetRowCapacity(v1, p2)
			end
			local v13 = math.ceil(p3 / v11) + (p4 or 0)
			p1.CanvasSize = UDim2.fromScale(0, v13 / (v1.AbsoluteSize.Y / p2.AbsoluteSize.Y) + (v13 - 1) * UIListLayout.Padding.Scale + v2) + UDim2.fromOffset(0, (v13 - 1) * UIListLayout.Padding.Offset)
		end
	end
end
local CurrentCamera = workspace.CurrentCamera
function t.GetScale() --[[ GetScale | Line: 306 | Upvalues: CurrentCamera (copy) ]]
	return math.min(CurrentCamera.ViewportSize.X / 1920, CurrentCamera.ViewportSize.Y / 1080)
end
function t.OnScaleChanged(p1) --[[ OnScaleChanged | Line: 310 | Upvalues: t (copy), CurrentCamera (copy) ]]
	task.spawn(p1, t.GetScale())
	return CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 312 | Upvalues: p1 (copy), t (ref) ]]
		p1(t.GetScale())
	end)
end
function t.PosInGuiObject(p1, p2) --[[ PosInGuiObject | Line: 317 ]]
	local AbsolutePosition = p2.AbsolutePosition
	if p1.X < AbsolutePosition.X or p1.Y < AbsolutePosition.Y then
	else
		local v1 = AbsolutePosition + p2.AbsoluteSize
		return if p1.X < v1.X then p1.Y < v1.Y else false
	end
end
function t.SetTextAndSize(p1, p2, p3, p4, p5, p6, p7, p8) --[[ SetTextAndSize | Line: 332 | Upvalues: TextService (copy) ]]
	local v1 = TextService:GetTextSize(p2, p3, p4, Vector2.new(1000, p3)).X / p5 * p6
	if p7 then
		v1 = math.max(v1, p7)
	end
	if p8 then
		v1 = math.min(v1, p8)
	end
	p1.Size = UDim2.fromScale(v1, p1.Size.Y.Scale)
	p1.Text = p2
	return v1
end
if RunService:IsServer() then
	warn(debug.traceback("\230\156\141\229\138\161\231\171\175\229\188\149\231\148\168\228\186\134 GuiUtils", 2))
end
return t