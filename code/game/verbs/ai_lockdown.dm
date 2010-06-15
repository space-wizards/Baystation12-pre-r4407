/mob/ai/proc/lockdown()
	set category = "AI Commands"
	set name = "Lockdown"

	if(usr.stat == 2)
		usr <<"You cannot initiate lockdown because you are dead!"
		return

	world << "\red Lockdown initiated by [usr.name]!"

	for(var/obj/machinery/firealarm/FA in world) //activate firealarms
		spawn( 0 )
			if(!FA.lockdownbyai)
				FA.alarm(1)

/mob/ai/proc/disablelockdown()
	set category = "AI Commands"
	set name = "Disable Lockdown"

	if(usr.stat == 2)
		usr <<"You cannot disable lockdown because you are dead!"
		return

	world << "\red Lockdown cancelled by [usr.name]!"

	for(var/obj/machinery/firealarm/FA in world) //deactivate firealarms
		spawn( 0 )
			if(FA.lockdownbyai)
				FA.reset(1)