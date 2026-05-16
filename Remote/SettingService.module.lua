-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.SettingService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Settings = require(ReplicatedStorage.Common.SettingService.Settings)
require(ReplicatedStorage.Remote.ABTest)
local v1 = TableUtils.SwapKV(Settings)
local v2 = false
local t = {}
for v3, v4 in Settings do
	v4.Name = v3
	if not v4:IsA("StringValue") then
		v4.Changed:Connect(function() --[[ Line: 21 | Upvalues: v2 (ref), t (copy), v4 (copy), v3 (copy) ]]
			if not (v2 or t[v4]) then
				script.UpdateData:FireServer(v3, v4.Value)
			end
		end)
	end
	if RunService:IsStudio() then
		v4.Parent = script
	end
end
local t2 = {
	DataInited = SimpleSignal.new()
}
local t3 = {
	Inited = false,
	Event = t2,
	Settings = Settings
}
function t3.WaitInit() --[[ WaitInit | Line: 43 | Upvalues: t3 (copy), t2 (copy) ]]
	if not t3.Inited then
		t2.DataInited:Wait()
	end
	return t3
end
function t3.OnInit(p1) --[[ OnInit | Line: 50 | Upvalues: t3 (copy), t2 (copy) ]]
	if t3.Inited then
		p1()
	else
		t2.DataInited:Once(p1)
	end
end
function t3.Set(p1, p2) --[[ Set | Line: 58 | Upvalues: v1 (copy), Utils (copy) ]]
	if v1[p1] then
		if Utils.IsSaveableString(p2) then
			local v12, v2 = pcall(function() --[[ Line: 65 | Upvalues: p1 (copy), p2 (copy) ]]
				return script.Set:InvokeServer(p1.Name, p2)
			end)
			if v12 and v2 == true then
				p1.Value = p2
			end
			return if v12 then if v2 == true then true else false else v12, if v2 == -2 then "Network error, please retry later" else false
		else
			return false, "Contains Invalid Character"
		end
	else
		return false, "Unknown Setting"
	end
end
function t3.Reset(p1) --[[ Reset | Line: 74 | Upvalues: v1 (copy) ]]
	if v1[p1] and p1.Value ~= p1:GetAttribute("Default") then
		p1.Value = p1:GetAttribute("Default")
		if p1:IsA("StringValue") then
			task.spawn(function() --[[ Line: 84 | Upvalues: p1 (copy) ]]
				script.Set:InvokeServer(p1.Name)
			end)
		end
	end
end
function t3.ResetAll() --[[ ResetAll | Line: 90 | Upvalues: Settings (copy), t3 (copy) ]]
	for v1, v2 in Settings do
		t3.Reset(v2)
	end
end
function t3.PauseSync(p1) --[[ PauseSync | Line: 96 | Upvalues: v1 (copy), t (copy) ]]
	if v1[p1] and not p1:IsA("StringValue") and not t[p1] then
		t[p1] = {
			Value = p1.Value
		}
	end
end
function t3.ResumeSync(p1, p2) --[[ ResumeSync | Line: 105 | Upvalues: v1 (copy), t (copy) ]]
	if v1[p1] and not p1:IsA("StringValue") then
		local v12 = t[p1]
		t[p1] = nil
		if v12 and p2 then
			p1.Value = v12.Value
		elseif v12 and v12.Value ~= p1.Value then
			script.UpdateData:FireServer(p1.Name, p1.Value)
		end
	end
end
script.UpdateData.OnClientEvent:Connect(function(p1) --[[ Line: 121 | Upvalues: v2 (ref), Settings (copy), t3 (copy), t2 (copy) ]]
	v2 = true
	for v1, v22 in p1 do
		if Settings[v1] then
			if typeof(Settings[v1].Value) == "Color3" then
				Settings[v1].Value = Color3.new(v22.R, v22.G, v22.B)
			end
			Settings[v1].Value = v22
		end
	end
	v2 = false
	t3.Inited = true
	t2.DataInited:Fire()
end)
return t3