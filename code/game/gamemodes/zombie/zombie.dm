// future site for the zombie gamemode
/*
/obj/machinery/bendydoor // a bolted down airlock that is being bended open by zombies.
	icon = 'zombiedamage.dmi'
	icon_state = "bendy0"
	var/bendedness = 0
	var/cooldown = 0
	var/destroyed = 0

/obj/machinery/bendydoor/attack_hand()
	var count = 0
	for (mob/human/M in orange(2,src))
		count += 1
	if (count > 3 && !cooldown)
		bendedness += 1
		icon_state = "bendy[bendedness]"
		cooldown = 1
		spawn(15)
			cooldown = 0
		*/