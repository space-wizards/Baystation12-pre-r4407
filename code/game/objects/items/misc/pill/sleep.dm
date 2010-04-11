/obj/item/weapon/m_pill/sleep/ingest(mob/M as mob)
	if (M.drowsyness < 600)
		M.drowsyness += 600
		M.drowsyness = min(M.drowsyness, 1800)
	if (prob(25))
		M.paralysis += 60
	else if (prob(50))
		M.paralysis += 30
	..()
	return