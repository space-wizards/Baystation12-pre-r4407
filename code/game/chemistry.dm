/////////////////////////////// Chemical.dm merge
#define REGULATE_RATE 5


/obj/item/weapon/organ/proc/process()
	return


/obj/item/weapon/organ/proc/receive_chem(chemical as obj)
	return

/obj/item/weapon/organ/external/proc/take_damage(brute, burn)
	if ((brute <= 0 && burn <= 0))
		return 0
	if ((src.brute_dam + src.burn_dam + brute + burn) < src.max_damage)
		src.brute_dam += brute
		src.burn_dam += burn
	else
		var/can_inflict = src.max_damage - (src.brute_dam + src.burn_dam)
		if (can_inflict)
			if (brute > 0 && burn > 0)
				brute = can_inflict/2
				burn = can_inflict/2
				var/ratio = brute / (brute + burn)
				src.brute_dam += ratio * can_inflict
				src.burn_dam += (1 - ratio) * can_inflict
			else
				if (brute > 0)
					brute = can_inflict
					src.brute_dam += brute
				else
					burn = can_inflict
					src.burn_dam += burn
		else
			return 0
	if (src.brute_dam + brute >= (src.max_damage*0.8))
		src.broken = 1
	if (src.broken)
		if (prob(50))
			if (src.owner:stat != 2)
				src.owner:emote("scream")
	return src.update_icon()


/obj/item/weapon/organ/external/proc/heal_damage(brute, burn)
	src.brute_dam = max(0, src.brute_dam - brute)
	src.burn_dam = max(0, src.brute_dam - burn)
	return update_icon()

/obj/item/weapon/organ/external/proc/get_damage()	//returns total damage
	return src.brute_dam + src.burn_dam	//could use src.health?

// new damage icon system
// returns just the brute/burn damage code

