/obj/machinery/atmoalter/canister/proc/update_icon()

	var/air_in = src.gas.tot_gas()

	src.overlays = 0

	if (src.destroyed)
		src.icon_state = text("[]-1", src._color)

	else
		icon_state = "[_color]"
		if(holding)
			overlays += image('canister.dmi', "can-oT")

		if (air_in < 10)
			overlays += image('canister.dmi', "can-o0")
		else if (air_in < (src.gas.maximum * 0.2))
			overlays += image('canister.dmi', "can-o1")
		else if (air_in < (src.maximum * 0.6))
			overlays += image('canister.dmi', "can-o2")
		else
			overlays += image('canister.dmi', "can-o3")
	return


/obj/machinery/atmoalter/canister/vat/update_icon()

	var/air_in = src.gas.tot_gas()

	src.overlays = 0

	if (src.destroyed)
		src.icon_state = "[src._color]-1"

	else
		icon_state = "[_color]"

		if (air_in < 10)
			overlays += image('canister.dmi', "[_color]-o0")
		else if (air_in < (src.gas.maximum * 0.2))
			overlays += image('canister.dmi', "[_color]-o1")
		else if (air_in < (src.maximum * 0.6))
			overlays += image('canister.dmi', "[_color]-o2")
	return



/obj/machinery/atmoalter/canister/proc/healthcheck()
	if (src.health <= 10)
		var/T = src.loc
		if (!( istype(T, /turf) ))
			return
		src.gas.turf_add(T, -1.0)
		src.destroyed = 1
		src.density = 0
		update_icon()
		if (src.holding)
			src.holding.loc = src.loc
			src.holding = null
		if (src.t_status == 2)
			src.t_status = 3
	return

/obj/machinery/atmoalter/canister/process()
	if (src.destroyed)
		return
	if(!allowbigbombs)
		if(src.gas.temperature >= 2300)
			src.health = 0
			healthcheck()
			return
	if(vsc.plc.CANISTER_CORROSION)
		if(gas.plasma > 10000 && !(flags & PLASMAGUARD))
			src.health -= 0.05
			healthcheck()
	var/T = src.loc
	if (istype(T, /turf))
		if (locate(/obj/move, T))
			T = locate(/obj/move, T)
	else
		T = null
	switch(src.t_status)
		if(1.0)
			if (src.holding)
				var/t1 = src.gas.tot_gas()
				var/t2 = t1
				var/t = src.t_per
				if (src.t_per > t2)
					t = t2
				src.holding.gas.transfer_from(src.gas, t)
			else
				if (T)
					var/t1 = src.gas.tot_gas()
					var/t2 = t1
					var/t = src.t_per
					if (src.t_per > t2)
						t = t2
					src.gas.turf_add(T, t)
			src.update_icon()
		if(2.0)
			if (src.holding)
				var/t1 = src.gas.tot_gas()
				var/t2 = src.maximum - t1
				var/t = src.t_per
				if (src.t_per > t2)
					t = t2
				src.gas.transfer_from(src.holding.gas, t)
			else
				src.t_status = 3
			src.update_icon()
		else

	src.updateDialog()
	src.update_icon()
	return

/obj/machinery/atmoalter/canister/New()

	..()
	src.gas = new /obj/substance/gas( src )
	src.gas.maximum = src.maximum
	return

/obj/machinery/atmoalter/canister/get_gas()
	return gas

/obj/machinery/atmoalter/canister/burn(fi_amount)
	src.health -= 1
	healthcheck()
	return

/obj/machinery/atmoalter/canister/blob_act()
	src.health -= 1
	healthcheck()
	return


/obj/machinery/atmoalter/canister/meteorhit(var/obj/O as obj)
	src.health = 0
	healthcheck()
	return

