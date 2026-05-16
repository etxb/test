-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.InstanceUtils

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Promise = require(ReplicatedStorage.Shared.Promise)
local Utils = require(ReplicatedStorage.Util.Utils)
local TaskUtils = require(ReplicatedStorage.Util.TaskUtils)
local t = {}
local t2 = {}
local t3 = {
	__index = t2
}
function t2.new() --[[ new | Line: 15 | Upvalues: t3 (copy) ]]
	return setmetatable({}, t3)
end
function t2.byName(p1) --[[ byName | Line: 19 | Upvalues: t3 (copy) ]]
	return setmetatable({
		Name = p1
	}, t3)
end
function t2.byType(p1) --[[ byType | Line: 23 | Upvalues: t3 (copy) ]]
	return setmetatable({
		Type = p1
	}, t3)
end
function t2.WithName(p1, p2) --[[ WithName | Line: 27 ]]
	p1.Name = p2
	return p1
end
function t2.WithType(p1, p2) --[[ WithType | Line: 32 ]]
	p1.Type = p2
	return p1
end
function t2.WithAttribute(p1, p2, p3) --[[ WithAttribute | Line: 37 ]]
	if not p1.Attrs then
		p1.Attrs = {}
	end
	p1.Attrs[p2] = p3
	return p1
end
function t2.Valid(p1) --[[ Valid | Line: 45 ]]
	return (p1.Name or (p1.Type or p1.Attrs and p1.Attrs[next(p1.Attrs)])) and true or false
end
function t2.Test(p1, p2) --[[ Test | Line: 49 ]]
	if p1:Valid() then
		if p1.Name and p2.Name ~= p1.Name or p1.Type and not p2:IsA(p1.Type) then
			return false
		else
			if p1.Attrs then
				for v1, v2 in p1.Attrs do
					if p2:GetAttribute(v1) ~= v2 then
						return false
					end
				end
			end
			return true
		end
	else
		return false
	end
end
t.InstanceDescriptor = t2
local function parsePath(p1) --[[ parsePath | Line: 73 ]]
	if typeof(p1) == "string" then
		p1 = p1:find("%.") and p1:split(".") or { p1 }
	end
	return p1
end
function t.FindFirst(p1, p2) --[[ FindFirst | Line: 80 ]]
	if p1 and p2 then
		if p2 == "." then
			return p1
		else
			local v1
			if typeof(p2) == "string" then
				local v2, v3
				if p2:find("%.") then
					v2 = p2:split(".")
					if not v2 then
						v3 = p2
						v2 = { p2 }
					end
				else
					v3 = p2
					v2 = { p2 }
				end
				v1 = v2
			else
				v1 = p2
			end
			v4 = v1
			v5 = p1
			for i = 1, #v1 do
				v5 = if v4[i] == "[parent]" then v5.Parent else v5:FindFirstChild(v4[i])
				if not v5 then
					break
				end
			end
			return v5
		end
	else
		return nil
	end
end
function t.WaitForAsync(p1, p2, p3) --[[ WaitForAsync | Line: 104 | Upvalues: Promise (copy), SimpleSignal (copy) ]]
	return Promise.new(function(p12, p22, p32) --[[ Line: 105 | Upvalues: SimpleSignal (ref), p2 (ref), p1 (copy), p3 (copy) ]]
		local v1 = nil
		if not p32(function() --[[ Line: 107 | Upvalues: v1 (ref) ]]
			if v1 then
				v1:Fire()
			end
		end) then
			v1 = SimpleSignal.new()
			local v2 = p2
			if typeof(v2) == "string" then
				v2 = v2:find("%.") and v2:split(".") or { v2 }
			end
			p2 = v2
			local v4 = p1
			for v5, v6 in v2 do
				local v7 = v4:FindFirstChild(v6)
				if not v7 then
					local v8 = v4:GetPropertyChangedSignal("Parent")
					local v9 = SimpleSignal.combine(v4.ChildAdded, v4.Destroying, v8, v1)
					local v10 = p3 and task.delay(p3, v9.Fire, v9, "timeout")
					repeat
						local v11, _ = v9:Wait()
						if v11 == "timeout" or (v11 == v4.Destroying or v11 == v8 and not v4.Parent) then
							break
						end
						local v12 = v4:FindFirstChild(v6)
						v7 = v12
					until v12
					v9:Destroy()
					if v10 then
						task.cancel(v10)
					end
				end
				v4 = v7
				if not v7 then
					break
				end
			end
			p12(v4)
		end
	end)
