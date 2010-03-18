/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if(src.holder.rank == "Host")
		Debug2 = !Debug2

		//world << "Debugging [Debug2 ? "On" : "Off"]"
	else
		alert("Hosts only baby")
		return

/client/proc/callproc()
	set category = "Debug"
	set name = "Advanced ProcCall"
	var/target = null
	var/arguments = null
	var/returnval = null
	//var/class = null

	switch(alert("Proc owned by obj?",,"Yes","No"))
		if("Yes")
			target = input("Enter target:","Target",null) as obj|mob|area|turf in world
		if("No")
			target = null

	var/procname = input("Procpath","path:", null)

	if (target)
		arguments = input("Arguments","Arguments:", null)
		usr << "\blue Calling '[procname]' with arguments '[arguments]' on '[target]'"
		returnval = call(target,procname)(arguments)
	else
		arguments = input("Arguments","Arguments:", null)
		usr << "\blue Calling '[procname]' with arguments '[arguments]'"
		returnval = call(procname)(arguments)

	usr << "\blue Proc returned: [returnval]"
/*
	var/argnum = input("Number of arguments:","Number",null) as num


	var/i
	for(i=0, i<argnum, i++)

		class = input("Type of Argument #[i]","Variable Type", default) in list("text","num","type","reference","mob reference", "icon","file","cancel")
		switch(class)
			if("cancel")
				return

			if("text")
				var/"argu"+i = input("Enter new text:","Text",null) as text

			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num

			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/obj,/mob,/area,/turf)

			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world

			if("mob reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob in world

			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file

			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon
		spawn(0)
			call(T,wproc)(warg)
*/

/client/proc/fire(turf/T as turf in world)
	set category = "Debug"
	set name = "Create Fire"
	usr << "\blue Fire created."
	spawn(0)
		T.poison += 30000000
		T.firelevel = T.poison
	//world << "[usr.key] created some fire! What a douche."

/client/proc/co2(turf/T as turf in world)
	set category = "Debug"
	set name = "Create CO2"
	usr << "\blue CO2 created."
	spawn(0)
		T.co2 += 300000000
	//world << "[usr.key] created some CO2! What a douche."

/client/proc/n2o(turf/T as turf in world)
	set category = "Debug"
	set name = "Create N2O"
	usr << "\blue N2O created."
	spawn(0)
		T.sl_gas += 30000000
	//world << "[usr.key] created some N2O!"

/client/proc/explosion(T as obj|mob|turf in world)
	set category = "Debug"
	set name = "Create Explosion"
	var/confirm = alert("Do you want the world to randomly combust", "DEATH TO ALL LIFE", "Yes", "No")
	if(confirm == "Yes")
		usr << "\blue Explosion created."
		var/obj/item/weapon/tank/plasmatank/pt = new /obj/item/weapon/tank/plasmatank( T )
		pt.gas.temperature = 600+T0C
		pt.ignite()
	//world << "[usr.key] created an explosion!"


/client/proc/droptarget(mob/M as mob in world)
	set category = "Admin"
	set name = "Drop everything"
	usr << "\blue Target dropped items."
	for(var/obj/item/weapon/W in M)
		if (!istype(W,/obj/item/weapon/organ))
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)
	world << "[usr.key] made [M.key] drop everything!"

/client/proc/tdome1(mob/M as mob in world)
	set category = "Admin"
	set name = "Thunderdome (Team1)"
	for(var/obj/item/weapon/W in M)
		if (!istype(W,/obj/item/weapon/organ))
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)
			del(W)
	var/mob/human/H = M
	for(var/A in H.organs)
		var/obj/item/weapon/organ/external/affecting = null
		if(!H.organs[A])    continue
		affecting = H.organs[A]
		if(!istype(affecting, /obj/item/weapon/organ/external))    continue
		affecting.heal_damage(1000, 1000)
	M.fireloss = 0
	M.toxloss = 0
	M.bruteloss = 0
	M.oxyloss = 0
	M.paralysis = 0
	M.stunned = 0
	M.weakened = 0
	M.health = 100
	M.radiation = 0
	M.updatehealth()
	M.buckled = null
	H.UpdateDamageIcon()
	if (M.stat) M.stat = 0
	M.loc = pick(tdome1)
	usr << "\blue Done."
	M << "\blue You have been sent to the Thunderdome."

/client/proc/tdome2(mob/M as mob in world)
	set category = "Admin"
	set name = "Thunderdome (Team2)"
	for(var/obj/item/weapon/W in M)
		if (!istype(W,/obj/item/weapon/organ))
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)
			del(W)
	var/mob/human/H = M
	for(var/A in H.organs)
		var/obj/item/weapon/organ/external/affecting = null
		if(!H.organs[A])    continue
		affecting = H.organs[A]
		if(!istype(affecting, /obj/item/weapon/organ/external))    continue
		affecting.heal_damage(1000, 1000)
	M.fireloss = 0
	M.toxloss = 0
	M.bruteloss = 0
	M.oxyloss = 0
	M.paralysis = 0
	M.stunned = 0
	M.weakened = 0
	M.health = 100
	M.radiation = 0
	M.updatehealth()
	M.buckled = null
	H.UpdateDamageIcon()
	if (M.stat) M.stat = 0
	M.loc = pick(tdome2)
	usr << "\blue Done."
	M << "\blue You have been sent to the Thunderdome."