/obj/item/weapon/organ/external/proc/d_i_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (src.burn_dam < (src.max_damage * 0.25 / 2))
		tburn = 1
	else if (src.burn_dam < (src.max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (src.brute_dam == 0)
		tbrute = 0
	else if (src.brute_dam < (src.max_damage * 0.25 / 2))
		tbrute = 1
	else if (src.brute_dam < (src.max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3

	return "[tbrute][tburn]"

// new damage icon system
// adjusted to set d_i_state to brute/burn code only (without r_name0 as before)

/obj/item/weapon/organ/external/proc/update_icon()

	var/n_is = "[d_i_text()]"
	if (n_is != src.d_i_state)
		src.d_i_state = n_is
		return 1
	else
		return 0
	return

/obj/substance/proc/leak(turf)
	return

/obj/substance/chemical/proc/volume()
	var/amount = 0
	for(var/item in src.chemicals)
		var/datum/chemical/C = src.chemicals[item]
		if (istype(C, /datum/chemical))
			amount += C.return_property("volume")
	return amount

/obj/substance/chemical/proc/split(amount)
	var/obj/substance/chemical/S = new /obj/substance/chemical( null )
	var/tot_volume = src.volume()
	if (amount > tot_volume)
		amount = tot_volume
		for(var/item in src.chemicals)
			var/C = src.chemicals[item]
			if (istype(C, /datum/chemical))
				S.chemicals[item] = C
				src.chemicals[item] = null
		return S
	else
		if (tot_volume <= 0)
			return S
		else
			for(var/item in src.chemicals)
				var/datum/chemical/C = src.chemicals[item]
				if (istype(C, /datum/chemical))
					var/datum/chemical/N = new C.type( null )
					C.copy_data(N)
					var/amt = C.return_property("volume") * amount / tot_volume
					C.moles -= amt * C.density / C.molarmass
					if (C.moles == 0)
						//C = null
						del(C)
					N.moles += amt * N.density / N.molarmass
					S.chemicals[text("[]", N.name)] = N
			return S
	return

/obj/substance/chemical/proc/transfer_from(var/obj/substance/chemical/S as obj, amount)
	var/volume = src.volume()
	var/s_volume = S.volume()
	if (amount > s_volume)
		amount = s_volume
	if (src.maximum)
		if (amount > (src.maximum - volume))
			amount = src.maximum - volume
	if (amount >= s_volume)
		for(var/item in S.chemicals)
			var/datum/chemical/C = S.chemicals[item]
			if (istype(C, /datum/chemical))
				var/datum/chemical/N = null
				N = src.chemicals[item]
				if (!( N ))
					N = new C.type( null )
					C.copy_data(N)
				N.moles += C.moles
				//C = null
				del(C)
	else
		var/obj/substance/chemical/U = S.split(amount)
		for(var/item in U.chemicals)
			var/datum/chemical/C = U.chemicals[item]
			if (istype(C, /datum/chemical))
				var/datum/chemical/N = src.chemicals[item]
				if (!( N ))
					N = new C.type( null )
					C.copy_data(N)
					src.chemicals[item] = N
				N.moles += C.moles
				//C = null
				del(C)
		//U = null
		del(U)
	var/datum/chemical/C = null
	for(var/t in src.chemicals)
		C = src.chemicals[text("[]", t)]
		if (istype(C, /datum/chemical))
			C.react(src)
	return amount

/obj/substance/chemical/proc/transfer_mob(var/mob/M as mob, amount)
	if (!( ismob(M) ))
		return
	var/obj/substance/chemical/S = src.split(amount)
	for(var/item in S.chemicals)
		var/datum/chemical/C = S.chemicals[item]
		if (istype(C, /datum/chemical))
			C.injected(M)
	//S = null
	del(S)
	return

/obj/substance/chemical/proc/dropper_mob(M as mob, amount)

	if (!( ismob(M) ))
		return
	var/obj/substance/chemical/S = src.split(amount)
	for(var/item in S.chemicals)
		var/datum/chemical/C = S.chemicals[item]
		if (istype(C, /datum/chemical))
			C.injected(M, "eye")
		//Foreach goto(44)
	//S = null
	del(S)
	return

/obj/substance/chemical/Del()

	for(var/item in src.chemicals)
		//src.chemicals[item] = null
		del(src.chemicals[item])
		//Foreach goto(17)
	..()
	return




/* --------------------------

heat = amount * temperature(abs)

heat is conserved between exchanges

---------------------------- */

//fractional multipliers of heat
#define TURF_ADD_FRAC 1		//cooling due to release of gas into tile
#define TURF_TAKE_FRAC 1		//heating due to pressurization into pipework

// Not used?
/obj/substance/gas/leak(T as turf)
	turf_add(T, src.co2 + src.oxygen + src.plasma + src.n2)
	return

/obj/substance/gas/proc/tot_gas()
	return src.co2 + src.oxygen + src.plasma + src.sl_gas + src.n2

/obj/substance/gas/proc/transfer_from(var/obj/substance/gas/target as obj, amount)

	if ((!( istype(target, /obj/substance/gas) ) || !( amount )))
		return
	var/t1 = target.co2 + target.oxygen + target.plasma + target.sl_gas + target.n2
	if (!( t1 ))
		return
	if (amount > t1)
		amount = t1
	var/t2 = src.co2 + src.oxygen + src.plasma + src.sl_gas + src.n2
	if (amount < 0)
		amount = t1
	if ((src.maximum > 0 && (src.maximum - t2) < amount))
		amount = src.maximum - t2
	var/t_oxy = amount * target.oxygen / t1
	var/t_pla = amount * target.plasma / t1
	var/t_co2 = amount * target.co2 / t1
	var/t_sl_gas = amount * target.sl_gas / t1
	var/t_n2 = amount * target.n2 / t1
	var/t3 = t1 + t2
	var/t4 = t2 * src.temperature
	var/t5 = t1 * target.temperature
	if (t3 > 0)
		src.temperature = (t4 + t5) / t3
	src.co2 += t_co2
	src.oxygen += t_oxy
	src.plasma += t_pla
	src.sl_gas += t_sl_gas
	src.n2 += t_n2
	target.oxygen -= t_oxy
	target.co2 -= t_co2
	target.plasma -= t_pla
	target.sl_gas -= t_sl_gas
	target.n2 -= t_n2
	return

/obj/substance/gas/proc/clear()

	src.oxygen = 0
	src.plasma = 0
	src.co2 = 0
	src.sl_gas = 0
	src.n2 = 0
	return

/obj/substance/gas/proc/has_gas()
	return (src.co2 + src.oxygen + src.plasma + src.sl_gas + src.n2) > 0

/obj/substance/gas/proc/turf_add(var/turf/target as turf, amount)

	if (((!( istype(target, /turf) ) && !( istype(target, /obj/move) )) || !( amount )))
		return
	if (locate(/obj/move, target))
		target = locate(/obj/move, target)
	var/t2 = src.co2 + src.oxygen + src.plasma + src.sl_gas + src.n2
	if (amount < 0)
		amount = src.plasma + src.oxygen + src.co2 + src.sl_gas + src.n2
	if (!( t2 ))
		return
	var/t_oxy = amount * src.oxygen / t2
	var/t_pla = amount * src.plasma / t2
	var/t_co2 = amount * src.co2 / t2
	var/t_sl_gas = amount * src.sl_gas / t2
	var/t_n2 = amount * src.n2 / t2

	src.co2 -= t_co2
	src.oxygen -= t_oxy
	src.plasma -= t_pla
	src.sl_gas -= t_sl_gas
	src.n2 -= t_n2

	var/ttotal = target.tot_gas()

	target.oxygen(t_oxy)//gas_add("O2",t_oxy)
	target.co2(t_co2)//gas_add("CO2",t_co2)
	target.poison(t_pla)//gas_add("Plasma",t_pla)
	target.sl_gas(t_sl_gas)//gas_add("N2O",t_sl_gas)
	target.n2(t_n2)//gas_add("N2",t_n2)

	target.temp_set((target.temp() * ttotal + (amount * temperature)*TURF_ADD_FRAC ) /  (ttotal + amount))
	//target.heat += amount * src.temperature
	target.res_vars()
	target.update_again=1

	return

/obj/substance/gas/proc/turf_add_all_oxy(var/turf/target as turf)

	var/t_gas = tot_gas()
	var/t_turf = target.tot_gas()

	if(t_gas>0)

		var/heat_change = oxygen * temperature

		//target.heat += heat_change
		if( (t_turf + oxygen) >0 )
			target.temp_set(( target.temp() * t_turf + heat_change ) / ( t_turf + oxygen ))

		target.oxygen(oxygen)


		var/nonoxy = tot_gas() - oxygen

		if(nonoxy>0)

			temperature = ( temperature * tot_gas() - heat_change )/(nonoxy)
		else
			temperature = T20C

		oxygen = 0
		target.res_vars()

	target.update_again = 1

	return

/obj/substance/gas/proc/turf_take(var/turf/target as turf, amount)

	if (((!( istype(target, /turf) ) && !( istype(target, /obj/move) )) || !( amount )))
		return
	if (locate(/obj/move, target))
		target = locate(/obj/move, target)

	var/t1 = target.per_turf()//target.co2 + target.oxygen + targeT.poison() + target.sl_gas + target.n2
	if (!( t1 ))
		return
	var/t2 = src.co2 + src.oxygen + src.plasma + src.sl_gas + src.n2

	if (amount > 0)
		if ((src.maximum > 0 && (src.maximum - t2) < amount))
			amount = src.maximum - t2
	else
		amount = src.plasma + src.oxygen + src.co2 + src.sl_gas + src.n2

	if (amount > t1)
		amount = t1

	var/turf_total = target.per_turf()//targeT.poison() + target.oxygen + target.co2 + target.sl_gas + target.n2

//	var/heat_gain = (turf_total ? amount / turf_total * target.heat : 0)
//	var/temp_gain = (turf_total ? target.heat / turf_total : 0)

	var/heat_gain = (turf_total ? amount * target.temp() : 0)


	var/t_oxy = amount * target.oxygen() / t1
	var/t_pla = amount * target.poison() / t1
	var/t_co2 = amount * target.co2() / t1
	var/t_sl_gas = amount * target.sl_gas() / t1
	var/t_n2 = amount * target.n2() / t1


	/*

	var/t3 = t1 + t2
	var/t4 = t2 * src.temperature
	var/t5 = t1 * temp_gain
	if (t3 > 0)
		src.temperature = (t4 + t5) / t3
	else
		src.temperature = 0
	*/
	if(t2+amount>0)
		temperature = (temperature*t2 + heat_gain * TURF_TAKE_FRAC)/(t2+amount)


	src.co2 += t_co2
	src.oxygen += t_oxy
	src.plasma += t_pla
	src.sl_gas += t_sl_gas
	src.n2 += t_n2

	target.oxygen(-t_oxy)
	target.co2(-t_co2)
	target.poison(-t_pla)
	target.sl_gas(-t_sl_gas)
	target.n2(-t_n2)
	//target.heat -= heat_gain			// no temp change; we just take a proportional amount of all gases
	target.res_vars()
	return

/* original version
/obj/substance/gas/proc/extract_toxs(var/turf/target as turf)

	if ((!( istype(target, /turf) ) && !( istype(target, /obj/move) )))
		return
	if (locate(/obj/move, target))
		target = locate(/obj/move, target)
	var/co2_diff = target.co2 - 0
	var/oxy_diff = target.oxygen - O2STANDARD
	var/no2_diff = target.sl_gas - 0
	var/n2_diff = target.n2 - N2STANDARD
	var/plas_diff = targeT.poison() - 0
	if (co2_diff < 0)
		co2_diff = 0
	if (oxy_diff < 0)
		oxy_diff = 0
	if (no2_diff < 0)
		no2_diff = 0
	if (n2_diff < 0)
		n2_diff = 0
	if (plas_diff < 0)
		plas_diff = 0
	var/turf_total = targeT.poison() + target.oxygen + target.co2 + target.sl_gas + target.n2
	var/air_total = co2_diff + oxy_diff + no2_diff + n2_diff + plas_diff
	var/heat_gain = (turf_total ? air_total / turf_total * target.heat : null)
	var/temp_gain = (turf_total ? target.heat / turf_total + TD0 : 0)
	src.co2 += co2_diff
	src.oxygen += oxy_diff
	src.sl_gas += no2_diff
	src.n2 += n2_diff
	src.plasma += plas_diff
	target.co2 -= co2_diff
	target.oxygen -= oxy_diff
	target.sl_gas -= no2_diff
	target.n2 -= n2_diff
	targeT.poison() -= plas_diff
	var/t3 = turf_total + air_total
	var/t4 = turf_total * src.temperature
	var/t5 = air_total * temp_gain
	if (t3 > 0)
		src.temperature = (t4 + t5) / t3
	else
		src.temperature = 0
	target.heat -= heat_gain
	target.res_vars()
	return
*/



// modified version
/obj/substance/gas/proc/extract_toxs(var/turf/target as turf)
	if ((!( istype(target, /turf) ) && !( istype(target, /obj/move) )))
		return
	if (locate(/obj/move, target))
		target = locate(/obj/move, target)
	var/co2_diff = max(0, target.co2() - 0)
	var/oxy_diff = max(0,target.oxygen() - O2STANDARD)
	var/no2_diff = max(0, target.sl_gas() - 0)
	var/n2_diff = max(0,target.n2() - N2STANDARD)
	var/plas_diff = max(0,target.poison() - 0)

	var/turf_total = target.per_turf()//targeT.poison() + target.oxygen + target.co2 + target.sl_gas + target.n2
	var/air_total = co2_diff + oxy_diff + no2_diff + n2_diff + plas_diff


	var/heat_gain = (turf_total ? air_total  * target.temp() : null)
	//var/temp_gain = (turf_total ? target.heat / turf_total + TD0 : 0)

	src.co2 += co2_diff
	src.oxygen += oxy_diff
	src.sl_gas += no2_diff
	src.n2 += n2_diff
	src.plasma += plas_diff

	target.co2(-co2_diff)
	target.oxygen(-oxy_diff)
	target.sl_gas(-no2_diff)
	target.n2(-n2_diff)
	target.poison(-plas_diff)


	var/gasheat1 = temperature * tot_gas()
	var/gastot2 = tot_gas() + air_total

	if(gastot2 > 0)
		temperature = (gasheat1 + heat_gain)/( gastot2 )
	else
		temperature = T20C

	var/turftot2 = turf_total - air_total
	if(turftot2>0)
		target.temp_set((target.temp()*turf_total - heat_gain)/(turftot2))

	//target.heat -= heat_gain

	//make stored temperature closer to nominal (20C)
	src.temperature += (T20C - src.temperature) / REGULATE_RATE


	target.res_vars()
	return

//


/obj/substance/gas/proc/merge_into(var/obj/substance/gas/target as obj)

	if (!( istype(target, /obj/substance/gas) ))
		return
	var/s_tot = src.tot_gas()
	var/t_tot = target.tot_gas()
	var/amount = s_tot + t_tot
	if (amount > 0 && t_tot > 0)
		src.temperature = (s_tot*src.temperature + t_tot*target.temperature) / amount

	src.co2 += target.co2
	src.oxygen += target.oxygen
	src.plasma += target.plasma
	src.sl_gas += target.sl_gas
	src.n2 += target.n2
	target.oxygen = 0
	target.plasma = 0
	target.co2 = 0
	target.sl_gas = 0
	target.n2 = 0
	return


// sets src to a given fraction of the gas (without affecting the gas)
/obj/substance/gas/proc/set_frac(var/obj/substance/gas/gas, amount)

	var/tot = gas.tot_gas()

	if(tot>0)		// if gas is 0, do nothing

		var/frac = amount / tot

		src.oxygen = frac * gas.oxygen
		src.co2 = frac * gas.co2
		src.plasma = frac * gas.plasma
		src.sl_gas = frac *	gas.sl_gas
		src.n2 = frac * gas.n2

		src.temperature = gas.temperature


// same as merge_into except the target is not zeroed
// calc temperature from added gas
// delta should always be positive
/obj/substance/gas/proc/add_delta(var/obj/substance/gas/target)


	var/s_tot = src.tot_gas()
	var/t_tot = target.tot_gas()


	if(t_tot < 0)
		world.log << "Called add_delta with negative delta: [src.loc] : [src.tostring()] + [target.tostring()]"

	var/amount = s_tot + t_tot
	if (amount>0)		// only set temp if adding gas, not subtracting
		src.temperature = (s_tot*src.temperature + t_tot*target.temperature) / amount
	src.co2 += target.co2
	src.oxygen += target.oxygen
	src.plasma += target.plasma
	src.sl_gas += target.sl_gas
	src.n2 += target.n2


// subtract a (+ve) delta. Do not affect temperature since just a proportional change
/obj/substance/gas/proc/sub_delta(var/obj/substance/gas/target)

	src.co2 -= target.co2
	src.oxygen -= target.oxygen
	src.plasma -= target.plasma
	src.sl_gas -= target.sl_gas
	src.n2 -= target.n2

/obj/substance/gas/proc/sub_delta_turf(turf/T)

	T.co2(-src.co2)
	T.oxygen(-src.oxygen)
	T.poison(-src.plasma)
	T.sl_gas(-src.sl_gas)
	T.n2(-src.n2)




// replaces gas values of src with n - updates during gas_flow step
/obj/substance/gas/proc/replace_by(var/obj/substance/gas/n)
	oxygen = n.oxygen
	plasma = n.plasma
	sl_gas = n.sl_gas
	co2 = n.co2
	n2 = n.n2
	temperature = n.temperature

	//do nothing to values of n

// relative "specific heat capacity" of gas contents
/obj/substance/gas/proc/shc()
	return 2*co2 + 1.5*n2 + oxygen + 0.5*sl_gas + 1.2*plasma


/datum/chemical/pathogen/proc/process(source as obj)

	return

/datum/chemical/proc/react(S as obj)

	return

/datum/chemical/proc/react_organ(O as obj)

	return

/datum/chemical/proc/injected(M as mob, zone)

	if (zone == null)
		zone = "body"
	return

/datum/chemical/proc/copy_data(var/datum/chemical/C)

	C.molarmass = src.molarmass
	C.density = src.density
	C.chem_formula = src.chem_formula
	return

/datum/chemical/proc/return_property(property)

	switch(property)
		if("moles")
			return src.moles
		if("mass")
			return src.moles * src.molarmass
		if("density")
			return src.density
		if("volume")
			return src.moles * src.molarmass / src.density
		else
	return

/datum/chemical/pl_coag/react(obj/substance/chemical/S as obj)

	var/datum/chemical/l_plas/C = S.chemicals["toxins"]
	if (istype(C, /datum/chemical/l_plas))
		if (C.moles < src.moles)
			src.moles -= C.moles
			var/datum/chemical/waste/W = S.chemicals["waste-l"]
			if (istype(W, /datum/chemical/waste))
				W.moles += C.moles
			else
				W = new /datum/chemical/waste(  )
				S.chemicals["waste-l"] = W
				W.moles += C.moles
			//C = null
			del(C)
		else
			C.moles -= src.moles
			var/datum/chemical/waste/W = S.chemicals["waste-l"]
			if (istype(W, /datum/chemical/waste))
				W.moles += src.moles
			else
				W = new /datum/chemical/waste(  )
				S.chemicals["waste-l"] = W
				W.moles += src.moles
			src.moles = 0
		if (src.moles <= 0)
			//SN src = null
			del(src)
			return
	return

/datum/chemical/pl_coag/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat -= volume * 2
			M.eye_stat = max(0, M.eye_stat)
		if("head")
			M.eye_blurry += volume
		else
			if (M.health >= 0)
				if ((volume * 4) >= M.toxloss)
					M.toxloss = 0
				else
					M.toxloss -= volume * 4
			M.antitoxs += volume * 180
			M.health = 100 - M.oxyloss - M.toxloss - M.fireloss - M.bruteloss
	return

/datum/chemical/l_plas/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat += volume * 5
			M.eye_blurry += volume * 3
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.plasma += volume * 6
			for(var/obj/item/weapon/implant/tracking/T in M)
				M.plasma += 1
				del(T)
	return

/datum/chemical/s_tox/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 10
			M.eye_blurry += volume * 15
		if("head")
			M.eye_blurry += volume
			M.paralysis += volume / 2
			if(M.stat !=2) M.stat = 1
		else
			M.paralysis += volume * 12
			if(M.stat != 2)	M.stat = 1
	return

/datum/chemical/epil/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 5
			M.eye_stat += volume * 2
			M.eye_blurry += volume * 20
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.r_epil += volume * 60
	return

/datum/chemical/fever_pill/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 5
			M.eye_stat += volume * 2
			M.eye_blurry += volume * 20
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.r_fever += volume * 60
	return

/datum/chemical/ch_cou/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 2
			M.eye_stat += volume * 3
			M.eye_blurry += volume * 20
			M << "\red Your eyes start to burn badly!"
			M.disabilities |= BADVISION
			if (prob(M.eye_stat - 20 + 1))
				M << "\red You go blind!"
				M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.r_ch_cou += volume * 60
	return

/datum/chemical/rejuv/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat -= volume * 5
			M.eye_blurry += volume * 5
			M.eye_stat = max(0, M.eye_stat)
		if("head")
			return
		else
			M.rejuv += volume * 3
			if (M.paralysis)
				M.paralysis = 3
			if (M.weakened)
				M.weakened = 3
			if (M.stunned)
				M.stunned = 3
	return


///////////////////////////////

/obj/item/weapon/bottle/examine()
	set src in usr

	usr << text("\blue The bottle \icon[] contains [] millimeters of chemicals", src, round(src.chem.volume(), 0.1))
	return

/obj/item/weapon/bottle/New()

	src.chem = new /obj/substance/chemical(  )
	..()
	return


/obj/item/weapon/bottle/attackby(obj/item/weapon/T as obj, mob/user as mob)

	if (istype(T, /obj/item/weapon/bottle))
		var/t1 = src.chem.maximum
		var/volume = src.chem.volume()
		if (volume < 0.1)
			return
		else
			t1 = volume - 0.1
		t1 = src.chem.transfer_from(T:chem, t1)
		if (t1)
			user.show_message(text("\blue You pour [] unit\s into the bottle. The bottle now contains [] millimeters.", round(t1, 0.1), round(src.chem.volume(), 0.1)))
	if (istype(T, /obj/item/weapon/syringe))
		if (T:mode == "inject")
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.01)
				return
			else
				if (volume < 5.01)
					t1 = volume - 0.01
			t1 = src.chem.transfer_from(T:chem, t1)
			T:update_is()
			if (t1)
				user.show_message(text("\blue You inject [] unit\s into the bottle. The syringe contains [] units.", round(t1, 0.1), round(T:chem.volume(), 0.1)))
		else
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.05)
				return
			else
				if (volume < 5.05)
					t1 = volume - 0.05
			t1 = T:chem.transfer_from(src.chem, t1)
			T:update_is()
			if (t1)
				user.show_message(text("\blue You draw [] unit\s from the bottle. The syringe contains [] units.", round(t1, 0.1), round(T:chem.volume(), 0.1)))
		src.add_fingerprint(user)
	else
		if (istype(T, /obj/item/weapon/dropper))
			if (T:mode == "inject")
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = src.chem.transfer_from(T:chem, t1)
				T:update_is()
				if (t1)
					user.show_message(text("\blue You deposit [] unit\s into the bottle. The dropper contains [] units.", round(t1, 0.1), round(T:chem.volume(), 0.1)))
			else
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = T:chem.transfer_from(src.chem, t1)
				T:update_is()
				if (t1)
					user.show_message(text("\blue You extract [] unit\s from the bottle. The dropper contains [] units.", round(t1, 0.1), round(T:chem.volume(), 0.1)))
	return

/obj/item/weapon/bottle/toxins/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/l_plas/C = new /datum/chemical/l_plas( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/antitoxins/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/pl_coag/C = new /datum/chemical/pl_coag( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/r_epil/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/epil/C = new /datum/chemical/epil( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/r_fever/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/epil/C = new /datum/chemical/fever( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return


/obj/item/weapon/chemistry/b_mercury/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/mercury/C = new /datum/chemical/mercury( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_acid/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/acid/C = new /datum/chemical/acid( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return


/obj/item/weapon/bottle/r_ch_cough/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/ch_cou/C = new /datum/chemical/ch_cou( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/rejuvenators/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/rejuv/C = new /datum/chemical/rejuv( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/s_tox/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/s_tox/C = new /datum/chemical/s_tox( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/bottle/New()

	..()
	src.pixel_y = rand(-8.0, 8)
	src.pixel_x = rand(-8.0, 8)
	return

/obj/item/weapon/chem/beaker/examine()
	set src in usr
	var/chemname
	usr << text("\blue The beaker contains [] millimeters of chemicals.", round(src.chem.volume(), 0.1))
	for (chemname in chem.chemicals)
		usr << text("\blue The beaker contains particles of [chemname].")

	return

/obj/item/weapon/chem/New()

	src.chem = new /obj/substance/chemical(  )
	..()
	return

/obj/item/weapon/chem/beaker/New()

	..()
	src.chem = new /obj/substance/chemical(  )
	src.chem.maximum = 80
	var/datum/chemical/mixing/C = new /datum/chemical/mixing ( null )
	C.moles = 5
	src.chem.chemicals[text("[]", C.name)] = C
	return


/obj/item/weapon/chemistry/New()

	src.chem = new /obj/substance/chemical(  )
	..()
	return

/obj/item/weapon/chemistry/New()

	..()
	src.pixel_y = rand(-6.0, 6)
	src.pixel_x = rand(-6.0, 6)
	return

/obj/item/weapon/chemistry/examine()
	set src in usr
	var/chemname
	usr << text("\blue The container contains [] units of chemicals.", round(src.chem.volume(), 0.1))
	for (chemname in chem.chemicals)
		usr << text("\blue The container contains [chemname] chemicals.")


/obj/item/weapon/chemistry/b_oxygen/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/oxygen/C = new /datum/chemical/oxygen( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_nitrogen/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/nitrogen/C = new /datum/chemical/nitrogen( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_chlorine/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/chlorine/C = new /datum/chemical/chlorine( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_silicate/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/silicate/C = new /datum/chemical/silicate( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_phosphorus/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/phosphorus/C = new /datum/chemical/phosphorus( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_radium/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/radium/C = new /datum/chemical/radium( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_silicon/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/silicon/C = new /datum/chemical/silicon( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_mixing/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/mixing/C = new /datum/chemical/mixing( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_lithium/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/lithium/C = new /datum/chemical/lithium( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_carbon/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/carbon/C = new /datum/chemical/carbon( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_water/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/water/C = new /datum/chemical/water( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_aluminium/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/aluminium/C = new /datum/chemical/aluminium( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_potassium/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/potassium/C = new /datum/chemical/potassium( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_iron/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/iron/C = new /datum/chemical/iron( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_hydrogen/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/hydrogen/C = new /datum/chemical/hydrogen( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chemistry/b_sulfur/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/sulfur/C = new /datum/chemical/sulfur( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return


/obj/item/weapon/chemistry/b_sugar/New()

	..()
	src.chem.maximum = 60
	var/datum/chemical/sugar/C = new /datum/chemical/sugar( null )
	C.moles = C.density * 50 / C.molarmass
	src.chem.chemicals[text("[]", C.name)] = C
	return

/obj/item/weapon/chem/attackby(obj/item/weapon/B as obj, mob/user as mob)

	if (istype(B, /obj/item/weapon/chemistry))
		var/t1 = src.chem.maximum
		var/volume = src.chem.volume()
		if (volume < 0.1)
			return
		else
			t1 = 20
		t1 = src.chem.transfer_from(B:chem, t1)
		if (t1)
			user.show_message(text("\blue You carefully pour [] unit\s into the beaker. The beaker now contains [] units.", round(t1, 0.1), round(src.chem.volume(), 0.1)))
	if (istype(B, /obj/item/weapon/bottle))
		var/t1 = src.chem.maximum
		var/volume = src.chem.volume()
		if (volume < 0.1)
			return
		else
			t1 = 20
		t1 = src.chem.transfer_from(B:chem, t1)
		if (t1)
			user.show_message(text("\blue You carefully pour [] unit\s into the beaker. The beaker now contains [] units.", round(t1, 0.1), round(src.chem.volume(), 0.1)))
	if (istype(B, /obj/item/weapon/chem/beaker))
		var/t1 = src.chem.maximum
		var/volume = src.chem.volume()
		if (volume < 0.1)
			return
		else
			t1 = 20
		t1 = src.chem.transfer_from(B:chem, t1)
		if (t1)
			user.show_message(text("\blue You carefully pour [] unit\s into the beaker. The beaker now contains [] units.", round(t1, 0.1), round(src.chem.volume(), 0.1)))
	if (istype(B, /obj/item/weapon/syringe))
		if (B:mode == "inject")
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.01)
				return
			else
				if (volume < 5.01)
					t1 = volume - 0.01
			t1 = src.chem.transfer_from(B:chem, t1)
			B:update_is()
			if (t1)
				user.show_message(text("\blue You inject [] unit\s into the beaker. The syringe contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
		else
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.05)
				return
			else
				if (volume < 5.05)
					t1 = volume - 0.05
			t1 = B:chem.transfer_from(src.chem, t1)
			B:update_is()
			if (t1)
				user.show_message(text("\blue You draw [] unit\s from the beaker. The syringe contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
		src.add_fingerprint(user)
	else
		if (istype(B, /obj/item/weapon/dropper))
			if (B:mode == "inject")
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = src.chem.transfer_from(B:chem, t1)
				B:update_is()
				if (t1)
					user.show_message(text("\blue You deposit [] unit\s into the beaker. The dropper contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
			else
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = B:chem.transfer_from(src.chem, t1)
				B:update_is()
				if (t1)
					user.show_message(text("\blue You extract [] unit\s from the beaker. The dropper contains [] units.", round(t1, 0.1), round(B:chem.volume(), 0.1)))
	return

obj/item/weapon/chemistry/attackby(obj/item/weapon/R as obj, mob/user as mob)

	if (istype(R, /obj/item/weapon/syringe))
		if (R:mode == "draw")
			var/t1 = 5
			var/volume = src.chem.volume()
			if (volume < 0.05)
				return
			else
				if (volume < 5.05)
					t1 = volume - 0.05
			t1 = R:chem.transfer_from(src.chem, t1)
			R:update_is()
			if (t1)
				user.show_message(text("\blue You draw [] unit\s from the container. The syringe contains [] units.", round(t1, 0.1), round(R:chem.volume(), 0.1)))
		src.add_fingerprint(user)
	else
		if (istype(R, /obj/item/weapon/dropper))
			if (R:mode == "draw")
				var/t1 = 1
				var/volume = src.chem.volume()
				if (volume < 0.0050)
					return
				else
					if (volume < 1.005)
						t1 = volume - 0.0050
				t1 = R:chem.transfer_from(src.chem, t1)
				R:update_is()
				if (t1)
					user.show_message(text("\blue You extract [] unit\s from the container. The dropper contains [] units.", round(t1, 0.1), round(R:chem.volume(), 0.1)))
	return

/obj/item/weapon/chem/beaker/attack_self(mob/usr as mob)
	var/mob/human/M = usr
	var/oxygenin
	var/nitrogenin
	var/potassiumin
	var/hydrogenin
	var/sulfurin
	var/sugarin
	var/mixingin
	var/mixermachiner
	var/phosphorusin
	var/waterin
	var/lithiumin
	var/carbonin
	var/chlorinein
	var/random4in
	var/random3in
	var/random1in
	var/random2in
	var/ccsin
	var/siliconin
	var/ironin
	var/radiumin
	var/mercuryin
	var/aluminiumin
	var/rejuvin
	var/epilin
	var/thermitein
	var/atoxinin
	var/volume = src.chem.volume()
	var/B = src
	if (M.l_hand == B || M.r_hand == B)
		for (mixermachiner in chem.chemicals)
			if (mixermachiner == "oxygen")
				oxygenin = 1
			if (mixermachiner == "nitrogen")
				nitrogenin = 1
			if (mixermachiner == "potassium")
				potassiumin = 1
			if (mixermachiner == "sugar")
				sugarin = 1
			if (mixermachiner == "mixing fluid")
				mixingin = 1
			if (mixermachiner == "sulfur")
				sulfurin = 1
			if (mixermachiner == "hydrogen")
				hydrogenin = 1
			if (mixermachiner == "phosphorus")
				phosphorusin = 1
			if (mixermachiner == "water")
				waterin = 1
			if (mixermachiner == "lithium")
				lithiumin = 1
			if (mixermachiner == "carbon")
				carbonin = 1
			if (mixermachiner == "chlorine")
				chlorinein = 1
			if (mixermachiner == "Epilepsy remedy")
				epilin = 1
			if (mixermachiner == "CCS remedy")
				ccsin = 1
			if (mixermachiner == "antitoxins")
				atoxinin = 1
			if (mixermachiner == "rejuvinators")
				rejuvin = 1
			if (mixermachiner == "silicon")
				siliconin = 1
			if (mixermachiner == "aluminium")
				aluminiumin = 1
			if (mixermachiner == "iron")
				ironin = 1
			if (mixermachiner == "thermite")
				thermitein = 1
			if (mixermachiner == "mercury")
				mercuryin = 1
			if (mixermachiner == "radium")
				radiumin = 1
			if (mixermachiner == random1)
				random1in = 1
			if (mixermachiner == random2)
				random2in = 1
			if (mixermachiner == random3)
				random3in = 1
			if (mixermachiner == random4)
				random4in = 1
		if (prob(3) && chem.chemicals.len >= 2 && volume >= 4)
			M << text("\blue Uh-oh!")
			OHMYGOD()
		if (random1in == 1 && random2in == 1 && random3in == 1 && random4in == 1 && mixingin == 1 && chem.chemicals.len <= 5)
			M << text("\blue You mix together the ingredients to form an unknown liquid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/jekyll/Ta = new /datum/chemical/jekyll( null )
			Ta.moles = 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (oxygenin == 1 && nitrogenin == 1 && potassiumin == 1 && sugarin == 1 && mixingin == 1 && volume >= 24 && chem.chemicals.len == 5)
			M << text("\blue You mix together the ingredients to form a smoke bomb!")
//			if (M.r_hand == B)
//			M:equip_if_possible(new /obj/item/weapon/smokebomb(M), M:slot_r_hand)
//			else
//				if (M.l_hand == B)
//					M.equip_if_possible(new /obj/item/weapon/smokebomb(M), M.slot_l_hand)
//				else
			new /obj/item/weapon/smokebomb(locate(M.x,M.y,M.z))
			if (volume >=49)
				new /obj/item/weapon/smokebomb(locate(M.x,M.y,M.z))
			if (volume >=74)
				new /obj/item/weapon/smokebomb(locate(M.x,M.y,M.z))
			del (B)
			return
		if (hydrogenin == 1 && sulfurin == 1 && oxygenin == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 4)
			M << text("\blue You mix together the ingredients to form sulphuric acid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/acid/Ta = new /datum/chemical/acid ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (carbonin == 1 && hydrogenin == 1 && chlorinein == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 4)
			M << text("\blue You mix together the ingredients to form chloroform!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/acid/Ta = new /datum/chemical/chloroform ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (lithiumin == 1 && ironin == 1 && oxygenin == 1 && phosphorusin == 1 && mixingin == 1 && volume >= 24 && chem.chemicals.len == 5)
			M << text("\blue You mix together the ingredients to form lithium ion phospate!")
			new /obj/item/weapon/lithbat(locate(M.x,M.y,M.z))
			return
		if (waterin == 1 && sulfurin == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3)
			M << text("\blue You mix together the ingredients to form sulphuric acid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/acid/Ta = new /datum/chemical/acid ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (hydrogenin == 1 && oxygenin == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3)
			M << text("\blue You mix together the ingredients to form water!")
			src.chem.chemicals.len = 0
			var/datum/chemical/water/Wa = new /datum/chemical/water ( null )
			Wa.moles = volume
			src.chem.chemicals[text("[]", Wa.name)] = Wa
			return
		if (radiumin == 1 && mercuryin == 1 && ccsin == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 4)
			M << text("\blue You mix together the ingredients to form a spacedrug!")
			src.chem.chemicals.len = 0
			var/datum/chemical/spacedrug/Wa = new /datum/chemical/spacedrug ( null )
			Wa.moles = 15
			src.chem.chemicals[text("[]", Wa.name)] = Wa
			return
		if (hydrogenin == 1 && chlorinein == 1 && oxygenin == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 4)
			M << text("\blue You mix together the ingredients to form hydrochloric acid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/acid/Ta = new /datum/chemical/acid ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (waterin == 1 && chlorinein == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3)
			M << text("\blue You mix together the ingredients to form hydrochloric acid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/acid/Ta = new /datum/chemical/acid ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if ((waterin == 1 && lithiumin == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3) || (waterin == 1 && potassiumin == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3))
			var/turf/T = get_turf(B)
			M << text("\blue That was pretty stupid!")
			flick("burning",T)
			T.firelevel = max(T.firelevel, T.poison() + 1)
			return
		if (oxygenin == 1 && nitrogenin == 1 && potassiumin == 1 && chlorinein == 1 && sulfurin == 1 && mixingin == 1 && volume >= 29 && chem.chemicals.len == 6)
			M << text("\blue You mix together the ingredients to form a mustard gas bomb!")
//			M:equip_if_possible(new /obj/item/weapon/mustardbomb(M), M:slot_r_hand)
//				if (M.l_hand == B)
//					M.equip_if_possible(new /obj/item/weapon/mustardbomb(M), M.slot_l_hand)
//				else
			new /obj/item/weapon/mustardbomb(locate(M.x,M.y,M.z))
			if (volume >=49)
				new /obj/item/weapon/mustardbomb(locate(M.x,M.y,M.z))
			if (volume >=74)
				new /obj/item/weapon/mustardbomb(locate(M.x,M.y,M.z))
			del (B)
			return
		if (hydrogenin == 1 && oxygenin == 1 && carbonin == 1 && nitrogenin == 1 && mixingin == 1 && phosphorusin == 1 && volume >= 29 && chem.chemicals.len == 6)
			M << text("\blue You mix together the ingredients to form a reactive incandescent mixture.")
			src.light()
			spawn (0)
				return
		if (hydrogenin == 1 && oxygenin == 1 && lithiumin == 1 && nitrogenin == 1 && mixingin == 1 && phosphorusin == 1 && volume >= 29 && chem.chemicals.len == 6)
			M << text("\blue You mix together the ingredients to form a reactive incandescent mixture.")
			src.light()
			spawn (0)
				return
		if (rejuvin == 1 && atoxinin == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3)
			M << text("\blue You mix together the ingredients to form an advanced healing liquid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/rejuvplus/Ta = new /datum/chemical/rejuvplus ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (rejuvin == 1 && ccsin == 1 && epilin == 1 && atoxinin == 1 && mixingin == 1 && volume >= 24 && chem.chemicals.len == 5)
			M << text("\blue You mix together the ingredients to form a detoxifying liquid!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/atoxplus/Ta = new /datum/chemical/atoxplus ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (aluminiumin == 1 && oxygenin == 1 && ironin == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 4)
			M << text("\blue You mix together the ingredients to form thermite!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/thermite/Ta = new /datum/chemical/thermite ( null )
			Ta.moles = volume / 3
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (oxygenin == 1 && siliconin == 1 && mixingin == 1 && volume >= 14 && chem.chemicals.len == 3)
			M << text("\blue You mix together the ingredients to form silicate!")
			volume = src.chem.volume()
			src.chem.chemicals.len = 0
			var/datum/chemical/silicate/Ta = new /datum/chemical/silicate ( null )
			Ta.moles = volume / 2
			src.chem.chemicals[text("[]", Ta.name)] = Ta
			return
		if (phosphorusin == 1 && hydrogenin == 1 && sulfurin == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 4)
			M << text("\blue You mix together the ingredients to form an incendiary device!")
			new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
			if (volume >=39)
				new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
			if (volume >=59)
				new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
			if (volume >=79)
				new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
			del (B)
			return

		if (phosphorusin == 1 && thermitein == 1 && mixingin == 1 && volume >= 19 && chem.chemicals.len == 3)
			M << text("\blue You mix together the ingredients to form an incendiary device!")
			var/I1 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
			I1:firestrength = 80
			if (volume >=39)
				var/I2 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
				I2:firestrength = 100
			if (volume >=59)
				var/I3 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
				I3:firestrength = 100
			if (volume >=79)
				var/I4 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
				I4:firestrength = 125
			del (B)
			return
		if (phosphorusin == 1 && hydrogenin == 1 && sulfurin == 1 && thermitein == 1 && mixingin == 1 && volume >= 24 && chem.chemicals.len == 5)
			M << text("\blue You mix together the ingredients to form an incendiary device!")
			var/I1 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
			I1:firestrength = 140
			if (volume >=49)
				var/I2 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
				I2:firestrength = 140
			if (volume >=74)
				var/I3 = new /obj/item/weapon/incendiarygrenade(locate(M.x,M.y,M.z))
				I3:firestrength = 140
			del (B)
			return
		if (carbonin == 1 && oxygenin == 1 && siliconin == 1 && radiumin == 1 && mixingin == 1 && volume >= 24 && chem.chemicals.len == 5)
			M << text("\blue You mix together the ingredients")
			M << text("\red The mixture rapidly expands and turns green.")
			var/obj/blob/X = new /obj/blob/(locate(M.x,M.y,M.z))
			X.Life()
			del (B)
			return
		else
			M << text("\blue Nothing happens...")
			if (prob(5) && chem.chemicals.len >= 2 && volume >= 4)
				M << text("\blue ..Except an unexpected reaction!")
				OHMYGOD()
	return
/obj/item/weapon/smokebomb
	desc = "It is set to detonate in 2 seconds."
	name = "smoke bomb"
	icon_state = "flashbang"
	var/state = null
	var/det_time = 20.0
	w_class = 2.0
	s_istate = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = 402.0

/obj/item/weapon/lithbat
	desc = "It can recharge a battery inside of an APC."
	name = "lithium cell"
	icon_state = "beaker"
	var/state = null
	w_class = 2.0
	s_istate = "beaker"

/obj/item/weapon/incendiarygrenade
	desc = "It is set to detonate in 3 seconds."
	name = "incendiary grenade"
	icon_state = "flashbang"
	var/state = null
	var/firestrength = 100
	var/det_time = 20.0
	w_class = 2.0
	s_istate = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = 402.0

/obj/item/weapon/mustardbomb
	desc = "It is set to detonate in 4 seconds."
	name = "mustard gas bomb"
	icon_state = "flashbang"
	var/state = null
	var/det_time = 40.0
	w_class = 2.0
	s_istate = "flashbang"
	throw_speed = 4
	throw_range = 20
	flags = 402.0

/obj/item/weapon/smokebomb/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 60)
			src.det_time = 20
			user.show_message("\blue You set the smoke bomb for a 2 second detonation time.")
			src.desc = "It is set to detonate in 2 seconds."
		else
			src.det_time = 60
			user.show_message("\blue You set the smoke bomb for a 6 second detonation time.")
			src.desc = "It is set to detonate in 6 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/incendiarygrenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 60)
			src.det_time = 30
			user.show_message("\blue You set the incendiary grenade for a 3 second detonation time.")
			src.desc = "It is set to detonate in 3 seconds."
		else
			src.det_time = 60
			user.show_message("\blue You set the incendiary grenade for a 6 second detonation time.")
			src.desc = "It is set to detonate in 6 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/smokebomb/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (!( src.state ))
			user << "\red You prime the smoke bomb! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/incendiarygrenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (!( src.state ))
			user << "\red You prime the incendiary grenade! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/incendiarygrenade/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/incendiarygrenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/smokebomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/smokebomb/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/smokebomb/proc/prime()
	var/obj/effects/badsmoke/O = new /obj/effects/badsmoke( src.loc )
	O.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn( 0 )
		O.Life()

	for(var/obj/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update()
	sleep(80)
	del(src)
	return

/obj/item/weapon/incendiarygrenade/proc/prime()
	var/turf/T = src.loc
	var/turf/Tx1 = src.x + 1
	var/turf/Txm1 = src.x - 1
	var/turf/Ty1 = src.y + 1
	var/turf/Tym1 = src.y - 1
	if(isturf(T))
		T.poison(firestrength * 155000) // Old was 155000
		T.firelevel = firestrength * 155000
		T.oxygen(firestrength * 155000)
	if(isturf(Tx1))
		Tx1.poison(firestrength * 155000)
		Tx1.firelevel = firestrength * 155000
	if(isturf(Ty1))
		Ty1.poison(firestrength * 155000)
		Ty1.firelevel = firestrength * 155000
	if(isturf(Txm1))
		Txm1.poison(firestrength * 155000)
		Txm1.firelevel = firestrength * 155000
	if(isturf(Tym1))
		Tym1.poison(firestrength * 155000)
		Tym1.firelevel = firestrength * 155000
//		oxygen += firestrength * 10000
//	for(var/obj/blob/B in view(8,src))
//		var/damage = round(30/(get_dist(B,src)+1))
//		B.health -= damage
//		B.update()
	sleep(10)
	del(src)
	return


/obj/item/weapon/smokebomb/attack_self(mob/user as mob)
	if (!src.state)
		user << "\red You prime the smoke bomb! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn( src.det_time )
			prime()
			return
	return

/obj/item/weapon/incendiarygrenade/attack_self(mob/user as mob)
	if (!src.state)
		user << "\red You prime the incendiary grenade! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn( src.det_time )
			prime()
			return
	return

/datum/chemical/mercury/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 7
			M.eye_stat += volume * 2
			M.eye_blurry += volume * 25
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
			M.b_mercury += volume
		else
			M.b_mercury += volume * 60
	return

/datum/chemical/sugar/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 4
			M.eye_stat += volume * 1
			M.eye_blurry += volume * 15
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M << text("\blue You feel a rush of energy!")
			M << text("\red You go diabetic!")
	return

/datum/chemical/jekyll/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			if (volume >= 1)
				M << text("\blue The walls suddenly disappear!")
				spawn (3600)
					M.xray = 0
				M.xray = 1
				sleep (rand(100, 1200))
				M << text("\blue The walls slowly reappear.")
				M.xray = 0
				sleep (rand(100, 1200))
				M << text("\blue The walls suddenly disappear!")
				M.xray = 1
				sleep (rand(100, 1200))
				M << text("\blue The walls slowly reappear.")
				M.xray = 0
		if("head")
			if (volume >= 1)
// i dunno, cough + epilepsy why the fuck not
				M.telekinesis = 1
				spawn (3600)
					M.telekinesis = 0
				M << text("\blue Your mind expands!")
				sleep (rand(100, 1200))
				M << text("\blue Your mind shrinks!")
				M.telekinesis = 0
				sleep (rand(100, 1200))
				M << text("\blue Your mind expands!")
				M.telekinesis = 1
				sleep (rand(100, 1200))
				M << text("\blue Your mind shrinks!")
				M.telekinesis = 0
		else
			if (volume >= 1)
//				if prob(50)
//					M.clumsy = 1
				M.ishulk = 1
				M.unlock_medal("It's Not Easy Being Green", 1, "Become the hulk.", "medium")
				spawn (3600)
					M.ishulk = 0
				M << text("\blue You feel ANGRY!")
				sleep (rand(100, 1200))
				M << text("\blue You feel very calm.")
				M.ishulk = 0
				sleep (rand(100, 1200))
				M << text("\blue You feel ANGRY!")
				M.ishulk = 1
				sleep (rand(100, 1200))
				M << text("\blue You feel very calm.")
				M.ishulk = 0
	return

/datum/chemical/radium/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 3
			M.eye_stat += volume * 7
			M.eye_blurry += volume * 5
			M.radiation += volume * 5
			if (M.eye_stat >= 30)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.radiation += volume
			M.sd_SetLuminosity(1)
		else
			M.radiation += volume * 5
			M.sd_SetLuminosity(1)
	return


/datum/chemical/acid/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 10
			M.eye_stat += volume * 10
			M.eye_blurry += volume * 25
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			if (M.wear_mask && M:head == null)
				del (M.wear_mask)
				M << "\red Your mask melts away!"
				return
			if (M.wear_mask == null && M:head)
				if (prob(20))
					del (M:head)
					M << "\red Your helmet melts into uselessness!"
				else
					M << "\red Your helmet protects you!"
				return
			if (M.wear_mask && M:head)
				if (M.wear_mask.chem_protect)
					if (!prob(M.wear_mask.chem_protect))
						del (M.wear_mask)
						M << "\red Your mask melts away!"
					if (prob(25))
						del (M:head)
						M << "\red Your helmet melts into uselessness!"
			else
			//	M.fireloss += volume * 2
				var/obj/item/weapon/organ/external/affecting = M:organs["head"]
				affecting.take_damage((volume *2), 0)
				M:UpdateDamage()
				M:UpdateDamageIcon()
				if (volume >= 30)
					M:emote("scream")
					M << "\red Your face has become disfigured!"
					if (M.rname != "Unknown")
						M.rname = "Unknown"
				else
					M:emote("moan")
		else
			M.b_acid += volume * 6
	return


/datum/chemical/rejuvplus/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat -= volume * 7
			M.eye_blurry += volume * 4
			M.eye_stat = max(0, M.eye_stat)
		if("head")
			return
		else
			if (M.health >= 0)
				if ((volume * 5) >= M.toxloss)
					M.toxloss = 0
				else
					M.toxloss -= volume * 5
			M.antitoxs += volume * 200
			var/ok = 0
			for(var/organ in M.organs)
				var/obj/item/weapon/organ/external/affecting = M.organs[text("[]", organ)]
				ok += affecting.heal_damage(volume, volume)
			if (ok)
				M:UpdateDamageIcon()
			else
				M:UpdateDamage()
			M.health = 100 - M.oxyloss - M.toxloss - M.fireloss - M.bruteloss
			M.rejuv += volume * 4
			if (M.paralysis)
				M.paralysis = 2
			if (M.weakened)
				M.weakened = 2
			if (M.stunned)
				M.stunned = 2
	return

/datum/chemical/atoxinplus/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat -= volume * 2
			M.eye_stat = max(0, M.eye_stat)
		if("head")
			M.eye_blurry += volume
		else
			if (M.health >= 0)
				if ((volume * 6) >= M.toxloss)
					M.toxloss = 0
				else
					M.toxloss -= volume * 6
			M.antitoxs += volume * 240
			M.health = 100 - M.oxyloss - M.toxloss - M.fireloss - M.bruteloss
			M.r_epil -= volume * 50
			M.r_ch_cou -= volume * 50
			M.r_Tourette -= volume * 50
			M.drowsyness -= volume * 50
	return


/datum/chemical/chlorine/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat += volume * 8
			M.eye_blurry += volume * 4
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.plasma += volume * 8
			for(var/obj/item/weapon/implant/tracking/T in M)
				M.plasma += 1
				del(T)
	return

/datum/chemical/aluminium/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat += volume * 5
			M.eye_blurry += volume * 3
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.plasma += volume * 4
	return

/datum/chemical/iron/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat += volume * 5
			M.eye_blurry += volume * 3
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.plasma += volume * 4
	return

/datum/chemical/potassium/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 10
			M.eye_stat += volume * 10
			M.eye_blurry += volume * 25
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")

//&& istype(M, /mob/human)
//&& !(M.wear_mask.see_face
			if (M.wear_mask)
				M << "\red Your mask protects you!"
				return
			if (M:head)
				M << "\red Your helmet protects you!"
				return
			else
			//	M.fireloss += volume * 2
				var/obj/item/weapon/organ/external/affecting = M:organs["head"]
				affecting.take_damage(volume, 0)
				M:UpdateDamage()
				M:UpdateDamageIcon()
				if (volume >= 60)
					M:emote("scream")
					M << "\red Your face has become disfigured!"
					if (M.rname != "Unknown")
						M.rname = "Unknown"
				else
					M:emote("moan")
		else
			M.b_acid += volume * 5
	return

/datum/chemical/phosphorus/injected(var/mob/M as mob, zone)

	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_blind += volume * 10
			M.eye_stat += volume * 10
			M.eye_blurry += volume * 25
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")

//&& istype(M, /mob/human)
//&& !(M.wear_mask.see_face
			if (M.wear_mask)
				M << "\red Your mask protects you!"
				return
			if (M:head)
				M << "\red Your helmet protects you!"
				return
			else
			//	M.fireloss += volume * 2
				var/obj/item/weapon/organ/external/affecting = M:organs["head"]
				affecting.take_damage(volume, 0)
				M:UpdateDamage()
				M:UpdateDamageIcon()
				if (volume >= 60)
					M:emote("scream")
					M << "\red Your face has become disfigured!"
					if (M.rname != "Unknown")
						M.rname = "Unknown"
				else
					M:emote("moan")
		else
			M.b_acid += volume * 6
	return


/datum/chemical/lithium/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat += volume * 7
			M.eye_blurry += volume * 4
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.eye_blurry += volume
		else
			M.plasma += volume * 7
			M << "\blue You feel happy for the first time in your life."
			for(var/obj/item/weapon/implant/tracking/T in M)
				M.plasma += 1
				del(T)
	return

/datum/chemical/spacedrug/injected(var/mob/M as mob, zone)
	var/volume = src.return_property("volume")
	switch(zone)
		if("eye")
			M.eye_stat += volume * 4
			M.druggy += volume * 6
			if (M.eye_stat >= 20)
				M << "\red Your eyes start to burn badly!"
				M.disabilities |= BADVISION
				if (prob(M.eye_stat - 20 + 1))
					M << "\red You go blind!"
					M.sdisabilities |= BLIND
		if("head")
			M.druggy += volume
		else
			M.druggy += volume * 8
			M << "\blue W\red o\green a \black h\yellow ."
	return


/obj/item/weapon/chem/beaker/proc/light()


	var/count
	var/T
	usr.drop_item()
	usr.swap_hand()
	usr.drop_item()
	usr.swap_hand()
	src.on = 1
	while (src.on)
		var/turf/location = src.loc
		src.anchored = 1.0
		if (count >= 48)
			on = 0
		for (T as turf in view(5,src))
			if (src.chem.chemicals.Find("lithium") != 0)
				T:lit = image('alphacolors.dmi', "red")
				spawn (10)
					T:lit = null
			else
				T:lit = image('alphacolors.dmi', "blue")
				spawn (10)
					T:lit = null
		if(isturf(location)) //start a fire if possible
			location.firelevel = max(location.firelevel, location.poison() + 1)
		src.sd_SetLuminosity(6)
		count++
		sleep(10)

	if (on == 0)
		src.anchored = 0.0
		spawn (10)
			sd_SetLuminosity(0)
		return

/obj/item/weapon/chem/beaker/attack(mob/M as mob, mob/user as mob, zone)
	if (!istype(M, /mob))
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	if (!src.chem.volume())
		user << "\red The beaker has nothing inside it!"
		return
	if (user)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [] has been splashed with chemicals by []!", M, user), 1)
			//Foreach goto(192)
		user.show_message(text("\red You throw the beaker containing [] units at []'s [zone]! The beaker is now broken.", src.chem.volume(), M))

		src.chem.beaker_mob(M, src.chem.volume())
		src.chem.chemicals.len = 0
		del (src)
//			src.update_is()
	return

/obj/item/weapon/chem/beaker/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/chem/beaker/attack_hand()
	if (src.on)
//		usr << text("Yo this is way too hot to pick up right now budski")
		return
	..()
	return

/obj/substance/chemical/proc/beaker_mob(M as mob, amount)

	if (!( ismob(M) ))
		return
	var/obj/substance/chemical/S = src.split(amount)
	for(var/item in S.chemicals)
		var/datum/chemical/C = S.chemicals[item]
		if (istype(C, /datum/chemical))
			C.injected(M, "head")
		//Foreach goto(44)
	//S = null
	del(S)
	return

/obj/effects/badsmoke
	name = "smoke"
	icon = 'water.dmi'
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 8.0


/obj/effects/badsmoke/proc/Life()
//	var/mob/human/Coughed
	if (src.amount > 1)
		var/obj/effects/badsmoke/W = new src.type( src.loc )
		W.amount = src.amount - 1
		W.dir = src.dir
		spawn( 0 )
			W.Life()
			return
	src.amount--
	if (src.amount <= 0)
		var/mob/human/R = locate() in src.loc
		var/COUNT
		smoke
		if (COUNT >= 8)
			goto END
		R = locate() in src.loc
		if (istype(R, /mob/human))
			if (R.internal != null && usr.wear_mask && (R.wear_mask.flags & MASKINTERNALS))
				goto skippy
			R.drop_item()
			R.oxyloss += 1
			if (R.coughedtime != 1)
				R.coughedtime = 1
				R.emote("cough")
				spawn ( 20 )
					R.coughedtime = 0
		skippy
		COUNT ++
		sleep(10)
		goto smoke
		END
		del(src)
		return
	var/turf/T = get_step(src, turn(src.dir, pick(90, 0, 0, -90.0)))
	if ((T && T.density))
		src.dir = turn(src.dir, pick(-90.0, 90))
	else
		step_to(src, T, null)
		T = src.loc
		if (istype(T, /turf))
			T.firelevel = T.poison()
	spawn( 3 )
		src.Life()
		return
	return

/obj/effects/reallybadsmoke
	name = "mustard gas"
	icon = 'water.dmi'
	icon_state = "mustard"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0

/obj/effects/reallybadsmoke/proc/Life()
	/affecting
	if (src.amount > 1)
		var/obj/effects/badsmoke/W = new src.type( src.loc )
		W.amount = src.amount - 1
		W.dir = src.dir
		spawn( 0 )
			W.Life()
			return
	src.amount--
	if (src.amount <= 0)
		var/mob/human/R = locate() in src.loc
		var/COUNT
		do
			for(R in src.loc)
				if (istype(R, /mob/human))
					if (R.internal != null && usr.wear_mask && (R.wear_mask.flags & MASKINTERNALS) && R.wear_suit != null && !istype(R.wear_suit, /obj/item/weapon/clothing/suit/labcoat) && !istype(R.wear_suit, /obj/item/weapon/clothing/suit/straight_jacket) && !istype(R.wear_suit, /obj/item/weapon/clothing/suit/straight_jacket && !istype(R.wear_suit, /obj/item/weapon/clothing/suit/armor)))
						continue
					R.burn_skin(0.75)
					if (R.coughedtime != 1)
						R.coughedtime = 1
						R.emote("gasp")
						spawn (20)
							R.coughedtime = 0
					R.updatehealth()
			COUNT ++
			sleep(10)
		while(COUNT < 10)
		del(src)
		return
	var/turf/T = get_step(src, turn(src.dir, pick(90, 0, 0, -90.0)))
	if ((T && T.density))
		src.dir = turn(src.dir, pick(-90.0, 90))
	else
		step_to(src, T, null)
		T = src.loc
		if (istype(T, /turf))
			T.firelevel = T.poison()
	spawn( 3 )
		src.Life()
		return
	return

/obj/item/weapon/mustardbomb/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.det_time == 80)
			src.det_time = 40
			user.show_message("\blue You set the mustard gas bomb for a 4 second detonation time.")
			src.desc = "It is set to detonate in 4 seconds."
		else
			src.det_time = 80
			user.show_message("\blue You set the mustard gas bomb for a 8 second detonation time.")
			src.desc = "It is set to detonate in 8 seconds."
		src.add_fingerprint(user)
	return

/obj/item/weapon/mustardbomb/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (user.equipped() == src)
		if (!( src.state ))
			user << "\red You prime the mustard gas bomb! [det_time/10] seconds!"
			src.state = 1
			src.icon_state = "flashbang1"
			spawn( src.det_time )
				prime()
				return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
		src.add_fingerprint(user)
	return

/obj/item/weapon/mustardbomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/weapon/mustardbomb/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/mustardbomb/proc/prime()
	var/obj/effects/reallybadsmoke/O = new /obj/effects/reallybadsmoke( src.loc )
	O.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn( 0 )
		O.Life()

	for(var/obj/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.health -= damage
		B.update()
	sleep(100)
	del(src)
	return

/obj/item/weapon/mustardbomb/attack_self(mob/user as mob)
	if (!src.state)
		user << "\red You prime the mustard gas bomb! [det_time/10] seconds!"
		src.state = 1
		src.icon_state = "flashbang1"
		add_fingerprint(user)
		spawn( src.det_time )
			prime()
			return
	return

/obj/item/weapon/storage/beakerbox
	name = "Beaker Box"
	icon_state = "beakerbox"
	s_istate = "syringe_kit"

/obj/item/weapon/storage/beakerbox/New()
	..()
	new /obj/item/weapon/chem/beaker( src )
	new /obj/item/weapon/chem/beaker( src )
	new /obj/item/weapon/chem/beaker( src )
	new /obj/item/weapon/chem/beaker( src )
	new /obj/item/weapon/chem/beaker( src )
	new /obj/item/weapon/chem/beaker( src )
	new /obj/item/weapon/chem/beaker( src )

//-MAYBE- glue that slows people down, i dunno
//MAYBE reanimation stuff, it does sound kinda cool
//check the possibility of putting if mixermachiner = oxygen returnproperty(???)
//labels
//no more pouring

/obj/item/weapon/chem
	name = "chem"
	var/obj/substance/chemical/chem = null
	throw_speed = 5
	throw_range = 22
	w_class = 1.0
/obj/item/weapon/chem/beaker
	name = "beaker"
	icon_state = "beaker"
	var/on
	var/random1 //= pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury")
	var/random2 //= pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury")
	var/random3 //= pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury")
	var/random4 //= pick("potassium","chlorine","oxygen","nitrogen","hydrogen","carbon","water","acid","phosphorus","sulfur","sugar","mercury")

/obj/item/weapon/chemistry/
	name = "chemistry"
	var/obj/substance/chemical/chem = null
	throw_speed = 4
	throw_range = 15
	w_class = 1.0
/obj/item/weapon/chemistry/b_oxygen
	name = "oxygen - O"
	icon_state = "contvapour"
/obj/item/weapon/chemistry/b_nitrogen
	name = "nitrogen - N"
	icon_state = "contvapour"
/obj/item/weapon/chemistry/b_hydrogen
	name = "hydrogen - H"
	icon_state = "contvapour"
/obj/item/weapon/chemistry/b_potassium
	name = "potassium - K"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_mercury
	name = "mercury - Hg"
	icon_state = "contliquid"
/obj/item/weapon/chemistry/b_sulfur
	name = "sulfur - S"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_carbon
	name = "carbon - C"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_mixing
	name = "mixing fluid"
	icon_state = "contliquid"
/obj/item/weapon/chemistry/b_chlorine
	name = "chlorine - Cl"
	icon_state = "contvapour"
/obj/item/weapon/chemistry/b_silicate
	name = "Silicate - Compound"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_phosphorus
	name = "phosphorus - P"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_lithium
	name = "lithium - Li"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_sugar
	name = "sugar - C6 H12 O6"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_acid
	name = "sulphuric acid - H2 S O4"
	icon_state = "contliquid"
/obj/item/weapon/chemistry/b_water
	name = "water - H2 O"
	icon_state = "contliquid"
/obj/item/weapon/chemistry/b_radium
	name = "radium - Ra"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_iron
	name = "iron - Fe"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_aluminium
	name = "aluminium"
	icon_state = "contsolid"
/obj/item/weapon/chemistry/b_silicon
	name = "silicon - Si"
	icon_state = "contsolid"
/obj/item/weapon/paper/alchemy/
	name = "paper- 'Chemistry Information'"

/obj/machinery/chemdispenser
	desc = "A dispenser for chemicals."
	name = "Chemical dispenser"
	icon = 'stationobjs.dmi'
	icon_state = "chemdispenser"
	density = 1
	var/oxygencont = 5
	var/nitrogencont = 5
	var/potassiumcont = 5
	var/hydrogencont = 5
	var/sulfurcont = 5
	var/sugarcont = 5
	var/mixingcont = 5
	var/phosphoruscont = 5
	var/lithiumcont = 5
	var/carboncont = 5
	var/chlorinecont = 5
	var/random4list = "you are"
	var/random3list = "the worst, most"
	var/random1list = "absolutely awful,"
	var/random2list = "shit admin."
	var/siliconcont = 5
	var/radiumcont = 5
	var/mercurycont = 5
	var/aluminiumcont = 5
	var/ironcont = 5
	anchored = 1.0

/obj/machinery/chemdispenser/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
//		if(3.0)
//			if (prob(25))
//				while(src.o2tanks > 0)
//					new /obj/item/weapon/tank/oxygentank( src.loc )
//					src.o2tanks--
//				while(src.pltanks > 0)
//					new /obj/item/weapon/tank/plasmatank( src.loc )
//					src.pltanks--
		else
	return

/obj/machinery/chemdispenser/blob_act()
	if (prob(25))
//		while(src.o2tanks > 0)
//			new /obj/item/weapon/tank/oxygentank( src.loc )
//			src.o2tanks--
//		while(src.pltanks > 0)
//			new /obj/item/weapon/tank/plasmatank( src.loc )
//			src.pltanks--
		del(src)

/obj/machinery/chemdispenser/meteorhit()
//	while(src.o2tanks > 0)
//		new /obj/item/weapon/tank/oxygentank( src.loc )
//		src.o2tanks--
//	while(src.pltanks > 0)
//		new /obj/item/weapon/tank/plasmatank( src.loc )
//		src.pltanks--
	del(src)
	return

/obj/machinery/chemdispenser/process()
	return

/obj/machinery/chemdispenser/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chemdispenser/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chemdispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	user.machine = src
	var/dat = text("<TT><B>Loaded Chemistry Dispensing Unit</B><BR>\n<FONT color = 'blue'><B>Hydrogen</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Lithium</B>: []</FONT> []<BR><FONT color = 'blue'><B>Carbon</B>: []</FONT> []<BR><FONT color = 'blue'><B>Nitrogen</B>: []</FONT> []<BR><FONT color = 'blue'><B>Oxygen</B>: []</FONT> []<BR><FONT color = 'blue'><B>Aluminium</B>: []</FONT> []<BR><FONT color = 'blue'><B>Silicon</B>: []</FONT> []<BR><FONT color = 'blue'><B>Phosphorus</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Sulfur</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Chlorine</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Potassium</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Iron</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Mercury</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Radium</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Sugar</B>: []</FONT> []<BR>\n<FONT color = 'blue'><B>Mixing Fluid</B>: []</FONT> []</TT>", src.hydrogencont, (src.hydrogencont ? text("<A href='?src=\ref[];hydrogen=1'>Dispense</A>", src) : "empty"), src.lithiumcont, (src.lithiumcont ? text("<A href='?src=\ref[];lithium=1'>Dispense</A>", src) : "empty"), src.carboncont, (src.carboncont ? text("<A href='?src=\ref[];carbon=1'>Dispense</A>", src) : "empty"), src.nitrogencont, (src.nitrogencont ? text("<A href='?src=\ref[];nitrogen=1'>Dispense</A>", src) : "empty"), src.oxygencont, (src.oxygencont ? text("<A href='?src=\ref[];oxygen=1'>Dispense</A>", src) : "empty"), src.aluminiumcont, (src.aluminiumcont ? text("<A href='?src=\ref[];aluminium=1'>Dispense</A>", src) : "empty"), src.siliconcont, (src.siliconcont ? text("<A href='?src=\ref[];silicon=1'>Dispense</A>", src) : "empty"), src.phosphoruscont, (src.phosphoruscont ? text("<A href='?src=\ref[];phosphorus=1'>Dispense</A>", src) : "empty"), src.sulfurcont, (src.sulfurcont ? text("<A href='?src=\ref[];sulfur=1'>Dispense</A>", src) : "empty"), src.chlorinecont, (src.chlorinecont ? text("<A href='?src=\ref[];chlorine=1'>Dispense</A>", src) : "empty"), src.potassiumcont, (src.potassiumcont ? text("<A href='?src=\ref[];potassium=1'>Dispense</A>", src) : "empty"), src.ironcont, (src.ironcont ? text("<A href='?src=\ref[];iron=1'>Dispense</A>", src) : "empty"), src.mercurycont, (src.mercurycont ? text("<A href='?src=\ref[];mercury=1'>Dispense</A>", src) : "empty"), src.radiumcont, (src.radiumcont ? text("<A href='?src=\ref[];radium=1'>Dispense</A>", src) : "empty"), src.sugarcont, (src.sugarcont ? text("<A href='?src=\ref[];sugar=1'>Dispense</A>", src) : "empty"), src.mixingcont, (src.mixingcont ? text("<A href='?src=\ref[];mixing=1'>Dispense</A>", src) : "empty"))
	user << browse(dat, "window=chemdispenser")
	return

/obj/machinery/chemdispenser/Topic(href, href_list)
	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained())
		return
	if (!(istype(usr, /mob/human) || ticker))
		if (!istype(usr, /mob/ai))
			usr << "\red You don't have the dexterity to do this!"
		else
			usr << "\red You are unable to dispense anything, since the controls are physical levers which don't go through any other kind of input."
		return

	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["oxygen"])
			if (text2num(href_list["oxygen"]))
				if (src.oxygencont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_oxygen( src.loc )
					src.oxygencont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["nitrogen"])
			if (text2num(href_list["nitrogen"]))
				if (src.nitrogencont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_nitrogen( src.loc )
					src.nitrogencont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["carbon"])
			if (text2num(href_list["carbon"]))
				if (src.carboncont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_carbon( src.loc )
					src.carboncont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["hydrogen"])
			if (text2num(href_list["hydrogen"]))
				if (src.hydrogencont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_hydrogen( src.loc )
					src.hydrogencont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["lithium"])
			if (text2num(href_list["lithium"]))
				if (src.lithiumcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_lithium( src.loc )
					src.lithiumcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["phosphorus"])
			if (text2num(href_list["phosphorus"]))
				if (src.phosphoruscont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_phosphorus( src.loc )
					src.phosphoruscont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["silicon"])
			if (text2num(href_list["silicon"]))
				if (src.siliconcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_silicon( src.loc )
					src.siliconcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["chlorine"])
			if (text2num(href_list["chlorine"]))
				if (src.chlorinecont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_chlorine( src.loc )
					src.chlorinecont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["sulfur"])
			if (text2num(href_list["sulfur"]))
				if (src.sulfurcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_sulfur( src.loc )
					src.sulfurcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["aluminium"])
			if (text2num(href_list["aluminium"]))
				if (src.aluminiumcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_aluminium( src.loc )
					src.aluminiumcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["iron"])
			if (text2num(href_list["iron"]))
				if (src.ironcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_iron( src.loc )
					src.ironcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["potassium"])
			if (text2num(href_list["potassium"]))
				if (src.potassiumcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_potassium( src.loc )
					src.potassiumcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["mercury"])
			if (text2num(href_list["mercury"]))
				if (src.mercurycont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_mercury( src.loc )
					src.mercurycont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["radium"])
			if (text2num(href_list["radium"]))
				if (src.radiumcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_radium( src.loc )
					src.radiumcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["sugar"])
			if (text2num(href_list["sugar"]))
				if (src.sugarcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_sugar( src.loc )
					src.sugarcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		if (href_list["mixing"])
			if (text2num(href_list["mixing"]))
				if (src.mixingcont > 0)
					use_power(5)
					new /obj/item/weapon/chemistry/b_mixing( src.loc )
					src.mixingcont--
			if (istype(src.loc, /mob))
				attack_hand(src.loc)
		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.attack_hand(M)
	else
		usr << browse(null, "window=chemdispenser")
		return
	return

/obj/item/weapon/storage/trashcan
	name = "disposal unit"
	w_class = 4.0
	anchored = 1.0
	density = 1.0
	var/processing = null
	var/locked = 1
	req_access = list(access_disposal_units)
	desc = "A compact incineration device, used to dispose of garbage."
	icon = 'stationobjs.dmi'
	icon_state = "trashcan"
	s_istate = "syringe_kit"

/obj/item/weapon/storage/trashcan/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (src.contents.len >= 7)
		user << "The trashcan is full!"
		return
	if (istype(W, /obj/item/weapon/disk/nuclear))
		user << "This is far too important to throw away!"
		return
	if (istype(W, /obj/item/weapon/storage/))
		return
	if (istype(W, /obj/item/weapon/grab))
		user << "You cannot fit the person inside."
		return
	var/t
	for(var/obj/item/weapon/O in src)
		t += O.w_class
		//Foreach goto(46)
	t += W.w_class
	if (t > 30)
		user << "You cannot fit the item inside. (Remove larger classed items)"
		return
	user.u_equip(W)
	W.loc = src
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	src.orient2hud(user)
	W.dropped()
	add_fingerprint(user)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("\blue [] has put [] in []!", user, W, src), 1)
		//Foreach goto(206)
	if (src.contents.len >= 7)
		src.locked = 1
		src.icon_state = "trashcan1"
	spawn (200)
		if (src.contents.len < 7)
			src.locked = 0
			src.icon_state = "trashcan"
	return

/obj/item/weapon/storage/trashcan/attack_hand(mob/user as mob)
	if(src.allowed(usr))
		locked = !locked
	else
		user << "\red Access denied."
		return
	if (src.processing)
		return
	if (src.contents.len >= 7)
		user << "\blue You begin the emptying procedure."
		var/area/A = src.loc.loc		// make sure it's in an area
		if(!A || !isarea(A))
			return
		var/turf/T = src.loc
		A.use_power(250, EQUIP)
		src.processing = 1
		src.contents.len = 0
		src.icon_state = "trashmelt"
//		if (istype(T, /turf))
//			T.firelevel = T.poison()
		if(isturf(T)) //start a fire if possible
			T.firelevel = max(T.firelevel, T.poison() + 1)
		sleep (60)
		src.icon_state = "trashcan"
		src.processing = 0
		return
	else
		src.icon_state = "trashcan"
		user << "\blue Due to conservation measures, the unit is unable to start until it is completely filled."
		return

/obj/item/weapon/chem/beaker/burn(fi_amount)
	if (fi_amount > 18000)
		spawn( 0 )
			if (src.chem.chemicals.Find("thermite") != 0)
				var/turf/T = src.loc
				if(isturf(T))
					T:health -= 75
				del(src)
				return
			return
		return 0
	return 1

/obj/item/weapon/chem/beaker/proc/OHMYGOD()

	var/OHGODSAVEME
	OHGODSAVEME = pick("smoke", "mustard", "explosion", "fire", "light")
	switch (OHGODSAVEME)
		if ("smoke")
//			world << "smoke"
			var/obj/effects/badsmoke/O = new /obj/effects/badsmoke( src.loc )
			O.dir = pick(NORTH, SOUTH, EAST, WEST)
			spawn( 0 )
				O.Life()
		if ("mustard")
//			world << "mustard"
			var/obj/effects/reallybadsmoke/O = new /obj/effects/reallybadsmoke( src.loc )
			O.dir = pick(NORTH, SOUTH, EAST, WEST)
			spawn( 0 )
				O.Life()
		if ("explosion")
//			world << "explosion"
			var/turf/T = get_turf(src.loc)
			T.firelevel = T.poison()
			T.res_vars()
			var/sw = locate(max(T.x - 4, 1), max(T.y - 4, 1), T.z)
			var/ne = locate(min(T.x + 4, world.maxx), min(T.y + 4, world.maxy), T.z)
			for(var/turf/U in block(sw, ne))
				var/zone = 4
				if ((U.y <= T.y + 2 && U.y >= T.y - 2 && U.x <= T.x + 2 && U.x >= T.x - 2))
					zone = 3
				for(var/atom/A as mob|obj|turf|area in U)
					A.ex_act(zone)
				U.ex_act(zone)
				U.buildlinks()
		if ("fire")
//			world << "fire"
			var/turf/T = src.loc
			var/turf/Tx1 = src.x + 1
			var/turf/Txm1 = src.x - 1
			var/turf/Ty1 = src.y + 1
			var/turf/Tym1 = src.y - 1
			if(isturf(T))
				T.poison(1550000)
				T.firelevel = max(T.firelevel, T.poison() + 1)
				T.oxygen(1000000)
			if(isturf(Tx1))
				Tx1.poison(1550000)
				Tx1.firelevel = max(Tx1.firelevel, Tx1.poison() + 1)
			if(isturf(Ty1))
				Ty1.poison(1550000)
				Ty1.firelevel = max(Ty1.firelevel, Ty1.poison() + 1)
			if(isturf(Txm1))
				Txm1.poison(1550000)
				Txm1.firelevel = max(Txm1.firelevel, Txm1.poison() + 1)
			if(isturf(Tym1))
				Tym1.poison(1550000)
				Tym1.firelevel = max(Tym1.firelevel, Tym1.poison() + 1)
			//		oxygen += firestrength * 10000
		if ("light")
//			world << "light"
			light()
			sleep(600)
	spawn (20)
		usr << "\blue Your beaker breaks!"
		del (src)
	return

////////////////////////////////////////
///obj/attackby(obj/item/weapon/grab/G as obj, mob/smasher as mob)
//	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
//		return
//	var/mob/smashee = G.affecting
//	var/obj/item/weapon/organ/external/organtohurt
//	if (istype(src, /obj/item/weapon/))
//		var/obj/item/weapon/Y = src
//		src.smashforce = Y.force
//	if (G.state == 1)
//		return
//	if (G.state == 2)
//		organtohurt = smashee.organs["chest"]
//		organtohurt.take_damage(src.smashforce, 0)
//		smashee:UpdateDamage()
//		smashee:UpdateDamageIcon()
//		for (var/mob/M in viewers())
//			M << "\red [smasher] has shoved [smashee] in to [src]!"
//	if (G.state == 3)
//		organtohurt = smashee.organs["head"]
//		organtohurt.take_damage(src.smashforce, 0)
//		smashee:UpdateDamage()
//		smashee:UpdateDamageIcon()
//		for (var/mob/M in viewers(smasher, null))
//			if ((M.client && !( M.blinded )))
//				M << "\red [smasher] has smashed [smashee]'s face on [src]!"