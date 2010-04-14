/obj/item/weapon/card/data/verb/label(t as text)
	set src in usr

	if (t)
		src.name = text("Data Disk- '[]'", t)
	else
		src.name = "Data Disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/verb/read()
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	return

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	var/input = input(user, "What is the name you wish to assign to this card", "Syndicate Card", "")
	src.registered = input
	input = input(user, "What assignment would you like to forge, be warned this does NOT give you the access, just the title", "Assignment", "")
	src.assignment = input
	src.name = text("[]'s ID Card ([])", registered, assignment)
	src.hide = alert("Do you want to enable the AI countermeasures (This causes you to be hidden on the AI tracking scanners, but does not hide you from cameras)", "Hide", "Yes", "No")
/obj/item/weapon/rods/attack_hand(mob/user as mob)
	if ((user.r_hand == src || user.l_hand == src))
		src.add_fingerprint(user)
		var/obj/item/weapon/rods/F = new /obj/item/weapon/rods( user )
		F.amount = 1
		src.amount--
		if (user.hand)
			user.l_hand = F
		else
			user.r_hand = F
		F.layer = 52
		F.add_fingerprint(user)
		if (src.amount < 1)
			//SN src = null
			del(src)
			return
	else
		..()
	return