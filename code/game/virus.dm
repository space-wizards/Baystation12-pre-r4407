#define FEVER 1

/obj/virus
	var
		amount = 100
		infect = 0 // whether this virus is infecting someone
		bdesc = "TEMPLATE BUG"
	invisibility = 101

/obj/virus/New()
	..()
	//spawn start()

/obj/virus/proc/start()
	reproduce()
	while(1)
		sleep(10)
		if(infect) break
		amount -= 2
		if(amount <= 0) del src

		for(var/mob/human/H in loc)
			if(H.has_air_contact() && prob(10))
				infect(H)
			if(!H.internal && prob(30))
				infect(H)
		for(var/mob/monkey/M in loc)
			if(prob(10)) infect(M)

		if(prob(10))
			reproduce()

/obj/virus/proc/reproduce()
	spawn
		sleep(30)
		var/turf/T = loc
		if(infect || !istype(T,/turf)) return
		for(var/turf/X in T.FindLinkedTurfs())
			if(!(locate(/obj/virus) in X) && prob(50))
				var/obj/virus/V = new src.type(X)
				V.amount = amount - 10

/obj/virus/proc/spread(mob/M)
	if(M != null)
		if(M.has_air_contact() || !M.internal)
			if(prob(40) && !(locate(/obj/virus/) in M.loc))
				new src.type(M.loc)

/obj/virus/proc/infect(mob/M)
	if(!(locate(type) in M.viri))
		if(istype(M,/mob/human))
			var/mob/human/H = M
			if(istype(H.wear_mask,/obj/item/weapon/clothing/mask/surgical))
				return

		var/obj/virus/V = new type()
		V.infect = 1
		M.viri += V

		spawn while(1)
			sleep(20)
			spread(M)

/obj/virus/proc/affect(mob/M)

/mob/var/list/viri = new

/mob/proc/is_infected(vir)
	return (locate(vir) in viri)
/mob/proc/cure(vir)
	if(locate(vir) in viri)
		viri -= locate(vir) in viri


/obj/virus/fever
	amount = 100
	var/progress = 0
	bdesc = "Space-fever, a common but deadly bug found on neo-transian stations. Can be cured with fever pills"

/obj/virus/fever/affect(mob/M)
	if(M.feverD)
		return
	if(progress < 1000 && M.r_fever > 1)
		if(prob(M.r_fever / 10))
			M.cure(/obj/virus/fever)
			if(prob(70))
				M.feverD = 1
		return
	progress++
	if(!M.sleeping || prob(50))
		if(progress > 80)
			M.bodytemperature += 1
		if(progress > 160)
			M.bodytemperature += 2
		if(progress > 300)
			M.drowsyness = 1
			M.bodytemperature += 3
		if(progress > 400)
			M.weakened = 1
			M.bodytemperature += 6
		if(progress > 500)
			M.bodytemperature += 12
			if(prob(10) && istype(M,/mob/human))
				var/mob/human/H = M
				spawn(10)
					H.emote("gasp")
					H.paralysis += 5
		if(progress > 800)
			M.r_fever += 10
			M.toxloss += 10

	if(!M.internal && prob(15))
		if(progress > 200)
			if(istype(M,/mob/human) )
				var/mob/human/H = M
				H.emote("cough")
			spread(M)

/obj/virus/spacemonkey
	amount = 100
	var/progress = 0
	bdesc = "Mutated Space-fever, a common bug with yet to be discovered properties. Can be cured with fever pills"

/obj/virus/spacemonkey/affect(mob/M)
	if(M.spacemonkeyD)
		return
	if(istype(M,/mob/human))

		if(progress < 1000 && M.r_fever > 1)
			if(prob(M.r_fever / 10))
				M.cure(/obj/virus/spacemonkey)
				if(prob(70))
					M.spacemonkeyD = 1
			return
		progress++
		if(!M.sleeping || prob(50))
			if(progress > 80)
				M.bodytemperature += 1
			if(progress > 160)
				M.bodytemperature += 2
			if(progress > 600)
				M.bodytemperature += 3
			if(progress > 700)
				M.weakened = 1
				M.bodytemperature += 6
			if(progress > 800)
				M.bodytemperature += 12
				M.drowsyness = 1
				if(prob(10) && istype(M,/mob/human))
					var/mob/human/H = M
					spawn(10)
						H.emote("whimper")
						H.paralysis += 5
			if(progress > 900)
				var/mob/human/H = M
				H.monkeyize()
				if(prob(70))
					H.spacemonkeyD = 1
		if(!M.internal && prob(15))
			if(progress > 200)
				if(istype(M,/mob/human) )
					var/mob/human/H = M
					H.emote("whimper")
				spread(M)

