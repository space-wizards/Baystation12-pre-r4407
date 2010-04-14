/obj/item/weapon/m_pill/Tourette/ingest(mob/M as mob)
	if (M.drowsyness < 600)
		M.drowsyness += rand(3, 5) * 60
		M.drowsyness = min(M.drowsyness, 600)
	M.r_Tourette += 1200
	..()
	return