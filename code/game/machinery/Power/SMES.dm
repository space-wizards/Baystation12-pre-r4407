// the SMES
// stores power

/obj/machinery/power/smes/var/building=0
/obj/machinery/power/smes/New()
	..()

	spawn(5)
		while(building)
			sleep(10)
		dir_loop:
			for(var/d in cardinal)
				var/turf/T = get_step(src, d)
				for(var/obj/machinery/power/terminal/term in T)
					if(term && term.dir == turn(d, 180))
						terminal = term
						break dir_loop

		if(!terminal)
			stat |= BROKEN
			return

		terminal.master = src

		updateicon()

/obj/machinery/power/smes/receivemessage(message,sender)
	if(..())
		return
	var/command = uppertext(stripnetworkmessage(message))
	var/list/listofcommand = dd_text2list(command," ",null)
	if(listofcommand.len < 2)
		return
	if(check_password(listofcommand[1]))
		if(checkcommand(listofcommand,2,"CHARGE"))
			if(checkcommand(listofcommand,3,"AUTO"))
				chargemode = 1
				updateicon()

			else if(checkcommand(listofcommand,3,"OFF"))
				chargemode = 0
				charging = 0
				updateicon()

		else if(checkcommand(listofcommand,2,"OUTPUT"))
			if(checkcommand(listofcommand,3,"ONLINE"))
				online = 1
				updateicon()

			else if(checkcommand(listofcommand,3,"OFFLINE"))
				online = 0
				updateicon()

		else if(checkcommand(listofcommand,2,"ALTERCHARGE") && listofcommand.len >= 3)
			var/num
			num = text2num(listofcommand[3])
			if(num >= 0 && num <= SMESMAXCHARGELEVEL)
				chargelevel = num


		else if(checkcommand(listofcommand,2,"ALTEROUTPUT") && listofcommand.len >= 3)
			var/num
			num = text2num(listofcommand[3])
			if(num >= 0 && num <= SMESMAXOUTPUT)
				output = num

		else if (checkcommand(listofcommand,2,"SENSE"))
			transmitmessage(createmessagetomachine("REPORT POWER [tag] [src.chargemode ? "AUTO" : "OFF"] [src.charging ? "CHARGING" : "NOT CHARGING"] [charge] [src.online ? "ONLINE" : "OFFLINE"] [chargelevel] [output]", sender))


/obj/machinery/power/smes/identinfo()
	return "SMES [src.charging ? "CHARGING" : "NOT CHARGING"] [src.online ? "ONLINE" : "OFFLINE"]"

/obj/machinery/power/smes/attackby(obj/item/weapon/W, mob/user)
	if(building)
		if(istype(W,/obj/item/weapon/circuitry)&&building<3)
			building++
			updateicon()
			del(W)
			return
		if(istype(W,/obj/item/weapon/sheet/metal)&&building>2&&building<5)
			var/obj/item/weapon/sheet/metal/M=W
			if(M.amount<5)
				user<<"Not enough"
				return
			building++
			updateicon()
			if(M.amount==5)
				del(W)
			else M.amount-=5
			capacity=0
			return
		if(istype(W,/obj/item/weapon/circuitry)&&building>=5&&building%2)
			building++
			updateicon()
			capacity+=5e5
			user<<"The current capacity is [capacity]"
			if(building>10)building=10
			del(W)
			return
		if(istype(W,/obj/item/weapon/sheet/metal)&&building>=5&&!(building%2))
			var/obj/item/weapon/sheet/metal/M=W
			if(M.amount<5)
				user<<"Not enough"
				return
			building++
			if(building>9)
				user<<"To upgrade the capacity, add more circuitry, otherwise finish it with metal"
			if(building>11)building=11
			updateicon()
			if(M.amount==5)
				del(W)
			else M.amount-=5
			return
		if(istype(W,/obj/item/weapon/sheet/metal)&&building==11)
			var/obj/item/weapon/sheet/metal/M=W
			if(M.amount<5)
				user<<"Not enough"
				return
			if(z==user.z&&(x==user.x&&(y==user.y+1||y==user.y-1))||(y==user.y&&(x==user.x+1||x==user.x-1)))
				var/obj/machinery/power/terminal/T=new
				T.loc=user.loc
				T.dir=get_dir(user.loc, src)
				building=0
				charge=0
				updateicon()
				if(M.amount==5)
					del(W)
				else M.amount-=5
				spawn(1)
					makepowernets()
				return
			else
				user<<"You must be standing next to the SMES to the north, south, east,or west."
	..()

