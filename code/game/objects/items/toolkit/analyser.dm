/obj/item/weapon/analyzer/attack_self(mob/user as mob)

	if (user.stat)
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		usr << "\red You don't have the dexterity to do this!"
		return
	var/turf/T = user.loc
	if (!( istype(T, /turf) ))
		return
	if (locate(/obj/move, T))
		T = locate(/obj/move, T)
	var/turf_total = T.per_turf()
	turf_total = max(turf_total, 1)
	user.show_message("\blue <B>Results:</B>", 1)
	var/t = ""
	var/t1 = turf_total / CELLSTANDARD * 100
	if ((90 < t1 && t1 < 110))
		user.show_message(text("\blue Air Pressure: []%", t1), 1)
	else
		user.show_message(text("\blue Air Pressure:\red []%", t1), 1)
	t1 = T.n2() / turf_total * 100
	t1 = round(t1, 0.0010)
	if ((60 < t1 && t1 < 80))
		t += text("<font color=blue>Nitrogen: []</font> ", t1)
	else
		t += text("<font color=red>Nitrogen: []</font> ", t1)
	t1 = T.oxygen() / turf_total * 100
	t1 = round(t1, 0.0010)
	if ((20 < t1 && t1 < 24))
		t += text("<font color=blue>Oxygen: []</font> ", t1)
	else
		t += text("<font color=red>Oxygen: []</font> ", t1)
	t1 = T.poison() / turf_total * 100
	t1 = round(t1, 0.0010)
	if (t1 < 0.5)
		t += text("<font color=blue>Plasma: []</font> ", t1)
	else
		t += text("<font color=red>Plasma: []</font> ", t1)
	t1 = T.co2() / turf_total * 100
	t1 = round(t1, 0.0010)
	if (t1 < 1)
		t += text("<font color=blue>CO2: []</font> ", t1)
	else
		t += text("<font color=red>CO2: []</font> ", t1)
	t1 = T.sl_gas() / turf_total * 100
	t1 = round(t1, 0.0010)
	if (t1 < 5)
		t += text("<font color=blue>N2O: []</font>", t1)
	else
		t += text("<font color=red>N2O: []</font>", t1)
	user.show_message(t, 1)
	user.show_message(text("\blue \t Temperature: []&deg;C", (T.temp()-T0C) ), 1)
	src.add_fingerprint(user)
	return