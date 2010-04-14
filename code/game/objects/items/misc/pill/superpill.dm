/obj/item/weapon/m_pill/superpill/ingest(mob/M as mob)
	if(istype(M, /mob/human))
		var/mob/human/H = M
		for(var/A in H.organs)
			var/obj/item/weapon/organ/external/affecting = null
			if(!H.organs[A])	continue
			affecting = H.organs[A]
			if(!istype(affecting, /obj/item/weapon/organ/external))	continue
			affecting.heal_damage(1000, 1000)	//fixes getting hit after ingestion, killing you when game updates organ health
		H.UpdateDamageIcon()
	M.fireloss = 0
	M.toxloss = 0
	M.bruteloss = 0
	M.oxyloss = 0
	M.paralysis = 3
	M.stunned = 4
	M.weakened = 5
	M.updatehealth()
	M.stat = 1
	..()
	return