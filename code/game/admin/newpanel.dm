//NEW Administrator Control Panel

//Idea is it'll be a single place to admin from, instead of how we currently have
//like 7 dialogs and 2 categories with admin commands spread around

//Should make managing the server a hell of a lot easier.  For now though, it's really, really incomplete.

//NOTE: See newpanelconfig.dm for configuration for the panel.

/*

Partial list of planned features:

*"You are logged in as ___, a _____" (name, rank)
*Traitor Management
*Full Shuttle Control (All 4 shuttles [prison, supply, emergency, syndicate])
*Round Control (Start, Restart, Reboot, Change-Mode)
*All the current functionality in the old Admin Panel
*All the current functionality in the admin category
*All the admin-only verbs in the Commands category
*Midround admin promotion (e.g. promote w/o altering admins.txt)

*/

/datum/ModeSelectionItem
	var/FriendlyName = ""
	var/ModeName = ""

/datum/ModeSelectionItem/New(Friendly as text, Mode as text)
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
					sleep(50)
					world.Reboot()
				else
					ticker = new /datum/control/gameticker()
					spawn (0)
						world.log_admin("[usr.key] used start_now")
						ticker.process()
					data_core = new /obj/datacore()

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
				if(src.holder.level < 2)
					return alert("You do not have permission to use that command")
				if(ticker)
					return alert("The game has already begun")
				var/list/ModeNames = list()
				for(var/datum/ModeSelectionItem/I in modes)
					ModeNames += strip_html(I.FriendlyName)
				var/NewModeFName = input("Select New Game Mode", "Change Mode") in ModeNames
				var/datum/ModeSelectionItem/NewMode = null
				for(var/datum/ModeSelectionItem/I in modes)
					if (I.FriendlyName == NewModeFName)
						NewMode = I
						break
				master_mode = NewMode.ModeName
				var/F = file(persistent_file)
				fdel(F)
				F << master_mode
				world << "\blue The game mode this round has been changed to [NewMode.FriendlyName]"

			if("delay")
				if(src.holder.level < 1)
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

			if("votemode")
				if(src.holder.level < MINLEVEL_CONTROLVOTES)
					return alert("You do not have permission to use that command")
				global.vote.mode = 1 	// hack to yield 0=restart, 1=changemode
				global.vote.voting = 1						// now voting
				global.vote.votetime = world.timeofday + config.vote_period*10	// when the vote will end

				spawn(config.vote_period*10)
					global.vote.endvote()

				world << "\red<B>*** A vote to change game mode has been initiated by [src.key] ([src.holder.level+1]])</B>"
				world << "\red     You have [global.vote.timetext(config.vote_period)] to vote."
				world.log_admin("Voting to change mode forced by [src.ranks[src.holder.level+1]] [src.key]")

			if("voterestart")
				if(src.holder.level < MINLEVEL_CONTROLVOTES)
					return alert("You do not have permission to use that command")
				global.vote.mode = 0 	// hack to yield 0=restart, 1=changemode
				global.vote.voting = 1						// now voting
				global.vote.votetime = world.timeofday + config.vote_period*10	// when the vote will end

				spawn(config.vote_period*10)
					global.vote.endvote()

				world << "\red<B>*** A vote to restart has been initiated by [src.key] ([src.holder.level+1]])</B>"
				world << "\red     You have [global.vote.timetext(config.vote_period)] to vote."
				world.log_admin("Voting to restart forced by [src.ranks[src.holder.level+1]] [src.key]")

			if("killvote")
				if(src.holder.level < MINLEVEL_CONTROLVOTES)
					return alert("You do not have permission to use that command")
				world << "\red <B>***Voting aborted by [usr.key].</B>"

				world.log_admin("Voting aborted by [usr.key]")

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
				world.log_admin("[usr.key] toggled new player game entering.")
				messageadmins("\blue [usr.key] toggled new player game entering.")
				world.update_stat()
				updateap()

			if("allowai")
				if(src.holder.level < MINLEVEL_TOGGLE_AI)
					alert("You don't have permission to alter that!")
					updateap()
					return
				var/allowenter = winget(src, "ap_roundcontrol.allowai", "is-checked") == "true"
				config.allow_ai = allowenter
				if (!( config.allow_ai ))
					world << "<B>The AI job is no longer chooseable.</B>"
				else
					world << "<B>The AI job is chooseable now.</B>"
				world.log_admin("[usr.key] toggled AI allowed.")
				messageadmins("\blue [usr.key] toggled the AI job.")
				world.update_stat()
				updateap()

			if("allowabandon")
				if(src.holder.level < MINLEVEL_TOGGLE_ABANDON)
					alert("You don't have permission to alter that!")
					updateap()
					return
				var/allowabandon = winget(src, "ap_roundcontrol.allowabandon", "is-checked") == "true"
				abandon_allowed = allowabandon
				if (abandon_allowed)
					world << "<B>You may now abandon mob.</B>"
				else
					world << "<B>You may no longer abandon mob :(</B>"
				messageadmins("\blue[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
				world.log_admin("[usr.key] toggled abandon mob to [abandon_allowed ? "On" : "Off"].")
				world.update_stat()

			else
				..()
	else
		..()

client/proc/SetupAdminPanel()
	if(!src.holder) return
	src.verbs += /client/proc/ap

	//TODO Grey out controls you don't have access to


client/proc/ap()
	set name = "Administrator Panel 2.0"
	set category = "Commands"
	if(!src.holder) return
	if(src.holder.level < MINLEVEL_SEEPANEL)
		return alert("You do not have permission to see the panel.  Sux2BU")
	winshow(src, "adminpanel",1)


proc/worlddata()
	return "Server active for [round(world.time/10)] game seconds.  Emergency shuttle is [shuttlecomming ? "en route" : "docked at [ shuttle_z == 1 ?"The Station":"CentCom"]"]"

proc/updateap()
	for(var/client/C)
		if(!C.holder) continue //If not an admin, this doesn't concern them
		if(ticker && ticker.mode)
			winset(C, "ap_roundcontrol.lblroundstatus", "text=\"[worlddata()]\n[ticker.mode.admininfo()]\"")
		else
			winset(C, "ap_roundcontrol.lblroundstatus", "text=\"[worlddata()]\nRound Not Started\"")
		winset(C, "ap_roundcontrol.allowenter", "is-checked=[ enter_allowed ? "true" : "false"]")