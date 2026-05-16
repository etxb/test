-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.WeaponConfig.Base

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
RunService:IsServer()
RunService:IsClient()
local v1 = RunService:IsStudio()
local v2 = TableUtils.SwapKV({ Constant.WeaponType.SMG, Constant.WeaponType.Rifle, Constant.WeaponType.MachineGun })
local t = {
	Damage = 1,
	AttackRate = 1,
	WalkSpeed = 0,
	SwitchTime = 0.8,
	MeleeDamage = 40,
	Rarity = Constant.Rarity.Common,
	warn = Utils.FunctionFilter(function() --[[ Line: 27 | Upvalues: v1 (copy) ]]
		return v1
	end, warn),
	GetDamage = function(p1) --[[ GetDamage | Line: 31 ]]
		return p1.Damage
	end,
	GetSwitchTime = function(p1) --[[ GetSwitchTime | Line: 35 ]]
		return p1.SwitchTime
	end,
	GetWalkSpeed = function(p1) --[[ GetWalkSpeed | Line: 41 ]]
		return p1.WalkSpeed
	end,
	GetCustomConfig = function(p1, p2) --[[ GetCustomConfig | Line: 47 | Upvalues: TableUtils (copy) ]]
		return TableUtils.OrEmpty(p1.CustomConfig and p1.CustomConfig[p2])
	end,
	HasTag = function(p1, p2) --[[ HasTag | Line: 51 ]]
		return p1.Tags and p1.Tags[p2]
	end,
	IsRarity = function(p1, ...) --[[ IsRarity | Line: 55 ]]
		for v1, v2 in { ... } do
			if p1.SecondaryRarity == v2 or p1.Rarity == v2 then
				return true
			end
		end
	end,
	IsExotic = function(p1) --[[ IsExotic | Line: 63 | Upvalues: Constant (copy) ]]
		return if p1.SecondaryRarity == Constant.Rarity.Exotic then true else p1.SecondaryRarity == Constant.Rarity.Secret
	end,
	IsSecret = function(p1) --[[ IsSecret | Line: 67 | Upvalues: Constant (copy) ]]
		return p1.SecondaryRarity == Constant.Rarity.Secret
	end,
	CanStatTrak = function(p1) --[[ CanStatTrak | Line: 71 | Upvalues: Constant (copy) ]]
		if p1:HasTag(Constant.WeaponTag.Accessory) then
			return false
		elseif p1.WeaponType == Constant.WeaponType.Melee then
			return p1.Name ~= "ClassKnife"
		else
			return not p1:HasTag(Constant.WeaponTag.BaseWeapon)
		end
	end,
	GetRarityDisplay = function(p1) --[[ GetRarityDisplay | Line: 81 | Upvalues: Constant (copy) ]]
		local v1 = p1.SecondaryRarity or p1.Rarity
		return Constant.RarityName[v1] or v1
	end
}
TableUtils.SwapKV({ "Moving", "MovingLeft", "MovingRight", "MovingBack" })
local function loadAnims(p1, p2, p3) --[[ loadAnims | Line: 93 | Upvalues: TableUtils (copy) ]]
	if not p3 then
		p3 = ""
	end
	local t = {
		{
			Instances = p2,
			Prefix = p3
		}
	}
	while #t > 0 do
		local v1 = table.remove(t, 1)
		for v2, v3 in v1.Instances do
			if typeof(v3) == "Instance" then
				local v4 = v3.Name
				if v3:IsA("ObjectValue") then
					v3 = v3.Value
				end
				if v3:IsA("Animation") then
					p1[("%s%s"):format(v1.Prefix, v4)] = v3
				end
				if v3:IsA("Folder") and not v3.Name:find("Disabled") then
					table.insert(t, {
						Instances = TableUtils.Array.InstancesToDict(v3:GetChildren()),
						Prefix = ("%s%s."):format(v1.Prefix, v4)
					})
				end
			end
		end
	end
end
local function buildAnimConfig(p1) --[[ buildAnimConfig | Line: 124 | Upvalues: loadAnims (copy) ]]
	if typeof(p1) == "Instance" then
		p1 = p1:GetChildren()
	end
	if p1._builded then
		return p1
	else
		local t = {}
		loadAnims(t, p1)
		t._builded = true
		return t
	end
