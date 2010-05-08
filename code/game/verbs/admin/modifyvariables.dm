/client/proc/modifyvariables(obj/O as obj|mob|turf|area in world)
	set category = "Debug"
	set name = "edit variables"
	set desc="(target) Edit a target item's variables"
	//var/locked[]
	//locked = list()

	if(config.crackdown)
		return

	if(Debug2 == Debug2) // HAHAHA LAZY
		if(!src.authenticated || !src.holder)
			src << "Only administrators may use this command."
			return

		if(istype(O,/obj/admins))
			world << "[src.key] tried to edit an admin panel object"
			return

		if(istype(O,/client))
			var/client/c = O
			if(c.holder)
				world << "[src.key] is trying to edit an administrator's client"
				if((input(c,"[src.key] is trying to edit your client. Allow?","Secuity question","No") in list("Yes","No")) == "No")
					return

		var/variable = input("Which var?","Var") in O.vars

		//if (locked.Find(variable))
		//	alert("Variable locked.")
		//	return

		var/default
		var/typeof = O.vars[variable]
		var/dir

		if(isnull(typeof))
			usr << "Unable to determine variable type."

		else if(isnum(typeof))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
			dir = 1

		else if(istext(typeof))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"

		else if(isloc(typeof))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"

		else if(isicon(typeof))
			usr << "Variable appears to be <b>ICON</b>."
			typeof = "\icon[typeof]"
			default = "icon"

		else if(istype(typeof,/atom) || istype(typeof,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"

		else if(istype(typeof,/list))
			usr << "Variable appears to be <b>LIST</b>."
			default = "list"

		else if(istype(typeof,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			default = "cancel"

		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"

		usr << "Variable contains: [typeof]"
		if(dir)
			switch(typeof)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				usr << "If a direction, direction is: [dir]"

		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num", "type", "reference", "mob reference", "icon", "file",
			"modify referenced variables", "list", "restore to default", "cancel")

		switch(class)
			if("cancel")
				return

			if("restore to default")
				O.vars[variable] = initial(O.vars[variable])

			if("text")
				O.vars[variable] = input("Enter new text:","Text",\
					O.vars[variable]) as text

			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num

			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/obj,/mob,/area,/turf)

			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world

			if("mob reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob in world

			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file

			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon
			if("modify referenced variables")
				modifyvariables(O.vars[variable])
				return

			if("list")
				var/list/temp
				if(!istype(O.vars[variable],/list))
					temp = new
				else
					//Copy the old without bothering to make a second temporary var
					temp = O.vars[variable]
					temp = temp.Copy()
				temp = modifylist(temp)
				if(temp != null)
					O.vars[variable] = temp
				else
					return
		world.log_admin("[src.key] modified [O.name]'s [variable] to [O.vars[variable]]")
		world << text("[src.key] modified [O.name]'s [variable] to [O.vars[variable]]")

	else
		alert("Debugging is disabled")





//Return value: null to discard any change, otherwise the new /list
/client/proc/modifylist(list/edited)
	var/choice = input("What var?", "Edit list", "cancel") in edited + "new entry" + "cancel"
	if(choice == "cancel")
		return null
	else if(choice == "new entry")
		choice = input("What to add?", "Add to list", "cancel") in list("text", "num",
			"type", "reference", "mob reference", "list", "cancel")
		switch(choice)
			if("cancel")
				return null
			if("text")
				edited += input("Text:","Add to list","") as text
			if("num")
				edited += input("Number:","Add to list","") as num
			if("type")
				edited += input("Type:","Add to list","") in typesof(/obj,/mob,/area,/turf)
			if("reference")
				edited += input("Reference:","Add to list","") as mob|obj|turf|area in world
			if("mob reference")
				edited += input("Reference:","Add to list","") as mob in world
			if("list")
				var/list/temp = modifylist(list())
				edited += temp
		world.log_admin("[src.key] added an entry to a list")
		world << "[src.key] added an entry to a list"
	else
		var/list/types = list("remove", "cancel")
		if(istype(choice,/atom))
			types = list("remove", "modify object", "cancel")
		switch(input("Remove or Modify?", "Edit list entry", "cancel") in types)
			if("cancel")
				return null
			if("modify object")
				modifyvariables(choice)
				return null
			if("remove")
				edited -= choice
				world.log_admin("[src.key] removed [choice] from a list")
				world << "[src.key] removed [choice] from a list"
	return edited