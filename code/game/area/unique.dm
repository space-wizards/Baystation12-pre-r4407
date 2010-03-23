/obj/item/weapon/tank/oxygentank/bloodytank/New()
	var/obj/item/weapon/source2 = src
	source2.icon_old = src.icon
	var/icon/I = new /icon(src.icon, src.icon_state)
	I.Blend(new /icon('blood.dmi', "thisisfuckingstupid"),ICON_ADD)
	I.Blend(new /icon('blood.dmi', "itemblood"),ICON_MULTIPLY)
	I.Blend(new /icon(src.icon, src.icon_state),ICON_UNDERLAY)
	src.icon = I

///obj/BloodLocation/proc/Create()
//	var/obj/bloodtemplate/this = new /obj/bloodtemplate(src)
//
///obj/BloodLocation
//	icon = 'screen1.dmi'
//	icon_state = "x2"
//
///obj/BloodLocation/New()
//	icon = null
//	icon_state = null