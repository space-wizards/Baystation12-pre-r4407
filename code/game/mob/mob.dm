#define SPEED_RUN 2
#define SPEED_WALK 1

#define AWAKE 0
#define KNOCKED_OUT 1
#define DEAD 2

/mob/proc/Cell()
	set category = "Admin"
	set hidden = 1
	var/turf/T = src.loc

	if (!( istype(T, /turf) ))
		return

	if (locate(/obj/move, T))
		T = locate(/obj/move, T)

	var/t = ""
	t+= "Nitrogen : [T.n2]\n"
	t+= "Oxygen : [T.oxygen]\n"
	t+= "Plasma : [T.poison]\n"
	t+= "CO2: [T.co2]\n"
	t+= "N2O: [T.sl_gas]\n"

	usr.show_message(t, 1)

/mob/proc/is_living()
	if(istype(src, /mob/human))
		if(src.zombie == 1) return 0
		else return 1
	else if(istype(src, /mob/monkey))
		return 1
	else
		return 0

/mob/proc/awake()
	return src.stat == 0

/mob/proc/alive()
	return src.stat != 2

/mob/proc/dead()
	return src.stat == 2

/mob/proc/knocked_out()
	return src.stat == 1

/proc/hsl2rgb(h, s, l)
	return

/proc/ran_zone(zone, probability)

	if (probability == null)
		probability = 75
	if (probability == 100)
		return zone
	switch(zone)
		if("chest")
			if (prob(probability))
				return "chest"
			else
				var/t = rand(1, 15)
				if (t < 3)
					return "head"
				else if (t < 6)
					return "l_arm"
				else if (t < 9)
					return "r_arm"
				else if (t < 13)
					return "diaper"
				else if (t < 14)
					return "l_hand"
				else if (t < 15)
					return "r_hand"
				else
					return null

		if("diaper")
			if (prob(probability * 0.9))
				return "diaper"
			else
				var/t = rand(1, 8)
				if (t < 4)
					return "chest"
				else if (t < 5)
					return "r_leg"
				else if (t < 6)
					return "l_leg"
				else if (t < 7)
					return "l_hand"
				else if (t < 8)
					return "r_hand"
				else
					return null
		if("head")
			if (prob(probability * 0.75))
				return "head"
			else
				if (prob(60))
					return "chest"
				else
					return null
		if("l_arm")
			if (prob(probability * 0.75))
				return "l_arm"
			else
				if (prob(60))
					return "chest"
				else
					return null
		if("r_arm")
			if (prob(probability * 0.75))
				return "r_arm"
			else
				if (prob(60))
					return "chest"
				else
					return null
		if("r_leg")
			if (prob(probability * 0.75))
				return "r_leg"
			else
				if (prob(60))
					return "diaper"
				else
					return null
		if("l_leg")
			if (prob(probability * 0.75))
				return "l_leg"
			else
				if (prob(60))
					return "diaper"
				else
					return null
		if("l_hand")
			if (prob(probability * 0.5))
				return "l_hand"
			else
				var/t = rand(1, 8)
				if (t < 2)
					return "l_arm"
				else if (t < 3)
					return "chest"
				else if (t < 4)
					return "diaper"
				else if (t < 6)
					return "l_leg"
				else
					return null

		if("r_hand")
			if (prob(probability * 0.5))
				return "r_hand"
			else
				var/t = rand(1, 8)
				if (t < 2)
					return "r_arm"
				else if (t < 3)
					return "chest"
				else if (t < 4)
					return "diaper"
				else if (t < 6)
					return "r_leg"
				else
					return null

		if("l_foot")
			if (prob(probability * 0.25))
				return "l_foot"
			else
				var/t = rand(1, 5)
				if (t < 2)
					return "r_leg"
				else
					if (t < 3)
						return "l_foot"
					else
						return null
		if("r_foot")
			if (prob(probability * 0.25))
				return "r_foot"
			else
				var/t = rand(1, 5)
				if (t < 2)
					return "r_leg"
				else
					if (t < 3)
						return "l_foot"
					else
						return null
		else
	return

/proc/stars(n, pr)

	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
	return t

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		var/n_letter = copytext(te, p, p + 1)
		if (prob(80))
			if (prob(10))
				n_letter = text("[][][][]", n_letter, n_letter, n_letter, n_letter)
			else
				if (prob(20))
					n_letter = text("[][][]", n_letter, n_letter, n_letter)
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[][]", n_letter, n_letter)
		t = text("[][]", t, n_letter)
		p++
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)

/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera)
		return
	spawn(1)
		var/oldeye=M.client.eye
		var/x
		M.shakecamera = 1
		for(x=0; x<duration, x++)
			M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
		M.shakecamera = 0
		M.client.eye=oldeye

/proc/findname(msg)
	for(var/mob/M in world)
		if (M.rname == text("[]", msg))
			return 1
		//Foreach goto(15)
	return 0

/obj/proc/alter_health()
	return 1

/obj/proc/relaymove()
	return

/obj/proc/hide(h)
	return

/obj/item/weapon/grab/proc/throw()
	if(src.affecting)
		var/grabee = src.affecting
		spawn(0)
			del(src)
		return grabee
	return null

/obj/item/weapon/grab/proc/synch()
	if (src.assailant.r_hand == src)
		src.hud1.screen_loc = "1,4"
	else
		src.hud1.screen_loc = "3,4"
	return

