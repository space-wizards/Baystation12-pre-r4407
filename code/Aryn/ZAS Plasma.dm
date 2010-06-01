pl_control/var
	CLOTH_CONTAMINATION = 1 //If this is on, plasma does damage by getting into cloth.
	CLOTH_CONTAMINATION_RANDOM = 60

	ALL_ITEM_CONTAMINATION = 0 //If this is on, any item can be contaminated, so suits and tools must be discarded or
										  //decontaminated.
	ALL_ITEM_CONTAMINATION_RANDOM = 10

	PLASMAGUARD_ONLY = 0
	PLASMAGUARD_ONLY_RANDOM = 20

	CANISTER_CORROSION = 0         //If this is on, plasma must be stored in orange tanks and canisters,
	CANISTER_CORROSION_RANDOM = 20 //or it will corrode the tank.

	GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 10,000.
	GENETIC_CORRUPTION_RANDOM = "PROB10/3d6"

	SKIN_BURNS = 0       //Plasma has an effect similar to mustard gas on the un-suited.
	SKIN_BURNS_RANDOM = 10

	PLASMA_INJECTS_TOXINS = 0         //Plasma damage injects the toxins chemical to do damage over time.
	PLASMA_INJECTS_TOXINS_RANDOM = 30

	EYE_BURNS = 0 //Plasma burns the eyes of anyone not wearing eye protection.
	EYE_BURNS_RANDOM = 30

	N2O_REACTION = 0 //Plasma can react with N2O, making sparks and starting a fire if levels are high.
	N2O_REACTION_RANDOM = 5

	PLASMA_COLOR = "onturf" //Plasma can change colors yaaaay!
	PLASMA_COLOR_RANDOM = "PICKonturf,onturf,onturf,onturf,onturf,red,blue,purple,yellow,black"

	PLASMA_DMG_OFFSET = 1
	PLASMA_DMG_OFFSET_RANDOM = "1d5"
	PLASMA_DMG_QUOTIENT = 10
	PLASMA_DMG_QUOTIENT_RANDOM = "1d10+4"

	CONTAMINATION_LOSS = 0.01
	//CONTAMINATION_LOSS_RANDOM = "5d5"
//Plasma has a chance to be a different color.

obj/var/contaminated = 0

turf/var
	can_dist
	turf
		link_N
		link_S
		link_E
		link_W
turf/var
	has_plasma
	has_n2o
	dist_timer

turf/proc/GetDistLinks()
	if(Airtight(src))
		can_dist = 0
		if(link_N) link_N.link_S = null
		if(link_S) link_S.link_N = null
		if(link_E) link_E.link_W = null
		if(link_W) link_W.link_E = null
		return
	else
		can_dist = 1
	var/turf/T

	T = get_step(src,NORTH)
	link_N = null
	if(T)
		if(!Airtight(T,src))
			link_N = T
			T.link_S = src

	T = get_step(src,SOUTH)
	link_S = null
	if(T)
		if(!Airtight(T,src))
			link_S = T
			T.link_N = src

	T = get_step(src,EAST)
	link_E = null
	if(T)
		if(!Airtight(T,src))
			link_E = T
			T.link_W = src

	T = get_step(src,WEST)
	link_W = null
	if(T)
		if(!Airtight(T,src))
			link_W = T
			T.link_E = src

turf/proc/DistributeGas()
	if(istype(src,/turf/space))
		poison = 0
		sl_gas = 0
		return
	var
		total_plasma
		total_n2o
		turf/T
		tturfs = 1

	if(!can_dist)
		//world << "No Distribution"
		return

	T = link_N
	if(T)
		total_plasma += T.poison
		total_n2o += T.sl_gas
		tturfs++

	T = link_S
	if(T)
		total_plasma += T.poison
		total_n2o += T.sl_gas
		tturfs++

	T = link_E
	if(T)
		total_plasma += T.poison
		total_n2o += T.sl_gas
		tturfs++

	T = link_W
	if(T)
		total_plasma += T.poison
		total_n2o += T.sl_gas
		tturfs++

	total_plasma += src.poison
	total_n2o += src.sl_gas

	//world << "Total Turfs: [tturfs] Total Plasma: [total_plasma] Total N2O: [total_n2o]"

	T = link_N
	if(T)
		T.poison = total_plasma / (tturfs)
		T.sl_gas = total_n2o / (tturfs)

	T = link_S
	if(T)
		T.poison = total_plasma / (tturfs)
		T.sl_gas = total_n2o / (tturfs)

	T = link_E
	if(T)
		T.poison = total_plasma / (tturfs)
		T.sl_gas = total_n2o / (tturfs)

	T = link_W
	if(T)
		T.poison = total_plasma / (tturfs)
		T.sl_gas = total_n2o / (tturfs)

	poison = total_plasma / (tturfs)
	sl_gas = total_n2o / (tturfs)

	//world << "Distributed."

	if(poison() > 100000)
		if(!has_plasma)
			overlays += plmaster
			has_plasma = 1
	else if(has_plasma)
		overlays -= plmaster
		has_plasma = 0
	if(sl_gas() > 101000)
		if(!has_n2o)
			overlays += slmaster
			has_n2o = 1
	else if(has_n2o)
		overlays -= slmaster
		has_n2o = 0

	if(poison > 30000 && vsc.plc.CLOTH_CONTAMINATION)
		for(var/obj/item/weapon/W in src)
			if(W.can_contaminate()) W.contaminated = 1

	if((poison > 10000 && sl_gas > 10000) && vsc.plc.N2O_REACTION)
		var/obj/effects/sparks/S = new(src)
		S.Life()
		poison = 0
		sl_gas = 0
		//if(zone)
		//	zone.gases["Plasma"] += poison * 0
		//	poison -= poison * 0
		//	zone.gases["N2O"] += sl_gas * 0
		//	sl_gas -= sl_gas * 0

		//To make plasma and N2O become gases over time, use this.

