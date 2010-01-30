#define FEVER 1

/obj/virus
	var
		amount = 100
		infect = 0 // whether this virus is infecting someone

/obj/virus/New()
	..()
	//spawn start()

/obj/virus/proc/start()
	/*reproduce()
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
			reproduce()*/

/obj/virus/proc/reproduce()
	/*spawn
		sleep(30)
		var/turf/T = loc
		if(infect || !istype(T,/turf)) return
		for(var/turf/X in T.FindLinkedTurfs())
			if(!(locate(/obj/virus) in X) && prob(50))
				var/obj/virus/V = new src.type(X)
				V.amount = amount - 10*/

/obj/virus/proc/spread(mob/M)
	/*if(M.has_air_contact() || !M.internal)
		if(prob(40) && !(locate(/obj/virus/) in M.loc))
			new src.type(M.loc)*/

/obj/virus/proc/infect(mob/M)
	/*if(!(locate(type) in M.viri))
		var/obj/virus/V = new type()
		V.infect = 1
		M.viri += V

		spawn while(1)
			sleep(20)
			spread(M)*/

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

/obj/virus/fever/affect(mob/M)
	if(progress < 1000 && M.r_fever > 1)
		if(prob(M.r_fever / 10)) M.cure(/obj/virus/fever)
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
			M.toxloss += 2
		if(progress > 800)
			M.r_fever += 10


	if(!M.internal || prob(30))
		if(progress > 200)
			if(istype(M,/mob/human))
				var/mob/human/H = M
				H.emote("cough")
			spread()