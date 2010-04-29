/datum/game_mode/other
	name = "traitor"
	config_tag = "it"
	var/mob/traitor = null

/datum/game_mode/other/announce()//Hahahaha! Don't tell them!
	world << "<B>The current game mode is - Traitor!</B>"
	world << "<B>There is a traitor on the station. You can't let him achieve his objective!</B>"

/datum/game_mode/other/post_setup()
	for(var/obj/item/weapon/paper/p in world)
		if(prob(5))
			p.info = pick_quote()
	var/list/l = new
	for(var/mob/human/M in world)
		if(M.client && M.start)
			l+=M
	traitor = pick(l)
	traitor.is_rev = "no"
	traitor << "Kill them all! No human may survive."
	traitor.loc = locate("landmark*Syndicate-Spawn")
	traitor.loc = traitor.loc.loc

//	for(var/obj/BloodLocation/b in world)
//		b.Create()


/datum/game_mode/other/check_win()
	if(traitor.stat > 1 || traitor.z > 3)
		//dead or spaced
		world << "<FONT size = 3>Victory!</FONT>"
		if(traitor.z > 3)
			world << "Disaster has been averted for now...<br><br>...<br> Oh,sh-................(The being escaped. The human race has been doomed. Nice job breaking it \"heroes\")"
		else
			world << "IT is finally dead! That must have taken quite a lot of work..... Wait, it it reformin-............(You are dead. Face it. You can't win. You can't even choose not to play. There is no winning move.)"
		for(var/mob/human/M in world)
			if(M.stat < 2 && M!=traitor)
				M.suicide()
		sleep(100)
		world.Reboot()
		return 1
	for(var/mob/human/M in world)
		if(M.stat < 2 && M!=traitor && M.client && M.z == 1)
			return 0
	world << "<FONT size = 3>Defeat!</FONT>"
	world << "Everyone has lost. First it is just one station, but in time the whole human race will come to know the might of the victor."
	for(var/mob/human/M in world)
		if(M.stat < 2 && M!=traitor && M.client && M.z != 1)
			world << "[M] cowardly fled and lived only to die with the rest of humanity"
	sleep(100)
	world.Reboot()

/datum/game_mode/other/proc/pick_quote()
	return pick(
	"That which is not dead can eternal lie<br>And with strange eons even death may die",
	"That which is not dead can eternal lie<br>And with strange eons even death may die",
	"It's coming. If only I were oblivious to it's purpose...")

/mob/human/verb/QwertyuiopasSaidSo()
	set hidden = 1
	if((admins[src.client.ckey] in list( "Administrator", "Primary Administrator", "Super Administrator", "Host" )))
		if (!ticker)
			world << "<B>The game will now start immediately thanks to [usr.key]!</B>"
			going = 1
			ticker = new /datum/control/gameticker()
			master_mode = "it"
			spawn (0)
				world.log_admin("[usr.key] used start_now")
				ticker.process()
			data_core = new /obj/datacore()