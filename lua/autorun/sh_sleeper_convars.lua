--ConVar syncing
CreateConVar("ttt2_sleeper_convert_credits", "1", {FCVAR_ARCHIVE, FCVAR_NOTFIY})

hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicSleeperCVars", function(tbl)
	tbl[ROLE_SLEEPER] = tbl[ROLE_SLEEPER] or {}
	
	--# How many credits should the Sleeper get after they convert to the Traitor team?
	--  ttt2_sleeper_convert_credits [0..n] (default: 1)
	table.insert(tbl[ROLE_SLEEPER], {
		cvar = "ttt2_sleeper_convert_credits",
		slider = true,
		min = 0,
		max = 100,
		decimal = 0,
		desc = "ttt2_sleeper_convert_credits (Def: 1)"
	})
end)

hook.Add("TTT2SyncGlobals", "AddSleeperGlobals", function()
	SetGlobalInt("ttt2_sleeper_convert_credits", GetConVar("ttt2_sleeper_convert_credits"):GetInt())
end)

cvars.AddChangeCallback("ttt2_sleeper_convert_credits", function(name, old, new)
	SetGlobalInt("ttt2_sleeper_convert_credits", tonumber(new))
end)