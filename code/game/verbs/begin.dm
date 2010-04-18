/obj/begin/verb/ready()
	set src in usr.loc

	if (!usr.client.authenticated)
		src << "You are not authorized to enter the game."
		return

	if (!enter_allowed)
		usr << "\blue There is an administrative lock on entering the game!"
		return

	if (!istype(usr, /mob/human) || usr.start)
		usr << "You have already started!"
		return

	var/mob/human/M = usr

	for(var/mob/human/H in world)
		if(H.start && cmptext(H.rname,M.rname))
			usr << "You are using a name that is very similar to a currently used name, please choose another one using Character Setup."
			return
	if(cmptext("Unknown",M.rname))
		usr << "This name is reserved for use by the game, please choose another one using Character Setup."
		return
	src.get_dna_ready(M)

	if (ticker)
		var/list/L = assistant_occupations
		var/job
		if (L.Find(M.occupation1))
			job = M.occupation1
		else if (L.Find(M.occupation2))
			job = M.occupation2
		else if (L.Find(M.occupation3))
			job = M.occupation3
		else
			job = pick(L)
		var/joined_late = 1
		M.Assign_Rank(job, joined_late)

	M.verbs -= /mob/human/verb/char_setup
	M.start = 1
	M.update_face()
	M.update_body()

	enter()

/obj/begin/verb/enter()
	if (!usr.start || !istype(usr, /mob/human))
		usr << "\blue <B>You aren't ready! Use the ready verb on this pad to set up your character!</B>"
		return

	world.log_game("[usr.key] entered as [usr.rname]")

	if (ticker)
		world << "\blue [usr.rname] has arrived on the station!"
		usr << "<B>Game mode is [master_mode].</B>"

/*	var/mob/human/M = usr
	var/area/A = locate(/area/arrival/start)
	var/list/L = list()
	for(var/turf/T in A)
		if(T.isempty())
			L += T

	while(!L.len)
		usr << "\blue <B>You were unable to enter because the arrival shuttle has been destroyed! The game will reattempt to spawn you in 30 seconds!</B>"
		sleep(300)
		for(var/turf/T in A)
			if(T.isempty())
				L += T
*/
	var/mob/human/M = usr //Update the person-placement blocks with these two
	var/area/A = locate(/area/arrival/start)
	var/list/L = list()
	for (var/area/B in A.superarea.areas)
		for(var/turf/T in B)
			if(T.isempty())
				L += T

	while(!L.len)
		usr << "\blue <B>You were unable to enter because the arrival shuttle has been destroyed! The game will reattempt to spawn you in 30 seconds!</B>"
		sleep(300)
		for (var/area/B in A.superarea.areas)
			for(var/turf/T in B)
				if(T.isempty())
					L += T


	if(ticker)
		reg_dna[M.primary.uni_identity] = M.rname
		if(ticker.mode.name == "sandbox")
			M.CanBuild()


	M << "\blue Now teleporting."
	M.loc = pick(L)