/obj/machinery/atmoalter/canister/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmoalter/canister/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmoalter/canister/attack_hand(var/mob/user as mob)
	if(!allowbigbombs)
		if(src.gas.temperature >= 2300)
			src.health = 0
			healthcheck()
			return
	if (src.destroyed)
		return
	user.machine = src
	var/tt
	switch(src.t_status)
		if(1.0)
			tt = text("Releasing <A href='?src=\ref[];t=2'>Siphon (only tank)</A> <A href='?src=\ref[];t=3'>Stop</A>", src, src)
		if(2.0)
			tt = text("<A href='?src=\ref[];t=1'>Release</A> Siphoning (only tank) <A href='?src=\ref[];t=3'>Stop</A>", src, src)
		if(3.0)
			tt = text("<A href='?src=\ref[];t=1'>Release</A> <A href='?src=\ref[];t=2'>Siphon (only tank)</A> Stopped", src, src)
		else
	var/ct = null
	switch(src.c_status)
		if(1.0)
			ct = text("Releasing <A href='?src=\ref[];c=2'>Accept</A> <A href='?src=\ref[];c=3'>Stop</A>", src, src)
		if(2.0)
			ct = text("<A href='?src=\ref[];c=1'>Release</A> Accepting <A href='?src=\ref[];c=3'>Stop</A>", src, src)
		if(3.0)
			ct = text("<A href='?src=\ref[];c=1'>Release</A> <A href='?src=\ref[];c=2'>Accept</A> Stopped", src, src)
		else
			ct = "Disconnected"


	var/dat = {"<TT><B>Canister Valves</B><BR>
<FONT color = 'blue'><B>Contains/Capacity</B> [num2text(src.gas.tot_gas(), 20)] / [num2text(src.maximum, 20)]</FONT><BR>
Upper Valve Status: [tt]<BR>
\t[(src.holding ? "<A href='?src=\ref[src];tank=1'>Tank ([src.holding.gas.tot_gas()]</A>)" : null)]<BR>
\t<A href='?src=\ref[src];tp=-[num2text(1000000.0, 7)]'>M</A> <A href='?src=\ref[src];tp=-10000'>-</A> <A href='?src=\ref[src];tp=-1000'>-</A> <A href='?src=\ref[src];tp=-100'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> [src.t_per] <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=100'>+</A> <A href='?src=\ref[src];tp=1000'>+</A> <A href='?src=\ref[src];tp=10000'>+</A> <A href='?src=\ref[src];tp=[num2text(1000000.0, 7)]'>M</A><BR>
Pipe Valve Status: [ct]<BR>
\t<A href='?src=\ref[src];cp=-[num2text(1000000.0, 7)]'>M</A> <A href='?src=\ref[src];cp=-10000'>-</A> <A href='?src=\ref[src];cp=-1000'>-</A> <A href='?src=\ref[src];cp=-100'>-</A> <A href='?src=\ref[src];cp=-1'>-</A> [src.c_per] <A href='?src=\ref[src];cp=1'>+</A> <A href='?src=\ref[src];cp=100'>+</A> <A href='?src=\ref[src];cp=1000'>+</A> <A href='?src=\ref[src];cp=10000'>+</A> <A href='?src=\ref[src];cp=[num2text(1000000.0, 7)]'>M</A><BR>
<BR>
<A href='?src=\ref[user];mach_close=canister'>Close</A><BR>
</TT>"}

	user << browse(dat, "window=canister;size=600x300")
	return

/obj/machinery/atmoalter/canister/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	if (((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf)))
		usr.machine = src
		if (href_list["c"])
			var/c = text2num(href_list["c"])
			switch(c)
				if(1.0)
					src.c_status = 1
				if(2.0)
					c_status = 2
				if(3.0)
					src.c_status = 3
		else
			if (href_list["t"])
				var/t = text2num(href_list["t"])
				if (src.t_status == 0)
					return
				switch(t)
					if(1.0)
						src.t_status = 1
					if(2.0)
						if (src.holding)
							src.t_status = 2
						else
							src.t_status = 3
					if(3.0)
						src.t_status = 3
			else
				if (href_list["tp"])
					var/tp = text2num(href_list["tp"])
					src.t_per += tp
					src.t_per = min(max(round(src.t_per), 0), 1000000.0)
				else
					if (href_list["cp"])
						var/cp = text2num(href_list["cp"])
						src.c_per += cp
						src.c_per = min(max(round(src.c_per), 0), 1000000.0)
					else
						if (href_list["tank"])
							var/cp = text2num(href_list["tank"])
							if ((cp == 1 && src.holding))
								src.holding.loc = src.loc
								src.holding = null
								if (src.t_status == 2)
									src.t_status = 3
		src.updateUsrDialog()
		src.add_fingerprint(usr)
		update_icon()
	else
		usr << browse(null, "window=canister")
		return
	return

/obj/machinery/atmoalter/canister/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!allowbigbombs)
		if(src.gas.temperature >= 2300)
			src.health = 0
			healthcheck()
			return

	if ((istype(W, /obj/item/weapon/tank) && !( src.destroyed )))
		if (src.holding)
			return
		var/obj/item/weapon/tank/T = W
		user.drop_item()
		T.loc = src
		src.holding = T
		update_icon()
	else
		if ((istype(W, /obj/item/weapon/wrench)))
			var/obj/machinery/connector/con = locate(/obj/machinery/connector, src.loc)
			var/obj/a_pipe/connector/con2 = locate() in src.loc

			if (src.c_status)
				src.anchored = 0
				src.c_status = 0
				user.show_message("\blue You have disconnected the canister.", 1)
				if(con)
					con.connected = null
				if(con2)
					con2.p_zone.tanks -= src
			else
				if(con && !con.connected && !destroyed)
					src.anchored = 1
					src.c_status = 3
					user.show_message("\blue You have connected the canister.", 1)
					con.connected = src
				else if(con2)
					src.anchored = 1
					src.c_status = 3
					user.show_message("\blue You have connected the canister.", 1)
					con2.p_zone.tanks += src
				else
					user.show_message("\blue There is nothing here with which to connect the canister.", 1)
		else if(istype(W, /obj/item/weapon/analyzer) && get_dist(user, src) <= 1)
			view(3,usr)  << "\red [user] has used the analyzer on \icon[icon]"
			var/total = src.gas.tot_gas()
			var/t1 = 0
			user << "\blue Results of analysis of canister."
			if (total)
				user << "\blue Overall: [total] / [src.gas.maximum]"
				t1 = round( src.gas.n2 / total * 100 , 0.0010)
				user << "\blue Nitrogen: [t1]%"
				t1 = round( src.gas.oxygen / total * 100 , 0.0010)
				user << "\blue Oxygen: [t1]%"
				t1 = round( src.gas.plasma / total * 100 , 0.0010)
				user << "\blue Plasma: [t1]%"
				t1 = round( src.gas.co2 / total * 100 , 0.0010)
				user << "\blue CO2: [t1]%"
				t1 = round( src.gas.sl_gas / total * 100 , 0.0010)
				user << "\blue N2O: [t1]%"
				user << text("\blue Temperature: []&deg;C", src.gas.temperature-T0C)
				src.add_fingerprint(user)
			else
				user << "\blue Tank is empty!"
				src.add_fingerprint(user)
		else
			switch(W.damtype)
				if("fire")
					src.health -= W.force
				if("brute")
					src.health -= W.force * 0.5
				else
			src.healthcheck()
			..()
	return

