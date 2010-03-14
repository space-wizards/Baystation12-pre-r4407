/world/proc/log_admin(text)
	if (config.log_admin)
		world.log << "ADMIN: [text]"
		var/F = file(log_file)
		F << "ADMIN: [text]"

/world/proc/log_game(text)
	if (config.log_game)
		world.log << "GAME: [text]"
		var/F = file(log_file)
		F << "GAME: [text]"

/world/proc/log_vote(text)
	if (config.log_vote)
		world.log << "VOTE: [text]"
		var/F = file(log_file)
		F << "VOTE: [text]"
/world/proc/log_access(text)
	if (config.log_access)
		world.log << "ACCESS: [text]"
		var/F = file(log_file)
		F << "ACCESS: [text]"
/world/proc/log_say(text)
	if (config.log_say)
		world.log << "SAY: [text]"
		var/F = file(log_file)
		F << "SAY: [text]"
/world/proc/log_ooc(text)
	if (config.log_ooc)
		world.log << "OOC: [text]"
		var/F = file(log_file)
		F << "OOC: [text]"
/world/proc/log_Mattack(text)
	world.log << "MATTACK: [text]"
	var/F = file(log_file)
	F << "MATTACK: [text]"

/*/world/proc/log_attack(text)
	world.log << "ATTACK: [text]"
	var/F = file(log_file_verbose)
	F << "ATTACK: [text]"*/