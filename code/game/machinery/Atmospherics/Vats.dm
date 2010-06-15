/obj/machinery/atmoalter/canister/vat/New()
	..()


/obj/machinery/atmoalter/canister/vat/plasmavat/New()

	..()
	if (locate(/obj/machinery/connector, src.loc))
		src.anchored = 1
		src.c_status = 3

	else if(locate(/obj/a_pipe/connector, src.loc))
		src.anchored = 1
		src.c_status = 3

	else
		del src
	src.gas.plasma = src.maximum*filled
	return

/obj/machinery/atmoalter/canister/vat/attack_ai(mob/user as mob)
	user << "the [name] vat reports [gas.plasma + gas.oxygen] left."

/obj/machinery/atmoalter/canister/vat/attack_hand(mob/user as mob)
	user << "the [name] has: [gas.plasma + gas.oxygen] left."
	return

/obj/machinery/atmoalter/canister/vat/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/atmoalter/canister/vat/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		if(src.c_per != 100000000)
			user << "\blue You break the [src.name] seal.\nI'ts contents start flowing into the connector"
			src.c_per = 100000000
			src.c_status = 1
		else
			user << "\blue The seal is already broken"
	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/B = W
		if (B.welding && (B.weldfuel >= 10))
			if (gas.plasma + gas.oxygen > 4000 && !destroyed)
				if (!confirmed)
					user << "\blue You stop for a moment and ponder the question; \"Do I really want to start disassembling a vat of volatile, highly pressurised gas?\""
					confirmed = 1
					spawn(100)
						confirmed = 0
				else
					user << "\blue You decide you really REALLY want to disassemble that vat."
					var/moo = user.loc
					sleep(30)
					if((gas.plasma + gas.oxygen >= 10000) && user.loc == moo)
						if (gas.plasma > 0)
							health = 0
							healthcheck()

							var/turf/T = src.loc // gladly stolen from the igniter

							if (!( istype(T, /turf) ))
								T = T.loc
							if (!( istype(T, /turf) ))
								T = T.loc
							if (locate(/obj/move, T))
								T = locate(/obj/move, T)
							else
								if (!( istype(T, /turf) ))
									return
							if (T.firelevel < 900000.0)
								T.firelevel = T.poison
							else
								return
						if (gas.oxygen > 0)
							usr.bruteloss +=40
							health = 0
							healthcheck()
					else
						user << "\blue The gas escapes with a quiet pshhhhh"
			else
				if(!destroyed)
					usr << "\blue You start disassembling the vat."
					var/moo = user.loc
					sleep(30)
					if (user.loc != moo)
						return
					health = 0
					healthcheck()
					moo = user.loc
					sleep(30)
					if (user.loc != moo)
						return
					del src

				else
					user << "\blue You continue disassembling the vat."
					var/moo = user.loc
					sleep(30)
					if (user.loc != moo)
						return
					del src

/obj/machinery/atmoalter/canister/vat/oxygenvat/New()

	..()
	if (locate(/obj/machinery/connector, src.loc))
		src.anchored = 1
		src.c_status = 3
	else if(locate(/obj/a_pipe/connector, src.loc))
		src.anchored = 1
		src.c_status = 3
	else
		del src
	src.gas.oxygen = src.maximum*filled
	return