end
function t.WaitFor(p1, p2, p3, p4, p5) --[[ WaitFor | Line: 146 | Upvalues: SimpleSignal (copy) ]]
	if p1.Parent or p4 then
		local path
		if typeof(p2) == "string" then
			local v1, v2
			if p2:find("%.") then
				v1 = p2:split(".")
				if not v1 then
					v2 = p2
					v1 = { p2 }
				end
			else
				v2 = p2
				v1 = { p2 }
			end
			path = v1
		else
			path = p2
		end
		if p5 then
			print("path", path)
		end
		local v4 = p1
		for v5, v6 in path do
			local v7 = v4:FindFirstChild(v6)
			if not v7 then
				if p5 then
					print("wait", v6)
				end
				local _ = v4.Parent
				local v8 = v4:GetPropertyChangedSignal("Parent")
				local v9 = SimpleSignal.combine(v4.ChildAdded, v4.Destroying, v8)
				local v10 = if p3 then task.delay(p3, v9.Fire, v9, "timeout") else p3
				repeat
					local v11, _2 = v9:Wait()
					if v11 == "timeout" or (v11 == v4.Destroying or v11 == v8 and not v4.Parent) then
						break
					end
					local v12 = v4:FindFirstChild(v6)
					v7 = v12
				until v12
				v9:Destroy()
				if v10 then
					task.cancel(v10)
				end
			end
			v4 = v7
			if not v7 then
				break
			end
		end
		return v4
	end
end
function t.WaitTree(p1, p2) --[[ WaitTree | Line: 187 | Upvalues: t (copy) ]]
	local t2 = {
		{
			Instance = p1,
			Tree = p2
		}
	}
	while #t2 > 0 do
		local v1 = table.remove(t2, 1)
		for v2, v3 in v1.Tree do
			if typeof(v3) == "string" and not t.WaitFor(v1.Instance, v3) then
				return
			end
			local v4 = t.WaitFor(v1.Instance, v2)
			if not v4 then
				return
			end
			if typeof(v3) == "table" then
				table.insert(t2, {
					Instance = v4,
					Tree = v3
				})
			end
		end
	end
	return true
end
function t.FindAncestor(p1, p2, p3) --[[ FindAncestor | Line: 210 ]]
	if p1.Parent then
		local v1 = if p3 then p3.Ref else p3
		local v2 = if p3 then p3.SavePath else p3
		local v3 = if p3 then p3.Filter else p3
		local v4 = v2 and { p1 } or nil
		local v5 = p1.Parent
		local v6
		while true do
			v5 = v5.Parent
			if not v5 or v5 == game then
				return
			end
			if v3 and not v3(v5) then
				return false
			end
			v6 = if v1 then v1[v5] else v1
			if v6 then
				break
			end
			if v5 and v4 then
				table.insert(v4, 1, v5)
			end
			if p2:Test(v5) then
				return v5, v4
			end
		end
		if v4 then
			for v8, v9 in v6 do
				table.insert(v4, v8, v9)
			end
		end
		return v6[1], v4, true
	end
end
function t.CloneInstances(p1) --[[ CloneInstances | Line: 246 ]]
	local t = {}
	for v1, v2 in p1 do
		local Archivable = v2.Archivable
		v2.Archivable = true
		table.insert(t, v2:Clone())
		v2.Archivable = Archivable
	end
	return t
end
function t.ExportInstProperties(p1, p2) --[[ ExportInstProperties | Line: 257 | Upvalues: t (copy) ]]
	local t2 = {}
	for v2, v3 in p2 do
		local v1
		local t3 = {}
		if v2 == "#self" or v2 == 1 then
			if p1 then
				v1 = p1
			end
			if v1 and #v3 > 0 then
				for v4, v5 in v3 do
					t3[v5] = v1[v5]
				end
			elseif v1 then
				for v6, v7 in v3 do
					t3[v6] = v1[v6]
				end
			end
			if next(t3) then
				t2[v2] = t3
			end
			continue
		end
		v1 = t.FindFirst(p1, v2)
		if v1 and #v3 > 0 then
			for v4, v5 in v3 do
				t3[v5] = v1[v5]
			end
		elseif v1 then
			for v6, v7 in v3 do
				t3[v6] = v1[v6]
			end
		end
		if next(t3) then
			t2[v2] = t3
		end
	end
	return t2
end
function t.ImportInstProperties(p1, p2) --[[ ImportInstProperties | Line: 280 | Upvalues: t (copy) ]]
	for v2, v3 in p2 do
		local v1
		if v2 == "#self" or v2 == 1 then
			if p1 then
				v1 = p1
			end
			if v1 then
				for v4, v5 in v3 do
					v1[v4] = v5
				end
			end
			continue
		end
		v1 = t.FindFirst(p1, v2)
		if v1 then
			for v4, v5 in v3 do
				v1[v4] = v5
			end
		end
	end