/obj/machinery/power/smes/updateicon()


	overlays = null
	if(stat & BROKEN)
		return

	if(building)
		overlays +=image('power.dmi', "smes-build[building]")
		return

	overlays += image('power.dmi', "smes-op[online]")

	if(charging)
		overlays += image('power.dmi', "smes-oc1")
	else
		if(chargemode)
			overlays += image('power.dmi', "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += image('power.dmi', "smes-og[clevel]")

/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/capacity)

#define SMESRATE 0.05			// rate of internal charge to external power


/obj/machinery/power/smes/process()

	if(stat & BROKEN || building)
		return


	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = charging
	var/last_onln = online

	if(terminal)
		var/excess = terminal.surplus()

		if(charging)
			if(excess >= 0)		// if there's power available, try to charge

				var/load = min((capacity-charge)/SMESRATE, chargelevel)		// charge at set rate, limited to spare capacity

				charge += load * SMESRATE	// increase the charge

				add_load(load)		// add the load to the terminal side network

			else					// if not enough capcity
				charging = 0		// stop charging
				chargecount  = 0

		else
			if(chargemode)
				if(chargecount > rand(3,6))
					charging = 1
					chargecount = 0

				if(excess > chargelevel)
					chargecount++
				else
					chargecount = 0
			else
				chargecount = 0

	if(online)		// if outputting
		lastout = min( charge/SMESRATE, output)		//limit output to that stored

		charge -= lastout*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)

		add_avail(lastout)				// add output to powernet (smes side)

		if(charge < 0.0001)
			online = 0					// stop output if charge falls to zero

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != charging || last_onln != online)
		updateicon()

	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick

/obj/machinery/power/smes/proc/restore()
	if(stat & BROKEN || building)
		return

	if(!online)
		loaddemand = 0
		return

	var/excess = powernet.netexcess		// this was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(lastout, excess)				// clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity-charge)/SMESRATE, excess)	// for safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// now recharge this amount

	var/clev = chargedisplay()

	charge += excess * SMESRATE
	powernet.netexcess -= excess		// remove the excess from the powernet, so later SMESes don't try to use it

	loaddemand = lastout-excess

	if(clev != chargedisplay() )
		updateicon()


/obj/machinery/power/smes/add_load(var/amount)
	if(terminal && terminal.powernet)
		terminal.powernet.newload += amount

/obj/machinery/power/smes/attack_ai(mob/user)

	add_fingerprint(user)

	if(stat & BROKEN || building) return

	interact(user)

/obj/machinery/power/smes/attack_hand(mob/user)

	add_fingerprint(user)

	if(stat & BROKEN) return
	if(building)
		user<<"The current capacity is [capacity]"
		return

	interact(user)



