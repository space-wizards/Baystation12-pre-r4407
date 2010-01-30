/obj/machinery/computer/hologram_comp/New()
	..()
	spawn( 10 )
		src.projector = locate(/obj/machinery/hologram_proj, get_step(src.loc, NORTH))
		return
	return

/obj/machinery/computer/hologram_comp/DblClick()
	if (get_dist(src, usr) > 1)
		return 0
	src.show_console(usr)
	return

/obj/machinery/computer/hologram_comp/proc/render()
	var/icon/I = new /icon('human.dmi', "body_m_s")

	if (src.lumens >= 0)
		I.Blend(rgb(src.lumens, src.lumens, src.lumens), ICON_ADD)
	else
		I.Blend(rgb(- src.lumens,  -src.lumens,  -src.lumens), ICON_SUBTRACT)

	I.Blend(new /icon('human.dmi', "mouth_m_s"), ICON_OVERLAY)
	I.Blend(new /icon('human.dmi', "diaper_m_s"), ICON_OVERLAY)

	var/icon/U = new /icon('human_face.dmi', "hair_a_s")
	U.Blend(rgb(src.h_r, src.h_g, src.h_b), ICON_ADD)

	I.Blend(U, ICON_OVERLAY)

	src.projector.projection.icon = I

/obj/machinery/computer/hologram_comp/proc/show_console(var/mob/user as mob)
	var/dat
	user.machine = src
	if (src.temp)
		dat = text("[]<BR><BR><A href='?src=\ref[];temp=1'>Clear</A>", src.temp, src)
	else
		dat = text("<B>Hologram Status:</B><HR>\nPower: <A href='?src=\ref[];power=1'>[]</A><HR>\n<B>Hologram Control:</B><BR>\nColor Luminosity: []/220 <A href='?src=\ref[];reset=1'>\[Reset\]</A><BR>\nLighten: <A href='?src=\ref[];light=1'>1</A> <A href='?src=\ref[];light=10'>10</A><BR>\nDarken: <A href='?src=\ref[];light=-1'>1</A> <A href='?src=\ref[];light=-10'>10</A><BR>\n<BR>\nHair Color: ([],[],[]) <A href='?src=\ref[];h_reset=1'>\[Reset\]</A><BR>\nRed (0-255): <A href='?src=\ref[];h_r=-300'>\[0\]</A> <A href='?src=\ref[];h_r=-10'>-10</A> <A href='?src=\ref[];h_r=-1'>-1</A> [] <A href='?src=\ref[];h_r=1'>1</A> <A href='?src=\ref[];h_r=10'>10</A> <A href='?src=\ref[];h_r=300'>\[255\]</A><BR>\nGreen (0-255): <A href='?src=\ref[];h_g=-300'>\[0\]</A> <A href='?src=\ref[];h_g=-10'>-10</A> <A href='?src=\ref[];h_g=-1'>-1</A> [] <A href='?src=\ref[];h_g=1'>1</A> <A href='?src=\ref[];h_g=10'>10</A> <A href='?src=\ref[];h_g=300'>\[255\]</A><BR>\nBlue (0-255): <A href='?src=\ref[];h_b=-300'>\[0\]</A> <A href='?src=\ref[];h_b=-10'>-10</A> <A href='?src=\ref[];h_b=-1'>-1</A> [] <A href='?src=\ref[];h_b=1'>1</A> <A href='?src=\ref[];h_b=10'>10</A> <A href='?src=\ref[];h_b=300'>\[255\]</A><BR>", src, (src.projector.projection ? "On" : "Off"),  -src.lumens + 35, src, src, src, src, src, src.h_r, src.h_g, src.h_b, src, src, src, src, src.h_r, src, src, src, src, src, src, src.h_g, src, src, src, src, src, src, src.h_b, src, src, src)
	user << browse(dat, "window=hologram_console")
	return

/obj/machinery/computer/hologram_comp/Topic(href, href_list)
	if(..())
		return
	if ((get_dist(src, usr) <= 1 || usr.telekinesis == 1))
		flick("holo_console1", src)
		if (href_list["power"])
			if (src.projector.projection)
				src.projector.icon_state = "hologram0"
				//src.projector.projection = null
				del(src.projector.projection)
			else
				src.projector.projection = new /obj/projection(src.projector.loc)
				src.projector.projection.icon = 'human.dmi'
				src.projector.projection.icon_state = "body_m_s"
				src.projector.icon_state = "hologram1"
				src.render()
		else
			if (href_list["h_r"])
				if (src.projector.projection)
					src.h_r += text2num(href_list["h_r"])
					src.h_r = min(max(src.h_r, 0), 255)
					render()
			else
				if (href_list["h_g"])
					if (src.projector.projection)
						src.h_g += text2num(href_list["h_g"])
						src.h_g = min(max(src.h_g, 0), 255)
						render()
				else
					if (href_list["h_b"])
						if (src.projector.projection)
							src.h_b += text2num(href_list["h_b"])
							src.h_b = min(max(src.h_b, 0), 255)
							render()
					else
						if (href_list["light"])
							if (src.projector.projection)
								src.lumens += text2num(href_list["light"])
								src.lumens = min(max(src.lumens, -185.0), 35)
								render()
						else
							if (href_list["reset"])
								if (src.projector.projection)
									src.lumens = 0
									render()
							else
								if (href_list["temp"])
									src.temp = null
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.show_console(M)
	return

/turf/station/command/floor/updatecell()
	src.oxygen = O2STANDARD
	src.firelevel = 0
	src.co2 = 0
	src.poison = 0
	src.sl_gas = 0
	src.n2 = N2STANDARD
	return

/turf/station/command/conduction()
	return

/turf/station/command/floor/attack_paw(user as mob)
	return src.attack_hand(user)

/turf/station/command/floor/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.pulling = null
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.pulling = t
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return