end
function t.GetPathIn(p1, p2, p3) --[[ GetPathIn | Line: 291 ]]
	if p1:IsDescendantOf(p2) then
		local v1 = if p3 then p3.Renamer else p3
		v2 = p1
		v3 = {}
		while v2 ~= p2 do
			table.insert(v3, 1, v1 and v1(v2, v2.Name) or v2.Name)
			v2 = v2.Parent
		end
		return v3
	else
		warn("muse be a descendant of ancestor")
	end
end
function t.GetProps(p1, ...) --[[ GetProps | Line: 306 ]]
	local t = {}
	local v1 = select(1, ...)
	if typeof(v1) ~= "table" then
		v1 = { ... }
	end
	for v2, v3 in v1 do
		t[v3] = p1[v3]
	end
	return t
end
function t.SetProperties(p1, p2, p3) --[[ SetProperties | Line: 318 ]]
	if typeof(p1) == "Instance" then
		p1 = { p1 }
	end
	for v1, v2 in p1 do
		if not p3 or p3(v2) then
			for v3, v4 in p2 do
				v2[v3] = v4
			end
		end
	end
end
function t.SetPropertiesByClass(p1, p2, p3) --[[ SetPropertiesByClass | Line: 331 ]]
	for v1, v2 in p1 do
		local v3 = p2[v2.ClassName]
		if v3 and (not p3 or p3(v2)) then
			for v4, v5 in v3 do
				v2[v4] = v5
			end
		end
	end
end
function t.OnParentLost(p1, p2, p3) --[[ OnParentLost | Line: 342 ]]
	assert(p1.Parent or p3, "instance must be parented")
	local v2 = nil
	local function exec() --[[ exec | Line: 345 | Upvalues: p1 (copy), p2 (copy), v2 (ref) ]]
		if not p1.Parent then
			p2()
			v2:Disconnect()
		end
	end
	v2 = p1:GetPropertyChangedSignal("Parent"):Connect(function() --[[ Line: 351 | Upvalues: p1 (copy), p2 (copy), v2 (ref) ]]
		if not p1.Parent then
			p2()
			v2:Disconnect()
		end
	end)
	if not p1.Parent then
		task.delay(15, function() --[[ Line: 355 | Upvalues: p1 (copy), p2 (copy), v2 (ref) ]]
			if not p1.Parent then
				p2()
				v2:Disconnect()
			end
		end)
	end
	return v2
end
function t.AutoDisconnect(p1, p2, p3) --[[ AutoDisconnect | Line: 362 | Upvalues: t (copy) ]]
	return t.AutoDisconnects(p1, { p2 }, p3)
end
function t.AutoDisconnects(p1, p2, p3) --[[ AutoDisconnects | Line: 366 | Upvalues: t (copy) ]]
	return t.OnParentLost(p1, function() --[[ Line: 367 | Upvalues: p2 (copy) ]]
		for v1, v2 in p2 do
			v2:Disconnect()
		end
	end, true)
end
function t.OnTagged(p1, p2, p3) --[[ OnTagged | Line: 374 | Upvalues: Utils (copy), CollectionService (copy) ]]
	local t = { Utils.ConnectAndExecuteWiths(CollectionService:GetInstanceAddedSignal(p1), p2, CollectionService:GetTagged(p1)) }
	if p3 then
		table.insert(t, CollectionService:GetInstanceRemovedSignal(p1):Connect(p3))
	end
	return t
end
function t.OnSafeTagged(p1, p2, p3, p4) --[[ OnSafeTagged | Line: 382 | Upvalues: t (copy) ]]
	return t.OnTagged(p1, function(p1) --[[ Line: 383 | Upvalues: p3 (copy), p2 (copy) ]]
		if not p1:GetAttribute("taggedSafe") then
			local v1 = os.clock()
			p1:SetAttribute("taggedSafe", v1)
			if p3(p1) and p1:GetAttribute("taggedSafe") == v1 then
				p2(p1)
			end
		end
	end, function(p1) --[[ Line: 394 | Upvalues: p4 (copy) ]]
		p1:SetAttribute("taggedSafe")
		if p4 then
			p4(p1)
		end
	end)
end
function t.OnChild(p1, p2, p3) --[[ OnChild | Line: 403 | Upvalues: Utils (copy) ]]
	local t = { Utils.ConnectAndExecuteWiths(p1.ChildAdded, p2, p1:GetChildren()) }
	if p3 then
		table.insert(t, p1.ChildRemoved:Connect(p3))
	end
	return t
end
function t.CreateWith(p1, p2, p3, p4) --[[ CreateWith | Line: 411 | Upvalues: t (copy) ]]
	local v1 = Instance.new(p2)
	v1.Name = p1
	if p4 then
		t.SetProperties({ v1 }, p4)
	end
	v1.Parent = p3
	return v1
