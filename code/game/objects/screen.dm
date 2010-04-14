/obj/screen/close/DblClick()
	if (src.master)
		src.master:close(usr)
	return

/obj/screen/storage/attackby(W, mob/user as mob)
	src.master.attackby(W, user)
	return
