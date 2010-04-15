mob/human/npc
	name = "Test dude 1"
	var/mob/target
	var/debug = 1
mob/human/npc/New()
	process()
	return ..()
mob/human/npc/proc/process()

/*
	doing nothing = 1
	attacking = 2




*/
	var/mainstate = 1
	spawn while(1)
		switch(mainstate)
			if(1)
				step_rand(src)
				var/list/mlist1
				mlist1 = new()
				for(var/mob/M in oviewers(world.view,src))
					mlist1 += M
				target = pick(mlist1)
				if(debug)
					world << "[mainstate],[target]"
				if(!target)
					step_rand(src)
					spawn(10)
					process()
					return
				else
					mainstate = 2
					spawn(10)
					process()
					return
			if(2)
				if(!(target in oviewers(world.view,src)))
					target = null
					mainstate = 1
					spawn(10)
					process()
					return
				walk_towards(src,target,1)
				if(target in oviewers(world.view,src))
					attack_hand(target)
					spawn(10)
					process()
					return
				else
					walk_towards(src,target,1)
					spawn(10)
					process()
					return





	/*
	for(M in oview(2))
		moblist += M
	if(!moblist)
		var/list/moblist2
		moblist2 = new()
		for(M in oview(5))
			moblist2 += M
		if(!moblist2)
			step_rand(src)
			step_rand(src)
			process()
		target = pick(moblist2)
		walk_towards(src,target,5)
		if(target in oview(3))
			attack_hand(target)
			say("attacking")
		else
			walk_towards(src,target,5)
		if(!target in oview(5))
			target = null
			process()
	else
		target = pick(moblist)
		walk_towards(src,target,5)
		whoop
		if(target in oview(3))
			attack_hand(target)
			say("attacking")
		else
			walk_towards(src,target,5)
		if(target in oview(5))
			target = null
			process()
*/