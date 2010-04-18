mob/var/zombieleader = 0
mob/var/zombieimmune = 0
/mob/proc/zombify()
	stat &= 1
	health = 100
	oxyloss = 0
	toxloss = 0
	becoming_zombie = 0
	fireloss = 0
	bruteloss = 0
	zombie = 1
	bodytemperature = 310.055
	see_in_dark = 5
	src.sight = 38
	UpdateClothing()
	src << "\red<font size=3> You have become a zombie!"
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M << "[rname] seizes up, his eyes dead and lifeless..."
	if(ticker.mode.name == "Zombie Outbreak")
		ticker.check_win()



/mob/proc/unzombify()
	zombie = 0
	see_in_dark = 2
	UpdateClothing()
	src << "You have been cured from being a zombie!"

/mob/proc/zombie_bit(var/mob/biter)
	var/mob/human/biten = src
	if(zombie || becoming_zombie || !is_living())
		return
	if(stat > 1)//dead: it takes time to reverse death, but there is no chance of failure
		sleep(50)
		zombify()
		return
	if(istype(biten.wear_suit, /obj/item/weapon/clothing/suit/bio_suit) || (istype(biten.head, /obj/item/weapon/clothing/head/bio_hood)))
		if(istype(biten.head, /obj/item/weapon/clothing/head/bio_hood) && (istype(biten.wear_suit, /obj/item/weapon/clothing/suit/bio_suit)))
			if(prob(50))
				for(var/mob/M in viewers(src, null))
					if ((M.client && !( M.blinded )))
						M << "[biter.name] fails to bite [name]"
				return
		else if(prob(25))
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M << "[biter.name] fails to bite [name]"
			return
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M << "[biter.name] bites [name]"
	if(zombieimmune)
		return
	if(prob(5))
		zombify()
	else if(prob(5))
		becoming_zombie = 1
		src << "You feel a strange itch"
		sleep(300)
		if(becoming_zombie)
			zombify()
	else if(prob(30))
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
/mob/proc/traitor_infect()
	becoming_zombie = 1
	zombieleader = 1
	src << "You feel a strange itch"
	sleep(300)
	if(becoming_zombie)
		zombify()

/mob/proc/admin_infect()
	becoming_zombie = 1
	src << "You faintly feel a strange itch"
	sleep(800)
	if(becoming_zombie)
		src << "You feel a strange itch, stronger this time"
		sleep(400)
		if(becoming_zombie)
			zombify()
/mob/verb/supersuicide()
	set name = "Zombie suicide"
	set hidden = 0
	if(zombie == 1)
		switch(alert(usr,"Are you sure you wanna die?",,"Yes","No"))
			if("Yes")
				fireloss = 999
				src << "You died suprised?"
				return
			else
				src << "You live to see another day."
				return
	else
		src << "Only for zombies."
