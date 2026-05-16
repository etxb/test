-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.GameUtils

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = if RunService:IsServer() then "Server" else "Client"
local v2 = RunService:IsStudio()
local v3 = v2 and false
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local TaskUtils = require(ReplicatedStorage.Util.TaskUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local t = {
	FindModule = function(p1, p2, p3, p4) --[[ FindModule | Line: 19 | Upvalues: InstanceUtils (copy), v2 (copy), v2 (copy) ]]
		local v1 = p3 and InstanceUtils.FindFirst(p1, ("%s.%s"):format(p3, p2)) or p1:FindFirstChild(p2)
		if not (v1 and v1:IsA("ModuleScript")) and p3 then
			if v2 then
				warn(("\230\156\170\230\137\190\229\136\176\230\168\161\229\188\143 %s (%s) \231\154\132%s, \229\176\157\232\175\149\233\128\154\232\191\135\230\168\161\229\188\143\229\164\167\231\177\187\230\159\165\230\137\190..."):format(p2, p3, p4))
			end
			v1 = p1:FindFirstChild(p3)
		end
		if not (v1 and v1:IsA("ModuleScript")) then
			if p1:IsA("ModuleScript") then
				v1 = p1
			end
			if v2 and v1 == p1 then
				warn(("\230\156\170\230\137\190\229\136\176\230\168\161\229\188\143 %s (%s) \229\143\175\231\148\168\231\154\132%s, \228\189\191\231\148\168\230\160\185\230\168\161\229\157\151..."):format(p2, p3 or p2, p4))
			elseif v2 then
				warn(("\230\156\170\230\137\190\229\136\176\230\168\161\229\188\143 %s (%s) \229\143\175\231\148\168\231\154\132%s"):format(p2, p3 or p2, p4))
			end
		end
		if v1 then
			if v2 then
				print(("\229\183\178\232\142\183\229\143\150%s: %s / %s (%s)"):format(p4, v1.Name, p2, p3 or p2))
			end
			return v1:IsA("ModuleScript") and require(v1) or v1
		end
	end
}
({}).__tostring = function(p1) --[[ __tostring | Line: 54 ]]
	return p1[1]
end
function t.NewSymbol(p1) --[[ NewSymbol | Line: 59 ]]
	local v1 = newproxy(true)
	getmetatable(v1).__tostring = function() --[[ Line: 62 | Upvalues: p1 (copy) ]]
		return if p1 then ("symbol:%s"):format(p1) or "symbol_#anonymous#" else "symbol_#anonymous#"
	end
	return v1
end
function t.CreateSymbol(p1, p2) --[[ CreateSymbol | Line: 68 | Upvalues: t (copy) ]]
	local v1 = t.NewSymbol(p2)
	p1.SYMBOL = v1
	p1[v1] = true
	return p1
end
function t.HasSymbol(p1, p2) --[[ HasSymbol | Line: 75 ]]
	return if p2 then p2[p1.SYMBOL] and p2 else p2
end
local v4 = t.NewSymbol("sided")
function t.IsSided(p1) --[[ IsSided | Line: 81 | Upvalues: v4 (copy) ]]
	return if p1 then p1[v4] else p1
end
local function removePrefix(p1, p2) --[[ removePrefix | Line: 85 ]]
	return p1:sub(1, #p2) == p2 and p1:sub(#p2 + 1) or p1
end
local function removeFirstLast(p1, p2, p3) --[[ removeFirstLast | Line: 89 ]]
	if p2 and #p2 < #p1 then
		p1 = p1:sub(1, #p2) == p2 and p1:sub(#p2 + 1) or p1
	end
	if p3 and #p3 < #p1 then
		p1 = p1:sub(#p1 - #p3 + 1) == p3 and p1:sub(1, #p1 - #p3) or p1
	end
	return p1
end
local function connectTable(p1, p2, p3) --[[ connectTable | Line: 119 ]]
	if rawget(p2, p1) then
		setmetatable(p2[p1], {
			__index = function(p12, p2) --[[ __index | Line: 122 | Upvalues: p3 (copy), p1 (copy) ]]
				return p3[p1] and p3[p1][p2]
			end
		})
	end
end
function t.BuildModules(p1, p2, p3, p4) --[[ BuildModules | Line: 142 | Upvalues: InstanceUtils (copy), removeFirstLast (copy), v2 (copy), t (copy), v1 (copy), TaskUtils (copy), v2 (copy), v4 (copy), v3 (copy) ]]
	local v12 = p1.Name
	if #v12 > 6 then
		v12 = v12:sub(1, 6) == "Common" and v12:sub(7) or v12
	end
	local v32 = v12
	local v42 = p4 or v32
	local v5 = p3 and p3.OnCommonLoad
	local v6 = p3 and p3.OnCommonConnect
	local v7 = p3 and p3.OnSideLoad
	local v8 = p3 and p3.OnSideConnect
	local v9 = p3 and p3.ConnectTables
	local v10 = require(p1)
	local v11 = InstanceUtils.LoadModuleScripts(p1, {
		Renamer = function(p1, p2) --[[ Renamer | Line: 154 | Upvalues: removeFirstLast (ref), v32 (copy) ]]
			return removeFirstLast(p2, "Common", v32)
		end,
		PathInstanceRenamer = function(p1, p2) --[[ PathInstanceRenamer | Line: 157 | Upvalues: removeFirstLast (ref), v32 (copy) ]]
			return removeFirstLast(p2, "Common", v32)
		end,
		OnLoad = function(p1, p2) --[[ OnLoad | Line: 160 | Upvalues: v2 (ref), t (ref), v5 (copy) ]]
			if rawget(p2, "__index") ~= p2 and v2 then
				warn(p1, "not set __index yet")
			end
			t.CreateSymbol(p2, p1.Name)
			if v5 then
				v5(p2)
			end
		end
	})
	t.CreateSymbol(v10)
	local v122 = require(p2)
	local v13 = InstanceUtils.LoadModuleScripts(p2, {
		Renamer = function(p1, p2) --[[ Renamer | Line: 177 | Upvalues: removeFirstLast (ref), v1 (ref), v32 (copy) ]]
			return removeFirstLast(p2, v1, v32)
		end,
		PathInstanceRenamer = function(p1, p2) --[[ PathInstanceRenamer | Line: 181 | Upvalues: removeFirstLast (ref), v1 (ref), v32 (copy) ]]
			return removeFirstLast(p2, v1, v32)
		end,
		OnLoad = function(p1, p2) --[[ OnLoad | Line: 185 | Upvalues: v2 (ref) ]]
			if rawget(p2, "__index") ~= p2 and v2 then
				warn(p1, "not set __index yet")
			end
		end
	})
	TaskUtils.ExecuteWait()
	if not t.HasSymbol(v10, v122) then
		setmetatable(v122, v10)
	end
	v10._common = v10
	v10._side = v122
	local t2 = {}
	local function v14(p1) --[[ handleModule | Line: 207 | Upvalues: v13 (copy), v11 (copy), v2 (ref), v42 (ref), t (ref), v1 (ref), v10 (copy), v122 (copy), v14 (copy), t2 (copy), v4 (ref), v7 (copy), v9 (copy), v8 (copy), v3 (ref), v6 (copy) ]]
		local v12 = v13[p1]
		local v22 = v11[p1]
		if v22 then
			if not v12 then
				if v2 then
					warn(("unimplement %s \"%s\" module %s"):format(v1, v42, p1))
				end
				local t3 = {
					Event = {},
					_name_raw = ("%s%s (%s dynamic)"):format(p1, v42, v1)
				}
				t3.__index = t3
				local v32 = getmetatable(v22)
				if v32 == v10 then
					setmetatable(t3, v122)
				else
					local v5 = v14(v32._path)
					if not v5 and v2 then
						warn(("dynamic module \"%s\" can\'t found %s module \"%s\""):format(p1, v1, v32._path))
					end
					setmetatable(t3, v5 or v32)
				end
				v12 = t3
				v13[p1] = t3
			end
			if not t2[v12] then
				t2[v12] = true
				v12[v4] = true
				v22._common = v22
				v22._side = v12
				if v7 then
					v7(v12)
				end
				local v62 = getmetatable(v12)
				if v62 ~= v22 then
					setmetatable(v12, v22)
					if v9 then
						for v72, v82 in v9 do
							if rawget(v12, v82) then
								setmetatable(v12[v82], {
									__index = function(p1, p2) --[[ __index | Line: 122 | Upvalues: v22 (copy), v82 (copy) ]]
										return v22[v82] and v22[v82][p2]
									end
								})
							end
						end
					end
					if v8 then
						v8(v12, v22)
					end
					v12._parent = v22
					if v3 then
						print(("connect (%s) %s \"%s\" to Common \"%s\""):format(v42, v1, v12._path, v22._path or "#base"))
					end
				end
				if getmetatable(v22) ~= v62 then
					setmetatable(v22, v62)
					if v9 then
						for v102, v112 in v9 do
							if rawget(v22, v112) then
								setmetatable(v22[v112], {
									__index = function(p1, p2) --[[ __index | Line: 122 | Upvalues: v62 (copy), v112 (copy) ]]
										return v62[v112] and v62[v112][p2]
									end
								})
							end
						end
					end
					if v6 then
						v6(v22, v62)
					end
					v22._parent = v62
					if v3 then
						print(("connect (%s) Common \"%s\" to %s \"%s\""):format(v42, v22._path, v1, v62._path or "#base"))
					end
				end
			end
			return v12
		else
			if v2 then
				warn(("unimplement Common \"%s\" module %s"):format(v42, p1))
			end
			if v12 then
				t.CreateSymbol(v12)
			end
		end
	end
	for v15, v16 in v11 do
		v14(v15)
		TaskUtils.ExecuteWait()
	end
	if v2 then
		print(v1, v42, "modules", v13)
	end
	return v13
end
local function isLocalPlayer(p1) --[[ isLocalPlayer | Line: 301 | Upvalues: Players (copy) ]]
	return p1 == Players.LocalPlayer
end
local v5 = t.NewSymbol("forwarded")
function t.Forward(p1, p2, p3, p4, p5) --[[ Forward | Line: 307 | Upvalues: v2 (copy), v5 (copy), TableUtils (copy) ]]
	if p3 then
		local v1 = if p4 then p4.Excludes else p4
		local v22 = p4 and p4.EventFirer
		local v3 = p4 and p4.Early
		for v4, v52 in p2 do
			if v4:sub(1, 2) ~= "__" and not (v1 and v1[v4]) then
				local v6 = p1[v4]
				if v6 then
					if getmetatable(v6) and getmetatable(v52) then
						if not v52[v5] then
							v52[v5] = true
							if TableUtils.IsWrappedGet(v6) then
								local function onAdded(p1, p2) --[[ onAdded | Line: 342 | Upvalues: v6 (copy), v3 (copy), p3 (copy), v22 (copy) ]]
									p2:OnConnected(function() --[[ Line: 343 | Upvalues: v6 (ref), p1 (copy), v3 (ref), p3 (ref), v22 (ref), p2 (copy) ]]
										local v1 = v6.GetOrCreate(p1)
										if v3 then
											v1:ConnectEarly(function(p1, ...) --[[ Line: 346 | Upvalues: p3 (ref), v22 (ref), p2 (ref) ]]
												if p3(p1) then
													if v22 then
														v22(p2, p1, ...)
														return
													end
													p2:Fire(p1, ...)
												end
											end)
										else
											v1:ConnectPre(function(p1, ...) --[[ Line: 356 | Upvalues: p3 (ref), v22 (ref), p2 (ref) ]]
												if p3(p1) then
													if v22 then
														v22(p2, p1, ...)
														return
													end
													p2:Fire(p1, ...)
												end
											end)
										end
									end)
								end
								v52.OnAdded(onAdded)
								for v7, v8 in v52 do
									if typeof(v7) == "string" and v7:sub(1, 2) ~= "__" then
										v8:OnConnected(function() --[[ Line: 343 | Upvalues: v6 (copy), v7 (copy), v3 (copy), p3 (copy), v22 (copy), v8 (copy) ]]
											local v1 = v6.GetOrCreate(v7)
											if v3 then
												v1:ConnectEarly(function(p1, ...) --[[ Line: 346 | Upvalues: p3 (ref), v22 (ref), v8 (ref) ]]
													if p3(p1) then
														if v22 then
															v22(v8, p1, ...)
															return
														end
														v8:Fire(p1, ...)
													end
												end)
											else
												v1:ConnectPre(function(p1, ...) --[[ Line: 356 | Upvalues: p3 (ref), v22 (ref), v8 (ref) ]]
													if p3(p1) then
														if v22 then
															v22(v8, p1, ...)
															return
														end
														v8:Fire(p1, ...)
													end
												end)
											end
										end)
									end
								end
								continue
							end
							v52:OnConnected(function() --[[ Line: 379 | Upvalues: v3 (copy), v6 (copy), p3 (copy), v22 (copy), v52 (copy) ]]
								if v3 then
									v6:ConnectEarly(function(p1, ...) --[[ Line: 381 | Upvalues: p3 (ref), v22 (ref), v52 (ref) ]]
										if p3(p1) then
											if v22 then
												v22(v52, p1, ...)
												return
											end
											v52:Fire(p1, ...)
										end
									end)
								else
									v6:ConnectPre(function(p1, ...) --[[ Line: 391 | Upvalues: p3 (ref), v22 (ref), v52 (ref) ]]
										if p3(p1) then
											if v22 then
												v22(v52, p1, ...)
												return
											end
											v52:Fire(p1, ...)
										end
									end)
								end
							end)
						end
						continue
					end
					warn("\229\188\130\229\184\184\231\177\187\229\158\139, \230\151\160\230\179\149\232\189\172\229\143\145", v4)
				end
				if v2 then
					warn("\230\137\190\228\184\141\229\136\176\229\133\168\229\177\128\228\186\139\228\187\182", v4)
				end
			end
		end
	else
		warn("\230\156\170\230\143\144\228\190\155\232\189\172\229\143\145\232\191\135\230\187\164\229\153\168")
	end
end
function t.ForwardLocal(p1, p2, p3, p4) --[[ ForwardLocal | Line: 405 | Upvalues: RunService (copy), isLocalPlayer (copy), t (copy) ]]
	if RunService:IsServer() then
		assert("\228\187\133\229\143\175\229\156\168\229\174\162\230\136\183\231\171\175\232\176\131\231\148\168")
	end
	local v2 = if p3 then p3.Excludes else p3
	local v3 = if p3 then p3.KeepParamter else p3
	local t2 = {
		Early = true,
		Excludes = v2
	}
	t2.EventFirer = not v3 and (function(p1, p2, ...) --[[ Line: 416 ]]
		p1:Fire(...)
	end)
	t.Forward(p1, p2, p3 and p3.LocalFilter or isLocalPlayer, t2, p4)
end
function t.FindModuleTree(p1, p2) --[[ FindModuleTree | Line: 473 ]]
	local v1 = p1[p2]
	local v2 = p2
	while not v1 and v2:find("%.") do
		local v3 = v2:sub(1, #v2 - v2:reverse():find("%."))
		v1 = p1[v3]
		v2 = v3
	end
	return v1, v2
end
function t.GetParent(p1) --[[ GetParent | Line: 485 ]]
	local v1 = getmetatable(p1) or p1._parent
	if v1 and v1 == p1.__index then
		v1 = getmetatable(v1)
	end
	local v3 = if v1 then v1.__index else v1
	if v3 then
		if typeof(v3) == "function" then
			return nil, v3
		else
			return v3
		end
	end
end
local v6 = t.NewSymbol("extendedTable")
function t.GetExtendedTable(p1, p2, p3) --[[ GetExtendedTable | Line: 506 | Upvalues: v6 (copy), t (copy) ]]
	local v1 = rawget(p1, p2)
	if not v1 then
		v1 = {
			[v6] = true
		}
		function v1.__index(p1, p2) --[[ Line: 510 | Upvalues: v1 (ref), p3 (copy) ]]
			local v12 = v1[p2]
			if v12 then
				p1[p2] = v12
			end
			return v12
		end
		p1[p2] = v1
		local v2 = t.GetParent(p1)
		if typeof(v2) == "table" then
			local v3 = t.GetExtendedTable(v2, p2)
			if v3 then
				setmetatable(v1, v3)
			end
		end
	end
	return v1
end
local v7 = TableUtils.SwapKV({ "_common", "_side" })
local v8 = t.NewSymbol("parentCached")
function t.CacheParent(p1, p2) --[[ CacheParent | Line: 542 | Upvalues: v8 (copy), t (copy), Utils (copy), v7 (copy), v4 (copy) ]]
	if rawget(p1, v8) then
	else
		local v2, v3 = t.GetParent(p1)
		if v2 then
			p1[v8] = true
			local v42 = t.CacheParent(v2)
			for v5, v6 in p1 do
				if (typeof(v5) ~= "string" or not Utils.StringStartsWith(v5, "__")) and (typeof(v6) == "table" and (v6 ~= p1 and not (p2 and p2[v5])) and (not v7[v5] and v5 ~= "_parent")) then
					t.CacheParent(v6)
				end
			end
			for v72, v82 in v2 do
				if v82 ~= v4 and (v72 ~= v8 and (v72 ~= "_parent" and (typeof(v72) ~= "string" or not Utils.StringStartsWith(v72, "__")))) and rawget(p1, v72) == nil then
					p1[v72] = v82
				end
			end
			setmetatable(p1, v42 or nil)
			p1._parent = v2
		else
			return v3
		end
	end
end
function t.CacheParentForeach(p1, p2) --[[ CacheParentForeach | Line: 585 | Upvalues: v2 (copy), t (copy) ]]
	for v1, v22 in p1 do
		t.CacheParent(v22, p2)
	end
end
return t