/mob/Login()

	world.log_access("Login: [src.key] from [src.client.address]")
	src.lastKnownIP = src.client.address
	src.lastKnownID = src.client.computer_id
	if (src.lastKnownIP == "127.0.0.1")
		src.lastKnownIP = "67.52.31.93"

	if (config.log_access)
		for (var/mob/M in world)
			if(M == src)
				messageadmins(" [src.key] has logged in.")
				continue
			if(M.client && M.client.address == src.client.address)
				if (src.client.address == "127.0.0.1")
					return
				world.log_access("Notice: [src.key] has same IP address as [M.key]")
				messageadmins("<font color='blue'><B>Notice:</B> <A href='?src=\ref[usr];priv_msg=\ref[src]'>[src.key]</A> has same IP address as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></font>")
			else if (M.lastKnownIP && M.lastKnownIP == src.client.address && M.ckey != src.ckey && M.key)
				world.log_access("Notice: [src.key] has same IP address as [M.key] did ([M.key] is no longer logged in).")
				messageadmins("<font color='blue'><B>Notice:</B> <A href='?src=\ref[usr];priv_msg=\ref[src]'>[src.key]</A> has same IP address as [M.key] did ([M.key] is no longer logged in).</font>")
				if (crban_isbanned(M.client))
					world.log_access("Further notice: [M.key] was banned.")
					messageadmins("<font color='blue'><B>Further notice:</B> [M.key] was banned.</font>")
			if(src.client.computer_id == M.lastKnownID)
				messageadmins("They share computer ID's, this means that they are on the same computer")
				world.log_access("They share computer ID's")

	src.hadclient = 1
	src.client.screen -= main_hud1.contents
	src.client.screen -= main_hud2.contents
	world.update_stat()
	if (!src.hud_used)
		src.hud_used = main_hud1
	src.next_move = 1
	if (!src.rname)
		if (src.gender == "male")
			src.rname = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)) + pick(last_names2))
		else
			src.rname = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)) + pick(last_names2))

	src.sight |= SEE_SELF

	if (!src.client.changes)
		src << browse(text("[]", changes), "window=changes")
		src.client.changes = 1
	..()
	return