end
function t.PreBuild(p1) --[[ PreBuild | Line: 141 ]] end
function t.BuildClientAnim(p1) --[[ BuildClientAnim | Line: 145 | Upvalues: t (copy), loadAnims (copy) ]]
	if p1 ~= t then
		local CharacterAnims = p1.CharacterAnims
		if CharacterAnims then
			local CharacterAnims_2 = p1.CharacterAnims
			if typeof(CharacterAnims_2) == "Instance" then
				CharacterAnims_2 = CharacterAnims_2:GetChildren()
			end
			if CharacterAnims_2._builded then
				CharacterAnims = CharacterAnims_2
			else
				local t2 = {}
				loadAnims(t2, CharacterAnims_2)
				t2._builded = true
				CharacterAnims = t2
			end
		end
		if CharacterAnims ~= false and CharacterAnims ~= p1.CharacterAnims then
			p1.CharacterAnims = CharacterAnims
		end
		if p1.Name and (CharacterAnims == nil and not (p1.PlaceholderWeapon or p1.AccessoryWeapon)) then
			t.warn((("\230\173\166\229\153\168 \"%*\" \230\156\170\233\133\141\231\189\174\232\167\146\232\137\178\229\138\168\231\148\187"):format(p1.Name)))
		end
		if p1.CharacterAnims ~= CharacterAnims or not CharacterAnims then
			p1.CharacterAnims = if CharacterAnims then CharacterAnims else {}
		end
		local FakeArmAnims = p1.FakeArmAnims
		if FakeArmAnims then
			local FakeArmAnims_2 = p1.FakeArmAnims
			if typeof(FakeArmAnims_2) == "Instance" then
				FakeArmAnims_2 = FakeArmAnims_2:GetChildren()
			end
			if FakeArmAnims_2._builded then
				FakeArmAnims = FakeArmAnims_2
			else
				local t2 = {}
				loadAnims(t2, FakeArmAnims_2)
				t2._builded = true
				FakeArmAnims = t2
			end
		end
		if FakeArmAnims ~= false and FakeArmAnims ~= p1.FakeArmAnims then
			p1.FakeArmAnims = FakeArmAnims
		end
		if p1.Name and (FakeArmAnims == nil and not (p1.PlaceholderWeapon or p1.AccessoryWeapon)) then
			t.warn((("\230\173\166\229\153\168 \"%*\" \230\156\170\233\133\141\231\189\174\231\172\172\228\184\128\228\186\186\231\167\176\230\137\139\232\135\130\229\138\168\231\148\187"):format(p1.Name)))
		end
		if p1.FakeArmAnims ~= FakeArmAnims or not FakeArmAnims then
			p1.FakeArmAnims = if FakeArmAnims then FakeArmAnims else {}
		end
		if p1.SwitchForm then
			local SecondCharacterAnims = p1.SecondCharacterAnims
			if SecondCharacterAnims then
				local SecondCharacterAnims_2 = p1.SecondCharacterAnims
				if typeof(SecondCharacterAnims_2) == "Instance" then
					SecondCharacterAnims_2 = SecondCharacterAnims_2:GetChildren()
				end
				if SecondCharacterAnims_2._builded then
					SecondCharacterAnims = SecondCharacterAnims_2
				else
					local t2 = {}
					loadAnims(t2, SecondCharacterAnims_2)
					t2._builded = true
					SecondCharacterAnims = t2
				end
			end
			if SecondCharacterAnims ~= false and SecondCharacterAnims ~= p1.SecondCharacterAnims then
				p1.SecondCharacterAnims = SecondCharacterAnims
			end
			if p1.Name and (SecondCharacterAnims == nil and not (p1.PlaceholderWeapon or p1.AccessoryWeapon)) then
				t.warn((("\230\173\166\229\153\168 \"%*\" \230\156\170\233\133\141\231\189\174\232\167\146\232\137\178\229\138\168\231\148\187"):format(p1.Name)))
			end
			if p1.SecondCharacterAnims ~= SecondCharacterAnims or not SecondCharacterAnims then
				p1.SecondCharacterAnims = if SecondCharacterAnims then SecondCharacterAnims else {}
			end
			local SecondFakeArmAnims = p1.SecondFakeArmAnims
			if SecondFakeArmAnims then
				local SecondFakeArmAnims_2 = p1.SecondFakeArmAnims
				if typeof(SecondFakeArmAnims_2) == "Instance" then
					SecondFakeArmAnims_2 = SecondFakeArmAnims_2:GetChildren()
				end
				if SecondFakeArmAnims_2._builded then
					SecondFakeArmAnims = SecondFakeArmAnims_2
				else
					local t2 = {}
					loadAnims(t2, SecondFakeArmAnims_2)
					t2._builded = true
					SecondFakeArmAnims = t2
				end
			end
			if SecondFakeArmAnims ~= false and SecondFakeArmAnims ~= p1.SecondFakeArmAnims then
				p1.SecondFakeArmAnims = SecondFakeArmAnims
			end
			if p1.Name and (SecondFakeArmAnims == nil and not (p1.PlaceholderWeapon or p1.AccessoryWeapon)) then
				t.warn((("\230\173\166\229\153\168 \"%*\" \230\156\170\233\133\141\231\189\174\231\172\172\228\184\128\228\186\186\231\167\176\230\137\139\232\135\130\229\138\168\231\148\187"):format(p1.Name)))
			end
			if p1.SecondFakeArmAnims ~= SecondFakeArmAnims or not SecondFakeArmAnims then
				p1.SecondFakeArmAnims = if SecondFakeArmAnims then SecondFakeArmAnims else {}
			end
		end
	end
end
function t.BuildClient(p1) --[[ BuildClient | Line: 198 ]]
	p1:BuildClientAnim()
