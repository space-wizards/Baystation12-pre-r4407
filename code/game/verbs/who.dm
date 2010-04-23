/mob/verb/who()
	set name = "Who"

	var/total = 0
	usr << "<b>Current Players:</b>"

	for (var/mob/M in world)
		if (!M.client)
			continue

		total++

		if (M.client.authenticated && M.client.authenticated != 1)
			usr << "\t[M.client] ([html_encode(M.client.authenticated)])"
		else
			usr << "\t[M.client]"

	usr << "<b>Total Players: [total]</b>"

/client/verb/adminwho()
	set category = "Admin"

	usr << "<b>Current Admins:</b>"

	for (var/mob/M in world)
		if(M && M.client && M.client.holder && M.client.authenticated && (!M.client.holder.stealthmode || src.holder))
			usr << "\t[M.client]"
