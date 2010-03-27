/mob/monkey/death()
	if(src.dead())
		return
	var/cancel
	if (src.healths)
		src.healths.icon_state = "health5"
	src.stat = DEAD
	src.canmove = 0
	if (src.blind)
		src.blind.layer = 0
	src.lying = 1

	var/h = src.hand
	src.hand = 0
	drop_item()
	src.hand = 1
	drop_item()
	src.hand = h

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	store_memory("Time of death: [tod]", 0)

		//For restructuring
	if(ticker.mode.name == "Corporate Restructuring")
		ticker.check_win()

	//src.icon_state = "dead"
	for(var/mob/M in world)
		if (M.client && M.awake())
			cancel = 1
			break
	if (!( cancel ))
		world << "<B>Everyone is dead! Resetting in 30 seconds!</B>"
		if(no_end == 1)
			no_end = 0
		if ((ticker && ticker.timing))
			ticker.check_win()
		else
			spawn( 300 )
				world.log_game("Rebooting because of no live players")
				world.Reboot()
				return
	src.verbs += /mob/observer/proc/turninghost
	return ..()