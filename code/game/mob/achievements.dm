/mob/proc/unlock_medal(title, announce, desc, diff)

	spawn ()
		if (ismob(src) && src.key)
			var/savefile/L =  new/savefile( text("players/[].sav", src.ckey) )
			L[achievements] << 	oldachievements
			//messageadmins("[achievements], [oldachievements], [title]")
			if (findtext("[oldachievements]","[title]") || findtext("[achievements]","[title]"))
		//		messageadmins("Fi fucking nally")
				return
			src.achievements += "\n" + title + " " + diff
			//txt2file(H,"players/[src.ckey].sav") // old shit
			src.savemedals()
			var/H
			switch(diff)
				if ("medium")
					H = "#EE9A4D"
				if ("easy")
					H = "green"
				if ("hard")
					H = "red"
			if (announce)
				world << "<b>Achievement Unlocked!: [src.key] unlocked the '<font color = [H]>[title]</font color>' achievement.</b></font>"
				src << text("[desc]")
			else if (!announce)
				src << "<b>Achievement Unlocked!: You unlocked the '<font color = [H]>[title]</font color>' achievement.</b></font>"
				src << text("[desc]")
/mob/proc/add_medal(name,announce,amount,req)

	spawn()
		//total++
		if (ismob(src) && src.key)
			//text2file(text("[src.key] [name]"),medals_file)
			if (total < req)
				total++
			//messageadmins("[amount] [total] [req]")
			if (total >= req)
				unlock_medal(name,announce)