/obj/machinery/atmoalter/canister/las_act(flag)

	if (flag == "bullet")
		src.health = 0
		spawn( 0 )
			healthcheck()
			return
	if (flag)
		var/turf/T = src.loc
		if (!( istype(T, /turf) ))
			return
		else
			T.firelevel = T.poison
	else
		src.health = 0
		spawn( 0 )
			healthcheck()
			return
	return

/obj/machinery/atmoalter/canister/poisoncanister/New()

	..()
	src.update_icon()
	src.gas.plasma = src.maximum*filled
	return

/obj/machinery/atmoalter/canister/oxygencanister/New()

	..()
	src.gas.oxygen = src.maximum*filled
	return

/obj/machinery/atmoalter/canister/anesthcanister/New()

	..()
	src.gas.sl_gas = src.maximum*filled
	return

/obj/machinery/atmoalter/canister/n2canister/New()

	..()
	src.gas.n2 = src.maximum*filled
	return

/obj/machinery/atmoalter/canister/co2canister/New()

	..()
	src.gas.co2 = src.maximum*filled
	return


/obj/machinery/atmoalter/canister/aircanister/New()

	..()
	src.gas.oxygen = (src.maximum*0.2)*filled
	src.gas.n2 = (src.maximum*0.7)*filled
	return
