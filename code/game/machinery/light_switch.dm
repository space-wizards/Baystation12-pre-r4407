// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var

/obj/machinery/light_switch/New()
	..()
	spawn(5)
		src.area = src.loc.loc

		if(otherarea)
			src.area = locate(text2path("/area/[otherarea]"))

		if(!name)
			name = "light switch ([area.name])"

		src.on = src.area.lightswitch
		updateicon()



/obj/machinery/light_switch/updateicon()
	if(stat & NOPOWER)
		icon_state = "light-p"
	else
		if(on)
			icon_state = "light1"
		else
			icon_state = "light0"

/obj/machinery/light_switch/examine()
	set src in oview(1)
	if(usr && !usr.stat)
		usr << "A light switch. It is [on? "on" : "off"]."

/obj/machinery/light_switch/attack_ai(mob/ai/user)
	togglelights()

/obj/machinery/light_switch/attack_paw(mob/user)
	src.attack_hand(user)

/obj/machinery/light_switch/proc/propagate()
	src.on = src.area.lightswitch
	updateicon()

/obj/machinery/light_switch/attack_hand(mob/user)
	user << "\blue You flick the light switch"
	togglelights()

/obj/machinery/light_switch/proc/togglelights()
	on = !on

	for(var/x in typesof(/obj/machinery/light))
		var/obj/machinery/light/L = locate(x)
		if (!L) continue
		transmitmessage(createmulticast("000", gettypeid(L.type), "[area.superarea.areaid] LIGHTS [on ? "ON" : "OFF"]"))

	//transmitmessage(createmulticast("000", gettypeid(/obj/machinery/light), "[area.superarea.areaid] LIGHTS [on ? "ON" : "OFF"]"))
	//transmitmessage(createmulticast("000", gettypeid(/obj/machinery/light/incandescent), "[area.superarea.areaid] LIGHTS [on ? "ON" : "OFF"]"))
	//transmitmessage(createmulticast("000", gettypeid(/obj/machinery/light/dimlight), "[area.superarea.areaid] LIGHTS [on ? "ON" : "OFF"]"))
	//transmitmessage(createmulticast("000", gettypeid(/obj/machinery/light/incandescent/spotlight), "[area.superarea.areaid] LIGHTS [on ? "ON" : "OFF"]"))

	transmitmessage(createmulticast("000", typeID, "[area.superarea.areaid] STATUS [on]"))

/obj/machinery/light_switch/receivemessage(message, srcmachine)
	if(..())
		return
	var/list/listofcommand = getcommandlist(message)
	if(listofcommand.len < 3)
		return
	if (listofcommand[2] == "STATUS" && (listofcommand[1] == "*" || listofcommand[1] == area.superarea.areaid))
		on = text2num(listofcommand[3])
		updateicon()

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()