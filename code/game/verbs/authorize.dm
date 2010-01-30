/client/proc/authorize()
	set name = "Authorize"

	if (src.authenticating)
		return

	if (!config.enable_authentication)
		src.authenticated = 1
		return

	src.authenticating = 1

	spawn (rand(4, 18))
		var/result = world.Export("http://byond.lljk.net/status/?key=[src.ckey]")
		var/success = 0

		if(lowertext(result["STATUS"]) == "200 ok")
			var/content = file2text(result["CONTENT"])

			var/pos = findtext(content, " ")
			var/code
			var/account = ""

			if (!pos)
				code = lowertext(content)
			else
				code = lowertext(copytext(content, 1, pos))
				account = copytext(content, pos + 1)

			if (code == "ok" && account)
				src.verbs -= /client/proc/authorize
				src.authenticated = account
				src << "Key authorized: Hello [html_encode(account)]!"
				src << "\blue[auth_motd]"
				success = 1
			else if (code == "banned")
				//Crispy fullban
				crban_fullban(src)
				del(src)
				return

		if (!success)
			src.verbs += /client/proc/authorize
			src << "Failed to authenticate your key."
			src << "If you have not already authorize it at http://byond.lljk.net/ - your BYOND key is [src.key]."
			src << "Try again using the <b>Authorize</b> command, sometimes the server will hiccup and not correctly authorize."
			src << "\blue[no_auth_motd]"
		src.authenticating = 0