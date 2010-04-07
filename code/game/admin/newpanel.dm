//NEW Administrator Control Panel

//Idea is it'll be a single place to admin from, instead of how we currently have
//like 7 dialogs and 2 categories with admin commands spread around

//Should make managing the server a hell of a lot easier.  For now though, it's really, really incomplete.

//NOTE: See newpanelconfig.dm for configuration for the panel.

/datum/ModeSelectionItem
	var/FriendlyName = ""
	var/ModeName = ""

/datum/ModeSelectionItem/New(Friendly as text, Mode as text)
	FriendlyName = Friendly
	ModeName = Mode

#define ModeItem new /datum/ModeSelectionItem

client/Command(C as command_text)

	/*

	Admin Panel command handler
	TODO:
	  *All the current functionality in the old Admin Panel
	  *All the current functionality in the admin category
	  *Midround Admin control
	  *Fix Bans

	*/

	if (src.holder)

		switch(C)
			if("oldpanel")
				src.player_panel()

			if("startnow")
				if(src.holder.level < 2)
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
				if(src.holder.level < 4)
					return alert("You do not have permission to use that command")
				if(alert("Reboot server?",,"Yes","No") == "No")
					return
				world << text("\red <B> Rebooting world!</B>\blue  Initiated by []!", usr.key)
				world.log_admin("[usr.key] initiated an immediate reboot.")
				no_end = 0
				world.Reboot()

			if("changemode")
				if(src.holder.level < 1)
					return alert("You do not have permission to use that command")
				var/list/ModeNames = list()
				for(var/datum/ModeSelectionItem/I in modes)
					ModeNames += I.FriendlyName
				var/NewModeFName = input("Select New Game Mode", "Change Mode") in ModeNames
				var/datum/ModeSelectionItem/NewMode = null
				for(var/datum/ModeSelectionItem/I in modes)
					if (I.FriendlyName == NewModeFName)
						NewMode = I
						break
				src << NewMode.FriendlyName
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
	winshow(src, "adminpanel",1)