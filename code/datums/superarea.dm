/datum/superarea
	var/list/areas = list( )
	var/areaid = 0
	var/global/usedareaids = list()
	var/gravity = 1 //if the area has gravity enabled

	New()
		..()
		var/I = rand(1, 1048575)
		while (I in usedareaids)
			I = rand(1, 1048575)
		areaid = num2hex(I, 5)
		usedareaids += I