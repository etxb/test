-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GuiUtils.SectionedVirtualList

-- https://lua.expert/
local Pool = require(script.Parent.Parent.Pool)
local VisibleDetector = require(script.Parent.VisibleDetector)
local t = {
	ItemSize = nil,
	HeaderSize = nil,
	SlotMargin = 0,
	SlotAspectRatio = nil,
	ItemsPerRow = nil,
	TrailingItemRows = 2,
	Changed = false
}
t.__index = t
function t.new(p1, p2, p3, p4) --[[ new | Line: 52 | Upvalues: Pool (copy), VisibleDetector (copy) ]]
	local v1 = setmetatable({
		Container = p2,
		ItemTemplate = p3,
		HeaderTemplate = p4,
		ItemPool = Pool.byInstance(p3),
		HeaderPool = Pool.byInstance(p4),
		Slots = {},
		SlotsByGui = {},
		VisibleDetector = VisibleDetector.SetupVisibleDetector(p2)
	}, p1)
	p3.Parent = nil
	p4.Parent = nil
	local UIListLayout = p2:FindFirstChildOfClass("UIListLayout")
	if UIListLayout then
		UIListLayout.Parent = nil
	end
	p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() --[[ Line: 71 | Upvalues: v1 (copy) ]]
		v1:setSizeChanged()
	end)
	p2:GetPropertyChangedSignal("CanvasPosition"):Connect(function() --[[ Line: 75 | Upvalues: v1 (copy) ]]
		v1:setChanged()
	end)
	return v1
end
function t.setChanged(p1) --[[ setChanged | Line: 81 ]]
	if not p1.Updating then
		p1.Changed = true
	end
end
function t.setSizeChanged(p1) --[[ setSizeChanged | Line: 87 ]]
	if not p1.Updating then
		p1.Changed = true
		p1.SizeChanged = true
	end
end
function t.SetItemSize(p1, p2) --[[ SetItemSize | Line: 94 ]]
	p1.ItemSize = p2
	p1:setChanged()
end
function t.SetHeaderSize(p1, p2) --[[ SetHeaderSize | Line: 99 ]]
	p1.HeaderSize = p2
	p1:setChanged()
end
function t.SetSlotMargin(p1, p2) --[[ SetSlotMargin | Line: 104 ]]
	p1.SlotMargin = p2 or 0
	p1:setChanged()
end
function t.SetSlotAspectRatio(p1, p2) --[[ SetSlotAspectRatio | Line: 109 ]]
	if p2 == 0 then
		p2 = nil
	end
	p1.SlotAspectRatio = p2
	p1:setSizeChanged()
end
function t.SetContainerPadding(p1, p2) --[[ SetContainerPadding | Line: 117 ]]
	p1.ContainerPadding = p2
	p1:setChanged()
end
function t.SetItemsPerRow(p1, p2) --[[ SetItemsPerRow | Line: 122 ]]
	p1.ItemsPerRow = p2
	p1:setChanged()
end
function t.SetTrailingItemRows(p1, p2) --[[ SetTrailingItemRows | Line: 128 ]]
	p1.TrailingItemRows = p2
	p1:setChanged()
end
function t.SetSections(p1, p2) --[[ SetSections | Line: 134 ]]
	p1.Sections = p2
	p1.Changed = true
	p1.DataChanged = true
end
function t.InvalidateData(p1) --[[ InvalidateData | Line: 141 ]]
	p1.Changed = true
	p1.DataChanged = true
end
function t.LoadRender(p1) --[[ LoadRender | Line: 146 ]]
	p1.Loaded = true
	p1.Changed = true
	p1.VisibleDetector:SetRender(function(p12) --[[ Line: 149 | Upvalues: p1 (copy) ]]
		if p1.Changed then
			p1:Update()
		end
	end)
end
local function resolveUDim2ToAbsolute(p1, p2) --[[ resolveUDim2ToAbsolute | Line: 157 ]]
	return Vector2.new(p1.X.Offset + p1.X.Scale * p2.X, p1.Y.Offset + p1.Y.Scale * p2.Y)
