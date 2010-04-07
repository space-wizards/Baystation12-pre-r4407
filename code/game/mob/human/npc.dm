mob/human/npc
	name = "Test dude 1"
	var/mob/target
mob/human/npc/New()
	process()
	return ..()
mob/human/npc/proc/process()
	var/mob/M
	var/list/moblist
	moblist = new()
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
