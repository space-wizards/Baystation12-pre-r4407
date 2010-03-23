/world/proc/log_admin(text)
	if (config.log_admin)
		world.log << "[time2]:ADMIN: [text]"
		var/F = file(log_file)
		F << "[time2]:ADMIN: [text]"

/world/proc/log_game(text)
	if (config.log_game)
		world.log << "[time2]:GAME: [text]"
		var/F = file(log_file)
		F << "[time2]:GAME: [text]"

/world/proc/log_vote(text)
	if (config.log_vote)
		world.log << "[time2]:VOTE: [text]"
		var/F = file(log_file)
		F << "[time2]:VOTE: [text]"
/world/proc/log_access(text)
	if (config.log_access)
		world.log << "[time2]:ACCESS: [text]"
		var/F = file(log_file)
		F << "[time2]:ACCESS: [text]"
/world/proc/log_say(text)
	if (config.log_say)
		world.log << "[time2]:SAY: [text]"
		var/F = file(log_file)
		F << "[time2]:SAY: [text]"
/world/proc/log_ooc(text)
	if (config.log_ooc)
		world.log << "OOC: [text]"
		var/F = file(log_file)
		F << "[time2]:OOC: [text]"
/world/proc/log_Mattack(text)
	world.log << "[time2]:MATTACK: [text]"
	var/F = file(log_file)
	F << "[time2]:MATTACK: [text]"

/*/world/proc/log_attack(text)
	world.log << "ATTACK: [text]"
	var/F = file(log_file_verbose)
	F << "ATTACK: [text]"*/