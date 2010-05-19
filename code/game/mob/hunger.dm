#define hunger_tick_rate  10
#define thrist_tick_rate  10
mob/var/hunger = 200 // 0 is -100 100 is 0 200 is 100
mob/var/thirst = 200
mob/proc/hungertick()
	spawn(3000)
		if(src.zombie)
			return
		if(!src.stat)
			var/h = 1
			var/t = 2
			h *= hunger_tick_rate
			t *= thrist_tick_rate
			if(src.hunger)
				src.hunger -= h
			if(src.thirst)
				src.thirst -= t
			if(prob(10))
				if(src.hunger < 150)
					src:emote("hungry")
			if(prob(10))
				if(src.thirst < 150)
					src:emote("thirsty")
		hungertick()

obj/proc/add_food(var/mob/M,var/type,var/num)
	if(type)
		M.hunger += num
		if(M.hunger > 200)
			M.hunger = 200
	else
		M.thirst += num
		if(M.thirst > 200)
			M.thirst = 200


