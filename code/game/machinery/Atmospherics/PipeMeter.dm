/obj/machinery/meter/New()
	..()
	average = 0
	return

/obj/machinery/meter/receivemessage(message as text, var/obj/machinery/srcmachine)
	if(..())
		return
	var/list/commands = getcommandlist(message)
	if(commands.len < 1)
		return
	if(checkcommand(commands,1,"SENSE"))
		transmitmessage(createmessagetomachine("REPORT FLOW [round(100*abs(average)/6e6, 0.1)] [round(target.pl.gas.temperature,0.1)]", srcmachine))

/obj/machinery/meter/process()
	src.target = locate(/obj/machinery/pipes, src.loc)
	if(!target)
		icon_state = "meterX"
		return
	if(stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return

	use_power(5)

	average = 0.5 * average + 0.5 * target.pl.flow

	var/val = min(18, round( 18.99 * ((abs(average) / 2500000)**0.25)) )
	icon_state = "meter[val]"

/obj/machinery/meter/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/meter/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/meter/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if (get_dist(user, src) <= 3 || istype(user, /mob/ai))
		if (src.target)
			user << text("\blue <B>Results:</B>\nMass flow []%\nTemperature [] K", round(100*abs(average)/6e6, 0.1), round(target.pl.gas.temperature,0.1))
		else
			user << "\blue <B>Results: Connection Error!</B>"
	else
		user << "\blue <B>You are too far away.</B>"
	return