end
function t.LoadModuleScripts(p1, p2) --[[ LoadModuleScripts | Line: 421 | Upvalues: t (copy) ]]
	local t2 = {}
	local v1 = p2 and p2.SimpleName
	local v2 = if p2 then p2.Filter else p2
	local v3 = if p2 then p2.Renamer else p2
	local v4 = if p2 then p2.PathInstanceRenamer else p2
	local v5 = p2 and p2.Debug
	local v7
	for v8, v9 in p2 and p2.OnlyChild and p1:GetChildren() or p1:GetDescendants() do
		if v9:IsA("ModuleScript") and (not v2 or v2(v9)) then
			v7 = v9.Name
			if v3 then
				v7 = v3(v9, v7) or v7
			end
			local v10 = t.GetPathIn(v9, p1, {
				Renamer = v4
			})
			v10[#v10] = v7
			local v11 = table.concat(v10, ".")
			local v12, v13 = xpcall(function() --[[ Line: 443 | Upvalues: v5 (copy), v9 (copy), t2 (copy), v11 (copy), v1 (copy), v7 (ref), p2 (copy) ]]
				if v5 then
					print("loading", v9)
				end
				local v12 = require(v9)
				t2[v11] = v12
				if v1 and not t2[v9.Name] then
					t2[v7] = v12
				end
				if typeof(v12) == "table" then
					v12._name_raw = v9.Name
					v12._name = v7
					v12._path = v11
				end
				if p2 and p2.OnLoad then
					p2.OnLoad(v9, v12)
				end
			end, function(p1) --[[ Line: 460 ]]
				return p1 .. "\n" .. debug.traceback(nil, 2)
			end)
			if not v12 then
				warn(v13)
			end
		end
	end
	return t2
end
function t.ForeachDescendants(p1, p2, p3) --[[ ForeachDescendants | Line: 470 ]]
	for v1, v2 in p1:GetDescendants() do
		if not p3 or p3(v2) then
			p2(v2)
		end
	end
end
function t.ForeachDescendantsByRecursion(p1, p2, p3) --[[ ForeachDescendantsByRecursion | Line: 483 | Upvalues: TaskUtils (copy) ]]
	local v1 = if p3 then p3.Filter else p3
	local v2 = if p3 then p3.RecursionFilter else p3
	local v3 = if p3 then p3.ParentFirst else p3
	local t = { p1 }
	local t2 = {}
	while #t > 0 or #t2 > 0 do
		if #t == 0 then
			t, t2 = t2, {}
		end
		for v5, v6 in table.remove(t):GetChildren() do
			local v4
			if v1 and not v1(v6) then
				v4 = false
			else
				task.spawn(p2, v6)
				v4 = true
			end
			if not v2 or v2(v6, v4) then
				if v3 then
					table.insert(t2, v6)
				else
					table.insert(t, v6)
				end
			end
			TaskUtils.ExecuteWait()
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 546 ]]
	if typeof(p1) == "table" then
		for v1, v2 in p1 do
			v2:Destroy()
		end
	else
		p1:Destroy()
	end
end
function t.Is(p1, p2) --[[ Is | Line: 556 ]]
	return if p1 then p1:IsA(p2) and p1 else p1
end
function t.CanTransparent(p1) --[[ CanTransparent | Line: 560 ]]
	if p1 then
		return p1:IsA("BasePart") or (p1:IsA("Decal") or p1:IsA("Texture"))
	end
end
function t.CanEnable(p1) --[[ CanEnable | Line: 567 ]]
	if p1 then
		return p1:IsA("ParticleEmitter") or (p1:IsA("Smoke") or (p1:IsA("Fire") or (p1:IsA("Light") or (p1:IsA("Sparkles") or (p1:IsA("Trail") or (p1:IsA("Beam") or (p1:IsA("BillboardGui") or p1:IsA("SurfaceGui"))))))))
	end
end
function t.GetCFrame(p1) --[[ GetCFrame | Line: 582 ]]
	if p1:IsA("BasePart") then
		return p1.CFrame
	elseif p1:IsA("Attachment") then
		return p1.WorldCFrame
	else
		if not p1:IsA("Model") then
			error("unsupported instance type")
		end
		if p1.PrimaryPart then
			return p1.PrimaryPart.CFrame
		else
			return p1:GetPivot()
		end
	end
end
function t.SetAnimable(p1) --[[ SetAnimable | Line: 598 ]]
	local AnimationController = p1:FindFirstChild("AnimationController")
	if not AnimationController then
		local AnimationController_2 = Instance.new("AnimationController")
		AnimationController_2.Parent = p1
		AnimationController = AnimationController_2
	end
	if not AnimationController:FindFirstChild("Animator") then
		Instance.new("Animator", p1)
	end
	return p1
end
return t