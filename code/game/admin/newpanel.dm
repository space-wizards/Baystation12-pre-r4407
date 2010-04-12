//NEW Administrator Control Panel

//Idea is it'll be a single place to admin from, instead of how we currently have
//like 7 dialogs and 2 categories with admin commands spread around

//Should make managing the server a hell of a lot easier.  For now though, it's really, really incomplete.

//NOTE: See newpanelconfig.dm for configuration for the panel.

/*

Partial list of planned features:

*"You are logged in as ___, a _____" (name, rank)
*Traitor Management
*Full Shuttle Control - All 4 shuttles (prison, supply, emergency [D], syndicate)
*Round Control (Start, Restart, Reboot, Change-Mode) [DONE]
*All the current functionality in the old Admin Panel
*All the current functionality in the admin category
*All the admin-only verbs in the Commands category
*Midround admin promotion (e.g. promote w/o altering admins.txt)

*/

/datum/ModeSelectionItem
	var/FriendlyName = ""
	var/ModeName = ""
	var/Name = ""

/datum/ModeSelectionItem/New(ListName as text, Friendly as text, Mode as text)
	Name = ListName
	FriendlyName = Friendly
	ModeName = Mode



client/Command(C as command_text)

	/*
	Admin Panel command handler
	At this point, a GIANT switch.  This should probably eventually be changed over to multiple smaller subroutines.
	*/

	if (src.holder)

		switch(C)

			if("startnow")
				if(src.holder.level < MINLEVEL_STARTRESTART)
					return alert("You do not have permission to use that command")
				if(ticker)
					world << text("\red <B> Restarting world!</B>\blue  Initiated by []!", usr.key)
					world.log_admin("[usr.key] initiated a reboot.")
					no_end = 0
					spawn(50)
						world.Reboot()
				else
					ticker = new /datum/control/gameticker()
					spawn (0)
						world.log_admin("[usr.key] used start_now")
						ticker.process()
					data_core = new /obj/datacore()
					updateap()

			if("reboot")
				if(src.holder.level < MINLEVEL_REBOOTWORLD)
					return alert("You do not have permission to use that command")
				if(alert("Reboot server?",,"Yes","No") == "No")
					return
				world << text("\red <B> Rebooting world!</B>\blue  Initiated by []!", usr.key)
				world.log_admin("[usr.key] initiated an immediate reboot.")
				no_end = 0
				world.Reboot()

			if("changemode")
				if(src.holder.level < MINLEVEL_CHANGEMODE)
					return alert("You do not have permission to use that command")
				if(ticker)
					return alert("The game has already begun")
				var/list/ModeNames = list()
				for(var/datum/ModeSelectionItem/I in modes)
					ModeNames += I.Name
				ModeNames += "Cancel"
				var/NewModeFName = input("Select New Game Mode", "Change Mode") in ModeNames
				if (NewModeFName == "Cancel")
					return
				var/datum/ModeSelectionItem/NewMode = null
				for(var/datum/ModeSelectionItem/I in modes)
					if (I.Name == NewModeFName)
						NewMode = I
						break
				master_mode = NewMode.ModeName
				var/F = file(persistent_file)
				fdel(F)
				F << master_mode
				world << "\blue The game mode this round has been changed to [NewMode.FriendlyName] \blue by [src.key] ([ranks[src.holder.level+1]])."

			if("delay")
				if(src.holder.level < MINLEVEL_DELAYGAME)
					return alert("You do not have permission to use that command")
				if (ticker)
					return alert("The game has already started")
				going = !( going )
				if (!( going ))
					world << "<B>The game start has been delayed by [src.key] ([ranks[src.holder.level+1]])</B>"
					world.log_admin("[src.key] delayed the game.")
				else
					world << "<B>The game will start soon thanks to [src.key] ([ranks[src.holder.level+1]])</B>"
					world.log_admin("[src.key] removed the delay.")
				updateap()

			if("votemode")
				if(src.holder.level < MINLEVEL_CONTROLVOTES)
					return alert("You do not have permission to use that command")
				global.vote.mode = 1
				global.vote.voting = 1
				global.vote.votetime = world.timeofday + config.vote_period*10

				spawn(config.vote_period*10)
					global.vote.endvote()

				world << "\red<B>*** A vote to change game mode has been initiated by [src.key] ([ranks[src.holder.level+1]])</B>"
				world << "\red     You have [global.vote.timetext(config.vote_period)] to vote."
				world.log_admin("Voting to change mode forced by [ranks[src.holder.level+1]] [src.key]")

			if("voterestart")
				if(src.holder.level < MINLEVEL_CONTROLVOTES)
					return alert("You do not have permission to use that command")
				global.vote.mode = 0
				global.vote.voting = 1
				global.vote.votetime = world.timeofday + config.vote_period*10

				spawn(config.vote_period*10)
					global.vote.endvote()

				world << "\red<B>*** A vote to restart has been initiated by [src.key] ([ranks[src.holder.level+1]])</B>"
				world << "\red     You have [global.vote.timetext(config.vote_period)] to vote."
				world.log_admin("Voting to restart forced by [ranks[src.holder.level+1]] [src.key]")

			if("killvote")
				if(src.holder.level < MINLEVEL_CONTROLVOTES)
					return alert("You do not have permission to use that command")
				world << "\red <B>***Voting aborted by [usr.key] ([ranks[src.holder.level+1]]).</B>"

				world.log_admin("Voting aborted by [ranks[src.holder.level+1]] [usr.key]")

				global.vote.voting = 0
				global.vote.nextvotetime = world.timeofday + 10*config.vote_delay

				for(var/mob/M in world)		// clear vote window from all clients
					if(M.client)
						M << browse(null, "window=vote")
						M.client.showvote = 0

			if("allowenter")
				if(src.holder.level < MINLEVEL_TOGGLE_ENTERING)
					alert("You don't have permission to alter that!")
					updateap()
					return
				var/allowenter = winget(src, "ap_roundcontrol.allowenter", "is-checked") == "true"
				enter_allowed = allowenter
				if (!( enter_allowed ))
					world << "<B>You may no longer enter the game.</B>"
				else
					world << "<B>You may now enter the game.</B>"
				world.log_admin("[usr.key] ([ranks[src.holder.level+1]]) toggled new player game entering.")
				messageadmins("\blue [usr.key] toggled new player game entering.")
				world.update_stat()
				updateap()

			if("allowai")
				if(src.holder.level < MINLEVEL_TOGGLE_AI)
					alert("You don't have permission to alter that!")
					updateap()
					return
				config.allow_ai = winget(src, "ap_roundcontrol.allowai", "is-checked") == "true"
				if (!( config.allow_ai ))
					world << "<B>The AI job is no longer chooseable.</B>"
				else
					world << "<B>The AI job is chooseable now.</B>"
				world.log_admin("[usr.key] ([ranks[src.holder.level+1]]) toggled AI allowed.")
				messageadmins("\blue [usr.key] toggled the AI job.")
				world.update_stat()
				updateap()

			if("allowabandon")
				if(src.holder.level < MINLEVEL_TOGGLE_ABANDON)
					alert("You don't have permission to alter that!")
					updateap()
					return
				abandon_allowed = winget(src, "ap_roundcontrol.allowabandon", "is-checked") == "true"
				if (abandon_allowed)
					world << "<B>You may now abandon your mobs.</B>"
				else
					world << "<B>You may no longer abandon your mobs</B>"
				messageadmins("\blue [usr.key] ([ranks[src.holder.level+1]]) toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
				world.log_admin("[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
				world.update_stat()

			if("worldstart")
				if(src.holder.level < MINLEVEL_CHANGERESTARTMODE)
					alert("You don't have permission to alter that!")
					updateap()
					return
				var/newmode = 0
				if(winget(src, "ap_roundcontrol.world_alldead", "is-checked") == "true")
					newmode = 1
				if(winget(src, "ap_roundcontrol.world_force", "is-checked") == "true")
					newmode = 2
				switch(newmode)
					if(0)
						world << "<B>Automatic world restarts enabled by [usr.key] ([ranks[src.holder.level+1]])</B>"
					if(1)
						world << "<B>Automatic world restarts partially disabled by [usr.key] ([ranks[src.holder.level+1]])</B><br> Restart votes still work, and the world will still reset if everybody dies."
					if(2)
						world << "<B>Automatic world restarts disabled by [usr.key] ([ranks[src.holder.level+1]])</B>"
				no_end = newmode
				updateap()

			if("eshuttle")
				if(src.holder.level < MINLEVEL_CALLSHUTTLE)
					return alert("You do not have permission to use that command")
				if(!ticker)
					return alert("The round hasn't started!")
				if(roundover)
					return alert("The round has ended!")
				if(!shuttlecomming)
					if(!( ticker.timeleft ))
						ticker.timeleft = shuttle_time_to_arrive
					world << "\blue <B>Alert: The emergency shuttle has departed for SS13. It will arrive in [ticker.timeleft/600] minutes.</B>"
					shuttlecomming = 1
					ticker.timing = 1
					messageadmins("\blue [usr.key] ([ranks[src.holder.level+1]]) called the shuttle")
				else if(shuttle_z != 1)
					world << "\blue <B>Alert: The shuttle is going back!</B>"
					shuttlecomming = 0
					ticker.timing = -1.0
					messageadmins("\blue [usr.key] ([ranks[src.holder.level+1]]) sent the shuttle back")
				else
					alert("The shuttle has already arrived on station")
				updateap()

			if("allowooc")
				if(src.holder.level < MINLEVEL_TOGGLE_OOCTALK)
					alert("You don't have permission to alter that!")
					updateap()
					return
				ooc_allowed = winget(src, "ap_roundcontrol.allowooc", "is-checked") == "true"
				if (ooc_allowed)
					world << "<B>The OOC channel has been globally enabled!</B>"
				else
					world << "<B>The OOC channel has been globally disabled!</B>"
				world.log_admin("[usr.key] ([ranks[src.holder.level+1]]) toggled OOC.")
				messageadmins("\blue [usr.key] toggled OOC.")
				updateap()

			else
				..()
	else
		..()

client/proc/SetupAdminPanel()
	src.verbs -= /client/proc/ap
	if(!src.holder) return
	if(src.holder.level >= MINLEVEL_SEEPANEL)
		src.verbs += /client/proc/ap
		SetupPanelAccessibility()

client/proc/SetupPanelAccessibility()
	//TODO Grey out controls you don't have access to
	//     And let you access other controls that you do have access to

client/proc/ap()
	set name = "Administrator Panel 2.0"
	set category = "Commands"
	if(!src.holder) return
	if(src.holder.level < MINLEVEL_SEEPANEL)
		return alert("You do not have permission to see the panel.  Sux2BU")
	winshow(src, "adminpanel",1)


proc/worlddata()
	return "Server active for [round(world.time/10)] game seconds.  Emergency shuttle is [shuttlecomming ? "en route" : "docked at [ shuttle_z == 1 ?"The Station":"CentCom"]"]"

proc/updateap(var/timeonly = 0)

	for(var/client/C)
		if(!C.holder) continue //If not an admin, this doesn't concern them
		if(ticker && ticker.mode)
			winset(C, "ap_roundcontrol.lblroundstatus", "text=\"[worlddata()]\n[ticker.mode.admininfo()]\"")
			winset(C, "ap_roundcontrol.btnstartrestart", "text=\"End Round Now\"")
		else
			winset(C, "ap_roundcontrol.lblroundstatus", "text=\"[worlddata()]\nRound Not Started\"")
			winset(C, "ap_roundcontrol.btnstartrestart", "text=\"Start Round Now\"")

		if (shuttlecomming)
			winset(C, "ap_roundcontrol.btncallshuttle", "text=\"Return Emergency Shuttle\"")
		else
			winset(C, "ap_roundcontrol.btncallshuttle", "text=\"Call Emergency Shuttle\"")

		if(ticker)
			winset(C, "ap_roundcontrol.btndelay", "text=\"Game Started\"&is-disabled=true")
		else
			if(going)
				winset(C, "ap_roundcontrol.btndelay", "text=\"Delay Automatic Start\"")
			else
				winset(C, "ap_roundcontrol.btndelay", "text=\"Allow Automatic Start\"")

		if(timeonly) return

		winset(C, "ap_roundcontrol.allowenter", "is-checked=[ enter_allowed ? "true" : "false"]")
		winset(C, "ap_roundcontrol.allowai", "is-checked=[ config.allow_ai ? "true" : "false"]")
		winset(C, "ap_roundcontrol.allowooc", "is-checked=[ ooc_allowed ? "true" : "false"]")
		winset(C, "ap_roundcontrol.allowabandon", "is-checked=[ abandon_allowed ? "true" : "false"]")
		switch(no_end)
			if(0)
				winset(C, "ap_roundcontrol.world_normal", "is-checked=true")
				winset(C, "ap_roundcontrol.world_alldead", "is-checked=false")
				winset(C, "ap_roundcontrol.world_force", "is-checked=false")
			if(1)
				winset(C, "ap_roundcontrol.world_normal", "is-checked=false")
				winset(C, "ap_roundcontrol.world_alldead", "is-checked=true")
				winset(C, "ap_roundcontrol.world_force", "is-checked=false")
			if(2)
				winset(C, "ap_roundcontrol.world_normal", "is-checked=false")
				winset(C, "ap_roundcontrol.world_alldead", "is-checked=false")
				winset(C, "ap_roundcontrol.world_force", "is-checked=true")
		C << output(apmoblist(C), "ap_playercontrol.browser")
		C << output(aprecords(C.selectedrecord,C), "ap_playerrecords.browser")
proc/apmoblist(client/C)
	var/dat = {"
						<table width="100%">
						<tr>
							<th>Name</th>
							<th>Real Name</th>
							<th>Key</th>
						</tr>
	"}
	for(var/mob/M in world)
		if(M.client || M.hadclient)
			var/foo = "<td><a href=\"byond://?src=\ref[C.holder];changerecord=\ref[M.client.player]\">View Record</a></td>"
			dat += text("<tr><td>[]</td> <td>[]</td> <td>[]</td>[]</tr>", M.name, M.rname, (M.client ? M.client : "No client"), foo)
	dat += "</table>"
	return dat

proc/aprecords(var/player/player,var/client/caller)
	var/dat = ""

	if(player != null)
		dat += "<table width = '100%'><tr><th>[player.name]</th></tr>"
		dat += "<tr><td><center>Last online:[player.activity == -1 ? "currently online (activity: [player.client.inactivity])" : (!player.activity ? "never" : time2text(player.activity))]</center></td></tr>"
		var/player_warning/warning = player.GetBiggestWarning()
		var/text
		if(warning != 0)
			text = warning.state2text()
		else
			text = "No warnings/bans"
		dat += "<tr><td><center>Current Status:<a href=\"byond://?src=\ref[caller.holder];cmd=checkrecord;record=\ref[warning]\">[text]</center></td></tr>"
		//This doesn't work yet
		dat += "<tr><td><center>Associates: "

		for(var/player/P in player.GetLinkedAccounts())
			dat += "<a href=\"byond://?src=\ref[caller.holder];cmd=changerecord=\ref[P]\">[P.name]</a> "

		dat += {"<table width="100%">
<tr>
<th>Past ban/warning history</th>
</tr>
<tr>
<td><b>Author</b></td><td><b>Type</b></td><td><b>Expiration</b></td>
</tr>"}

		for(warning in player.warnings)
			dat += "<tr><td>[warning.author]</td><td>[warning.state2text()]</td><td>[warning.expires2text()]</td></tr>"
		dat += "</table>"

		dat += "<a href=\"byond://?src=\ref[caller.holder];cmd=createwarning=\ref[player]\">Create warning</a>"


		dat += "<br>Choose own name: <a href=\"byond://?src=\ref[caller.holder];togglename=\ref[player]\">[player.choosename ? "yes":"no"]</a>"
	else
		dat += "NO RECORD SELECTED, PLACEHOLDER FOR SEARCH FUNCTION"
	return dat
/proc/SavePlayerData()
	for(var/player/P in global.players) if(P.activity == -1) P.activity = world.realtime
	if(fexists("player_data.sav"))
		fcopy("player_data.sav", "player_data.sav.bak")
		fdel("player_data.sav")
	var/savefile/F = new("player_data.sav")
	F << players
/proc/LoadPlayerData()
	if(fexists("player_data.sav"))
		var/savefile/F = new("player_data.sav")
		F >> players
		for(var/player/P in players)
			for(var/X in P.associates) if(!X) P.associates -= X
	else players = new/list()
/proc/SavePlayerLoop()
	spawn(0)
		while(1)
			sleep(3000)
			SavePlayerData()