obj/item/proc
	can_contaminate()
		if(flags & PLASMAGUARD) return 0
		if((flags & SUITSPACE) && !vsc.plc.PLASMAGUARD_ONLY) return 1
		if(vsc.plc.ALL_ITEM_CONTAMINATION) return 1
		else if(istype(src,/obj/item/weapon/clothing)) return 1
		else if(istype(src,/obj/item/weapon/storage/backpack)) return 1

mob/human/proc
	contaminate()

		if(!pl_suit_protected())
			suit_contamination()
		else if(vsc.plc.PLASMAGUARD_ONLY)
			if(!wear_suit.flags & PLASMAGUARD) wear_suit.contaminated = 1



		if(!pl_head_protected())
			if(wear_mask) wear_mask.contaminated = 1
			if(prob(1)) suit_contamination() //Plasma can sometimes get through such an open suit.
		else if(vsc.plc.PLASMAGUARD_ONLY)
			if(!head.flags & PLASMAGUARD) head.contaminated = 1

		if(istype(back,/obj/item/weapon/storage/backpack) || vsc.plc.ALL_ITEM_CONTAMINATION)
			back.contaminated = 1

		if(l_hand)
			if(l_hand.can_contaminate()) l_hand.contaminated = 1
		if(r_hand)
			if(r_hand.can_contaminate()) r_hand.contaminated = 1
		if(belt)
			if(belt.can_contaminate()) belt.contaminated = 1
		if(wear_id && !pl_suit_protected())
			if(wear_id.can_contaminate()) wear_id.contaminated = 1
		if(w_radio && !pl_head_protected())
			if(w_radio.can_contaminate()) w_radio.contaminated = 1

	suit_interior()
		. = list()
		if(!pl_suit_protected())
			for(var/obj/item/I in src)
				. += I
			return .
		. += wear_mask
		. += w_uniform
		. += shoes
		. += gloves
		if(!pl_head_protected())
			. += head

	pl_head_protected()
		if(head)
			if(head.flags & PLASMAGUARD || head.flags & HEADSPACE) return 1
		return 0
	pl_suit_protected()
		if(wear_suit)
			if(wear_suit.flags & PLASMAGUARD || wear_suit.flags & SUITSPACE) return 1
		return 0

	suit_contamination()
		if(vsc.plc.ALL_ITEM_CONTAMINATION)
			for(var/obj/item/I in src)
				I.contaminated = 1
		else
			if(wear_suit) wear_suit.contaminated = 1
			if(w_uniform) w_uniform.contaminated = 1
			if(shoes) shoes.contaminated = 1
			if(gloves) gloves.contaminated = 1
			if(wear_mask) wear_mask.contaminated = 1

	pl_effects()
		if(vsc.plc.SKIN_BURNS)
			if(!pl_head_protected() || !pl_suit_protected())
				burn_skin(0.75)
				if (coughedtime != 1)
					coughedtime = 1
					emote("gasp")
					spawn (20)
						coughedtime = 0
				updatehealth()
		if(vsc.plc.EYE_BURNS && !pl_head_protected())
			if(!wear_mask)
				if(prob(20)) usr << "\red Your eyes burn!"
				eye_stat += 2.5
				eye_blurry += 1.5
				if (eye_stat >= 20 && !(disabilities & BADVISION))
					src << "\red Your eyes start to burn badly!"
					disabilities |= BADVISION
				if (prob(max(0,eye_stat - 20) + 1))
					src << "\red You are blinded!"
					eye_blind += 20
					eye_stat = max(eye_stat-25,0)
			else
				if(!(wear_mask.flags & MASKCOVERSEYES))
					if(prob(20)) usr << "\red Your eyes burn!"
					eye_stat += 2.5
					eye_blurry = min(eye_blurry+1.5,50)
					if (eye_stat >= 20 && !(disabilities & BADVISION))
						src << "\red Your eyes start to burn badly!"
						disabilities |= BADVISION
					if (prob(max(0,eye_stat - 20) + 1) &&!eye_blind)
						src << "\red You are blinded!"
						eye_blind += 20
						eye_stat = 0
		if(vsc.plc.GENETIC_CORRUPTION)
			if(rand(1,1000) < vsc.plc.GENETIC_CORRUPTION)
				randmutb(src)
				src << "\red High levels of toxins cause you to spontaneously mutate."
				domutcheck(src,null)

mob/monkey/proc
	contaminate()
	pl_effects()