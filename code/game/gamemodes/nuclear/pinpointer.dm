/obj/item/weapon/pinpointer/attack_self(mob/user as mob)
	user.machine = src
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = "<B>Nuclear Disk Pinpointer</B><HR>"
		dat += "<A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"

	user << browse(dat, "window=radio")

/obj/item/weapon/pinpointer/Topic(href, href_list)
	..()

	if (usr.stat || usr.restrained())
		return

	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1 || usr.telekinesis == 1) && istype(src.loc, /turf))))
		usr.machine = src
		if (href_list["refresh"])
			src.temp = "<B>Nuclear Disk Pinpointer</B><HR>"
			var/turf/sr = get_turf(src)

			if (sr)
				src.temp += "<B>Located Disks:</B><BR>"
				for(var/obj/item/weapon/disk/nuclear/W in world)
					var/turf/tr = get_turf(W)
					if (tr && tr.z == sr.z)
						var/distance = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						var/strength = "unknown"
						var/directional = dir2text(get_dir(sr, tr));

						if (distance < 5)
							strength = "Very strong"
						else if (distance < 10)
							strength = "Strong"
						else if (distance < 15)
							strength = "Weak"
						else if (distance < 20)
							strength = "Very weak"
							directional = "unknown"
						else
							continue
						if (!directional)
							directional = "right on top of it"

						src.temp += "[directional] - [strength]<BR>"

				src.temp += "<B>You are at \[[sr.x],[sr.y],[sr.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else if (href_list["temp"])
			src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for (var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
