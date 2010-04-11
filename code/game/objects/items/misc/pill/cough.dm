/obj/item/weapon/m_pill/cough/ingest(mob/M as mob)
	if ((prob(75) && M.drowsyness < 600))
		M.drowsyness += 60
		M.drowsyness = min(M.drowsyness, 600)
	M.r_ch_cou += 1200
	..()
	return