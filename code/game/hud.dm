obj/hud/New()
	src.instantiate()
	..()
	return

/obj/hud/proc/instantiate()
	src.adding = list(  )
	src.other = list(  )
	src.intents = list(  )
	src.mon_blo = list(  )
	src.m_ints = list(  )
	src.mov_int = list(  )
	src.vimpaired = list(  )
	src.darkMask = list(  )

	src.g_dither = new src.h_type( src )
	src.g_dither.screen_loc = "1,1 to 15,15"
	src.g_dither.name = "Mask"
	src.g_dither.icon_state = "dither12g"
	src.g_dither.layer = 18
	src.g_dither.mouse_opacity = 0

	src.blurry = new src.h_type( src )
	src.blurry.screen_loc = "1,1 to 15,15"
	src.blurry.name = "Blurry"
	src.blurry.icon_state = "blurry"
	src.blurry.layer = 17
	src.blurry.mouse_opacity = 0

	src.druggy = new src.h_type( src )
	src.druggy.screen_loc = "1,1 to 15,15"
	src.druggy.name = "Druggy"
	src.druggy.icon_state = "druggy"
	src.druggy.layer = 17
	src.druggy.mouse_opacity = 0

	var/obj/hud/using

	using = new src.h_type(src)
	using.name = "vitals"
	using.dir = SOUTH
	using.screen_loc = "15,2 to 15,15"
	using.layer = 19

	src.adding += using
	using = new src.h_type( src )
	using.name = "actions"
	using.dir = EAST
	using.screen_loc = "4,1 to 14,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.dir = NORTHWEST
	using.screen_loc = "15,1"
	using.layer = 19
	src.adding += using

	/*
	using = new src.h_type( src )
	using.dir = WEST
	using.screen_loc = "1,3 to 2,3"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.dir = NORTHEAST
	using.screen_loc = "3,3"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.dir = NORTH
	using.screen_loc = "3,2"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.dir = SOUTHEAST
	using.screen_loc = "3,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.dir = SOUTHWEST
	using.screen_loc = "1,1 to 2,2"
	using.layer = 19
	src.adding += using
	*/

	using = new src.h_type( src )
	using.name = "drop"
	using.icon_state = "act_drop"
	using.screen_loc = "7,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "swap"
	using.icon_state = "act_hand"
	using.screen_loc = "11,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "i_clothing"
	using.dir = SOUTH
	using.icon_state = "center"
	using.screen_loc = "2,2"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "o_clothing"
	using.dir = SOUTH
	using.icon_state = "equip"
	using.screen_loc = "2,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "headset"
	using.dir = SOUTHEAST
	using.icon_state = "equip"
	using.screen_loc = "3,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "r_hand"
	using.dir = WEST
	using.icon_state = "equip"
	using.screen_loc = "1,2"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "l_hand"
	using.dir = EAST
	using.icon_state = "equip"
	using.screen_loc = "3,2"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "id"
	using.dir = SOUTHWEST
	using.icon_state = "equip"
	using.screen_loc = "1,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "mask"
	using.dir = NORTH
	using.icon_state = "equip"
	using.screen_loc = "2,3"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "back"
	using.dir = NORTHEAST
	using.icon_state = "equip"
	using.screen_loc = "3,3"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "storage1"
	using.icon_state = "block"
	using.screen_loc = "4,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "storage2"
	using.icon_state = "block"
	using.screen_loc = "5,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "resist"
	using.icon_state = "act_resist"
	using.screen_loc = "13,1"
	using.layer = 19
	src.adding += using

	using = new src.h_type( src )
	using.name = "other"
	using.icon_state = "other"
	using.screen_loc = "4,2"
	using.layer = 20
	src.adding += using

	using = new src.h_type( src )
	using.name = "intent"
	using.icon_state = "intent"
	using.screen_loc = "14,15"
	using.layer = 20
	src.adding += using

	using = new src.h_type( src )
	using.name = "m_intent"
	using.icon_state = "move"
	using.screen_loc = "14,14"
	using.layer = 20
	src.adding += using

	using = new src.h_type( src )
	using.name = "gloves"
	using.icon_state = "gloves"
	using.screen_loc = "4,2"
	using.layer = 19
	src.other += using

	using = new src.h_type( src )
	using.name = "eyes"
	using.icon_state = "glasses"
	using.screen_loc = "6,2"
	using.layer = 19
	src.other += using

	using = new src.h_type( src )
	using.name = "ears"
	using.icon_state = "ears"
	using.screen_loc = "9,2"
	using.layer = 19
	src.other += using

	using = new src.h_type( src )
	using.name = "head"
	using.icon_state = "hair"
	using.screen_loc = "7,2"
	using.layer = 19
	src.other += using

	using = new src.h_type( src )
	using.name = "shoes"
	using.icon_state = "shoes"
	using.screen_loc = "5,2"
	using.layer = 19
	src.other += using

	using = new src.h_type( src )
	using.name = "belt"
	using.icon_state = "belt"
	using.screen_loc = "8,2"
	using.layer = 19
	src.other += using

	using = new src.h_type( src )
	using.name = "grab"
	using.icon_state = "grab"
	using.screen_loc = "11,15"
	using.layer = 19
	src.intents += using

	using = new src.h_type( src )
	using.name = "hurt"
	using.icon_state = "harm"
	using.screen_loc = "14,15"
	using.layer = 19
	src.intents += using
	src.m_ints += using

	using = new src.h_type( src )
	using.name = "disarm"
	using.icon_state = "disarm"
	using.screen_loc = "13,15"
	using.layer = 19
	src.intents += using

	using = new src.h_type( src )
	using.name = "help"
	using.icon_state = "help"
	using.screen_loc = "12,15"
	using.layer = 19
	src.intents += using
	src.m_ints += using

	using = new src.h_type( src )
	using.name = "face"
	using.icon_state = "facing"
	using.screen_loc = "14,14"
	using.layer = 19
	src.mov_int += using

	using = new src.h_type( src )
	using.name = "walk"
	using.icon_state = "walking"
	using.screen_loc = "13,14"
	using.layer = 19
	src.mov_int += using

	using = new src.h_type( src )
	using.name = "run"
	using.icon_state = "running"
	using.screen_loc = "12,14"
	using.layer = 19
	src.mov_int += using

	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "2,2"
	using.layer = 19
	src.mon_blo += using

	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "1,1"
	using.layer = 19
	src.mon_blo += using

	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "2,1"
	using.layer = 19
	src.mon_blo += using

	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "3,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "4,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = "blocked"
	using.icon_state = "x"
	using.screen_loc = "5,1"
	using.layer = 19
	src.mon_blo += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "1,1 to 5,15"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "5,1 to 10,5"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "6,11 to 10,15"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	using = new src.h_type( src )
	using.name = null
	using.icon_state = "dither50"
	using.screen_loc = "11,1 to 15,15"
	using.layer = 17
	using.mouse_opacity = 0
	src.vimpaired += using
	return
