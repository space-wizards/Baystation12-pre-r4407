/mob/proc/zombify()
	stat &= 1
	health = 100
	oxyloss = 0
	toxloss = 0
	fireloss = 0
	bruteloss = 0
	zombie = 1
	bodytemperature = 310.055
	see_in_dark = 5
	src.sight = 38
	UpdateClothing()
	src << "\red<font size=3> You have become a zombie!"
	view(5,src) << "[src.rname] seizes up, his eyes dead and lifeless..."
	if(ticker.mode.name == "Zombie Outbreak")
		ticker.check_win()


/mob/proc/unzombify()
	zombie = 0
	see_in_dark = 2
	UpdateClothing()
	src << "You have been cured from being a zombie!"

/mob/proc/zombie_bit(var/mob/biter)
	if(zombie || becoming_zombie || !is_living())
		return
	if(stat > 1)//dead: it takes time to reverse death, but there is no chance of failure
		sleep(50)
		zombify()
		return
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M << "[biter.name] bites [name]"
	if(prob(5))
		zombify()
	else if(prob(5))
		becoming_zombie = 1
		src << "You feel a strange itch"
		sleep(300)
		if(becoming_zombie)
			zombify()
	else if(prob(25))
		becoming_zombie = 1
		src << "You faintly feel a strange itch"
		sleep(800)
		if(becoming_zombie)
			src << "You feel a strange itch, stronger this time"
			sleep(400)
			if(becoming_zombie)
				zombify()

/mob/proc/zombie_infect()
	becoming_zombie = 1
	src << "You feel a strange itch"
	sleep(200)
	if(becoming_zombie)
		zombify()
