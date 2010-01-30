/client/proc/play_sound(S as sound)
	set category = "Admin"
	set name = "play sound"

	//if(Debug2)
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(config.crackdown)
		return

	if(usr.client.canplaysound && canplaysound)
		usr.client.canplaysound = 0
		canplaysound = 0
		world.log_admin("[src] played sound [S]")
		messageadmins("[src] played sound [S]")
		world << "[src] has played sound [S]."
		world << sound(S,0,1,1)
	//	spawn(3000)
		canplaysound = 1
	//	spawn(4200)
		usr.client.canplaysound = 1


	//else
	//	alert("Debugging is disabled")
	//	return