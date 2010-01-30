obj/ladder
		icon = 'weap_sat.dmi'
		icon_state = "heater_0"
		density = 1
		opacity = 0
		anchored = 1
		var/level = 5


/obj/ladder/attack_hand(mob/user/M)

	var/whatx = src.x
	var/whaty = src.y
	var/loc/below =
	M.loc.Exit()
	M.move(