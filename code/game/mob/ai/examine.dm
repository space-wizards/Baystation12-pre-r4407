/mob/ai/examine()
	set src in oview()

	usr << "\blue *---------*"
	usr << text("\blue This is \icon[] <B>[]</B>!", src, src.name)
	if (src.dead())
		usr << text("\red [] is powered-down.", src.name)
	else
		if (src.bruteloss)
			if (src.bruteloss < 30)
				usr << text("\red [] looks slightly dented", src.name)
			else
				usr << text("\red <B>[] looks severely dented!</B>", src.name)
			if (src.fireloss)
				if (src.fireloss < 30)
					usr << text("\red [] looks slightly burnt!", src.name)
				else
					usr << text("\red <B>[] looks severely burnt!</B>", src.name)
				if (src.knocked_out())
					usr << text("\red [] doesn't seem to be responding.", src.name)
	return
/mob/ai/verb/atmoalert(var/area/A in world)
	set category = "AI Commands"
	set name = "Atmospheerical Alert"
	usr.say("Irregular Atmospherical Conditions detected in [A]")
/mob/ai/verb/hullalert(var/area/A in world)
	set category = "AI Commands"
	set name = "Hull Breach Alert"
	usr.say("Hull Breach detected in [A]")
	return
/mob/ai/verb/firealert(var/area/A in world)
	set category = "AI Commands"
	set name = "Fire Alert"
	usr.say("Fire detected in [A]")
/mob/ai/verb/fightalert(var/area/A in world)
	set category = "AI Commands"
	set name = "Violence Alert"
	usr.say("Violence detected in [A]")