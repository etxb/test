-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.WishlistService

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local LocalWishlistStore = require(script.LocalWishlistStore)
local t = {
	DataInited = SimpleSignal.new()
}
local t2 = {
	Inited = false,
	Event = t,
	LocalWishlistStore = LocalWishlistStore
}
function t2.WaitInit() --[[ WaitInit | Line: 18 | Upvalues: t2 (copy), t (copy) ]]
	if not t2.Inited then
		t.DataInited:Wait()
	end
	return t2
end
function t2.OnInit(p1) --[[ OnInit | Line: 25 | Upvalues: t2 (copy), t (copy) ]]
	if t2.Inited then
		p1()
	else
		t.DataInited:Connect(p1)
	end
end
function t2.Start() --[[ Start | Line: 33 | Upvalues: LocalWishlistStore (copy), t2 (copy), t (copy) ]]
	script.UpdateData.OnClientEvent:Connect(function(p1, p2) --[[ Line: 34 | Upvalues: LocalWishlistStore (ref), t2 (ref), t (ref) ]]
		if LocalWishlistStore.Data or not p2 then
			if LocalWishlistStore.Data then
				if p1.Add then
					LocalWishlistStore:Add(p1.Add, {
						Remote = true
					})
				end
				if p1.Remove then
					LocalWishlistStore:Remove(p1.Remove, {
						Remote = true
					})
				end
			end
		else
			LocalWishlistStore.Data = p1
			t2.Inited = true
			t.DataInited:Fire()
		end
	end)
end
return t2