/obj/machinery/power/smes/proc/interact(mob/user)

	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/ai))
			user.machine = null
			user << browse(null, "window=smes")
			return

	user.machine = src


	var/t = "<TT><B>SMES Power Storage Unit</B> [n_tag? "([n_tag])" : null]<HR><PRE>"

	t += "Stored capacity : [round(100.0*charge/capacity, 0.1)]%<BR><BR>"

	t += "Input: [charging ? "Charging" : "Not Charging"]    [chargemode ? "<B>Auto</B> <A href = '?src=\ref[src];cmode=1'>Off</A>" : "<A href = '?src=\ref[src];cmode=1'>Auto</A> <B>Off</B> "]<BR>"


	t += "Input level:  <A href = '?src=\ref[src];input=-4'>M</A> <A href = '?src=\ref[src];input=-3'>-</A> <A href = '?src=\ref[src];input=-2'>-</A> <A href = '?src=\ref[src];input=-1'>-</A> [add_lspace(chargelevel,5)] <A href = '?src=\ref[src];input=1'>+</A> <A href = '?src=\ref[src];input=2'>+</A> <A href = '?src=\ref[src];input=3'>+</A> <A href = '?src=\ref[src];input=4'>M</A><BR>"

	t += "<BR><BR>"

	t += "Output: [online ? "<B>Online</B> <A href = '?src=\ref[src];online=1'>Offline</A>" : "<A href = '?src=\ref[src];online=1'>Online</A> <B>Offline</B> "]<BR>"

	t += "Output level: <A href = '?src=\ref[src];output=-4'>M</A> <A href = '?src=\ref[src];output=-3'>-</A> <A href = '?src=\ref[src];output=-2'>-</A> <A href = '?src=\ref[src];output=-1'>-</A> [add_lspace(output,5)] <A href = '?src=\ref[src];output=1'>+</A> <A href = '?src=\ref[src];output=2'>+</A> <A href = '?src=\ref[src];output=3'>+</A> <A href = '?src=\ref[src];output=4'>M</A><BR>"

	t += "Output load: [round(loaddemand)] W<BR>"

	t += "<BR></PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	user << browse(t, "window=smes;size=460x300")
	return

/obj/machinery/power/smes/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained() )
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		if(!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
			return
	var/d = 0
	//world << "[href] ; [href_list[href]]"

	if(istype(usr, /mob/ai) && usr.machine==src)
		var/mob/ai/AIusr = usr

		var/password = accesspasswords["[password_smeg]"]
		if( href_list["close"] )
			usr << browse(null, "window=smes")
			usr.machine = null
			return
		else if( href_list["cmode"] == "1" )
			AIusr.sendcommand("[password] CHARGE [chargemode ? "OFF" : "AUTO"]",src)
		else if( href_list["online"] == "1")
			AIusr.sendcommand("[password] OUTPUT O[online ? "FF" : "N"]LINE",src)
		else if( href_list["input"] )
			var/i = text2num(href_list["input"])
			switch(i)
				if(-4)
					d = -chargelevel
				if(4)
					d = SMESMAXCHARGELEVEL		//30000
				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			var/l = chargelevel + d
			l = max(0, min(SMESMAXCHARGELEVEL, l))	// clamp to range

			AIusr.sendcommand("[password] ALTERCHARGE [l]",src)

		else if( href_list["output"] )

			var/i = text2num(href_list["output"])

			switch(i)
				if(-4)
					d = -output
				if(4)
					d = SMESMAXOUTPUT		//30000

				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			var/l = output + d
			l = max(0, min(SMESMAXOUTPUT, l))	// clamp to range
			AIusr.sendcommand("[password] ALTEROUTPUT [l]",src)
		src.updateUsrDialog()



	else if (( usr.machine==src && ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))


		if( href_list["close"] )
			usr << browse(null, "window=smes")
			usr.machine = null
			return

		else if( href_list["cmode"])
			chargemode = !chargemode
			if(!chargemode)
				charging = 0
			updateicon()

		else if( href_list["online"] )
			online = !online
			updateicon()
		else if( href_list["input"] )

			var/i = text2num(href_list["input"])

			switch(i)
				if(-4)
					chargelevel = 0
				if(4)
					chargelevel = SMESMAXCHARGELEVEL		//30000

				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			chargelevel += d
			chargelevel = max(0, min(SMESMAXCHARGELEVEL, chargelevel))	// clamp to range

		else if( href_list["output"] )

			var/i = text2num(href_list["output"])

			switch(i)
				if(-4)
					output = 0
				if(4)
					output = SMESMAXOUTPUT		//30000

				if(1)
					d = 100
				if(-1)
					d = -100
				if(2)
					d = 1000
				if(-2)
					d = -1000
				if(3)
					d = 10000
				if(-3)
					d = -10000

			output += d
			output = max(0, min(SMESMAXOUTPUT, output))	// clamp to range


		src.updateUsrDialog()

	else
		usr << browse(null, "window=smes")
		usr.machine = null

	return