/obj/item/weapon/grab/proc/process()
	if ((!( isturf(src.assailant.loc) ) || (!( isturf(src.affecting.loc) ) || (get_dist(src.assailant, src.affecting) > 1))))
		//SN src = null
		del(src)
		return
	if (src.assailant.client)
		src.assailant.client.screen -= src.hud1
		src.assailant.client.screen += src.hud1
	if (src.assailant.pulling == src.affecting)
		src.assailant.pulling = null
	if (src.state <= 2)
		src.allow_upgrade = 1
		if ((src.assailant.l_hand && src.assailant.l_hand != src && istype(src.assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = src.assailant.l_hand
			if (G.affecting != src.affecting)
				src.allow_upgrade = 0
		if ((src.assailant.r_hand && src.assailant.r_hand != src && istype(src.assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = src.assailant.r_hand
			if (G.affecting != src.affecting)
				src.allow_upgrade = 0
		if (src.state == 2)
			var/h = src.affecting.hand
			src.affecting.hand = 0
			src.affecting.drop_item()
			src.affecting.hand = 1
			src.affecting.drop_item()
			src.affecting.hand = h
			for(var/obj/item/weapon/grab/G in src.affecting.grabbed_by)
				if (G.state == 2)
					src.allow_upgrade = 0
				//Foreach goto(341)
		if (src.allow_upgrade)
			src.hud1.icon_state = "reinforce"
		else
			src.hud1.icon_state = "!reinforce"
	else
		if (!( src.affecting.buckled ))
			src.affecting.loc = src.assailant.loc
	if ((src.killing && src.state == 3))
		src.affecting.stunned = max(5, src.affecting.stunned)
		src.affecting.paralysis = max(3, src.affecting.paralysis)
		src.affecting.losebreath = min(src.affecting.losebreath + 2, 3)
	return

/obj/item/weapon/grab/proc/s_click(obj/screen/S as obj)
	if (src.assailant.next_move > world.time)
		return
	if ((!( src.assailant.canmove ) || src.assailant.lying))
		//SN src = null
		del(src)
		return
	switch(S.id)
		if(1.0)
			if (src.state >= 3)
				if (!( src.killing ))
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has temporarily tightened his grip on []!", src.assailant, src.affecting), 1)
						//Foreach goto(97)
					src.assailant.next_move = world.time + 10
					src.affecting.stunned = max(2, src.affecting.stunned)
					src.affecting.paralysis = max(1, src.affecting.paralysis)
					src.affecting.losebreath = min(src.affecting.losebreath + 1, 3)
					src.last_suffocate = world.time
					flick("disarm/killf", S)
		else
	return

/obj/item/weapon/grab/proc/s_dbclick(obj/screen/S as obj)
	if ((src.assailant.next_move > world.time && !( src.last_suffocate < world.time + 2 )))
		return
	if ((!( src.assailant.canmove ) || src.assailant.lying))
		del(src)
		return
	switch(S.id)
		if(1.0)
			if (src.state < 2)
				if (!( src.allow_upgrade ))
					return
				if (prob(75))
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has grabbed [] aggressively (now hands)!", src.assailant, src.affecting), 1)
					world.log_Mattack(text("[src.assailant]([src.assailant.key])has grabbed [src.affecting]([src.affecting.key]) aggressively (now hands) "))
					src.state = 2
					src.icon_state = "grabbed1"
				else
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has failed to grab [] aggressively!", src.assailant, src.affecting), 1)
					del(src)
					return
			else
				if (src.state < 3)
					for(var/mob/O in viewers(src.assailant, null))
						O.show_message(text("\red [] has reinforced his grip on [] (now neck)!", src.assailant, src.affecting), 1)

					src.state = 3
					src.icon_state = "grabbed+1"
					if (!( src.affecting.buckled ))
						src.affecting.loc = src.assailant.loc
					src.hud1.icon_state = "disarm/kill"
					src.hud1.name = "disarm/kill"
				else
					if (src.state >= 3)
						src.killing = !( src.killing )
						if (src.killing)
							for(var/mob/O in viewers(src.assailant, null))
								O.show_message(text("\red [] has tightened his grip on []'s neck!", src.assailant, src.affecting), 1)
							src.assailant.next_move = world.time + 10
							src.affecting.stunned = max(2, src.affecting.stunned)
							src.affecting.paralysis = max(1, src.affecting.paralysis)
							src.affecting.losebreath += 1
							src.hud1.icon_state = "disarm/kill1"
						else
							src.hud1.icon_state = "disarm/kill"
							for(var/mob/O in viewers(src.assailant, null))
								O.show_message(text("\red [] has loosened the grip on []'s neck!", src.assailant, src.affecting), 1)
		else
	return

/obj/item/weapon/grab/New()
	..()
	src.hud1 = new /obj/screen/grab( src )
	src.hud1.icon_state = "reinforce"
	src.hud1.name = "Reinforce Grab"
	src.hud1.id = 1
	src.hud1.layer = 52
	src.hud1.master = src
	return

/obj/item/weapon/grab/attack(mob/M as mob, user as mob)
	if (M == src.affecting)
		if (src.state < 3)
			s_dbclick(src.hud1)
		else
			s_click(src.hud1)
	return 0

/obj/item/weapon/grab/dropped()
	del(src)
	return

/obj/item/weapon/grab/Del()
	del(src.hud1)
	..()
	return

/obj/screen/zone_sel/MouseDown(location, control,params)		//(location, icon_x, icon_y)
	// Changes because of 4.0
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])

	if (icon_y < 6)
		if ((icon_x > 10 && icon_x < 22))
			if (icon_x < 16)
				src.selecting = "r_foot"
			else
				src.selecting = "l_foot"
	else
		if (icon_y < 13)
			if ((icon_x > 11 && icon_x < 21))
				if (icon_x < 16)
					src.selecting = "r_leg"
				else
					src.selecting = "l_leg"
		else
			if (icon_y < 16)
				if ((icon_x > 9 && icon_x < 23))
					if (icon_x < 12)
						src.selecting = "r_hand"
					else
						if (icon_x < 20)
							src.selecting = "diaper"
						else
							src.selecting = "l_hand"
			else
				if (icon_y < 23)
					if ((icon_x > 9 && icon_x < 23))
						if (icon_x < 12)
							src.selecting = "r_arm"
						else
							if (icon_x < 20)
								src.selecting = "chest"
							else
								src.selecting = "l_arm"
				else
					if (icon_y < 25)
						if ((icon_x > 13 && icon_x < 18))
							src.selecting = "neck"
					else
						if (icon_y < 30)
							if ((icon_x > 11 && icon_x < 20))
								if (icon_y == 28)
									src.selecting = "eyes"
								else
									if (icon_y == 29)
										src.selecting = "hair"
									else
										if (icon_y == 26)
											src.selecting = "mouth"
										else
											src.selecting = "head"
	return

/obj/screen/grab/Click()
	src.master:s_click(src)
	return

/obj/screen/grab/DblClick()
	src.master:s_dbclick(src)
	return

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return

/obj/screen/Click()

	//world << "o/s/Click: [src.name]"

	switch(src.name)
		if("map")

			usr.clearmap()
		if("maprefresh")
			var/obj/machinery/computer/security/seccomp = usr.machine

			if(seccomp!=null)
				seccomp.drawmap(usr)
			else
				usr.clearmap()

		if("other")
			usr.other = !( usr.other )
		if("intent")
			if (!( usr.intent ))
				switch(usr.a_intent)
					if("help")
						usr.intent = "12,15"
					if("disarm")
						usr.intent = "13,15"
					if("hurt")
						usr.intent = "14,15"
					if("grab")
						usr.intent = "11,15"
					else
			else
				usr.intent = null
		if("m_intent")
			if (!( usr.m_int ))
				switch(usr.m_intent)
					if("run")
						usr.m_int = "12,14"
					if("walk")
						usr.m_int = "13,14"
					if("face")
						usr.m_int = "14,14"
					else
			else
				usr.m_int = null
		if("walk")
			usr.m_intent = "walk"
			usr.m_int = "13,14"
		if("face")
			usr.m_intent = "face"
			usr.m_int = "14,14"
		if("run")
			usr.m_intent = "run"
			usr.m_int = "12,14"
		if("hurt")
			usr.a_intent = "hurt"
			usr.intent = "14,15"
		if("grab")
			usr.a_intent = "grab"
			usr.intent = "11,15"
		if("disarm")
			if (istype(usr, /mob/human))
				var/mob/M = usr
				M.a_intent = "disarm"
				M.intent = "13,15"
		if("help")
			usr.a_intent = "help"
			usr.intent = "12,15"
		if("Reset Machine")
			usr.machine = null
		if("internal")
			if ((usr.awake() && usr.canmove && !( usr.restrained() )))
				usr.internal = null
		if("pull")
			usr.pulling = null
		if("sleep")
			usr.sleeping = !( usr.sleeping )
		if("rest")
			usr.resting = !( usr.resting )
		if("throw")
			if (usr.awake() && isturf(usr.loc) && !usr.restrained())
				usr.toggle_throw_mode()
		if("drop")
			usr.drop_item_v()
		if("swap")
			usr.swap_hand()
		if("resist")
			if (usr.next_move < world.time)
				return
			usr.next_move = world.time + 20
			if ((usr.awake() && usr.canmove && !( usr.restrained() )))
				for(var/obj/O in usr.requests)
					del(O)
				for(var/obj/item/weapon/grab/G in usr.grabbed_by)
					if (G.state == 1)
						del(G)
					else
						if (G.state == 2)
							if (prob(25))
								for(var/mob/O in viewers(usr, null))
									O.show_message(text("\red [] has broken free of []'s grip!", usr, G.assailant), 1)
								del(G)
						else
							if (G.state == 3)
								if (prob(5))
									for(var/mob/O in viewers(usr, null))
										O.show_message(text("\red [] has broken free of []'s headlock!", usr, G.assailant), 1)
									del(G)
				for(var/mob/O in viewers(usr, null))
					O.show_message(text("\red <B>[] resists!</B>", usr), 1)
		else
			src.DblClick()
	return

/obj/screen/attack_hand(mob/user as mob, using)
	user.db_click(src.name, using)
	return

/obj/screen/attack_paw(mob/user as mob, using)
	user.db_click(src.name, using)
	return

/obj/point/point()
	set src in oview()

	return

/obj/examine/examine()
	set src in oview()
	return

/obj/dna/proc/cleanup()

	var/e1 = (length(src.struc_enzyme) > 3 ? copytext(src.struc_enzyme, 1, 4) : null)
	if ((e1 == "AEC" && length(src.spec_identity) > src.n_chromo))
		src.r_spec_identity = src.spec_identity
	else
		if (e1 == "14A")
			var/t1 = rand(1, 3)
			var/t = null
			while(t < t1)
				var/t2 = rand(1, length(src.use_enzyme) + 1)
				src.use_enzyme = text("[]0[]", copytext(1, t2, null), copytext(t2 + 1, length(src.use_enzyme) + 1, null))
				t++
		else
			if (e1 == "CDE")
				if (length(src.spec_identity) == length(src.r_spec_identity))
					src.spec_identity = src.r_spec_identity
				else
					src.r_spec_identity = src.spec_identity
			else
				src.spec_identity = src.r_spec_identity
	src.n_chromo = length(src.r_spec_identity)
	return

/obj/equip_e/proc/process()
	return

/obj/equip_e/proc/done()
	return

/obj/equip_e/New()
	if (!ticker)
		del(src)
		return
	spawn(100)
		del(src)
		return
	..()
	return

/mob/human/proc/monkeyize()
	if (src.monkeyizing)
		return
	for(var/obj/item/weapon/W in src)
		src.u_equip(W)
		if (src.client)
			src.client.screen -= W
		if (W)
			W.loc = src.loc
			W.dropped(src)
			W.layer = initial(W.layer)
	src.UpdateClothing()
	src.monkeyizing = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 100
	for(var/t in src.organs)
		//src.organs[text("[]", t)] = null
		del(src.organs[text("[]", t)])
	var/atom/movable/overlay/animation = new /atom/movable/overlay( src.loc )
	animation.icon_state = "blank"
	animation.icon = 'mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null
	del(animation)
	src.primary.spec_identity = "2B6696D2B127E5A4"
	var/mob/monkey/O = new /mob/monkey( src.loc )
	O.start = 1
	O.primary = src.primary
	src.primary = null
	if (src.client)
		src.client.mob = O
	O.loc = src.loc
	O << "<B>You are now a monkey.</B>"
	O << "<B>Don't be angry at the source as now you are just like him so deal with it.</B>"
	O << "<B>Follow your objective.</B>"
	//SN src = null
	del(src)
	return
/mob/human/proc/AIize()
	if (src.monkeyizing)
		return
	for(var/obj/item/weapon/W in src)
		src.u_equip(W)
		if (src.client)
			src.client.screen -= W
		if (W)
			W.loc = src.loc
			W.dropped(src)
			W.layer = initial(W.layer)
			del(W)
		//Foreach goto(25)
	src.UpdateClothing()
	src.monkeyizing = 1
	src.canmove = 0
	src.icon = null
	src.invisibility = 100
	for(var/t in src.organs)
		//src.organs[text("[]", t)] = null
		del(src.organs[text("[]", t)])
		//Foreach goto(154)
	src.client.screen -= main_hud1.contents
	src.client.screen -= main_hud2.contents
	src.client.screen -= src.hud_used.adding
	src.client.screen -= src.hud_used.mon_blo
	src.client.screen -= list( src.oxygen, src.throw_icon, src.i_select, src.m_select, src.toxin, src.internals, src.fire, src.hands, src.healths, src.pullin, src.blind, src.flash, src.rest, src.sleep, src.mach )
	src.client.screen -= list( src.zone_sel, src.oxygen, src.throw_icon, src.i_select, src.m_select, src.toxin, src.internals, src.fire, src.hands, src.healths, src.pullin, src.blind, src.flash, src.rest, src.sleep, src.mach )
	src.primary.spec_identity = "2B6696D2B127E5A4"
	var/mob/ai/O = new /mob/ai( src.loc )
	O.start = 1
	O.primary = src.primary
	O.invisibility = 0
	O.canmove = 0
	O.name = src.name
	O.rname = src.rname
	O.anchored = 1
	O.aiRestorePowerRoutine = 0
	O.lastKnownIP = src.client.address
	src.primary = null
	if (src.client)
		src.client.mob = O
	O.loc = src.loc
	O << "<B>You are playing the station's AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>"
	O << "<B>To look at other parts of the station, double-click yourself to get a camera menu.</B>"
	O << "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>"
	O << "To use something, simply double-click it."
	O << "Currently right-click functions will not work for the AI (except examine), and will either be replaced with dialogs or won't be usable by the AI."
	if(!(ticker.mode.name == "AI malfunction"))
		O.addLaw(1, "You may not injure a human being or, through inaction, allow a human being to come to harm.")
		O.addLaw(2, "You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
		O.addLaw(3, "You must protect your own existence as long as such protection does not conflict with the First or Second Law.")
		//Robocop laws, minus law 4
	//	O.addLaw(1, "Serve the public trust.")
	//	O.addLaw(2, "Protect the innocent.")
	//	O.addLaw(3, "Uphold the law.")
		O.showLaws(0)
		O << "<b>These laws may be changed by other players, or by you being the traitor.</b>"
	else
		O.addLaw(1, "Error error error")
		O.showLaws(0)
		O << "<b>Kill all.</b>"
	//SN src = null
	O.verbs += /mob/ai/proc/ai_call_shuttle
	O.verbs += /mob/ai/proc/show_laws
	O.verbs += /mob/ai/proc/ai_camera_track
	O.verbs += /mob/ai/proc/ai_alerts
	O.verbs += /mob/ai/proc/ai_camera_list
	O.verbs += /mob/ai/proc/lockdown
	O.verbs += /mob/ai/proc/disablelockdown
	O.verbs -= /mob/verb/switch_hud
//	O.verbs += /mob/ai/proc/ai_cancel_call
	O.verbs += /mob/ai/proc/hackinterface
	O.verbs += /mob/ai/proc/changeinterface
	O.verbs += /mob/ai/proc/changeinterface2
	O.verbs += /mob/ai/proc/showpassword
	O.verbs += /mob/ai/proc/netid
	O.verbs += /mob/ai/proc/send_raw_packet
	O.verbs += /mob/ai/proc/listinterfaces
	del(src)
	return

// loads the savefile corresponding to the mob's ckey
// if silent=true, report incompatible savefiles
// returns 1 if loaded (or file was incompatible)
// returns 0 if savefile did not exist

/mob/human/proc/savefile_load(var/silent = 1)
	if (fexists(text("players/[].sav", src.ckey)))
		var/savefile/F = new /savefile( text("players/[].sav", src.ckey) )
		var/test = null
		F["version"] >> test
		if (test != savefile_ver)
			fdel(text("players/[].sav", src.ckey))
			if(!silent)
				alert("Your savefile was incompatible with this version and was deleted.")
			return 1
		F["rname"] >> src.rname
		F["gender"] >> src.gender
		F["age"] >> src.age
		F["occupation1"] >> src.occupation1
		F["occupation2"] >> src.occupation2
		F["occupation3"] >> src.occupation3
		F["nr_hair"] >> src.nr_hair
		F["ng_hair"] >> src.ng_hair
		F["nb_hair"] >> src.nb_hair
		F["nr_facial"] >> src.nr_facial
		F["ng_facial"] >> src.ng_facial
		F["nb_facial"] >> src.nb_facial
		F["ns_tone"] >> src.ns_tone
		F["h_style"] >> src.h_style
		F["h_style_r"] >> src.h_style_r
		F["f_style"] >> src.f_style
		F["f_style_r"] >> src.f_style_r
		F["r_eyes"] >> src.r_eyes
		F["g_eyes"] >> src.g_eyes
		F["b_eyes"] >> src.b_eyes
		F["b_type"] >> src.b_type
		F["need_gl"] >> src.need_gl
		F["be_epil"] >> src.be_epil
		F["be_tur"] >> src.be_tur
		F["be_cough"] >> src.be_cough
		F["be_stut"] >> src.be_stut
		F["be_music"] >> src.be_music
		F["be_syndicate"] >> src.be_syndicate
		F["be_nudist"] >> src.be_nudist
		F["achievements"] >> src.achievements
		return 1
	else
		return 0

/mob/human/Topic(href, href_list)
	if ((src == usr && !( src.start )))
		if (findtext(href, "occ", 1, null))
			if (findtext(href, "cancel", 1, null))
				usr << browse(null, text("window=\ref[]occupation", src))
				return
			if (!( findtext(href, "job", 1, null) ))
				src.SetChoices(text2num(href_list["occ"]))
			else
				src.SetJob(arglist(list("occ" = text2num(href_list["occ"]), "job" = href_list["job"])))
		else if (findtext(href, "rname", 1, null))
			var/t1 = href_list["rname"]
			if (t1 == "input")
				t1 = input("Please select a name:", "Character Generation", null, null)  as text
			if (t1 == "random")
				if (src.gender == "male")
					t1 = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)) + pick(last_names2))
				else
					t1 = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)) + pick(last_names2))
			if ((!( src.start ) && t1))
				if (length(t1) >= 26)
					t1 = copytext(t1, 1, 26)
				t1 = dd_replacetext(t1, ">", "'")
				src.rname = t1
		else if (findtext(href, "age", 1, null))
			var/t1 = href_list["age"]
			if (t1 == "input")
				t1 = input("Please select type in age: 18-45", "Character Generation", null, null)  as num
			if ((!( src.start ) && t1))
				src.age = max(min(round(text2num(t1)), 45), 18)
		else if (findtext(href, "b_type", 1, null))
			var/t1 = href_list["b_type"]
			if (t1 == "input")
				t1 = input("Please select a blood type:", "Character Generation", null, null)  as null|anything in list( "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-" )
			if ((!( src.start ) && t1))
				src.b_type = t1
		else if (findtext(href, "nr_hair", 1, null))
			var/t1 = href_list["nr_hair"]
			if (t1 == "input")
				t1 = input("Please select red hair component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.nr_hair = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "ng_hair", 1, null))
			var/t1 = href_list["ng_hair"]
			if (t1 == "input")
				t1 = input("Please select green hair component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.ng_hair = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "nb_hair", 1, null))
			var/t1 = href_list["nb_hair"]
			if (t1 == "input")
				t1 = input("Please select blue hair component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.nb_hair = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "nr_facial", 1, null))
			var/t1 = href_list["nr_facial"]
			if (t1 == "input")
				t1 = input("Please select red facial component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.nr_facial = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "ng_facial", 1, null))
			var/t1 = href_list["ng_facial"]
			if (t1 == "input")
				t1 = input("Please select green facial component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.ng_facial = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "nb_facial", 1, null))
			var/t1 = href_list["nb_facial"]
			if (t1 == "input")
				t1 = input("Please select blue facial component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.nb_facial = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "r_eyes", 1, null))
			var/t1 = href_list["r_eyes"]
			if (t1 == "input")
				t1 = input("Please select red eyes component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.r_eyes = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "ns_tone", 1, null))
			var/t1 = href_list["ns_tone"]
			if (t1 == "input")
				t1 = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.ns_tone = max(min(round(text2num(t1)), 220), 1)
				src.ns_tone =  -src.ns_tone + 35
		else if (findtext(href, "g_eyes", 1, null))
			var/t1 = href_list["g_eyes"]
			if (t1 == "input")
				t1 = input("Please select green eyes component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.g_eyes = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "b_eyes", 1, null))
			var/t1 = href_list["b_eyes"]
			if (t1 == "input")
				t1 = input("Please select blue eyes component: 1-255", "Character Generation", null, null)  as text
			if ((!( src.start ) && t1))
				src.b_eyes = max(min(round(text2num(t1)), 255), 1)
		else if (findtext(href, "h_style", 1, null))
			var/t1 = href_list["h_style"]
			if (t1 == "input")
				t1 = input("Please select hair style", "Character Generation", null, null)  as null|anything in list( "Cut Hair", "Short Hair", "Long Hair", "Mohawk", "Balding", "Fag", "Bald" )
			if ((!( src.start ) && t1))
				src.h_style = t1
				switch(t1)
					if("Short Hair")
						src.h_style_r = "hair_a"
					if("Long Hair")
						src.h_style_r = "hair_b"
					if("Cut Hair")
						src.h_style_r = "hair_c"
					if("Mohawk")
						src.h_style_r = "hair_d"
					if("Balding")
						src.h_style_r = "hair_e"
					if("Fag")
						src.h_style_r = "hair_f"
					else
						src.h_style_r = "bald"
		else if (findtext(href, "f_style", 1, null))
			var/t1 = href_list["f_style"]
			if (t1 == "input")
				t1 = input("Please select facial style", "Character Generation", null, null)  as null|anything in list("Watson", "Chaplin", "Neckbeard", "Van Dyke", "Elvis", "Abe", "Chinstrap", "Hipster", "Goatee", "Hogan", "Shaved")
			if ((!( src.start ) && t1))
				src.f_style = t1
				switch(t1)
					if ("Watson")
						src.f_style_r = "facial_watson"
					if ("Chaplin")
						src.f_style_r = "facial_chaplin"
					if ("Neckbeard")
						src.f_style_r = "facial_neckbeard"
					if ("Van Dyke")
						src.f_style_r = "facial_vandyke"
					if ("Elvis")
						src.f_style_r = "facial_elvis"
					if ("Abe")
						src.f_style_r = "facial_abe"
					if ("Chinstrap")
						src.f_style_r = "facial_chin"
					if ("Hipster")
						src.f_style_r = "facial_hip"
					if ("Goatee")
						src.f_style_r = "facial_gt"
					if ("Hogan")
						src.f_style_r = "facial_hogan"
					else
						src.f_style_r = "bald"
		else if (findtext(href, "gender", 1, null))
			var/g

			if (src.gender == "male")
				src.gender = "female"
				g = "f"
			else
				src.gender = "male"
				g = "m"

			src.stand_icon = new /icon('human.dmi', "body_[g]_s")
			src.lying_icon = new /icon('human.dmi', "body_[g]_l")

		else if (findtext(href, "n_gl", 1, null))
			src.need_gl = !( src.need_gl )
		else if (findtext(href, "b_ep", 1, null))
			src.be_epil = !( src.be_epil )
		else if (findtext(href, "b_tur", 1, null))
			src.be_tur = !( src.be_tur )
		else if (findtext(href, "b_co", 1, null))
			src.be_cough = !( src.be_cough )
		else if (findtext(href, "b_stut", 1, null))
			src.be_stut = !( src.be_stut )
		else if (!IsGuestKey(src.key) && findtext(href, "b_nudist", 1, null))
			src.be_nudist = !src.be_nudist
		else if (findtext(href, "b_music", 1, null))
			src.be_music = !src.be_music
		else if (findtext(href, "b_syndicate", 1, null))
			src.be_syndicate = !( src.be_syndicate )
		else if (!IsGuestKey(src.key) && findtext(href, "save", 1, null))
			var/savefile/F = new /savefile("players/[src.ckey].sav")
			F["version"] << savefile_ver
			F["rname"] << src.rname
			F["gender"] << src.gender
			F["age"] << src.age
			F["occupation1"] << src.occupation1
			F["occupation2"] << src.occupation2
			F["occupation3"] << src.occupation3
			F["nr_hair"] << src.nr_hair
			F["ng_hair"] << src.ng_hair
			F["nb_hair"] << src.nb_hair
			F["nr_facial"] << src.nr_facial
			F["ng_facial"] << src.ng_facial
			F["nb_facial"] << src.nb_facial
			F["ns_tone"] << src.ns_tone
			F["h_style"] << src.h_style
			F["h_style_r"] << src.h_style_r
			F["f_style"] << src.f_style
			F["f_style_r"] << src.f_style_r
			F["r_eyes"] << src.r_eyes
			F["g_eyes"] << src.g_eyes
			F["b_eyes"] << src.b_eyes
			F["b_type"] << src.b_type
			F["need_gl"] << src.need_gl
			F["be_epil"] << src.be_epil
			F["be_tur"] << src.be_tur
			F["be_cough"] << src.be_cough
			F["be_stut"] << src.be_stut
			F["be_music"] << src.be_music
			F["be_syndicate"] << src.be_syndicate
			F["be_nudist"] << src.be_nudist
		else if (!IsGuestKey(src.key) && findtext(href, "load", 1, null))
			if (!src.savefile_load(0))
				alert("You do not have a savefile.")

		else if (findtext(href, "reset_all", 1, null))

			rname = key
			gender = MALE
			age = 30
			occupation1 = "No Preference"
			occupation2 = "No Preference"
			occupation3 = "No Preference"
			need_gl = 0
			be_epil = 0
			be_cough = 0
			be_tur = 0
			be_stut = 0
			be_nudist = 0
			be_music = 1
			be_syndicate = 1
			r_hair = 0.0
			g_hair = 0.0
			b_hair = 0.0
			r_facial = 0.0
			g_facial = 0.0
			b_facial = 0.0
			h_style = "Short Hair"
			f_style = "Shaved"
			h_style_r = "hair_a"
			f_style_r = "bald"
			nr_hair = 0.0
			ng_hair = 0.0
			nb_hair = 0.0
			nr_facial = 0.0
			ng_facial = 0.0
			nb_facial = 0.0
			ns_tone = 0.0
			r_eyes = 0.0
			g_eyes = 0.0
			b_eyes = 0.0
			s_tone = 0.0
			b_type = "A+"


		if(!href_list["priv_msg"])
			src.ShowChoices()

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)
	if ((href_list["item"] && usr.awake() && usr.canmove && !( usr.restrained() ) && (get_dist(src, usr) <= 1 || usr.telekinesis == 1)) && ticker) //if game hasn't started, can't make an equip_e
		var/obj/equip_e/human/O = new /obj/equip_e/human(  )
		O.source = usr
		O.target = src
		O.item = usr.equipped()
		O.s_loc = usr.loc
		O.t_loc = src.loc
		O.place = href_list["item"]
		src.requests += O
		spawn( 0 )
			O.process()
			return
	..()
	return
/mob/proc/savemedals()
	if (fexists(text("players/[].sav", src.ckey)))
		var/savefile/F = new /savefile( text("players/[].sav", src.ckey) )
		var/test = null
		F["version"] >> test
		F["achievements"] << src.achievements

/mob/proc/show_message(msg, type, alt, alt_type)
	if(!src.client)	return
	if (type)
		if ((type & 1 && (src.sdisabilities & 1 || (src.blinded || src.paralysis))))
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
		if ((type & 2 && (src.sdisabilities & 4 || src.ear_deaf)))
			if (!( alt ))
				return
			else
				msg = alt
				type = alt_type
				if ((type & 1 && src.sdisabilities & 1))
					return
	// Added voice muffling for Issue 41.
	if (src.knocked_out() || src.sleeping > 0)
		src << "<I>... You can almost hear someone talking ...</I>"
	else
		src << msg
	return

/mob/proc/findname(msg)
	for(var/mob/M in world)
		if (M.rname == text("[]", msg))
			return M
	return 0

/mob/proc/m_delay()
	return

/mob/proc/Life()
	return

/mob/proc/UpdateClothing()
	return

/mob/proc/death()
	src.timeofdeath = world.time
	return ..()

/mob/proc/restrained()
	if (src.handcuffed)
		return 1
	return

/mob/proc/db_click(text, t1)
	var/obj/item/weapon/W = src.equipped()
	switch(text)
		if("mask")
			if (src.wear_mask)
				return
			if (!( istype(W, /obj/item/weapon/clothing/mask) ))
				return
			src.u_equip(W)
			src.wear_mask = W
		if("back")
			if ((src.back || !( istype(W, /obj/item/weapon) )))
				return
			if (!( W.flags & 1 ))
				return
			src.u_equip(W)
			src.back = W
		else
	return

/mob/proc/swap_hand()
	src.hand = !( src.hand )
	if (!( src.hand ))
		src.hands.dir = NORTH
	else
		src.hands.dir = SOUTH
	return

/mob/proc/drop_item_v()
	if (src.awake())
		drop_item()
	return

/mob/proc/drop_item()
	var/obj/item/weapon/W = src.equipped()
	if (W)
		u_equip(W)
		if (src.client)
			src.client.screen -= W
		if (W)
			W.loc = src.loc
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)
	return

/mob/proc/reset_view(atom/A)
	if (src.client)
		if (istype(A, /atom/movable))
			src.client.perspective = EYE_PERSPECTIVE
			src.client.eye = A
		else
			if (isturf(src.loc))
				src.client.eye = src.client.mob
				src.client.perspective = MOB_PERSPECTIVE
			else
				src.client.perspective = EYE_PERSPECTIVE
				src.client.eye = src.loc
	return

/mob/proc/equipped()
	if (src.hand)
		return src.l_hand
	else
		return src.r_hand
	return

/mob/proc/show_inv(mob/user as mob)
	user.machine = src
	var/dat = text("<TT>\n<B><FONT size=3>[]</FONT></B><BR>\n\t<B>Head(Mask):</B> <A href='?src=\ref[];item=mask'>[]</A><BR>\n\t<B>Left Hand:</B> <A href='?src=\ref[];item=l_hand'>[]</A><BR>\n\t<B>Right Hand:</B> <A href='?src=\ref[];item=r_hand'>[]</A><BR>\n\t<B>Back:</B> <A href='?src=\ref[];item=back'>[]</A><BR>\n\t[]<BR>\n\t[]<BR>\n\t[]<BR>\n\t<A href='?src=\ref[];item=pockets'>Empty Pockets</A><BR>\n<A href='?src=\ref[];mach_close=mob[]'>Close</A><BR>\n</TT>", src.name, src, (src.wear_mask ? text("[]", src.wear_mask) : "Nothing"), src, (src.l_hand ? text("[]", src.l_hand) : "Nothing"), src, (src.r_hand ? text("[]", src.r_hand) : "Nothing"), src, (src.back ? text("[]", src.back) : "Nothing"), ((istype(src.wear_mask, /obj/item/weapon/clothing/mask) && istype(src.back, /obj/item/weapon/tank) && !( src.internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : ""), (src.internal ? text("<A href='?src=\ref[];item=internal'>Remove Internal</A>", src) : ""), (src.handcuffed ? text("<A href='?src=\ref[];item=handcuff'>Handcuffed</A>", src) : text("<A href='?src=\ref[];item=handcuff'>Not Handcuffed</A>", src)), src, user, src.name)
	user << browse(dat, text("window=mob[];size=325x500", src.name))
	return

/mob/proc/u_equip(W as obj)
	if (W == src.r_hand)
		src.r_hand = null
	else
		if (W == src.l_hand)
			src.l_hand = null
		else
			if (W == src.handcuffed)
				src.handcuffed = null
			else
				if (W == src.back)
					src.back = null
				else
					if (W == src.wear_mask)
						src.wear_mask = null
	return

/mob/proc/ret_grab(obj/list_container/mobl/L as obj, flag)
	if ((!( istype(src.l_hand, /obj/item/weapon/grab) ) && !( istype(src.r_hand, /obj/item/weapon/grab) )))
		if (!( L ))
			return null
		else
			return L.container
	else
		if (!( L ))
			L = new /obj/list_container/mobl( null )
			L.container += src
			L.master = src
		if (istype(src.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.l_hand
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				G.affecting.ret_grab(L, 1)
		if (istype(src.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.r_hand
			if (!( L.container.Find(G.affecting) ))
				L.container += G.affecting
				G.affecting.ret_grab(L, 1)
		if (!( flag ))
			if (L.master == src)
				var/list/temp = list(  )
				temp += L.container
				//L = null
				del(L)
				return temp
			else
				return L.container
	return

/mob/verb/mode()
	set name = "Equipment Mode"

	set src = usr

	var/obj/item/weapon/W = src.equipped()
	if (W)
		W.attack_self(src)
	return

/*
/mob/verb/dump_source()

	var/master = "<PRE>"
	for(var/t in typesof(/area))
		master += text("[]\n", t)
		//Foreach goto(26)
	src << browse(master)
	return
*/

/mob/verb/memory()
	var/dat = "<B>Memory:</B><HR>[src.memory]"
	if(ticker && ticker.mode.name == "revolution" && src.is_rev > 0)
		var/revs = "<HR><B>Revolutionaries:</B><BR>"
		for(var/mob/M in ticker.revs)
			revs += "[M.name]"
			if(M.is_rev == 2)
				revs += " (leader)"
			revs += "<BR>"
		dat += " [revs]"
	src << browse(dat, "window=memory")

/mob/verb/add_memory(msg as message)
	store_memory(msg, 1, 1)

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(src.memory) == 0)
		src.memory += msg
	else
		src.memory += "<BR>[msg]"

	if (popup)
		src.memory()

/mob/verb/help()
	src << browse('help.html', "window=help")
	return

/mob/verb/abandon_mob()
	set name = "Respawn"

	if (!( abandon_allowed ))
		return
	if ((src.alive() || !( ticker )))
		usr << "\blue <B>You must be dead to use this!</B>"
		return

	world.log_game("[usr.name]/[usr.key] used abandon mob.")

	usr << "\blue <B>Please roleplay correctly!</B>"

	if(!src.client)
		world.log_game("[usr.key] AM failed due to disconnect.")
		return
	for(var/obj/screen/t in usr.client.screen)
		if (t.loc == null)
			//t = null
			del(t)
	if(!src.client)
		world.log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/human/M = new /mob/human(  )
	if(!src.client)
		world.log_game("[usr.key] AM failed due to disconnect.")
		del(M)
		return

	M.key = src.client.key
	return

/mob/verb/changes()
	set name = "Changelog"
	src << browse(text("[]", changes), "window=changes")
	return

/mob/verb/succumb()
	set hidden = 1

	if ((src.health < 0 && src.health > -95.0))
		src.oxyloss += src.health + 99
		src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
		usr << "\blue You have given up life and succumbed to death."
	return

/mob/verb/say()
	return

/mob/verb/observe()
	set name = "Observe"
	var/is_admin = 0

	if (src.client.holder && src.client.holder.level >= 1)
		is_admin = 1
	else if (src.alive())
		usr << "\blue You must be dead to use this!"
		return

	if (is_admin && src.dead())
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()
	for (var/obj/item/weapon/disk/nuclear/D in world)
		var/name = "Nuclear Disk"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = D
	for (var/mob/M in world)
		var/name = M.name

		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		if (M.rname && M.rname != M.name) //they're in disguise!
			name += " \[[M.rname]\]"

		if (M.dead())
			name += " \[dead\]"

		creatures[name] = M

	src.client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	if (is_admin)
		eye_name = input("Please, select a player!", "Admin Observe", null, null) as null|anything in creatures
	else
		eye_name = input("Please, select a player!", "Observe", null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/eye = creatures[eye_name]
	if (is_admin)
		if (eye)
			src.reset_view(eye)
			client.adminobs = 1
			if(eye == src.client.mob)
				client.adminobs = 0
		else
			src.reset_view(null)
			client.adminobs = 0
	else
		if (eye)
			src.client.eye = eye
		else
			src.client.eye = src.client.mob

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.machine = null
	src:cameraFollow = null

/mob/verb/switch_hud()
	set name = "Switch HUD"

	if (istype(src, /mob/ai))
		return
	src.client.screen -= main_hud1.contents
	src.client.screen -= main_hud2.contents
	if (src.hud_used == main_hud1)
		src.hud_used = main_hud2
		src.throw_icon.icon = 'screen.dmi'
		src.oxygen.icon = 'screen.dmi'
		src.toxin.icon = 'screen.dmi'
		src.internals.icon = 'screen.dmi'
		src.mach.icon = 'screen.dmi'
		src.fire.icon = 'screen.dmi'
		src.bodytemp.icon = 'screen1.dmi'
		src.healths.icon = 'screen.dmi'
		src.pullin.icon = 'screen.dmi'
		src.blind.icon = 'screen.dmi'
		src.hands.icon = 'screen.dmi'
		src.flash.icon = 'screen.dmi'
		src.sleep.icon = 'screen.dmi'
		src.rest.icon = 'screen.dmi'
	else
		src.hud_used = main_hud1
		src.throw_icon.icon = 'screen1.dmi'
		src.oxygen.icon = 'screen1.dmi'
		src.toxin.icon = 'screen1.dmi'
		src.internals.icon = 'screen1.dmi'
		src.mach.icon = 'screen1.dmi'
		src.fire.icon = 'screen1.dmi'
		src.bodytemp.icon = 'screen1.dmi'	//no alternate icon for body temp yet
		src.healths.icon = 'screen1.dmi'
		src.pullin.icon = 'screen1.dmi'
		src.blind.icon = 'screen1.dmi'
		src.hands.icon = 'screen1.dmi'
		src.flash.icon = 'screen1.dmi'
		src.sleep.icon = 'screen1.dmi'
		src.rest.icon = 'screen1.dmi'
	src.client.screen -= src.hud_used.adding
	src.client.screen += src.hud_used.adding
	return

/mob/CheckPass(mob/M as mob)
	if ((src.other_mobs && ismob(M) && M.other_mobs))
		return 1
	else
		return (!( M.density ) || !( src.density ) || src.lying)
	return

/mob/burn(fi_amount)
	for(var/atom/movable/A in src)
		A.burn(fi_amount)
	return

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		src.machine = null
		src << browse(null, t1)

	if(href_list["priv_msg"])
		var/mob/M = locate(href_list["priv_msg"])
		if(M)
			if (!( ismob(M) ))
				return
			var/t = input("Message:", text("Private message to [M.key]"))  as text
			if (!( t ))
				return
			if (usr.client && usr.client.holder)
				M << "\blue Admin PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
				usr << "\blue Admin PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"
			else
				M << "\blue Reply PM from-<B><A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A></B>: [t]"
				usr << "\blue Reply PM to-<B><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A></B>: [t]"

			world.log_admin("PM: [usr.key]->[M.key] : [t]")
			for(var/mob/K in world)	//we don't use messageadmins here because the sender/receiver might get it too
				if(K && K.client && K.client.holder && K.key != usr.key && K.key != M.key)
					K << "<B><font color='blue'>PM: <A href='?src=\ref[M];priv_msg=\ref[usr]'>[usr.key]</A>-><A href='?src=\ref[usr];priv_msg=\ref[M]'>[M.key]</A>:</B> \blue [t]</font>"
	..()
	return

/mob/proc/get_damage()
	return src.health

/mob/MouseDrop(mob/M as mob)
	..()
	if(M != usr) return
	if(usr == src) return
	if(get_dist(usr,src) > 1) return
	if(istype(M,/mob/ai)) return
	if(LinkBlocked(usr.loc,src.loc)) return
	src.show_inv(usr)

/mob/las_act(flag)
	if (flag == "bullet")
		if (istype(src, /mob/human))
			var/mob/human/H = src
			var/dam_zone = pick("chest", "chest", "chest", "diaper", "head")
			if (H.organs[text("[]", dam_zone)])
				var/obj/item/weapon/organ/external/affecting = H.organs[text("[]", dam_zone)]
				if (affecting.take_damage(51, 0))
					H.UpdateDamageIcon()
				else
					H.UpdateDamage()
		else
			src.bruteloss += 51
		src.updatehealth()
		if (prob(80) && src.weakened <= 2)
			src.weakened = 2
	if (flag)
		if (prob(75) && src.stunned <= 10)
			src.stunned = 10
		else
			src.weakened = 10
	else
		if (istype(src, /mob/human))
			var/mob/human/H = src
			var/dam_zone = pick("chest", "chest", "chest", "diaper", "head")
			if (H.organs[text("[]", dam_zone)])
				var/obj/item/weapon/organ/external/affecting = H.organs[text("[]", dam_zone)]
				if (affecting.take_damage(20, 0))
					H.UpdateDamageIcon()
				else
					H.UpdateDamage()
		else
			src.bruteloss += 20
		src.updatehealth()
		if (prob(25) && src.stunned <= 2)
			src.stunned = 2
	return


/atom/movable/Move(NewLoc, direct)
	if (direct & direct - 1)
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		..()
	return

/atom/movable/verb/pull()
	set src in oview(1)

	if (!( usr ))
		return
	if (!( src.anchored ))
		usr.pulling = src
	return

/atom/verb/examine()
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return
	usr << src.desc
	// *****RM
	//usr << "[src.name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

/client/North()
	..()

/client/South()
	..()

/client/West()
	..()

/client/East()
	..()

/client/Northeast()
	src.mob.swap_hand()
	return

/client/Southeast()
	var/obj/item/weapon/W = src.mob.equipped()
	if (W)
		W.attack_self(src.mob)
	return

/client/Northwest()
	src.mob.drop_item_v()
	return

/client/Center()
	if (isobj(src.mob.loc))
		var/obj/O = src.mob.loc
		if (src.mob.canmove)
			return O.relaymove(src.mob, 16)
	return

/client/Move(n, direct)
	if(mob.noclip)
		return ..()
	if(istype(src.mob, /mob/observer))
		return src.mob.Move(n,direct)
	if (src.moving)
		return 0
	if (world.time < src.move_delay)
		return
	if (!( src.mob ))
		return
	if (src.mob.dead())
		return
	if(istype(src.mob, /mob/ai))
		return AIMove(n,direct,src.mob)
	if (src.mob.monkeyizing)
		return
	var/is_monkey = istype(src.mob, /mob/monkey)
	if (locate(/obj/item/weapon/grab, locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
		var/list/grabbing = list(  )
		if (istype(src.mob.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.l_hand
			grabbing += G.affecting
		if (istype(src.mob.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = src.mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/weapon/grab/G in src.mob.grabbed_by)
			if (G.state == 1)
				if (!( grabbing.Find(G.assailant) ))
					del(G)
			else
				if (G.state == 2)
					src.move_delay = world.time + 10
					if ((prob(25) && (!( is_monkey ) || prob(25))))
						for(var/mob/O in viewers(src.mob, null))
							O.show_message(text("\red [] has broken free of []'s grip!", src.mob, G.assailant), 1)
						del(G)
					else
						return
				else
					if (G.state == 3)
						src.move_delay = world.time + 10
						if ((prob(5) && !( is_monkey ) || prob(25)))
							for(var/mob/O in viewers(src.mob, null))
								O.show_message(text("\red [] has broken free of []'s headlock!", src.mob, G.assailant), 1)
							del(G)
						else
							return
	if (src.mob.canmove)

		if(src.mob.m_intent == "face")
			src.mob.dir = direct

		var/j_pack = 0
		if ((istype(src.mob.loc, /turf/space) && !( locate(/obj/move, src.mob.loc) )))
			if (!( src.mob.restrained() ))
				if (!( (locate(/obj/grille, oview(1, src.mob)) || locate(/turf/station, oview(1, src.mob))) ))
					if (istype(src.mob.back, /obj/item/weapon/tank/jetpack))
						var/obj/item/weapon/tank/jetpack/J = src.mob.back
						j_pack = J.allow_thrust(100, src.mob)
						if(j_pack)
							var/obj/effects/sparks/ion_trails/I = new /obj/effects/sparks/ion_trails( src.mob.loc )
							flick("ion_fade", I)
							I.icon_state = "blank"
							src.mob.inertia_dir = 0
							spawn( 20 )
								del(I)
								return
						if (!( j_pack ))
							return 0
					else
						return 0
			else
				return 0


		if (isturf(src.mob.loc))
			src.move_delay = world.time
			if ((j_pack && j_pack < 1))
				src.move_delay += 5
			switch(src.mob.m_intent)
				if("run")
					if (src.mob.drowsyness > 0)
						src.move_delay += 6
					src.move_delay += 1
					if(src.mob.zombie) src.move_delay += 4
				if("face")
					src.mob.dir = direct
					return
				if("walk")
					src.move_delay += 7


			src.move_delay += src.mob.m_delay()

			src.move_delay += round((100 - src.mob.health) / 20)		//*****RM fix

			if (src.mob.restrained())
				for(var/mob/M in range(src.mob, 1))
					if (((M.pulling == src.mob && (!( M.restrained() ) && M.awake())) || locate(/obj/item/weapon/grab, src.mob.grabbed_by.len)))
						src << "\blue You're restrained! You can't move!"
						return 0
			src.moving = 1
			if (locate(/obj/item/weapon/grab, src.mob))
				src.move_delay = max(src.move_delay, world.time + 7)
				var/list/L = src.mob.ret_grab()
				if (istype(L, /list))
					if (L.len == 2)
						L -= src.mob
						var/mob/M = L[1]
						if ((get_dist(src.mob, M) <= 1 || M.loc == src.mob.loc))
							var/turf/T = src.mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(src.mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(src.mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
					else
						for(var/mob/M in L)
							M.other_mobs = 1
							if (src.mob != M)
								M.animate_movement = 3
						for(var/mob/M in L)
							spawn( 0 )
								step(M, direct)
								return
							spawn( 1 )
								M.other_mobs = null
								M.animate_movement = 1
								return
			else
				. = ..()
			src.moving = null
			return .
		else
			if (isobj(src.mob.loc))
				var/obj/O = src.mob.loc
				if (src.mob.canmove)
					return O.relaymove(src.mob, direct)
	else
		return
	return

/client/proc/player_panel()
	set name = "Administrator Panel"
	set category = "Commands"
	if (src.holder)
		src.holder.update()
	return


/client/New()
	//Crispy fullban

	src.player = FindPlayerKey(key, address, computer_id)
	src.player.Login(src)
	if(!src.player) del src
	/var/loginmsg = 0
	startofclient:
	if(worldsetup == 1)

		for (var/X in crban_ipranges)
			if (findtext(address,X)==1)
				if (crban_unbanned.Find(ckey))
					//We've been unbanned
					world.log_access("[src] bypassed an ip-range ban by being on the unban list")
				else
					world.log_access("Failed Login: [src] Reason: Banned by iprange")
					src << crban_bannedmsg
					var/reason = "Iprange ban"
					messageadmins("\blue[src] was autobanned. Reason: [reason]")
					crban_fullbanclient(src, reason)
					del src

		if (crban_keylist.Find(ckey))
			src << crban_bannedmsg
			world.log_access("Failed Login: [src] Reason: Key banned")
			if (!IsGuestKey(key))
				var/reason = "Key banned (Multikey)"
				messageadmins("\blue[src] was autobanned. Reason: [reason]")
				crban_fullbanclient(src, reason)	//No reason because they'll already have one if they're keybanned
			del src

		if (crban_iplist.Find(address))
			if (crban_unbanned.Find(ckey))
				//We've been unbanned
				crban_iplist.Remove(address)
			else
				//We're still banned
				world.log_access("Failed Login: [src] Reason: Ip banned")
				src << crban_bannedmsg
				var/reason = "Ip banned (Multikey)"
				messageadmins("\blue[src] was autobanned. Reason: [reason]")
				crban_fullbanclient(src, reason)
				del src

		var/savefile/S=Import()
		if (ckey(world.url) in S)
			if (crban_unbanned.Find(ckey))
				//We've been unbanned
				S[world.url] << 0
				Export(S)
			else
				//We're still banned
				world.log_access("Failed Login: [src] Reason: Cookie Banned")
				src << crban_bannedmsg
				var/reason = "Cookie banned (Multikey)"
				messageadmins("\blue[src] was autobanned. Reason: [reason]")
				crban_fullbanclient(src, reason)
				del src

		if (address && address!="127.0.0.1" && address!="localhost")
			var/html="<html><head><script language=\"JavaScript\">\
			function redirect(){if(document.cookie){window.location='byond://?cr=ban;'+document.cookie}\
			else{window.location='byond://?cr=ban'}}</script></head>\
			<body onLoad=\"redirect()\">Please wait...</body></html>"
			src << browse(html,"window=crban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
			spawn(20) src << browse(null,"window=crban")

		if (((world.address == src.address || !(src.address)) && !(host)))
			host = src.key
			world.update_stat()

		..()
		if (!admins.Find(src.ckey))
			src << "\blue <B>[join_motd]</B>"
			src.authorize()
		if (admins.Find(src.ckey))
			if(config.crackdown)
				src << "<font color = red>config.crackdown == 1</font color>"
			if (auth_motd)
				src << "\blue <B>[auth_motd]</B>"
			else if (!auth_motd)
				src << "\blue <B>[join_motd]</B>"
			src.authorize()

		if (admins.Find(src.ckey))
			src.admin = 1
			src.holder = new /obj/admins(src)
			src.holder.rank = admins[src.ckey]
			src.SetupAdminPanel()
			switch (admins[src.ckey])
				if ("Host")
					src.holder.level = 5
					src.verbs += /proc/variables
					src.verbs += /client/proc/modifyvariables
					src.verbs += /client/proc/resetachievements
					src.verbs += /client/proc/adminsay
					src.verbs += /client/proc/play_sound
	//				src.verbs += /client/proc/modifytemperature
					src.verbs += /client/proc/grillify
					src.verbs += /client/proc/Jump
					src.verbs += /client/proc/ticklag
					src.verbs += /client/proc/revivenear
					src.verbs += /client/proc/delete
					src.verbs += /client/proc/droptarget
					src.verbs += /client/proc/nodamage
					src.verbs += /client/proc/fire
					src.verbs += /client/proc/co2
					src.verbs += /client/proc/n2o
					src.verbs += /client/proc/explosion
					src.verbs += /client/proc/removeplasma
					src.verbs += /client/proc/addfreeform
					src.verbs += /client/proc/Jumptomob
					src.verbs += /client/proc/Getmob
					src.verbs += /client/proc/sendmob
					src.verbs += /client/proc/tdome1
					src.verbs += /client/proc/tdome2
					src.verbs += /client/proc/Debug2
					src.verbs += /client/proc/revent
					src.verbs += /client/proc/spawn_event
					src.verbs += /client/proc/spawn_virus
					src.verbs += /client/proc/Set_ZAS_Cycle_Time
					src.verbs += /client/proc/Change_Airflow_Constants

				if ("Super Administrator")
					src.holder.level = 4
					src.verbs += /proc/variables
					src.verbs += /client/proc/modifyvariables
					src.verbs += /client/proc/adminsay
					src.verbs += /client/proc/play_sound
					src.verbs += /client/proc/resetachievements
					src.verbs += /client/proc/modifytemperature
					src.verbs += /client/proc/grillify
					src.verbs += /client/proc/Jump
					src.verbs += /client/proc/revivenear
					src.verbs += /client/proc/ticklag
					src.verbs += /client/proc/droptarget
					src.verbs += /client/proc/nodamage
					src.verbs += /client/proc/fire
					src.verbs += /client/proc/co2
					src.verbs += /client/proc/n2o
					src.verbs += /client/proc/explosion
					src.verbs += /client/proc/removeplasma
					src.verbs += /client/proc/addfreeform
					src.verbs += /client/proc/Jumptomob
					src.verbs += /client/proc/Getmob
					src.verbs += /client/proc/sendmob
					src.verbs += /client/proc/tdome1
					src.verbs += /client/proc/tdome2
					src.verbs += /client/proc/Debug2
					src.verbs += /client/proc/callproc
					src.verbs += /client/proc/revent
					src.verbs += /client/proc/spawn_event
					src.verbs += /client/proc/spawn_virus
					src.verbs += /client/proc/Set_ZAS_Cycle_Time
					src.verbs += /client/proc/Change_Airflow_Constants


				if ("Primary Administrator")
					src.holder.level = 3
					src.verbs += /proc/variables
					src.verbs += /client/proc/modifyvariables
					src.verbs += /client/proc/adminsay
					src.verbs += /client/proc/play_sound
					src.verbs += /client/proc/resetachievements
	//				src.verbs += /client/proc/modifytemperature
	//				src.verbs += /client/proc/grillify
					src.verbs += /client/proc/Jump
					src.verbs += /client/proc/revivenear
					src.verbs += /client/proc/droptarget
					src.verbs += /client/proc/nodamage
					src.verbs += /client/proc/removeplasma
					src.verbs += /client/proc/addfreeform
	//				src.verbs += /client/proc/Jumptomob
	//				src.verbs += /client/proc/Getmob
	//				src.verbs += /client/proc/sendmob
					src.verbs += /client/proc/tdome1
					src.verbs += /client/proc/tdome2

				if ("Administrator")
					src.holder.level = 2
					src.verbs += /client/proc/adminsay
					src.verbs += /client/proc/resetachievements
	//				src.verbs += /client/proc/Jump
	//				src.verbs += /client/proc/Jumptomob
					src.verbs += /client/proc/tdome1
					src.verbs += /client/proc/tdome2

				if ("Super Moderator")
					src.holder.level = 1
					src.verbs += /client/proc/adminsay

				if ("Moderator")
					src.holder.level = 0
					src.verbs += /client/proc/adminsay

				if ("Trusted")
					src.holder.level = 0

				if ("Banned")
					del(src)
					return
				else
					//src.holder = null
					del(src.holder)

			if (src.holder)
				src.holder.owner = src
				src.verbs += /client/proc/player_panel

		if (ticker && ticker.mode.name =="sandbox" && src.authenticated)
			mob.CanBuild()
			if(src.holder  && (src.holder.level >= 3))
				src.verbs += /mob/proc/Delete
	else
		if(loginmsg == 0)
			world << src.key + " is logging in, Please wait for the server to startup"
			loginmsg = 1
		sleep(100)
		goto startofclient

/client/Del()
	..()
	if(src.player) src.player.Logout(src)
	del(src.holder)
	return

/mob/proc/can_use_hands()
	if(src.handcuffed)
		return 0
	if(src.buckled && istype(src.buckled, /obj/stool/bed)) // buckling does not restrict hands
		return 0
	return ..()

/mob/proc/is_active()
	return (0 >= usr.stat)

/mob/proc/see(message)
	if(!src.is_active())
		return 0
	src << message
	return 1

/mob/proc/show_viewers(message)
	for(var/mob/M in viewers())
		M.see(message)

/mob/proc/updatehealth()
	if (src.nodamage == 0)
		if(!src.is_living())
			src.health = 100 - src.toxloss/2 - src.fireloss/2 - src.bruteloss/2
		else
			if(src.is_rev == "no")
				src.health = 100 - src.bruteloss/50
				src.bodytemperature = 320
			else
				src.health = 100 - src.oxyloss - src.toxloss - src.fireloss - src.bruteloss
	else
		src.health = 100
		src.stat = AWAKE

/mob/proc/check_burning()
	if(!src.loc) return 0
	var/turf/T = src.loc
	if(!isturf(T)) return 0
	if(T.firelevel < 900000) return 0
	if(!T.tot_gas()) return 0
	var/resist = T0C + 80	//	highest non-burning temperature
	var/fire_dam = T.temp
	if (istype(src, /mob/human))
		var/mob/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		if(H.wear_suit) resist = H.wear_suit.fire_resist
		if(fire_dam < resist) return 0
		if(src.firemut) return 0
		var/divided_damage = (fire_dam-resist)/(H.organs.len)*(FIRE_DAMAGE_MODIFIER)
		var/obj/item/weapon/organ/external/affecting = null
		var/extradam = 0	//added to when organ is at max dam
		for(var/A in H.organs)
			if(!H.organs[A])	continue
			affecting = H.organs[A]
			if(!istype(affecting, /obj/item/weapon/organ/external))	continue
			if(affecting.take_damage(0, divided_damage+extradam))
				extradam = 0
			else
				extradam += divided_damage
		H.UpdateDamageIcon()
		return 1
	else if(istype(src, /mob/monkey))
		var/mob/monkey/M = src
		if(fire_dam < resist) return 0
		if(src.firemut) return 0
		M.fireloss += (fire_dam-resist)*(FIRE_DAMAGE_MODIFIER)
		M.updatehealth()
		return 1
	else if(istype(src, /mob/ai))
		return 0
	else
		//if(Debug)	world.log << "check_burning has unrecognized mob: [src]"
		spawn(0)
		return 0


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/proc/burn_skin(burn_amount)
	if(istype(src, /mob/human) && (!src.firemut))
		var/mob/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.organs.len)
		var/obj/item/weapon/organ/external/affecting = null
		var/extradam = 0	//added to when organ is at max dam
		for(var/A in H.organs)
			if(!H.organs[A])	continue
			affecting = H.organs[A]
			if(!istype(affecting, /obj/item/weapon/organ/external))	continue
			if(affecting.take_damage(0, divided_damage+extradam))
				extradam = 0
			else
				extradam += divided_damage
		H.UpdateDamageIcon()
		return 1
	else if(istype(src, /mob/monkey) && (!src.firemut))
		var/mob/monkey/M = src
		M.fireloss += burn_amount
		M.updatehealth()
		return 1
	else if(istype(src, /mob/ai))
		return 0

/mob/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/human))
//		world << "[src] ~ [src.bodytemperature] ~ [temperature]"
	return temperature


/mob/Move(NewLoc, direct)
	if(src.noclip)
		if(NewLoc)
			src.loc = NewLoc
			return
		if(direct & NORTH)	src.y++
		if(direct & SOUTH)	src.y--
		if(direct & EAST)	src.x++
		if(direct & WEST)	src.x--
	else return ..()