/client/proc/nodamage(mob/M as mob in world)
	set category = "Debug"
	set name = "Toggle No damage"
	if (M.nodamage == 1)
		M.nodamage = 0
		usr << "\blue Toggled OFF"
	else
		M.nodamage = 1
		usr << "\blue Toggled ON"
		world.log_admin("[usr.key] has toggled [M.key]'s nodamage to [M.nodamage]")

/client/proc/revent(number as num)
	set category = "Admin"
	set name = "Change event %"
	if(src.authenticated)
		eventchance = number
		usr << "\blue Set to [eventchance]%."
		world.log_admin("[src.key] set the random event chance to [eventchance]%.")

/client/proc/spawn_event()
	set category = "Admin"
	set name = "Spawn Event"
	if(src.authenticated)
		var/event = input("Choose an event") as null|anything in list("Meteor","Blob","Plasma Storm","Ion Storm","Radiation")
		if(!event) return
		var/num = 0
		switch(event)
			if("Meteor") num = 1
			if("Blob") num = 4
			if("Plasma Storm") num = 5
			if("Ion Storm") num = 6
			if("Radiation") num = 7
		global.spawn_event(num)
		usr << "\blue Spawned [event]."
		world.log_admin("[src.key] spawned the event [event].")

/client/proc/spawn_virus()
	set category = "Admin"
	set name = "Spawn Virus"
	if(src.authenticated)
		var/virus = input("Choose a virus") as null|anything in list("Fever")
		if(!virus) return
		var/tp = 0
		switch(virus)
			if("Fever") tp = /obj/virus/fever
		var/mob/target = input("Choose a target") as null|mob in world
		if(!target) return
		var/obj/virus/V = new tp
		V.infect(target)
		usr << "\blue Spawned [virus] on [target.name]."
		world.log_admin("[src.key] spawned the virus [virus] on [target.name].")


/client/proc/removeplasma()
	set category = "Admin"
	set name = "Stabilize Atmos."
	usr << "\blue Done."
	spawn(0)
		for(var/turf/T in view())
			T.poison = 0
			T.oxygen = 755985
			T.co2 = 14.8176
			T.n2 = 2.844e+006
			T.sl_gas = 0
			T.temp = 293.15
	world << "[usr.key] has stabilized the atmosphere."

/client/proc/addfreeform()
	set category = "Admin"
	set name = "Add AI law"
	var/confirm = alert("Are you sure you want to add an AI law?", "Confirm", "Yes", "No")

	if(confirm == "Yes")
		var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "")
		confirm = alert("Are you Really Really sure you want to add an AI law?", "Confirm", "Yes", "No") // I got annoyyed by the inability to cancel that after you press the initial yes.
		if (confirm)
			for(var/mob/ai/M in world)
				if (M.stat == 2)
					usr << "Upload failed. No signal is being detected from the AI."
				else if (M.see_in_dark == 0)
					usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
				else
					M.addLaw(10,input)
					M << "\blue New law uploaded by Centcom: " + input
//Commented out so admins can now add shite for AI to RP, without making everyone go "wtfbadmin". Bwahahaha.
//	world << "Admin [usr.key] has added a new AI law."

/client/proc/revivenear(mob/M as mob)
	set category = "Admin"
	set name = "Revive/Heal Visible"
    //    All admins should be authenticated, but... what if?
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return
	if(!src.mob)
		return
	if(config.allow_admin_rev)
		if(istype(M, /mob/human))
			var/mob/human/H = M
			for(var/A in H.organs)
				var/obj/item/weapon/organ/external/affecting = null
				if(!H.organs[A])    continue
				affecting = H.organs[A]
				if(!istype(affecting, /obj/item/weapon/organ/external))    continue
				affecting.heal_damage(1000, 1000)    //fixes getting hit after ingestion, killing you when game updates organ health
			H.UpdateDamageIcon()
		M.fireloss = 0
		M.toxloss = 0
		M.bruteloss = 0
		M.oxyloss = 0
		M.paralysis = 0
		M.stunned = 0
		M.weakened = 0
		M.radiation = 0
		M.health = 100
		M.updatehealth()
		if(M.stat > 1) M.stat=0
		..()
		usr << "\blue Healing/Reviving [M]!"
		messageadmins("\red Admin [usr.key] Healed/Revived [M.key]!")
		world.log_admin("[usr.key] Healed/Revived [M.key]")
		return
	else
		alert("Admin revive disabled")

/client/proc/delete(obj/O as obj|mob|turf)
	del(O)
/*
/client/proc/badmindetection()
	set category = "Admin"
	set name = "Nuke Station"
	world << "Admin [usr.key] is being a complete douche and tried to nuke the station. Fortunately, this was a fake command. You fail, [usr.key]. Mwahahahahaha.          -Floirt"
	*/
