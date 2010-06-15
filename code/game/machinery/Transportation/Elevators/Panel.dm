/obj/machinery/elevator/panel
	icon_state = "panel"
	icon='elevator.dmi'
	name = "Elevator Panel"
	var/id = ""
	var/datum/elevator/elevator = null
	layer = 3.1

/obj/machinery/elevator/panel/New()
	..()
	spawn(5)
		elevator = get_elevator(id)
		for (var/datum/elevfloor/EF in elevator.floors)
			EF.panel = src

/obj/machinery/elevator/panel/process()
	if (stat & (NOPOWER|BROKEN))
		return
	use_power(55)

/obj/machinery/elevator/panel/attack_paw(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator/panel/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator/panel/attack_hand(var/mob/user)
	if (stat & (NOPOWER|BROKEN))
		return
	Interact(user)

/obj/machinery/elevator/panel/proc/Interact(var/mob/user)
	var/dat = "<31>Elevator Console</h3><hr>"

	dat += "Current Floor: [elevator.currentfloor] <br>"

	dat += "<table><tr><th>Floor</th><td>&nbsp;</td><th>Request</th></tr>"

	for (var/datum/elevfloor/EF in elevator.floors)
		dat += "<tr><td>[EF.name]</td><td>&nbsp;</td><td>[EF.req ? "Requested" : "<a href='?src=\ref[src];call=[EF.zlevel]'>Request</a>" ]</td></tr>"

	dat += "</table><br>"

	dat += "<a href='?src=\ref[user];mach_close=elevpanel'>Close</a>"

	user << browse(dat, "window=elevpanel;size=250x500")

/obj/machinery/elevator/panel/Topic(href, href_list)
	if (..()) return
	usr.machine = src

	if (href_list["call"])
		var/datum/elevfloor/EF = elevator.get_floor(text2num(href_list["call"]))
		EF.req = 1
		updateUsrDialog()