/obj/begin/proc/get_dna_ready(var/mob/user as mob)
	var/mob/human/M = user //dnamarker2

	////////////// stuff for new DNA here
	var/temp
	var/hair
	var/beard

	if(M.h_style_r == "bald") hair = rand(1,750)
	if(M.h_style_r == "hair_c") hair = rand(751,1250)
	if(M.h_style_r == "hair_b") hair = rand(1251,2000)
	if(M.h_style_r == "hair_a") hair = rand(2001,2750)
	if(M.h_style_r == "hair_d") hair = rand(2751,3250)
	if(M.h_style_r == "hair_e") hair = rand(3251,4000)
	if(M.h_style_r == "hair_f") hair = rand(4001,4095)

	if(M.f_style_r == "bald") beard = rand(1,350)
	if(M.f_style_r == "facial_elvis") beard = rand(351,700)
	if(M.f_style_r == "facial_vandyke") beard = rand(701,1050)
	if(M.f_style_r == "facial_neckbeard") beard = rand(1051,1400)
	if(M.f_style_r == "facial_chaplin") beard = rand(1401,1750)
	if(M.f_style_r == "facial_watson") beard = rand(1751,2100)
	if(M.f_style_r == "facial_abe") beard = rand(2101,2450)
	if(M.f_style_r == "facial_chin") beard = rand(2451,2800)
	if(M.f_style_r == "facial_hip") beard = rand(2801,3150)
	if(M.f_style_r == "facial_gt") beard = rand(3151,3500)
	if(M.f_style_r == "facial_hogan") beard = rand(3501,4095)

	if(!M.nr_hair)
		M.nr_hair += rand(0,25)
	if(!M.ng_hair)
		M.ng_hair += rand(0,25)
	if(!M.nb_hair)
		M.nb_hair += rand(0,25)

	if(!M.nr_facial)
		M.nr_facial += rand(0,25)
	if(!M.ng_facial)
		M.ng_facial += rand(0,25)
	if(!M.nb_facial)
		M.nb_facial += rand(0,25)

	if(!M.r_eyes)
		M.r_eyes += rand(0,25)
	if(!M.g_eyes)
		M.g_eyes += rand(0,25)
	if(!M.b_eyes)
		M.b_eyes += rand(0,25)

	M.primarynew = new /obj/dna(null)

	temp = add_zero2(num2hex((M.nr_hair),1), 3)
	temp += add_zero2(num2hex((M.nb_hair),1), 3)
	temp += add_zero2(num2hex((M.ng_hair),1), 3)
	temp += add_zero2(num2hex((M.nr_facial),1), 3)
	temp += add_zero2(num2hex((M.nb_facial),1), 3)
	temp += add_zero2(num2hex((M.ng_facial),1), 3)
	temp += add_zero2(num2hex(((M.ns_tone * 25)+125),1), 3)
	temp += add_zero2(num2hex((M.r_eyes),1), 3)
	temp += add_zero2(num2hex((M.g_eyes),1), 3)
	temp += add_zero2(num2hex((M.b_eyes),1), 3)

	var/genderrand
	var/genderrand2
	if (M.gender == "male")
		genderrand = rand(1,2050)
		genderrand2 = add_zero2(num2hex((genderrand),1), 3)
	else
		genderrand = rand(2051,4094)
		genderrand2 = add_zero2(num2hex((genderrand),1), 3)

	temp += genderrand2
	temp += add_zero2(num2hex((beard),1), 3)
	temp += add_zero2(num2hex((hair),1), 3)




	M.primarynew.uni_identity = temp
	//world << temp

	if(prob(5) && random_illnesses)
		var/dis = pick(list(1,2,3))
		if(dis == 1)
			M.be_cough = 1
		else if(dis == 2)
			M.be_tur = 1
		else if(dis == 3)
			M.be_stut = 1

