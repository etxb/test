-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GuiUtils.UIRecycler

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Util.TableUtils)
local Pool = require(ReplicatedStorage.Util.Pool)
local VisibleDetector = require(script.Parent.VisibleDetector)
local t = {
	Container = nil,
	SlotTemplate = nil,
	SlotAspectRatio = nil,
	ItemCount = 0,
	Changed = false,
	SlotMargin = UDim.new()
}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 30 | Upvalues: Pool (copy), VisibleDetector (copy) ]]
	local v1 = setmetatable({
		Container = p2,
		SlotTemplate = p3,
		SlotPool = Pool.byInstance(p3),
		Slots = {},
		SlotsByGuiObject = {},
		VisibleDetector = VisibleDetector.SetupVisibleDetector(p2)
	}, p1)
	p3.Parent = nil
	local function setChanged() --[[ setChanged | Line: 53 | Upvalues: v1 (copy) ]]
		if not v1.Updating then
			v1.Changed = true
		end
	end
	local function setSizeChanged() --[[ setSizeChanged | Line: 59 | Upvalues: v1 (copy) ]]
		if not v1.Updating then
			v1.Changed = true
			v1.SizeChanged = true
		end
	end
	p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(setSizeChanged)
	p2:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(setSizeChanged)
	p2:GetPropertyChangedSignal("CanvasPosition"):Connect(setChanged)
	local UIAspectRatioConstraint = p3:FindFirstChildOfClass("UIAspectRatioConstraint")
	if UIAspectRatioConstraint then
		v1:SetSlotAspectRatio(UIAspectRatioConstraint.AspectRatio)
	end
	return v1
end
function t.setChanged(p1) --[[ setChanged | Line: 78 ]]
	if not p1.Updating then
		p1.Changed = true
	end
end
function t.setSizeChanged(p1) --[[ setSizeChanged | Line: 84 ]]
	if not p1.Updating then
		p1.Changed = true
		p1.SizeChanged = true
	end
end
function t.SetSlotMargin(p1, p2) --[[ SetSlotMargin | Line: 91 ]]
	p1.SlotMargin = if p2 then p2 else UDim.new()
	p1:setSizeChanged()
end
function t.SetSlotAspectRatio(p1, p2) --[[ SetSlotAspectRatio | Line: 96 ]]
	if p2 == 0 then
		p2 = nil
	end
	p1.SlotAspectRatio = p2
	p1:setSizeChanged()
end
function t.SetContainerPadding(p1, p2) --[[ SetContainerPadding | Line: 108 ]]
	p1.ContainerPadding = p2
	p1:setSizeChanged()
end
function t.LoadRender(p1) --[[ LoadRender | Line: 113 ]]
	p1.Loaded = true
	p1.Changed = true
	p1.VisibleDetector:SetRender(function(p12) --[[ Line: 116 | Upvalues: p1 (copy) ]]
		if p1.Changed then
			p1:Update()
		end
	end)
end
local function safeNumber(p1) --[[ safeNumber | Line: 123 ]]
	if p1 ~= p1 then
		p1 = 0
	end
	return p1
end
function t.GetContainerPadding(p1, p2) --[[ GetContainerPadding | Line: 130 ]]
	local v1 = Vector2.new(p1.Container.AbsoluteCanvasSize.X, p1.Container.AbsoluteSize.Y)
	local t = {
		Top = 0,
		Bottom = 0,
		Left = 0,
		Right = 0
	}
	if p1.ContainerPadding then
		t.Top = t.Top + (v1.Y * p1.ContainerPadding.PaddingTop.Scale + p1.ContainerPadding.PaddingTop.Offset)
		t.Bottom = t.Bottom + (v1.Y * p1.ContainerPadding.PaddingBottom.Scale + p1.ContainerPadding.PaddingBottom.Offset)
		t.Left = t.Left + (v1.X * p1.ContainerPadding.PaddingLeft.Scale + p1.ContainerPadding.PaddingLeft.Offset)
		t.Right = t.Right + (v1.X * p1.ContainerPadding.PaddingRight.Scale + p1.ContainerPadding.PaddingRight.Offset)
	end
	if p2 then
		p2.ContainerPadding = t
	end
	return t
