-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.Server

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local t = {
	RunningRoom = script.RunningRoom,
	NextGameTime = script.NextGameTime,
	Instance = script,
	GetMode = function() --[[ GetMode | Line: 12 ]]
		if #script.Mode.Value == 0 then
			script.Mode.Changed:Wait()
		end
		return script.Mode.Value
	end,
	GetRawMode = function() --[[ GetRawMode | Line: 19 ]]
		if #script.RawMode.Value == 0 then
			script.RawMode.Changed:Wait()
		end
		return script.RawMode.Value
	end
}
function t.IsMode(...) --[[ IsMode | Line: 26 | Upvalues: t (copy) ]]
	for v1, v2 in { ... } do
		if v2 == t.GetMode() then
			return true
		end
	end
end
function t.IsNewbie() --[[ IsNewbie | Line: 34 | Upvalues: t (copy) ]]
	t.GetMode()
	return script.Newbie.Value
end
function t.IsMobile() --[[ IsMobile | Line: 39 | Upvalues: t (copy) ]]
	t.GetMode()
	return script.Mobile.Value
end
function t.IsTest() --[[ IsTest | Line: 44 | Upvalues: t (copy) ]]
	t.GetMode()
	return script.Test.Value
end
function t.IsLobby() --[[ IsLobby | Line: 49 | Upvalues: t (copy), Constant (copy) ]]
	local isLobby = t.GetMode() == Constant.ServerMode.Lobby
	return isLobby
end
function t.IsTradeLobby() --[[ IsTradeLobby | Line: 53 | Upvalues: t (copy), Constant (copy) ]]
	local isLobby_Trade = t.GetMode() == Constant.ServerMode.Lobby_Trade
	return isLobby_Trade
end
function t.HasLobby() --[[ HasLobby | Line: 57 | Upvalues: t (copy), Constant (copy) ]]
	if t.IsLobby() or t.IsTradeLobby() then
		return true
	else
		return not t.IsMode(Constant.ServerMode.Matchmaking)
	end
end
function t.IsArcade() --[[ IsArcade | Line: 67 | Upvalues: t (copy), Constant (copy) ]]
	return if t.GetMode() == Constant.ServerMode.Arcade or t.GetMode() == Constant.ServerMode.FFA then true else t.GetMode() == Constant.ServerMode.TDM
end
function t.IsMatchmaking() --[[ IsMatchmaking | Line: 71 | Upvalues: t (copy), Constant (copy) ]]
	return if t.GetMode() == Constant.ServerMode.Matchmaking then t.IsReservedServer() else false
end
function t.GetServerType() --[[ GetServerType | Line: 75 ]]
	if #script.ServerType.Value == 0 then
		script.ServerType.Changed:Wait()
	end
	return script.ServerType.Value
end
function t.IsReservedServer() --[[ IsReservedServer | Line: 82 | Upvalues: t (copy) ]]
	return t.GetServerType() == "Reserved"
end
function t.IsPrivateServer() --[[ IsPrivateServer | Line: 86 | Upvalues: t (copy) ]]
	return t.GetServerType() == "Private"
end
function t.GetServerName() --[[ GetServerName | Line: 90 ]]
	if #script.ServerName.Value == 0 then
		script.ServerName.Changed:Wait()
	end
	return script.ServerName.Value
end
function t.GetContinent() --[[ GetContinent | Line: 97 ]]
	if #script.Loc_Continent.Value == 0 then
		script.Loc_Continent.Changed:Wait()
	end
	return script.Loc_Continent.Value
end
function t.GetCountry() --[[ GetCountry | Line: 104 ]]
	if #script.Loc_Country.Value == 0 then
		script.Loc_Country.Changed:Wait()
	end
	return script.Loc_Country.Value
end
return t