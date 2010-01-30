/client/proc/resetachievements()
	set category = "Debug"
	set name = "Reset Achievements"
	//	All admins should be authenticated, but... what if?
	if(!src.authenticated || !src.holder)
		src << "Only administrators may use this command."
		return

	if(!src.mob)
		return

	if(src.holder.rank != "Host")
		src << "Fuck you, no resetting achievements."

	for(var/mob/M in world)
		M.achievements = ""
		M << "[src.key] is being a complete asshole and has reset all of your achievements."
		M.savemedals()