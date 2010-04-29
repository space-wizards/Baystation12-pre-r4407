/obj/loadMapModule
	name = "loadMapModule"
	icon = 'screen1.dmi'
	icon_state = "x3"
	anchored = 1.0
	var/category = "8x8"
	var/list/map = list("blank")
	var/done = 0

var/list/mapModules = new()
var/list/moduleMarkers = new()

/obj/loadMapModule/New()
	..()
	src.invisibility = 100
	if(!category in mapModules)
		mapModules += category
	if(!mapModules[category])
		mapModules[category] = list()
	mapModules[category] += pick(map)
	moduleMarkers += src

/proc/load_map_modules()
	var/obj/loadMapModule/m
	while(moduleMarkers.len)
		m = pick(moduleMarkers)
		if(!m.done)
			var/list/l=mapModules[m.category]
			world << l.len
			m.done = 1
			var/randMap = pick(l)
			mapModules[m.category] -= randMap
			QML_loadMap("maps\\modules\\[randMap].dmm",m.x-1,m.y-1,m.z-1)
		moduleMarkers -= m