end
local function v3(p1) --[[ closeCollide | Line: 203 | Upvalues: v3 (copy) ]]
	local Handle = p1:FindFirstChild("Handle")
	if Handle and Handle:IsA("BasePart") then
		Handle.RootPriority = 10
	end
	for v1, v2 in p1:GetChildren() do
		if v2:IsA("BasePart") then
			v2.CanCollide = false
			v2.CanQuery = false
			v2.CanTouch = false
			v2.Massless = true
			if not v2:IsA("MeshPart") then
				v2:IsA("UnionOperation")
			end
			v3(v2)
		end
		if v2:IsA("Model") then
			v3(v2)
		end
	end
end
function t.BuildServer(p1) --[[ BuildServer | Line: 224 | Upvalues: v3 (copy) ]]
	if p1.MeleeSeq then
		for v1, v2 in p1.MeleeSeq do
			if not v2.SegmentWeight then
				local sum = 0
				if v2.Segments then
					for v32, v4 in v2.Segments do
						if typeof(v4.Weight) ~= "number" then
							v4.Weight = 1
						end
						sum = sum + v4.Weight
					end
				end
				v2.SegmentWeight = sum
			end
		end
	end
	if p1.FirstPersonModel then
		v3(p1.FirstPersonModel)
	end
	if p1.ThirdPersonModel then
		v3(p1.ThirdPersonModel)
	end
end
function t.Build(p1) --[[ Build | Line: 250 | Upvalues: Constant (copy), t (copy), v2 (copy), TableUtils (copy) ]]
	if not p1.Display then
		p1.Display = p1.Name
		if not p1.Lazy and (not p1.PlaceholderWeapon and p1.WeaponType ~= Constant.WeaponType.Skill) then
			t.warn("\230\173\166\229\153\168", p1.Name, "\230\156\170\233\133\141\231\189\174\229\144\141\231\167\176")
		end
	end
	local WeaponType = p1.WeaponType
	if p1.BulletDamage then
		p1.Damage = p1.BulletDamage
	end
	if not (p1.WeaponModule or p1.AccessoryWeapon) then
		t.warn(p1.Name, "\230\156\170\233\133\141\231\189\174 WeaponModule")
	end
	if p1.Damage and (p1.FullAuto == nil and v2[WeaponType]) then
		p1.FullAuto = true
	end
	local AcceptSlots = p1.AcceptSlots
	if AcceptSlots and AcceptSlots[AcceptSlots[1]] ~= 1 then
		TableUtils.Bid(AcceptSlots, true)
	elseif not AcceptSlots and (not p1.PlaceholderWeapon and p1.WeaponType ~= Constant.WeaponType.Skill) then
		t.warn(p1.Name, "\230\156\170\233\133\141\231\189\174 AcceptSlots")
	end
	if p1.MeleeSeq then
		for v1, v22 in p1.MeleeSeq do
			v22.Num = v1
			v22.Index = v1
			if v22.Segments and v22.Segments then
				for v3, v4 in v22.Segments do
					v4.Num = v3
					v4.Index = v3
				end
			end
		end
	end
end
function t.parent(p1) --[[ parent | Line: 298 ]]
	local v1 = getmetatable(p1)
	return if v1 then v1.__index else v1
end
function t.PostBuildClientAnim(p1) --[[ PostBuildClientAnim | Line: 303 | Upvalues: t (copy) ]]
	if p1.CharacterAnimsInherit ~= false then
		local v1 = t.GetConfig(p1.CharacterAnimsInherit) or p1:parent()
		local CharacterAnims = p1.CharacterAnims
		if v1 and (typeof(v1.CharacterAnims) == "table" and CharacterAnims ~= v1.CharacterAnims) then
			setmetatable(CharacterAnims, {
				__index = v1.CharacterAnims
			})
		end
	end
	if p1.FakeArmAnimsInherit ~= false then
		local v2 = t.GetConfig(p1.FakeArmAnimsInherit) or p1:parent()
		local FakeArmAnims = p1.FakeArmAnims
		if not v2 then
			return
		end
		if typeof(v2.FakeArmAnims) ~= "table" or FakeArmAnims == v2.FakeArmAnims then
			return
		end
		setmetatable(FakeArmAnims, {
			__index = v2.FakeArmAnims
		})
	end
end
function t.PostBuildClient(p1) --[[ PostBuildClient | Line: 321 ]]
	p1:PostBuildClientAnim()
	if p1.PostConfig then
		p1:PostConfig()
	end
end
function t.PostBuildServer(p1) --[[ PostBuildServer | Line: 328 ]] end
function t.PostBuild(p1) --[[ PostBuild | Line: 332 ]] end
local t2 = {}
function t.extends(p1, p2) --[[ extends | Line: 338 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1]
	if not v1 then
		local t = {
			__index = p1
		}
		t2[p1] = t
		v1 = t
	end
	return setmetatable(p2, v1)
end
local v4 = TableUtils.SwapKV({ "number", "Vector2", "Vector3" })
function t.adjust(p1, p2) --[[ adjust | Line: 349 | Upvalues: v4 (copy) ]]
	for v1, v2 in p2 do
		if p1[v1] and v4[typeof(v2)] then
			p2[v1] = p1[v1] + v2
		end
	end
	return p1:extends(p2)
end
return t