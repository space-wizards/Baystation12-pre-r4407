/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"

/datum/game_mode/announce()
	spawn ( 0 )
		randomchems()
	world << "<B>The current game mode is - Extended Role-Playing!</B>"
	world << "<B>Just have fun and role-play!</B>"