/obj/virus/coughfever
	amount = 100
	var/progress = 0
	bdesc = "A resiliant form of fever, not deadly but has an unknown cure. Called coughfever"

/obj/virus/coughfever/affect(mob/M)
	if(M.coughfeverD)
		return
	if(M.druggy > 1)
		if(prob(M.druggy / 10))
			M.cure(/obj/virus/coughfever)
			if(prob(70))
				M.coughfeverD = 1
		return
	progress++
	if(!M.sleeping || prob(15))
		if(progress > 800)
			if(prob(5) && istype(M,/mob/human))
				var/mob/human/H = M
				H.emote("cough")

	if(!M.internal && prob(15))
		if(progress > 200)
	//		if(istype(M,/mob/human) )
		//		var/mob/human/H = M
		//		H.emote("cough")
			spread(M)

/obj/virus/poweritis
	amount = 100
	var/progress = 0
	bdesc = "Unknown virus, designation:poweritis"

/obj/virus/poweritis/affect(mob/M)
	if(M.poweritisD)
		M.xray = 0
		M.firemut = 0
		M.ishulk = 0
		return
	if(M.b_acid > 1)
		if(prob(M.b_acid / 10))
			M.cure(/obj/virus/poweritis)
			if(prob(70))
				M.poweritisD = 1
		return
	progress++
	if(!M.sleeping || prob(15))
		if(progress > 300)
			M.xray = 1
		if(progress > 500)
			M.firemut = 1
		if(progress > 700)
			M.ishulk = 1
		if(progress > 750)
			if(prob(5) && istype(M,/mob/human))
				var/mob/human/H = M
				H.toxloss += 10

	if(!M.internal && prob(15))
		if(progress > 100)
	//		if(istype(M,/mob/human) )
		//		var/mob/human/H = M
		//		H.emote("cough")
			spread(M)

/obj/virus/radiation
	amount = 100
	var/progress = 0
	bdesc = "Unknown virus: Gives off radiation"

/obj/virus/radiation/affect(mob/M)
	if(M.radiationD)
		return
	if(M.rejuv > 1)
		if(prob(M.rejuv/ 10))
			M.radiation = 0
			M.cure(/obj/virus/radiation)
			if(prob(70))
				M.radiationD = 1
		return
	progress++
	if(!M.sleeping || prob(15))
		if(progress > 400)
			M.bodytemperature += 5
		if(progress > 1000)
			if(istype(M.loc,/turf/))
				var/turf/C = M.loc
				C.poison += 1.3E6
				M.toxloss = 0
		if(progress > 1200)
			M.radiation += 5

	if(!M.internal && prob(15))
		if(progress > 100)
			if(istype(M,/mob/human) )
				var/mob/human/H = M
				H.emote("shiver")
			spread(M)

/obj/virus/humanitis
	amount = 100
	var/progress = 0
	bdesc = "Seams to effect monkey cells only"

/obj/virus/humanitis/affect(mob/M)
	if(M.rejuv > 1)
		if(prob(M.rejuv/ 10))
			M.radiation = 0
			M.cure(/obj/virus/humanitis)
		return
	progress++
	if(!M.sleeping || prob(15))
		if(progress > 500)
			if(istype(M,/mob/monkey))
				var/mob/monkey/C = M
				C.humanize()

	if(!M.internal && prob(15))
		if(progress > 100)
			if(istype(M,/mob/human) )
				var/mob/human/H = M
				H.emote("shiver")
			spread(M)