end
function t.GetContainerSize(p1, p2) --[[ GetContainerSize | Line: 148 ]]
	local v1 = Vector2.new(p1.Container.AbsoluteCanvasSize.X, p1.Container.AbsoluteSize.Y)
	local v2, v4
	if p2 then
		local v3
		v2 = p2.ContainerPadding
		if v2 then
			v3 = v1
		end
		v4 = v3 - Vector2.new(v2.Left + v2.Right, v2.Top + v2.Bottom)
		if p2 then
			p2.ContainerSize = v4
		end
		return v4
	end
	v2 = p1:GetContainerPadding(p2)
	v4 = v1 - Vector2.new(v2.Left + v2.Right, v2.Top + v2.Bottom)
	if p2 then
		p2.ContainerSize = v4
	end
	return v4
end
local function getSize(p1, p2, p3) --[[ getSize | Line: 165 ]]
	local v1 = Vector2.new(p1.X * p2.X.Scale + p2.X.Offset, p1.Y * p2.Y.Scale + p2.Y.Offset)
	if p3 then
		local v2 = Vector2.new(v1.X, v1.X / p3)
		local v3 = Vector2.new(v1.Y * p3, v1.Y)
		if v3.X < v2.X then
			return v3
		end
		v1 = v2
	end
	return v1
end
function t.GetSlotSize(p1, p2) --[[ GetSlotSize | Line: 194 | Upvalues: getSize (copy) ]]
	local v2 = getSize(p2 and p2.ContainerSize or p1:GetContainerSize(p2), p1.SlotTemplate.Size, p1.SlotAspectRatio)
	if p2 then
		p2.SlotSize = v2
	end
	return v2
end
function t.GetColumnCount(p1, p2) --[[ GetColumnCount | Line: 205 ]]
	local v1 = p2 and p2.ContainerSize or p1:GetContainerSize(p2)
	local v2 = p2 and p2.SlotSize or p1:GetSlotSize(p2)
	local SlotMargin = p1.SlotMargin
	local v6 = math.max(math.floor(v1.X / (v2.X + (v1.X * SlotMargin.Scale + SlotMargin.Offset))), 1)
	if v6 ~= v6 then
		v6 = 0
	end
	if p2 then
		p2.ColumnCount = v6
	end
	return v6
end
function t.GetRowCount(p1, p2) --[[ GetRowCount | Line: 222 ]]
	local v3 = math.ceil(p1.ItemCount / (p2 and p2.ColumnCount or p1:GetColumnCount(p2)))
	if v3 ~= v3 then
		v3 = 0
	end
	if p2 then
		p2.RowCount = v3
	end
	return v3
end
function t.SetItemCount(p1, p2, p3) --[[ SetItemCount | Line: 236 ]]
	p1.ItemCount = p2
	p1.ItemGroup = nil
	p1.Changed = true
	p1.ItemChanged = true
