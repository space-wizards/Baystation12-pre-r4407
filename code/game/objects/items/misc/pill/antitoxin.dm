/obj/item/weapon/m_pill/antitoxin/ingest(mob/M as mob)
	if ((prob(50) && M.drowsyness < 600))
		M.drowsyness += 60
		M.drowsyness = min(M.drowsyness, 600)
	if (M.health >= 0)
		if (M.toxloss <= 20)
			M.toxloss = 0
		else
			M.toxloss -= 20
	M.antitoxs += 600
	M.updatehealth()
	..()
	return