end
local function getResolvedSizes(p1) --[[ getResolvedSizes | Line: 169 ]]
	local AbsoluteSize = p1.Container.AbsoluteSize
	local HeaderSize = p1.HeaderSize
	if not HeaderSize then
		local Size = p1.HeaderTemplate.Size
		local v1 = Vector2.new(Size.X.Offset + Size.X.Scale * AbsoluteSize.X, Size.Y.Offset + Size.Y.Scale * AbsoluteSize.Y)
		HeaderSize = if AbsoluteSize.Y <= 0 or v1.Y <= 0 then Vector2.new(math.max(v1.X, 0), 32) else v1
	end
	local ItemSize = p1.ItemSize
	if not ItemSize then
		local Size = p1.ItemTemplate.Size
		local v5 = Vector2.new(Size.X.Offset + Size.X.Scale * AbsoluteSize.X, Size.Y.Offset + Size.Y.Scale * AbsoluteSize.Y)
		ItemSize = if AbsoluteSize.Y <= 0 or v5.Y <= 0 then Vector2.new(math.max(v5.X, 0), 40) else v5
	end
	local FooterVec = p1.FooterVec
	if not FooterVec then
		local Size = p1.HeaderTemplate.Size
		local v9 = Vector2.new(Size.X.Offset + Size.X.Scale * AbsoluteSize.X, Size.Y.Offset + Size.Y.Scale * AbsoluteSize.Y)
		FooterVec = if AbsoluteSize.Y <= 0 or v9.Y <= 0 then Vector2.new(math.max(v9.X), 0, 40) else v9
	end
	return HeaderSize, ItemSize, FooterVec
end
local function getPadding(p1) --[[ getPadding | Line: 195 ]]
	local t = {
		Top = 0,
		Bottom = 0,
		Left = 0,
		Right = 0
	}
	if p1.ContainerPadding then
		local AbsoluteSize = p1.Container.AbsoluteSize
		t.Top = AbsoluteSize.Y * p1.ContainerPadding.PaddingTop.Scale + p1.ContainerPadding.PaddingTop.Offset
		t.Bottom = AbsoluteSize.Y * p1.ContainerPadding.PaddingBottom.Scale + p1.ContainerPadding.PaddingBottom.Offset
		t.Left = AbsoluteSize.X * p1.ContainerPadding.PaddingLeft.Scale + p1.ContainerPadding.PaddingLeft.Offset
		t.Right = AbsoluteSize.X * p1.ContainerPadding.PaddingRight.Scale + p1.ContainerPadding.PaddingRight.Offset
	end
	return t