// HAI PERSH!
	var/mutvis
	if (M.need_gl) //on
		mutvis = add_zero2(num2hex(rand(2050,4095)),3)
		M.disabilities = M.disabilities | 1
		M << "\blue You need glasses!"
	else  //off
		mutvis = add_zero2(num2hex(rand(1,2049)),3)

	var/mutepil
	if (M.be_epil) //on
		mutepil = add_zero2(num2hex(rand(2050,4095)),3)
		M.disabilities = M.disabilities | 2
		M << "\blue You are epileptic!"
	else  //off
		mutepil = add_zero2(num2hex(rand(1,2049)),3)

	var/mutcough
	if (M.be_cough) //on
		mutcough = add_zero2(num2hex(rand(2050,4095)),3)
		M.disabilities = M.disabilities | 4
		M << "\blue You have a chronic coughing syndrome!"
	else  //off
		mutcough = add_zero2(num2hex(rand(1,2049)),3)

	var/muttur
	if (M.be_tur) //on
		muttur = add_zero2(num2hex(rand(2050,4095)),3)
		M.disabilities = M.disabilities | 8
		M << "\blue You have Tourette syndrome!"
	else  //off
		muttur = add_zero2(num2hex(rand(1,2049)),3)

	var/mutstut
	if (M.be_stut) //on
		mutstut = add_zero2(num2hex(rand(2050,4095)),3)
		M.disabilities = M.disabilities | 16
		M << "\blue You have a stuttering problem!"
	else  //off
		mutstut = add_zero2(num2hex(rand(1,2049)),3)



	var/mutstring
	mutstring = "[mutvis]3E8[mutepil]44C[mutcough]4B0[muttur]514[mutstut]5785DC6406A4708"
	M.primarynew.struc_enzyme = mutstring
	//world << mutstring

	M.primarynew.use_enzyme = md5(M.rname)

	////////////// New stuff ends here

	if (!M.primary)
		var/t2

		M.r_hair = M.nr_hair
		M.b_hair = M.nb_hair
		M.g_hair = M.ng_hair
		M.r_facial = M.nr_facial
		M.b_facial = M.nb_facial
		M.g_facial = M.ng_facial
		M.s_tone = M.ns_tone
		var/t1 = rand(1000, 1500)
		dna_ident += t1
		if (dna_ident > 65536)
			dna_ident = rand(1, 1500)
		M.primary = new /obj/dna(null)
		M.primary.uni_identity  = add_zero(num2hex(dna_ident), 4)
		M.primary.uni_identity += add_zero(num2hex(M.nr_hair), 2)
		M.primary.uni_identity += add_zero(num2hex(M.ng_hair), 2)
		M.primary.uni_identity += add_zero(num2hex(M.nb_hair), 2)
		M.primary.uni_identity += add_zero(num2hex(M.r_eyes), 2)
		M.primary.uni_identity += add_zero(num2hex(M.g_eyes), 2)
		M.primary.uni_identity += add_zero(num2hex(M.b_eyes), 2)
		M.primary.uni_identity += add_zero(num2hex(-M.ns_tone + 35), 2)

		if (M.gender == "male")
			t2 = "[num2hex(rand(  1, 124))]"
		else
			t2 = "[num2hex(rand(127, 250))]"

		if (length(t2) < 2)
			M.primary.uni_identity = text("[]0[]", M.primary.uni_identity, t2)
		else
			M.primary.uni_identity = text("[][]", M.primary.uni_identity, t2)

		M.primary.spec_identity = "5BDFE293BA5500F9FFFD500AAFFE"
		M.primary.struc_enzyme = "CDE375C9A6C25A7DBDA50EC05AC6CEB63"

		//if (rand(1, 3125) == 13)
		//	M.need_gl = 1
		//	M.be_epil = 1
		//	M.be_cough = 1
		//	M.be_tur = 1
		//	M.be_stut = 1

		var/b_vis
		if (M.need_gl)
			b_vis = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			//M.disabilities = M.disabilities | 1
			//M << "\blue You need glasses!"
		else
			b_vis = "5A7"

		var/epil
		if (M.be_epil)
			epil = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			//M.disabilities = M.disabilities | 2
			//M << "\blue You are epileptic!"
		else
			epil = "6CE"

		var/cough
		if (M.be_cough)
			cough = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			//M.disabilities = M.disabilities | 4
			//M << "\blue You have a chronic coughing syndrome!"
		else
			cough = "EC0"

		var/Tourette
		if (M.be_tur)
			epil = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			//M.disabilities = M.disabilities | 8
			//M << "\blue You have Tourette syndrome!"
		else
			Tourette = "5AC"

		var/stutter
		if (M.be_stut)
			stutter = add_zero(text("[]", num2hex(rand(10, 1400))), 3)
			//M.disabilities = M.disabilities | 16
			//M << "\blue You have a stuttering problem!"
		else
			stutter = "A50"

		M.primary.struc_enzyme = "CDE375C9A6C2[b_vis]DBD[stutter][cough][Tourette][epil]B63"
		M.primary.use_enzyme = "493DB249EB6D13236100A37000800AB71"
		M.primary.n_chromo = 28