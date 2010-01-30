/mob/Logout()
	world.log_access("Logout: [src.key]")
	if (src.key != "" || src.key != " ") // Tired of ' : Has logged out' spam arggggh
		messageadmins(" [src.key] has logged out.")
	if(!src.start)
		del(src)
		return
	else
		..()
	return