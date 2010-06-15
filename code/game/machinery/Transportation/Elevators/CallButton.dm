/obj/machinery/elevator/callbutton
	name = "Call Button"
	icon='elevator.dmi'
	icon_state = "callbutton"
	var/id = ""
	var/datum/elevfloor/floor = null

/obj/machinery/elevator/callbutton/New()
	..()
	spawn(5)
		var/datum/elevator/E = get_elevator(id)
		floor = E.get_floor(z)
		floor.buttons += src

/obj/machinery/elevator/callbutton/attack_hand(var/mob/user)
	icon_state = "callbutton1"
	floor.called = 1
	user << "\blue You call the elevator"

/obj/machinery/elevator/callbutton/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator/callbutton/attack_paw(var/mob/user)
	return attack_hand(user)

/obj/machinery/elevator/callbutton/attackby(var/item/weapon/W, var/mob/user)
	return attack_hand(user)
				return
