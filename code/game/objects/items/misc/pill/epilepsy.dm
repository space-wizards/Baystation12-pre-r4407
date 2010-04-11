/obj/item/weapon/m_pill/epilepsy/ingest(mob/M as mob)
	if (M.drowsyness < 600)
		M.drowsyness += rand(2, 3) * 60
		M.drowsyness = min(M.drowsyness, 600)
	M.r_epil += 1200
	..()
	return