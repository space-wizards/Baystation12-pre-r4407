
/atom/proc/hear_sound(sound,dist)
	var/sound/B = sound
	for(var/mob/human/O in viewers(src,dist))		//If you find a way to get the human earmuffs working without all of this then im all ears :/
		if (O.besound)
			O << sound(B)
	for(var/mob/monkey/O in viewers(src,dist))
		if (O.besound)
			O << sound(B)
	for(var/mob/observer/O in viewers(src,dist))
		if (O.besound)
			O << sound(B)
	for(var/mob/observer/O in viewers(src,dist))
		if (O.besound)
			O << sound(B)
	return

/mob/verb/soundtoggle()
	set name = "Sound Toggle"
	if(src.besound == 0)
		src.besound = 1
		src << "\red Sounds toggled on!"
		return
	src.besound = 0
	src << "\red Sounds toggled off!"