end
local function computeGroupHeights(p1, p2, p3, p4, p5, p6) --[[ computeGroupHeights | Line: 208 ]]
	local t = { 0 }
	local sum = 0
	local v1 = p6 or 1
	for i = 1, p2 do
		t[i] = sum
		local sum_2 = math.ceil(#(p1[i] and p1[i].Items or {}) / v1) * (p4 + p5)
		if p1[i] and p1[i].Title then
			sum_2 = sum_2 + (p3 + p5)
		end
		if p1[i] and p1[i].Footer then
			sum_2 = sum_2 + (p3 + p5)
		end
		sum = sum + sum_2
	end
	t[p2 + 1] = sum
	return t, sum
end
local function buildSectionStructure(p1) --[[ buildSectionStructure | Line: 230 ]]
	local v1 = p1.Sections or {}
	local t = {
		[0] = 0
	}
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local count = 0
	local count_2 = 0
	for i, v in ipairs(v1) do
		local v2 = t[i - 1]
		local v3 = v.Items or {}
		local count_3 = 0
		if v.Title then
			count_3 = count_3 + 1
			table.insert(t4, {
				header = true,
				index = #t4 + 1,
				start = v2 + count_3,
				stop = v2 + count_3,
				headerRows = count,
				footerRows = count_2
			})
			count = count + 1
		end
		for i2 = 1, #v3, p1.ItemsPerRow do
			local _ = #t4 + math.ceil(i2 / p1.ItemsPerRow)
			local t5 = {
				index = #t4 + 1,
				start = v2 + count_3 + i2
			}
			t5.stop = v2 + count_3 + math.min(i2 + p1.ItemsPerRow, #v3)
			t5.headerRows = count
			t5.footerRows = count_2
			table.insert(t4, t5)
		end
		local count_4 = count_3 + #v3
		if v.Footer then
			count_4 = count_4 + 1
			table.insert(t4, {
				footer = true,
				index = #t4 + 1,
				start = v2 + count_4,
				stop = v2 + count_4,
				headerRows = count,
				footerRows = count_2
			})
			count_2 = count_2 + 1
		end
		t[i] = v2 + count_4
		local v6 = v2 + 1
		for j = v6, t[i] do
			t3[j] = i
			t2[j] = j - v6 + 1
		end
	end
	p1._sections = v1
	p1._sectionPrefix = t
	p1._flatToSectionS = t3
	p1._flatToSectionLocalIdx = t2
	p1._flatCount = #v1 > 0 and t[#v1] or 0
	p1._rows = t4
	p1._numSections = #v1
end
local function computeSectionLayout(p1) --[[ computeSectionLayout | Line: 310 | Upvalues: buildSectionStructure (copy), getPadding (copy), getResolvedSizes (copy), computeGroupHeights (copy) ]]
	if p1.DataChanged then
		buildSectionStructure(p1)
	end
	local v1 = p1._sections or {}
	local v5 = p1.SlotMargin or 0
	local v6 = p1.ItemsPerRow or 1
	local v7 = getPadding(p1)
	local v8 = p1.Container.AbsoluteSize.X - v7.Left - v7.Right
	local v9, v10, v11 = getResolvedSizes(p1)
	local Y = v9.Y
	local v12 = v8 > 0 and v6 > 0 and v8 / v6 or 0
	local Y_3 = v10.Y
	if p1.SlotAspectRatio and (p1.SlotAspectRatio > 0 and v12 > 0) then
		local v13 = Vector2.new(v12, v12 / p1.SlotAspectRatio)
		local v14 = Vector2.new(v10.Y * p1.SlotAspectRatio, v10.Y)
		v10 = if v14.X < v13.X then v14 else v13
		Y_3 = v10.Y
	end
	local v15, v16 = computeGroupHeights(v1, p1._numSections or 0, Y, Y_3, v5, p1.ItemsPerRow)
	local t = {
		sections = v1,
		sectionPrefix = p1._sectionPrefix or {
			[0] = 0
		},
		sectionStartY = v15,
		totalHeight = v16,
		flatCount = p1._flatCount or 0,
		headerH = Y,
		itemH = Y_3,
		footerH = v11.Y,
		headerSizeVec = v9,
		itemSizeVec = v10,
		footerVec = v11,
		margin = v5,
		itemsPerRow = v6,
		containerWidth = math.max(0, v8),
		cellWidth = v12,
		flatToSectionS = p1._flatToSectionS,
		flatToSectionLocalIdx = p1._flatToSectionLocalIdx
	}
	t.useTemplateHeaderSize = p1.HeaderSize == nil
	t.useTemplateItemSize = p1.ItemSize == nil
	t.rows = p1._rows
	return t
end
local function getSectionAndLocal(p1, p2) --[[ getSectionAndLocal | Line: 365 ]]
	local v1 = p1.flatToSectionS and p1.flatToSectionS[p2]
	if v1 then
		return v1, p1.flatToSectionLocalIdx[p2]
	else
		local sectionPrefix = p1.sectionPrefix
		local v2 = #p1.sections
		local v3 = 1
		while v3 <= v2 do
			local v4 = (v3 + v2) // 2
			if sectionPrefix[v4] < p2 then
				v3 = v4 + 1
			else
				v2 = v4 - 1
			end
		end
		return v3, p2 - sectionPrefix[v3 - 1]
	end
end
local function getCellInfo(p1, p2) --[[ getCellInfo | Line: 384 | Upvalues: getSectionAndLocal (copy) ]]
	local v1, count = getSectionAndLocal(p1, p2)
	local v2 = p1.sections[v1]
	local v3 = if v2 then v2.Title else v2
	local v4 = if v2 then v2.Footer else v2
	local v5 = v2 and v2.Items or {}
	if v3 then
		count = count - 1
	end
	if count == 0 then
		return {
			Type = "header",
			ItemIndex = nil,
			ItemData = nil,
			SectionIndex = v1,
			SectionTitle = v3
		}
	elseif v4 and count == #v5 + 1 then
		return {
			Type = "footer",
			ItemIndex = nil,
			ItemData = nil,
			SectionIndex = v1,
			SectionFooter = v4
		}
	else
		return {
			Type = "item",
			SectionIndex = v1,
			SectionTitle = v3,
			SectionFooter = v4,
			ItemIndex = count,
			ItemData = v5[count]
		}
	end
end
local function getRowHeight(p1, p2) --[[ getRowHeight | Line: 410 | Upvalues: getSectionAndLocal (copy) ]]
	local v1, count = getSectionAndLocal(p1, p2)
	local v2 = p1.sections[v1]
	if v2 and v2.Title then
		count = count - 1
	end
	return (count == 0 or v2 and (v2.Footer and count == #v2.Items + 1)) and p1.headerH or p1.itemH
end
local function getYOffset(p1, p2) --[[ getYOffset | Line: 421 | Upvalues: getSectionAndLocal (copy) ]]
	local v1, count = getSectionAndLocal(p1, p2)
	local v2 = p1.sections[v1]
	local sum = 0
	if count > 1 then
		if v2 and v2.Title then
			count = count - 1
		end
		local v4 = if v2 then v2.Footer and if count == #v2.Items + 1 then true else false else v2
		if v4 then
			count = count - 1
		end
		local count_2 = (count - 1) // (p1.itemsPerRow or 1)
		if v4 then
			count_2 = count_2 + 1
		end
		sum = sum + count_2 * (p1.itemH + p1.margin)
		if v2 and v2.Title then
			sum = sum + (p1.headerH + p1.margin)
		end
	end
	return p1.sectionStartY[v1] + sum
end
local function getXOffset(p1, p2, p3) --[[ getXOffset | Line: 451 | Upvalues: getSectionAndLocal (copy) ]]
	local v1, count = getSectionAndLocal(p1, p2)
	local v2 = p1.sections[v1]
	if v2 and v2.Title then
		count = count - 1
	end
	if count == 0 then
		return p3
	else
		local v3 = p1.sections[v1]
		if v3 and (v3.Footer and count == #v3.Items + 1) then
			return p3
		else
			return p3 + (count - 1) % (p1.itemsPerRow or 1) * p1.cellWidth
		end
	end
end
local function isRowVisible(p1, p2, p3, p4, p5) --[[ isRowVisible | Line: 470 | Upvalues: getYOffset (copy), getSectionAndLocal (copy) ]]
	local v1 = getYOffset(p1, p2) + p3
	local v2, count = getSectionAndLocal(p1, p2)
	local v3 = p1.sections[v2]
	if v3 and v3.Title then
		count = count - 1
	end
	return if p4 < v1 + ((count == 0 or v3 and (v3.Footer and count == #v3.Items + 1)) and p1.headerH or p1.itemH) then v1 < p5 else false
end
local function firstVisibleGroup(p1, p2, p3, p4) --[[ firstVisibleGroup | Line: 477 ]]
	local sectionStartY = p1.sectionStartY
	local v1, v2 = 1, p4
	while v1 <= v2 do
		local v3 = (v1 + v2) // 2
		if p3 < sectionStartY[v3 + 1] + p2 then
			v2 = v3 - 1
		else
			v1 = v3 + 1
		end
	end
	return v1
end
local function lastVisibleGroup(p1, p2, p3, p4) --[[ lastVisibleGroup | Line: 493 ]]
	local sectionStartY = p1.sectionStartY
	local v1, v2 = 1, p4
	while v1 <= v2 do
		local v3 = (v1 + v2) // 2
		if sectionStartY[v3] + p2 < p3 then
			v1 = v3 + 1
		else
			v2 = v3 - 1
		end
	end
	return v2
end
local function firstVisibleRow(p1, p2, p3, p4) --[[ firstVisibleRow | Line: 508 ]]
	local headerSizeVec = p1.headerSizeVec
	local itemSizeVec = p1.itemSizeVec
	local v1, v2 = 1, p4
	while v1 <= v2 do
		local v3 = (v1 + v2) // 2
		local v4 = p1.rows[v3]
		local v5 = v4.headerRows + v4.footerRows
		local v6 = v5 * headerSizeVec.Y + (v4.index - v5 - 1) * itemSizeVec.Y
		if p3 < if v4.header or v4.footer then v6 + headerSizeVec.Y else v6 + itemSizeVec.Y then
			v2 = v3 - 1
		else
			v1 = v3 + 1
		end
	end
	return v1
end
local function lastVisibleRow(p1, p2, p3, p4) --[[ lastVisibleRow | Line: 534 ]]
	local headerSizeVec = p1.headerSizeVec
	local itemSizeVec = p1.itemSizeVec
	local v1, v2 = 1, p4
	while v1 <= v2 do
		local v3 = (v1 + v2) // 2
		local v4 = p1.rows[v3]
		local v5 = v4.headerRows + v4.footerRows
		if v5 * headerSizeVec.Y + (v4.index - v5 - 1) * itemSizeVec.Y < p3 then
			v1 = v3 + 1
		else
			v2 = v3 - 1
		end
	end
	return v2
end
local function getVisibleFlatRange(p1, p2, p3, p4, p5) --[[ getVisibleFlatRange | Line: 554 | Upvalues: firstVisibleRow (copy), lastVisibleRow (copy), firstVisibleGroup (copy), lastVisibleGroup (copy), getYOffset (copy), getSectionAndLocal (copy) ]]
	if p1.rows then
		local v1 = firstVisibleRow(p1, p2, p3, #p1.rows)
		local v2 = lastVisibleRow(p1, p2, p4, #p1.rows)
		local v3 = p1.rows[v1]
		local v4 = p1.rows[v2]
		if v3 and (v4 and not (v2 < 1 or v2 < v1)) then
			return v3.start, v4.stop
		else
			return 1, 0
		end
	else
		local v5 = #p1.sections
		if v5 == 0 then
			return 1, 0
		else
			local sectionPrefix = p1.sectionPrefix
			local v6 = firstVisibleGroup(p1, p2, p3, v5)
			local count = lastVisibleGroup(p1, p2, p4, v5)
			if v5 < v6 or (count < 1 or count < v6) then
				return 1, 0
			else
				local v8 = sectionPrefix[count]
				local v9 = true
				while v9 and v8 < p5 do
					local v10 = getYOffset(p1, v8) + p2
					local v11, count_2 = getSectionAndLocal(p1, v8)
					local v12 = p1.sections[v11]
					if v12 and v12.Title then
						count_2 = count_2 - 1
					end
					if not if p3 < v10 + ((count_2 == 0 or v12 and (v12.Footer and count_2 == #v12.Items + 1)) and p1.headerH or p1.itemH) then if v10 < p4 then true else false else false then
						break
					end
					v9 = false
					count = count + 1
					if v5 < count then
						break
					end
					for i = sectionPrefix[count - 1] + 1, sectionPrefix[count] do
						local v15 = getYOffset(p1, i) + p2
						local v16, count_3 = getSectionAndLocal(p1, i)
						local v17 = p1.sections[v16]
						if v17 and v17.Title then
							count_3 = count_3 - 1
						end
						if not if p3 < v15 + ((count_3 == 0 or v17 and (v17.Footer and count_3 == #v17.Items + 1)) and p1.headerH or p1.itemH) then if v15 < p4 then true else false else false then
							break
						end
						v9, v8 = true, i
					end
				end
				return sectionPrefix[v6 - 1] + 1, v8
			end
		end
	end
end
function t.Update(p1) --[[ Update | Line: 600 | Upvalues: computeSectionLayout (copy), getPadding (copy), getVisibleFlatRange (copy), getCellInfo (copy), getSectionAndLocal (copy), getYOffset (copy), getXOffset (copy) ]]
	debug.profilebegin("SectionedVirtualList")
	local DataChanged = p1.DataChanged
	p1.Changed = false
	p1.Updating = true
	local v1 = computeSectionLayout(p1)
	p1.DataChanged = false
	local headerSizeVec = v1.headerSizeVec
	local itemSizeVec = v1.itemSizeVec
	local flatCount = v1.flatCount
	local totalHeight = v1.totalHeight
	local TrailingItemRows = p1.TrailingItemRows
	if flatCount > 0 and (TrailingItemRows and TrailingItemRows > 0) then
		totalHeight = totalHeight + TrailingItemRows * (v1.itemH + v1.margin)
	end
	local v2 = getPadding(p1)
	local Y = p1.Container.CanvasPosition.Y
	local v3 = math.max(Y - 50, 0)
	local v4 = Y + p1.Container.AbsoluteWindowSize.Y + 50
	p1.Container.CanvasSize = UDim2.fromOffset(0, totalHeight + v2.Top + v2.Bottom)
	if flatCount == 0 then
		for k, v in pairs(p1.SlotsByGui) do
			local GuiObject = v.GuiObject
			GuiObject.Visible = false
			if v.CellInfo and (v.CellInfo.Type == "header" or v.CellInfo.Type == "footer") then
				p1.HeaderPool:Release(GuiObject)
			else
				p1.ItemPool:Release(GuiObject)
			end
			p1:OnSlotRelease(GuiObject, v)
		end
		table.clear(p1.Slots)
		table.clear(p1.SlotsByGui)
		p1._lastI0 = nil
		p1._lastI1 = nil
	else
		local t = {}
		local v5, v6 = getVisibleFlatRange(v1, v2.Top, v3, v4, flatCount)
		if v6 < v5 and flatCount > 0 then
			v5 = 1
			v6 = 1
		end
		if v5 <= v6 then
			for i = v5, v6 do
				t[#t + 1] = i
			end
		end
		local v7 = #t
		local _lastI0 = p1._lastI0
		local _lastI1 = p1._lastI1
		local SizeChanged = p1.SizeChanged
		p1.SizeChanged = false
		if p1.Slots[1] and (_lastI0 and (_lastI1 and (v7 > 0 and not (SizeChanged or DataChanged)))) then
			local v8 = #p1.Slots
			if _lastI0 < v5 then
				local v9 = v5 - _lastI0
				if v9 > 0 and v9 < v8 then
					local t2 = {}
					table.move(p1.Slots, 1, v9, 1, t2)
					table.move(p1.Slots, v9 + 1, v8, 1, p1.Slots)
					table.move(t2, 1, v9, v8 - v9 + 1, p1.Slots)
				end
			elseif v6 < _lastI1 then
				local v10 = _lastI1 - v6
				if v10 > 0 and v10 < v8 then
					local t2 = {}
					table.move(p1.Slots, v8 - v10 + 1, v8, 1, t2)
					table.move(p1.Slots, 1, v8 - v10, v10 + 1, p1.Slots)
					table.move(t2, 1, v10, 1, p1.Slots)
				end
			end
		end
		local v11 = p1.Container.AbsoluteSize.X - v2.Left - v2.Right
		local useTemplateHeaderSize = v1.useTemplateHeaderSize
		local useTemplateItemSize = v1.useTemplateItemSize
		local t2 = {}
		for j = 1, v7 do
			local v12, v13
			local v14 = t[j]
			local v15 = p1.Slots[j]
			local v16 = getCellInfo(v1, v14)
			local v17 = if v16.Type == "header" then true else v16.Type == "footer"
			if v15 then
				if v15.IsHeader ~= v17 then
					local GuiObject = v15.GuiObject
					GuiObject.Visible = false
					p1.SlotsByGui[GuiObject] = nil
					if v15.IsHeader then
						p1.HeaderPool:Release(GuiObject)
					else
						p1.ItemPool:Release(GuiObject)
					end
					p1:OnSlotRelease(GuiObject, v15)
					if v17 then
						v15.GuiObject = p1.HeaderPool:Request()
						v15.IsHeader = true
					else
						v15.GuiObject = p1.ItemPool:Request()
						v15.IsHeader = false
					end
					v15.GuiObject.AnchorPoint = Vector2.zero
					p1.SlotsByGui[v15.GuiObject] = v15
					p1:OnSlotCreate(v15.GuiObject, v15)
				end
			else
				v15 = if v17 then {
	IsHeader = true,
	GuiObject = p1.HeaderPool:Request()
} else {
	IsHeader = false,
	GuiObject = p1.ItemPool:Request()
}
				v15.GuiObject.AnchorPoint = Vector2.zero
				p1.SlotsByGui[v15.GuiObject] = v15
				p1:OnSlotCreate(v15.GuiObject, v15)
			end
			local v18 = getCellInfo(v1, v14)
			local v19, count = getSectionAndLocal(v1, v14)
			local v20 = v1.sections[v19]
			if v20 and v20.Title then
				count = count - 1
			end
			if count == 0 or v20 and (v20.Footer and count == #v20.Items + 1) then
				v12 = v18
				v13 = v1.headerH or v1.itemH
			else
				v12 = v18
				v13 = v1.itemH
			end
			local v21 = getYOffset(v1, v14) + v2.Top
			local v22 = getXOffset(v1, v14, v2.Left)
			local v23 = if v15.FlatIndex == v14 then false else true
			local t3 = {
				FlatIndex = v15.FlatIndex,
				CellInfo = v15.CellInfo
			}
			v15.FlatIndex = v14
			v15.CellInfo = v12
			local GuiObject = v15.GuiObject
			GuiObject.Visible = true
			GuiObject.Parent = p1.Container
			local v24, v25, v26, v27, v28
			if v1.itemsPerRow and v1.itemsPerRow > 1 then
				v24 = v1.cellWidth
				if v24 then
					v25 = headerSizeVec.X
					v26 = math.max(v25, v11)
					if v12.Type == "header" or v12.Type == "footer" then
						if useTemplateHeaderSize then
							v27 = p1.HeaderTemplate.Size
							GuiObject.Size = UDim2.new(v27.X.Scale, v27.X.Offset - v2.Left - v2.Right, 0, v13)
						else
							GuiObject.Size = UDim2.fromOffset(v26 - v2.Left - v2.Right, v13)
						end
					elseif useTemplateItemSize then
						v28 = p1.ItemTemplate.Size
						GuiObject.Size = UDim2.new(v28.X.Scale, v28.X.Offset, 0, v13)
					else
						GuiObject.Size = UDim2.fromOffset(v24, v13)
					end
					GuiObject.Position = UDim2.fromOffset(v22, v21)
					if v23 or DataChanged then
						p1:UpdateSlot(GuiObject, v15, v14, t3)
					end
					t2[j] = v15
				end
			end
			v24 = math.max(itemSizeVec.X, v11)
			v25 = headerSizeVec.X
			v26 = math.max(v25, v11)
			if v12.Type == "header" or v12.Type == "footer" then
				if useTemplateHeaderSize then
					v27 = p1.HeaderTemplate.Size
					GuiObject.Size = UDim2.new(v27.X.Scale, v27.X.Offset - v2.Left - v2.Right, 0, v13)
				else
					GuiObject.Size = UDim2.fromOffset(v26 - v2.Left - v2.Right, v13)
				end
			elseif useTemplateItemSize then
				v28 = p1.ItemTemplate.Size
				GuiObject.Size = UDim2.new(v28.X.Scale, v28.X.Offset, 0, v13)
			else
				GuiObject.Size = UDim2.fromOffset(v24, v13)
			end
			GuiObject.Position = UDim2.fromOffset(v22, v21)
			if v23 or DataChanged then
				p1:UpdateSlot(GuiObject, v15, v14, t3)
			end
			t2[j] = v15
		end
		for k = v7 + 1, #p1.Slots do
			local v29 = p1.Slots[k]
			local GuiObject = v29.GuiObject
			GuiObject.Visible = false
			if v29.IsHeader then
				p1.HeaderPool:Release(GuiObject)
			else
				p1.ItemPool:Release(GuiObject)
			end
			p1:OnSlotRelease(GuiObject, v29)
			v29.FlatIndex = nil
			v29.CellInfo = nil
			p1.SlotsByGui[GuiObject] = nil
		end
		p1.Slots = t2
		if v7 > 0 then
			p1._lastI0 = v5
			p1._lastI1 = v6
		else
			p1._lastI0 = nil
			p1._lastI1 = nil
		end
	end
	p1.Updating = false
	debug.profileend()
end
function t.OnSlotCreate(p1, p2, p3) --[[ OnSlotCreate | Line: 804 ]] end
function t.UpdateSlot(p1, p2, p3, p4) --[[ UpdateSlot | Line: 807 ]] end
function t.OnSlotRelease(p1, p2, p3) --[[ OnSlotRelease | Line: 812 ]] end
function t.GetFlatIndexFromGui(p1, p2) --[[ GetFlatIndexFromGui | Line: 816 ]]
	local v1 = p1.SlotsByGui and p1.SlotsByGui[p2]
	return if v1 then v1.FlatIndex else v1
end
function t.GetCellInfoFromGui(p1, p2) --[[ GetCellInfoFromGui | Line: 822 ]]
	local v1 = p1.SlotsByGui and p1.SlotsByGui[p2]
	return if v1 then v1.CellInfo else v1
end
return t