-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.AttrService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Types)
require(ReplicatedStorage.Constant)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local NetworkHelper = require(ReplicatedStorage.Common.NetworkHelper)
local AttrService = ReplicatedStorage.Common.AttrService
require(AttrService.AttrDataContainer)
local v1 = SimpleSignal.new()
local v2 = SimpleSignal.new()
local LocalAttrDataContainer = require(script.LocalAttrDataContainer)
local v4 = setmetatable({
	Inited = false,
	DataInited = v1,
	DataUpdated = v2,
	LocalAttrDataContainer = LocalAttrDataContainer
}, require(AttrService))
function v4.GetValue(p1) --[[ GetValue | Line: 30 | Upvalues: LocalAttrDataContainer (copy) ]]
	return LocalAttrDataContainer:GetAttr(p1)
end
function v4.Start() --[[ Start | Line: 34 | Upvalues: NetworkHelper (copy), v4 (copy), LocalAttrDataContainer (copy), v1 (copy) ]]
	NetworkHelper.Packets.AttrService.Packets.packets.UpdateData.listen(function(p1) --[[ Line: 35 | Upvalues: v4 (ref), LocalAttrDataContainer (ref), v1 (ref) ]]
		if v4.Inited or p1.Init then
			LocalAttrDataContainer:LoadAttr(p1.AttrData)
			if p1.Init then
				v4.Inited = true
				v1:Fire()
			end
		end
	end)
	task.spawn(function() --[[ Line: 47 | Upvalues: LocalAttrDataContainer (ref) ]]
		while task.wait(0.06666666666666667) do
			if LocalAttrDataContainer.HasTemp then
				LocalAttrDataContainer:UpdateTemp()
			end
		end
	end)
end
function v4.WaitInit() --[[ WaitInit | Line: 56 | Upvalues: v4 (copy), v1 (copy) ]]
	if not v4.Inited then
		v1:Wait()
	end
	return v4
end
function v4.OnInit(p1) --[[ OnInit | Line: 63 | Upvalues: v4 (copy), v1 (copy) ]]
	if v4.Inited then
		p1()
	else
		v1:Connect(p1)
	end
end
return v4