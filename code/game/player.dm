var/list/players = new/list()

proc/estimate_time(num)
    num = abs(num)

    if(num >= 31536000000)
        //estimate in centuries
        var/amount = round(num/31536000000,1)
        return "[amount] centur[amount != 1 ? "ies" : "y"]"

    else if(num >= 3153600000)
        //estimate in decades
        var/amount = round(num/3153600000,1)
        return "[amount] decade[amount != 1 ? "s" : ""]"

    else if(num >= 315360000)
        //estimate in years
        var/amount = round(num/315360000,1)
        return "[amount] year[amount != 1 ? "s" : ""]"

    else if(num >= 25920000)
        //estimate in months
        var/amount = round(num/25920000,1)
        return "[amount] month[amount != 1 ? "s" : ""]"

    else if(num >= 6048000)
        //estimate in weeks
        var/amount = round(num/6048000,1)
        return "[amount] week[amount != 1 ? "s" : ""]"

    else if(num >= 864000)
        //estimate in days
        var/amount = round(num/864000,1)
        return "[amount] day[amount != 1 ? "s" : ""]"

    else if(num >= 36000*2)
        //estimate in hours
        var/amount = round(num/36000,1)
        return "[amount] hour[amount != 1 ? "s" : ""]"

    else if(num >= 60*3)
        //estimate in minutes
        var/amount = round(num/60,1)
        return "[amount] minute[amount != 1 ? "s" : ""]"

    else if(num >= 10)
        //estimate in seconds
        var/amount = round(num/10,1)
        return "[amount] second[amount != 1 ? "s" : ""]"

    else
        return "1 second"
proc
	FindPlayerKey(key, address, computer_id)
		if(!istype(players,/list)) players = list()
		var/ckey = ckey(key)
		var/player/P
		for(P in players) //check for existing keys
			if(ckey(P.name) == ckey) break
		/*if(!P)
			for(P in players)
				if((ckey in P.associates) || (address in P.associates) || (computer_id in P.associates)) break*/
		if(!P)
			P = new(key)
			players += P
		P.AddAssoc(key, computer_id,address)
		return P



player
	var
		name
		list
			warnings
			associates
			allowed_jobs
			denied_jobs
		activity
		player_profile
			profile
		tmp/client/client
		choosename = 1

	New(Key)
		if(Key)
			name = Key
	proc
		Login(client/C)
			src.client = C
			activity = -1
			CheckWarnState(C)
		Logout(client/C)
			client = null
			activity = world.realtime
		AddAllowedJob(var/job)
			if(!allowed_jobs) allowed_jobs = new/list()
			if(!(job in allowed_jobs)) allowed_jobs += job

		AddDeniedJob(var/job)
			if(!denied_jobs) denied_jobs = new/list()
			if(!(job in denied_jobs)) denied_jobs += job
		RemoveAllowedJob(var/job)
			if(!allowed_jobs) return
			if(job in allowed_jobs) allowed_jobs -= job
			if(!allowed_jobs.len) allowed_jobs = null

		RemoveDeniedJob(var/job)
			if(!denied_jobs) return
			if(job in denied_jobs) denied_jobs -= job
			if(!denied_jobs.len) denied_jobs = null

		GetDeniedJobs()
			. = denied_jobs ? denied_jobs.Copy() : list()
			for(var/player/P in GetLinkedAccounts())
				for(var/job in P.denied_jobs)
					if(!(job in .)) . += job

		GetAllowedJobs()
			var/list/jobs = occupations.Copy()
			jobs -= GetDeniedJobs()
			return jobs

		AddWarning(author,content,message,state,expires = 0)
			if(!warnings) warnings = new/list()
			var/player_warning/P = new/player_warning(author, content, message, state, expires)
			warnings += P

		RemoveWarning(player_warning/warning)
			if(warning in warnings)
				warnings -= warning
				if(!warnings.len) warnings = null

		GetWarnings()
			var/list/L = new/list()
			for(var/player/P in global.players)
				if(P == src || (ckey(name) in P.associates))
					for(var/player_warning/W in P.warnings) L[W] = P
			return L

		GetLinkedAccounts(skip)
			var/list/L = new/list()
			for(var/player/P in global.players)
				if(P == src) continue
				if(ckey(name) in P.associates) L += P
			return L

		GetClients()
			var/list/L = client ? list(client) : new/list()
			for(var/player/P in global.players)
				if(!P.client || P == src) continue
				if(ckey(name) in P.associates) L += P.client
			return L

		GetBiggestWarning()
			var
				list/L = GetWarnings()
				player_warning/W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_FULLBAN) break
			if(W) return W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_PARTIALBAN) break
			if(W) return W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_FULLYMUTED) break
			if(W) return W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_OOCMUTED) break
			if(W) return W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_MODERATED) break
			if(W) return W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_WARNED) break
			if(W) return W
			return 0


		CheckWarnState()
			var
				client/C = src.client
				player_warning/W = GetBiggestWarning()
			if(!C || !W) return