end
function t.Update(p1) --[[ Update | Line: 257 ]]
	debug.profilebegin("uiRecycler")
	local SizeChanged = p1.SizeChanged
	local ItemChanged = p1.ItemChanged
	p1.SizeChanged = false
	p1.ItemChanged = false
	p1.Changed = false
	p1.Updating = true
	local t = {}
	local v1 = p1:GetContainerPadding(t)
	local v2 = p1:GetContainerSize(t)
	local v3 = p1:GetSlotSize(t)
	local SlotMargin = p1.SlotMargin
	local v4 = v2.X * SlotMargin.Scale + SlotMargin.Offset
	local v5 = v3 + v4 * Vector2.one
	local v6 = p1:GetColumnCount(t)
	local v8 = v5.Y * p1:GetRowCount(t) + v2.Y * 0.25
	p1.Container.CanvasSize = UDim2.fromOffset(0, v8)
	local v11 = math.floor(math.min(p1.Container.CanvasPosition.Y, v8 - v2.Y) / v5.Y)
	local v13 = (math.ceil((v2.Y + v1.Top) / v5.Y) + 1) * v6
	local v14
	if p1.ItemCount == 0 or (v5.X == 0 or v5.Y == 0) then
		v13 = 0
		v11 = 0
		v14 = 0
	else
		v14 = v11 * v6
	end
	local v15 = v11 + 1
	local v16 = if v15 == p1.CurrentRow then false else true
	p1.CurrentRow = v15
	local v17 = v2.X / 2 - v6 * v5.X / 2 + v4 / 2
	if p1.Slots[1] and (not SizeChanged and (v13 > 0 and v16)) then
		local Index = p1.Slots[1].Index
		local Index_2 = p1.Slots[#p1.Slots].Index
		local v18 = #p1.Slots
		if Index and Index <= v14 then
			local v19 = v14 - Index + 1
			if v19 < v13 then
				local t2 = {}
				table.move(p1.Slots, 1, v19, 1, t2)
				table.move(p1.Slots, v19 + 1, v18, 1, p1.Slots)
				table.move(t2, 1, v19, v18 - v19 + 1, p1.Slots)
			end
		elseif Index_2 and v14 + v13 < Index_2 then
			local v20 = Index_2 - v14 - v13
			if v20 < v13 then
				local t2 = {}
				table.move(p1.Slots, v18 - v20 + 1, v18, 1, t2)
				table.move(p1.Slots, 1, v18 - v20, v20 + 1, p1.Slots)
				table.move(t2, 1, v20, 1, p1.Slots)
			end
		end
	end
	if v16 or (SizeChanged or ItemChanged) then
		local t2 = {}
		for i = 1, math.max(v13, #p1.Slots) do
			local v22 = v14 + i
			local v23 = p1.Slots[i]
			if p1.ItemCount < v22 or v13 < i then
				if v23 then
					local Index = v23.Index
					v23.Index = nil
					v23.GuiObject.Visible = false
					p1:UpdateSlot(v23.GuiObject, v23, nil, Index)
					if v13 < i then
						table.insert(t2, i)
						p1.SlotsByGuiObject[v23.GuiObject] = nil
						p1.SlotPool:Release(v23.GuiObject)
						v23.GuiObject.Parent = nil
						p1:OnSlotRelease(v23.GuiObject, v23)
					end
				end
				continue
			end
			if not v23 then
				local t3 = {
					GuiObject = p1.SlotPool:Request()
				}
				t3.GuiObject.AnchorPoint = Vector2.zero
				p1.SlotsByGuiObject[t3.GuiObject] = t3
				table.insert(p1.Slots, t3)
				p1:OnSlotCreate(t3.GuiObject, t3)
				v23 = t3
			end
			local v24 = if v23.Index == v22 then ItemChanged else true
			if v24 then
				debug.profilebegin("uiRecycler_updateSlot")
				local Index = v23.Index
				v23.Index = v22
				v23.GuiObject.Visible = true
				v23.GuiObject.Parent = p1.Container
				p1:UpdateSlot(v23.GuiObject, v23, v22, Index)
				debug.profileend()
			end
			if v24 or SizeChanged then
				v23.GuiObject.Position = UDim2.fromOffset(v17 + (v22 - 1) % v6 * v5.X + v1.Left, math.floor((v22 - 1) / v6) * v5.Y + v1.Top)
				v23.GuiObject.Size = UDim2.fromOffset(v3.X, v3.Y)
			end
		end
		for j = #t2, 1, -1 do
			table.remove(p1.Slots, t2[j])
		end
	end
	p1.Updating = false
	debug.profileend()
end
function t.OnSlotCreate(p1, p2) --[[ OnSlotCreate | Line: 410 ]] end
function t.GetSlotItemIndex(p1, p2) --[[ GetSlotItemIndex | Line: 414 ]]
	local v1 = p1.SlotsByGuiObject[p2]
	return if v1 then v1.Index else v1
end
function t.UpdateSlot(p1, p2, p3, p4) --[[ UpdateSlot | Line: 419 ]] end
function t.OnSlotRelease(p1, p2) --[[ OnSlotRelease | Line: 423 ]] end
return t