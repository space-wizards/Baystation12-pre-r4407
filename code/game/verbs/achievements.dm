/mob/verb/list_achievements()
	var/H
	if (findtext("[src.achievements]","medium"))
		H = "#EE9A4D"
	else if (findtext("[src.achievements]","easy"))
		H = "green"
	else if (findtext("[src.achievements]","hard"))
		H = "red"

	//messageadmins("[H]")
	src << "<font color = [H]>[src.achievements]</font color>"