//			for(A in global.dadmins)
//				if(A.ckey == C.ckey) break
//			if(A)
//				C << "\red You have a warning: \"[W.state2text(W.state)]\"."
//				C << "\red [W.message]."
//				C << "\red Admins are not effected by warnings."
//				return
	// FIX UP THIS SO THAT ADMINS CANNOT BAN EACH OTHER
			switch(W.state)
				if(W.STATE_FULLBAN)
					C << "\red You have been fully banned from this server!"
					C << "\red [W.message]"
					if(W.expires) C << "\red Your ban will expire in [estimate_time(W.expires - world.realtime)]."
					C << "\red If you feel you have been treated unfairly, please PM the server host at bay12games.com"
					del C
				if(W.STATE_PARTIALBAN)
					C << "\red You have been banned from being able to play, this includes all OOC chat."
					C << "\red [W.message]"
					if(W.expires) C << "\red Your ban will expire in [estimate_time(W.expires - world.realtime)]."
					C << "\red If you feel you have been treated unfairly, please adminhelp."
					C << "\red Spamming adminhelp will get the ban upgraded"
				if(W.STATE_FULLYMUTED)
					C << "\red You may no speak, both ingame and in OOC."
					C << "\red [W.message]"
					if(W.expires) C << "\red Your mute will expire in [estimate_time(W.expires - world.realtime)]."
					C << "\red If you feel you have been treated unfairly, please adminhelp."
					C << "\red Spamming adminhelp will get the ban upgraded"
				if(W.STATE_OOCMUTED)
					C << "\red You may no longer make use of the OOC channel."
					C << "\red [W.message]"
					if(W.expires) C << "\red Your mute will expire in [estimate_time(W.expires - world.realtime)]."
					C << "\red If you feel you have been treated unfairly, please adminhelp."
					C << "\red Spamming adminhelp will get the ban upgraded"
				if(W.STATE_MODERATED, W.STATE_WARNED)
					C << "\red You have been cautioned, further behavior may result in a ban being implaced."
					C << "\red [W.message]"
					if(W.expires) C << "\red Your warning will expire in [estimate_time(W.expires - world.realtime)]."

		IsFullyBanned()
			if(client && client.admin) return null
			var
				list/L = GetWarnings()
				player_warning/W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_FULLBAN) break
			return W
		IsPartiallyBanned()
			if(client && client.admin) return null
			var
				list/L = GetWarnings()
				player_warning/W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_PARTIALBAN) break
			return W
		IsOOCMuted()
			if(client && client.admin) return null
			var
				list/L = GetWarnings()
				player_warning/W
			for(W in L)
				if(!W.expired() && (W.state == W.STATE_PARTIALBAN || W.state == W.STATE_FULLYMUTED || (W.state == W.STATE_OOCMUTED))) break
			return W

		IsFullyMuted()
			if(client && client.admin) return null
			var
				list/L = GetWarnings()
				player_warning/W
			for(W in L)
				if(!W.expired() && (W.state == W.STATE_PARTIALBAN || W.state == W.STATE_FULLYMUTED)) break
			return W

		IsModerated()
			if(client && client.admin) return null
			var
				list/L = GetWarnings()
				player_warning/W
			for(W in L)
				if(!W.expired() && W.state == W.STATE_MODERATED) break
			return W

		IsWarned(at_all)
			if(client && client.admin) return null
			var
				list/L = GetWarnings()
				player_warning/W
			if(at_all) return L.len
			for(W in L)
				if(!W.expired() && W.state == W.STATE_WARNED) break
			return W

		AddAssoc(key, computer_id, address)
			var/ckey = ckey(key)
			if(!(ckey in associates)) associates += ckey
			if(computer_id && !(computer_id in associates)) associates += computer_id
			if(address && !(address in associates)) associates += address

			for(var/player/P in global.players)
				if(P == src) continue
				if((computer_id && (computer_id in P.associates)) || (address && (address in P.associates)))
					if(!(ckey in P.associates)) P.associates += ckey
					if(!(ckey(P.name) in src.associates)) src.associates += ckey(P.name)

		FindAssoc(data)
			if(!data) return 0
			if(data == ckey(name)) return 1
			if(data in associates) return 1
			return 0
		RemoveAssoc(data)
			associates -= data

player_key
	var
		player/player
		name
		address
		computer_id
	New(player/player, name, address, computer_id)
		src.player = player
		src.name = name
		src.address = address
		src.computer_id = computer_id







player_profile
	var
		name
		age = 26
		disabilities = 0
		sdisabilities = 0
		occupation1
		occupation2
		occupation3
		blood_type = "A+"
		skin_tone = 35
		hair_r
		hair_g
		hair_b
		hair_style
		eye_r
		eye_g
		eye_b

player_warning
	var
		author
		content
		message
		state
		date
		const
			STATE_NOTHING = 0
			STATE_WARNED = 1
			STATE_MODERATED = 2
			STATE_OOCMUTED = 3
			STATE_FULLYMUTED = 4
			STATE_PARTIALBAN = 5
			STATE_FULLBAN = 6
		expires
	proc
		expired()
			if(state == 0) return 1
			if(expires == -1) return 0
			if(!expires) return 1
			if(expires <= world.realtime) return 1
			return 0
		expires2text()
			if(state == STATE_NOTHING) return "N/A"
			if(expires == -1) return "never expires"
			else if(!expires) return "expired"
			else
				if(expires <= world.realtime) return "expired [estimate_time(world.realtime - expires)] ago"
				return "will expire in [estimate_time(expires - world.realtime)] from now"
		state2text()
			switch(state)
				if(STATE_NOTHING) return "note"
				if(STATE_WARNED) return "warned"
				if(STATE_MODERATED) return "moderated"
				if(STATE_OOCMUTED) return "OOC muted"
				if(STATE_FULLYMUTED) return "fully muted"
				if(STATE_PARTIALBAN) return "banned"
				if(STATE_FULLBAN) return "fully banned"
				else return "unknown"
