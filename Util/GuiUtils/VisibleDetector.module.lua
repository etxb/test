-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GuiUtils.VisibleDetector

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local t = {
	Visible = false
}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 15 | Upvalues: TableUtils (copy) ]]
	local v2 = TableUtils.SwapKV(p3)
	local t = {
		Visibled = 0,
		Visible = false,
		DetectTarget = p2,
		Instances = v2,
		Connections = {},
		Count = #p3
	}
	local v3 = setmetatable(t, p1)
	local v4 = true
	local function updateVisible(p1, p2) --[[ updateVisible | Line: 30 | Upvalues: v2 (ref), v3 (copy), v4 (ref) ]]
		v2[p1] = p2
		if p2 then
			local v1 = v3
			v1.Visibled = v1.Visibled + 1
		elseif not v4 then
			local v22 = v3
			v22.Visibled = v22.Visibled - 1
		end
		if not v4 then
			v3:Update()
		end
	end
	for v5, v6 in v2 do
		if v5:IsA("GuiObject") then
			table.insert(v3.Connections, v5:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 45 | Upvalues: v5 (copy), v2 (ref), v3 (copy), v4 (ref) ]]
				local Visible = v5.Visible
				v2[v5] = Visible
				if Visible then
					local v22 = v3
					v22.Visibled = v22.Visibled + 1
				elseif not v4 then
					local v32 = v3
					v32.Visibled = v32.Visibled - 1
				end
				if not v4 then
					v3:Update()
				end
			end))
			local Visible = v5.Visible
			v2[v5] = Visible
			if Visible then
				v3.Visibled = v3.Visibled + 1
			elseif not v4 then
				v3.Visibled = v3.Visibled - 1
			end
			if not v4 then
				v3:Update()
			end
			continue
		end
		if v5:IsA("LayerCollector") then
			table.insert(v3.Connections, v5:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 50 | Upvalues: v5 (copy), v2 (ref), v3 (copy), v4 (ref) ]]
				local Enabled = v5.Enabled
				v2[v5] = Enabled
				if Enabled then
					local v22 = v3
					v22.Visibled = v22.Visibled + 1
				elseif not v4 then
					local v32 = v3
					v32.Visibled = v32.Visibled - 1
				end
				if not v4 then
					v3:Update()
				end
			end))
			local Enabled = v5.Enabled
			v2[v5] = Enabled
			if Enabled then
				v3.Visibled = v3.Visibled + 1
			elseif not v4 then
				v3.Visibled = v3.Visibled - 1
			end
			if not v4 then
				v3:Update()
			end
		end
	end
	table.insert(v3.Connections, p2.Destroying:Connect(function() --[[ Line: 56 | Upvalues: v3 (copy) ]]
		v3:Destroy()
	end))
	v4 = false
	v3:Update()
	return v3
end
function t.SetRender(p1, p2) --[[ SetRender | Line: 66 ]]
	p1.Render = p2
	p1:UpdateRender()
end
function t.UpdateRender(p1) --[[ UpdateRender | Line: 71 | Upvalues: RunService (copy) ]]
	if p1.RenderConnection then
		p1.RenderConnection:Disconnect()
		p1.RenderConnection = nil
	end
	if p1.Render and p1.Visible then
		p1.RenderConnection = RunService.PreRender:Connect(p1.Render)
	end
end
function t.Update(p1) --[[ Update | Line: 81 ]]
	local isCount = p1.Visibled == p1.Count
	if isCount ~= p1.Visible then
		p1.Visible = isCount
		p1:UpdateRender()
		p1:OnChanged()
		if isCount then
			p1:OnVisibled()
		else
			p1:OnInvisibled()
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 96 ]]
	for v1, v2 in p1.Connections do
		v2:Disconnect()
	end
	if p1.RenderConnection then
		p1.RenderConnection:Disconnect()
		p1.RenderConnection = nil
	end
	table.clear(p1)
end
function t.OnChanged(p1) --[[ OnChanged | Line: 107 ]] end
function t.OnVisibled(p1) --[[ OnVisibled | Line: 111 ]] end
function t.OnInvisibled(p1) --[[ OnInvisibled | Line: 115 ]] end
local t2 = {
	ScreenGui = true,
	BillboardGui = true,
	SurfaceGui = true
}
local v1 = InstanceUtils.InstanceDescriptor.byType("ScreenGui")
local function ancestorFilter(p1) --[[ ancestorFilter | Line: 126 ]]
	return p1:IsA("GuiBase")
end
local t3 = {}
function t.SetupVisibleDetector(p1, p2) --[[ SetupVisibleDetector | Line: 132 | Upvalues: t2 (copy), InstanceUtils (copy), v1 (copy), ancestorFilter (copy), t3 (copy), RunService (copy), t (copy) ]]
	if p2 and not t2[p2] then
		error(("unsupported root type \"%s\""):format(p2))
	end
	os.clock()
	local FindAncestor = InstanceUtils.FindAncestor
	local v3, v4, v5, v6, v7, v8, v9, v10
	if p2 then
		local v12, v2
		v12 = InstanceUtils.InstanceDescriptor.byType(p2)
		if v12 then
			v2 = p1
		end
		v3, v4, v5 = FindAncestor(v2, v12, {
			SavePath = true,
			Filter = ancestorFilter,
			Ref = t3
		})
		if not v3 then
			if v3 == false then
				return
			end
			if RunService:IsStudio() then
				warn({ debug.traceback() }, p1:GetFullName())
			end
			v6 = error
			v7 = "can\'t found ancestor \"%s\""
			v8 = if p2 then p2 else v1.Type
			v6(v7:format(v8))
		end
		if #v4 > 10 and not v5 then
			for i = 2, #v4 - 6 do
				v9 = v4[i]
				if not t3[v9] then
					v10 = {}
					table.move(v4, 1, i, 1, v10)
					t3[v9] = v10
				end
			end
		end
		return t:new(p1, v4)
	end
	v3, v4, v5 = FindAncestor(p1, v1, {
		SavePath = true,
		Filter = ancestorFilter,
		Ref = t3
	})
	if not v3 then
		if v3 == false then
			return
		end
		if RunService:IsStudio() then
			warn({ debug.traceback() }, p1:GetFullName())
		end
		v6 = error
		v7 = "can\'t found ancestor \"%s\""
		v8 = if p2 then p2 else v1.Type
		v6(v7:format(v8))
	end
	if #v4 > 10 and not v5 then
		for i = 2, #v4 - 6 do
			v9 = v4[i]
			if not t3[v9] then
				v10 = {}
				table.move(v4, 1, i, 1, v10)
				t3[v9] = v10
			end
		end
	end
	return t:new(p1, v4)
end
return t