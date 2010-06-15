/obj/machinery/piano
	name = "Piano"
	icon = 'piano.dmi'
	icon_state = "piano"
	density = 1
	var/cooldown = 0
	var/church = 1
	var/sound/S = sound('sound/piano1.wav')
	var/sound/C = sound('sound/piano2.wav')

/obj/machinery/piano/attack_hand(mob/user)
	if(cooldown)
		return
	if(!church)
		for(var/mob/M in viewers(src))
			M.show_message("\blue [user.name] played a tune on the [src.name]!", 3)
			M << S
		cooldown = 1
		spawn(120)
		cooldown = 0
		return
	else
		for(var/mob/M in viewers(src))
			M.show_message("\blue [user.name] played a tune on the [src.name]!", 3)
			M << C
		cooldown = 1
		spawn(120)
		cooldown = 0
		return
