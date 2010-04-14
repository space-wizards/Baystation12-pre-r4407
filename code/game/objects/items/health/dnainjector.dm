/obj/item/weapon/dnainjector/attack_paw(mob/user as mob)
	return src.attack_hand(user)


/obj/item/weapon/dnainjector/proc/inject(mob/M as mob)
	M.radiation += rand(20,50)
	if (dnatype == "ui")
		if (!block) //isolated block?
			if (ue) //unique enzymes? yes
				M.primarynew.uni_identity = dna
				updateappearance(M, M.primarynew.uni_identity)
				M.rname = ue
				M.name = ue
				uses--
			else //unique enzymes? no
				M.primarynew.uni_identity = dna
				updateappearance(M, M.primarynew.uni_identity)
				uses--
		else
			M.primarynew.uni_identity = setblock(M.primarynew.uni_identity,block,dna,3)
			updateappearance(M, M.primarynew.uni_identity)
			uses--
	if (dnatype == "se")
		if (!block) //isolated block?
			M.primarynew.struc_enzyme = dna
			domutcheck(M, null)
			uses--
		else
			M.primarynew.struc_enzyme = setblock(M.primarynew.struc_enzyme,block,dna,3)
			domutcheck(M, null,1)
			uses--
	del(src)
	return uses

/obj/item/weapon/dnainjector/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob))
		return
	if (!(istype(usr, /mob/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	if (user)
		if (istype(M, /mob/human))
			var/obj/equip_e/human/O = new /obj/equip_e/human(  )
			O.source = user
			O.target = M
			O.item = src
			O.s_loc = user.loc
			O.t_loc = M.loc
			O.place = "dnainjector"
			M.requests += O
			spawn( 0 )
				O.process()
				return
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] has been injected with [] by [].", M, src, user), 1)
				//Foreach goto(192)
			inject(M)
			user.show_message(text("\red You inject [M]"))
	return