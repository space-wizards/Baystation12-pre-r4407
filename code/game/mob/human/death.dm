/mob/human/death()
	if(src.dead())
		return
	if(src.healths)
		src.healths.icon_state = "health5"
	src.stat = DEAD
	emote("deathgasp") //let the world KNOW WE ARE DEAD
	src.canmove = 0
	if(src.client)
		src.blind.layer = 0
	src.lying = 1
	var/h = src.hand
	src.hand = 0
	drop_item()
	src.hand = 1
	drop_item()
	src.hand = h
	var/W = src.wear_suit
	if (istype(W, /obj/item/weapon/clothing/suit/a_i_a_ptank))
		var/obj/item/weapon/clothing/suit/a_i_a_ptank/A = W
//		world << "Detected that [src.key] is wearing a bomb" debug stuff
		if(A.status)
//			world << "Bomb has ignited?"
			A.part4.ignite()

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	store_memory("Time of death: [tod]", 0)
	//src.icon_state = "dead"

	if (ticker.shuttle_location == 1)
		src.unlock_medal("HUMANOID MUST NOT ESCAPE", 1,"Died while escaping to the shuttle","easy")

	if (src.handcuffed)
		src.unlock_medal("Fell Down The Stairs", 1, "Killed while handcuffed.", "easy")

	//For restructuring
	if (ticker.mode.name == "Corporate Restructuring" || ticker.mode.name=="revolution" || istype(ticker.mode,/datum/game_mode/other))
		ticker.check_win()

	if (ticker.mode.name == "wizard" && src == ticker.killer)
		world << "<FONT size = 3><B>Research Station Victory</B></FONT>"
		world << "<B>The Wizard has been killed!</B> The wizards federation has been taught an important lesson."
		ticker.processing = 0
		sleep(100)
		world << "\blue Rebooting due to end of game"
		world.Reboot()

	var/cancel
	for (var/mob/M in world)
		if ((M.client && M.awake()))
			cancel = 1
			break

	if (!cancel)
		spawn (50)
			cancel = 0
			for (var/mob/M in world)
				if (M.client && !M.stat)
					cancel = 1
					break

			if (!cancel)
				world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"
				if(no_end == 1)
					no_end = 0

				if (ticker && ticker.timing)
					ticker.check_win()
				else
					spawn (300)
						world.log_game("Rebooting because of no live players")
						world.Reboot()

	if (src.client)
		spawn(50)
			if(src.client && src.dead())
				src.verbs += /mob/observer/proc/turninghost
	return ..()
