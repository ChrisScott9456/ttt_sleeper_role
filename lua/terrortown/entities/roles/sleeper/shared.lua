if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_sleep.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(94, 79, 68, 255)

	self.abbr = "sleep"
	self.survivebonus = 1                   -- points for surviving longer
	self.preventFindCredits = true	        -- can't take credits from bodies
	self.preventKillCredits = true          -- does not get awarded credits for kills
	self.preventTraitorAloneCredits = true  -- no credits
	self.preventWin = false                 -- cannot win unless he switches roles
	self.score.killsMultiplier = 2          -- gets points for killing enemies of their team
	self.score.teamKillsMultiplier = -8     -- loses points for killing teammates
	self.disableSync = true                 -- dont tell the player about his role

	self.unknownTeam = true -- Doesn't know his teammates
	self.defaultTeam = TEAM_INNOCENT -- starts as Innocent Team

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 20,
		traitorButton = 1, -- can use traitor buttons
		shopFallback = SHOP_FALLBACK_TRAITOR -- Disabled since starts as Innocent
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)
end

-- Function to check if any traitors are still alive
local function CheckTraitorAlive()
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetTeam() == TEAM_TRAITOR and ply:Alive() then
			return true
		end
	end

	return false
end

local function ConvertToSleeper(ply)
	ply:UpdateTeam(TEAM_TRAITOR)
	ply:AddCredits(GetConVar("ttt2_sleeper_convert_credits"):GetInt())

	-- Reset their confirmation status, so innocents do not see the player as a traitor
	ply:ResetConfirmPlayer()

	-- Send update to other traitors
	SendFullStateUpdate()
end

if SERVER then
	-- When the last living Traitor dies, convert the Sleeper to the Traitor team
	hook.Add('TTT2PostPlayerDeath', 'TTT2SleeperTraitorDeathCheck', function(victim, _, _)
		if not CheckTraitorAlive() then
			for _, ply in ipairs(player.GetAll()) do
				if ply:GetSubRole() == ROLE_SLEEPER and ply:Alive() then
					ConvertToSleeper(ply)
				end
			end
		end
	end)

	-- Change how the role is displayed
	hook.Add("TTT2SpecialRoleSyncing", "TTT2SleeperDisplayRole", function(ply, tbl)
		for sleep in pairs(tbl) do
			if sleep:GetSubRole() == ROLE_SLEEPER then
				if ply == sleep then
					-- Display the Sleeper as Innocent to themselves
					if ply:GetTeam() == TEAM_INNOCENT then
						tbl[sleep] = {ROLE_INNOCENT, TEAM_INNOCENT}
					end

					-- Display the Sleeper as Traitor to themselves
					if ply:GetTeam() == TEAM_TRAITOR then
						tbl[sleep] = {ROLE_SLEEPER, TEAM_TRAITOR}
					end
				else
					-- Display the Sleeper as none to everyone else
					tbl[sleep] = {ROLE_NONE, TEAM_NONE}
				end
			end
		end
	end)
end
