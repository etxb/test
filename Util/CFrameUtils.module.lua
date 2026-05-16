-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.CFrameUtils

-- https://lua.expert/
local t = {
	AtFront = function(p1, p2) --[[ AtFront | Line: 3 ]]
		return (if typeof(p2) == "Vector3" then p1:PointToObjectSpace(p2) else p1:ToObjectSpace(p2)).Z < 0
	end,
	GetRelativeAngleDegree = function(p1, p2) --[[ GetRelativeAngleDegree | Line: 8 ]]
		local v2, v3, v4 = CFrame.lookAt(Vector3.new(0, 0, 0), (p1:PointToObjectSpace(p2))):ToOrientation()
		local v5 = math.deg(v2)
		local v6 = math.deg(v3)
		return Vector3.new(v5, v6, (math.deg(v4)))
	end,
	PointInAngle = function(p1, p2, p3, p4, p5) --[[ PointInAngle | Line: 14 ]]
		local v1 = p1:PointToObjectSpace(p2)
		if v1.Z > 0 then
			return false
		else
			local v2, v3, _ = CFrame.lookAt(Vector3.new(0, 0, 0), v1):ToOrientation()
			if p5 and not (math.abs((math.deg(v2))) <= p5) then
				return false
			end
			return if p4 and not (v1.Magnitude <= p4) then false else math.abs((math.deg(v3))) <= p3
		end
	end,
	RandomPoint = function(p1, p2) --[[ RandomPoint | Line: 26 ]]
		local v1 = math.random() * 2 - 1
		return (p1 * CFrame.new(v1 * (p2.X / 2), 0, (math.random() * 2 - 1) * (p2.Z / 2))).Position
	end,
	PointInArea = function(p1, p2, p3) --[[ PointInArea | Line: 32 ]]
		local v1 = p1:PointToObjectSpace(p3)
		local v2 = p2 / 2
		return if math.abs(v1.X) <= v2.X then if math.abs(v1.Y) <= v2.Y then math.abs(v1.Z) <= v2.Z else false else false
	end,
	Rotation = function(p1, p2) --[[ Rotation | Line: 38 ]]
		local v1, v2, v3 = p1:ToOrientation()
		return CFrame.Angles(v1 * p2.X, v2 * p2.Y, v3 * p2.Z)
	end,
	RotationVector3 = function(p1, p2) --[[ RotationVector3 | Line: 43 ]]
		if not p2 then
			p2 = Vector3.new(1, 1, 1)
		end
		local v1, v2, v3 = p1:ToOrientation()
		return Vector3.new(v1 * p2.X, v2 * p2.Y, v3 * p2.Z)
	end,
	RotationDiff = function(p1, p2, p3) --[[ RotationDiff | Line: 51 ]]
		local v1, v2, v3 = p1:ToOrientation()
		local v4, v5, v6 = p2:ToOrientation()
		return Vector3.new(v4 - v1, v5 - v2, v6 - v3) * p3
	end,
	LookAt = function(p1, p2, p3) --[[ LookAt | Line: 57 ]]
		local Unit = (p2 - p1).Unit
		if Unit == Unit and math.abs(Unit.Y) ~= 1 then
			local v1 = Unit:Cross(Vector3.new(0, 1, 0))
			if v1.Magnitude == 0 then
				v1 = Vector3.new(1, 0, 0)
			end
			local v2 = v1:Cross(Unit)
			if v2.Magnitude == 0 then
				v2 = Vector3.new(0, 1, 0)
			end
			local v3, v4, v5 = CFrame.fromMatrix(p1, v1, v2):ToOrientation()
			return CFrame.new(p1) * CFrame.fromOrientation(v3, v4, v5)
		end
		if p3 then
			return CFrame.new(p1) * p3
		else
			return CFrame.new(p1)
		end
	end
}
function t.InArea(p1, p2) --[[ InArea | Line: 78 | Upvalues: t (copy) ]]
	if p2:IsA("BasePart") then
		local v1 = p2.CFrame:PointToObjectSpace(p1.Position)
		local v2 = if math.abs(v1.X) <= p2.Size.X / 2 then if math.abs(v1.Y) <= p2.Size.Y / 2 then if math.abs(v1.Z) <= p2.Size.Z / 2 then true else false else false else false
		return v2, v2 and p2
	else
		for v3, v4 in p2:GetChildren() do
			local v5, v6 = t.InArea(p1, v4)
			if v5 then
				return v5, v6
			end
		end
	end
end
function t.InAreas(p1, p2) --[[ InAreas | Line: 94 | Upvalues: t (copy) ]]
	for v1, v2 in p2 do
		local v3, v4 = t.InArea(p1, v2)
		if v3 then
			return v3, v2, v4
		end
	end
end
local function lerpRotation(p1, p2, p3, p4) --[[ lerpRotation | Line: 107 ]]
	if math.abs(p1 - p2) >= math.pi then
		if p2 > 0 then
			p2 = p2 - 6.283185307179586
		elseif p2 < 0 then
			p2 = p2 + 6.283185307179586
		end
	end
	local v1 = (p2 - p1) * p3
	if p4 and (p4 > 0 and p4 < math.abs(v1)) then
		v1 = math.sign(v1) * p4
	end
	return p1 + v1
end
function t.LerpRotation(p1, p2, p3, p4) --[[ LerpRotation | Line: 124 ]]
	local v1, v2, v3 = p1.Rotation:ToOrientation()
	local v4, v5, v6 = p2.Rotation:ToOrientation()
	if typeof(p4) == "number" then
		p4 = Vector3.new(1, 1, 1) * p4
	end
	if not p4 then
		p4 = Vector3.new(0, 0, 0)
	end
	local v7 = CFrame.new(p1.Position:Lerp(p2.Position, p3))
	local fromOrientation = CFrame.fromOrientation
	local X = p4.X
	local v9 = (if math.abs(v1 - v4) >= 3.141592653589793 then if v4 > 0 then v4 - 6.283185307179586 elseif v4 < 0 then v4 + 6.283185307179586 else v4 else v4 - v1) * p3
	if X and (X > 0 and X < math.abs(v9)) then
		v9 = math.sign(v9) * X
	end
	local Y = p4.Y
	local v12 = (if math.abs(v2 - v5) >= 3.141592653589793 then if v5 > 0 then v5 - 6.283185307179586 elseif v5 < 0 then v5 + 6.283185307179586 else v5 else v5 - v2) * p3
	if Y and (Y > 0 and Y < math.abs(v12)) then
		v12 = math.sign(v12) * Y
	end
	local Z = p4.Z
	local v15 = (if math.abs(v3 - v6) >= 3.141592653589793 then if v6 > 0 then v6 - 6.283185307179586 elseif v6 < 0 then v6 + 6.283185307179586 else v6 else v6 - v3) * p3
	if Z and (Z > 0 and Z < math.abs(v15)) then
		v15 = math.sign(v15) * Z
	end
	return v7 * fromOrientation(v1 + v9, v2 + v12, v3 + v15)
end
return t