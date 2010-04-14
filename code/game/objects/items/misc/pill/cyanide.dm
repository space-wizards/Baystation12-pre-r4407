/obj/item/weapon/m_pill/cyanide/ingest(mob/M as mob)
	if (M.health > -50.0)
		M.toxloss += M.health + 50
	M.updatehealth()
	..()
	return