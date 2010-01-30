/client
	var/obj/admins/holder = null
	var/authenticated = 0
	var/authenticating = 0
	var/listen_ooc = 1
	var/move_delay = 1
	var/moving = null
	var/vote = null
	var/showvote = null
	var/adminobs = null
	var/changes = 0
	var/canplaysound = 1