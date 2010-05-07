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
			if(prob(50))
				if(src.hunger < 150 && src.hunger > 100)
					src << "You feel slightly hungry."
				if(src.hunger < 100 && src.hunger > 50)
					src << "You feel quite hungry."
				if(src.hunger < 50)
					src << "You are so hungry you could eat a horse."
			if(prob(50))
				if(src.thirst < 150 && src.thirst > 100)
					src << "You feel slightly thirsty."
				if(src.thirst < 100 && src.thirst > 50)
					src << "You feel quite thirsty."
				if(src.thirst < 50)
					src << "You are so thirsty you could drink a lake."
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


