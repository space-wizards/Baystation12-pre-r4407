/var/const
	access_maintenance_corridors = 1
	access_maintenance_hallway = 2
	access_disposal_units = 3
	access_custodial_closet = 4
	access_bar = 5
	access_morgue = 6
	access_chapel = 7
	access_tool_storage = 8
	access_solar_array = 9
	access_supply_shuttle = 10
	access_electrical_storage = 11
	access_atmospherics = 12
	access_engine = 13
	access_external_airlocks = 14
	access_eva = 15
	access_admin_atmos = 16
	access_apcs = 17
	access_eject_engine = 18
	access_hom = 19
	access_fire_station = 20
	access_medical_storage = 21
	access_medical_records = 22
	access_medbay = 23
	access_chemical_lab = 24
	access_genetics_lab = 25
	access_toxins_lab = 26
	access_hor = 27
	access_security_storage = 28
	access_forensics = 29
	access_brig = 30
	access_security_records = 31
	access_security = 32
	access_swat_locker = 33
	access_bridge = 34
	access_all_personal_lockers = 35
	access_hos = 36
	//access_legal_cabinet //To be created sometime after initial release - Trorbes 28/12/09
	access_judge_bench = 37
	access_change_ids = 38
	access_hop = 39
	access_teleporter = 40
	access_ai = 41
	access_captain = 42
	access_network = 43
	access_communications = 44
	access_medresearch = 45
	access_shieldsystems = 46

	password_firedoor = 100
	password_smeg = 101
	password_digitalvalve = 102
	password_router = 103
	password_heater = 104
	password_filterinlets = 105
	password_filtervents = 106


	/obj/var/list/req_access = null
/obj/var/req_access_txt = "0"
/obj/New()
	if(src.req_access_txt)
		var/req_access_str = params2list(req_access_txt)
		var/req_access_changed = 0
		for(var/x in req_access_str)
			var/n = text2num(x)
			if(n)
				if(!req_access_changed)
					req_access = list()
				req_access += n
	..()


/obj/proc/get_password()
	if(!src.req_access || !istype(src.req_access, /list) || !src.req_access.len)
		return "0"
	return accesspasswords["[req_access[1]]"]

/obj/proc/check_password(var/password)
	if(!src.req_access) //no requirements
		return 1
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	var/list/L = src.req_access
	if(!L.len) //no requirements
		return 1

	for(var/req in src.req_access)
		if(accesspasswords["[req]"] == password) //doesn't have this access
			return 1
	return 0

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1
	if(istype(M, /mob/ai))
		//AI can do whatever he wants
		return 1
	else if(istype(M, /mob/human))
		var/mob/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(src.check_access(H.equipped()) || src.check_access(H.wear_id))
			return 1
	else if(istype(M, /mob/monkey))
		var/mob/monkey/george = M
		//they can only hold things :(
		if(george.equipped() && istype(george.equipped(), /obj/item/weapon/card/id) && src.check_access(george.equipped()))
			return 1
	return 0

/obj/proc/check_access(obj/item/weapon/card/id/I)
	if(!src.req_access) //no requirements
		return 1
	if(!istype(src.req_access, /list)) //something's very wrong
		return 1

	var/list/L = src.req_access
	if(!L.len) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/weapon/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in src.req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/proc/gen_access()
	for(var/access in get_all_accesses())
		accesspasswords["[access]"] = num2hex(rand(1, 65535),4)
	for(var/access in get_all_passwords())
		accesspasswords["[access]"] = num2hex(rand(1, 65535),4)


/proc/get_access(job)
	switch(job)
		if("Captain")
			return get_all_accesses()
		if("Head of Personnel")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_disposal_units, access_custodial_closet, access_bar,
				access_morgue, access_chapel, access_tool_storage, access_solar_array, access_supply_shuttle,
				access_electrical_storage, access_atmospherics, access_engine, access_external_airlocks, access_eva,
				access_admin_atmos, access_apcs, access_fire_station, access_medical_storage, access_medical_records,
				access_medbay, access_chemical_lab, access_genetics_lab,access_toxins_lab, access_security_storage,
				access_forensics, access_brig, access_security_records, access_security, access_bridge, access_medresearch,
				access_all_personal_lockers, access_judge_bench, access_change_ids, access_hop, access_ai, access_communications,access_shieldsystems)
		if("Head of Security")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_disposal_units, access_custodial_closet, access_bar,
				access_morgue, access_chapel, access_tool_storage, access_solar_array, access_supply_shuttle,
				access_electrical_storage, access_atmospherics, access_engine, access_external_airlocks, access_eva,
				access_admin_atmos, access_fire_station, access_medical_storage, access_medbay, access_chemical_lab,
				access_genetics_lab, access_toxins_lab, access_security_storage, access_forensics, access_brig,
				access_security_records, access_security, access_swat_locker, access_bridge, access_all_personal_lockers,
				access_change_ids, access_hos, access_medresearch,access_shieldsystems)
		if("Network Technician")
			return list(access_network, access_maintenance_corridors, access_maintenance_hallway, access_tool_storage, access_communications, access_electrical_storage)
		if("Head of Research")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_tool_storage, access_medical_storage,
				access_atmospherics, access_medical_records, access_medbay, access_chemical_lab, access_genetics_lab,
				access_toxins_lab, access_hor, access_bridge, access_teleporter, access_medresearch)
		if("Head of Maintenance")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_disposal_units, access_custodial_closet, access_tool_storage,
				access_solar_array, access_electrical_storage, access_atmospherics, access_engine,
				access_external_airlocks, access_eva, access_admin_atmos, access_apcs, access_eject_engine,
				access_hom, access_bridge, access_supply_shuttle, access_network, access_communications,access_shieldsystems)
		if("Supply Officer")
			return list(access_supply_shuttle, access_disposal_units, access_maintenance_corridors, access_communications)
		if("Security Officer")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_disposal_units, access_security_storage, access_security_records,
				access_forensics, access_brig, access_security)
		if("Forensic Technician")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_disposal_units, access_security_storage, access_security_records,
				access_forensics, access_brig, access_security)
		if("Plasma Researcher")
			return list(access_medical_storage, access_medbay, access_toxins_lab)
		if("Geneticist")
			return list(access_medical_storage, access_medbay, access_genetics_lab, access_medresearch)
		if("Chemist")
			return list(access_medical_storage, access_medbay, access_chemical_lab, access_medresearch)
		if("Medical Doctor")
			return list(access_medical_storage, access_medical_records, access_medbay)
		if("Fire Fighter")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_engine, access_fire_station)
		if("Station Engineer")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_tool_storage, access_solar_array,
				access_electrical_storage, access_engine, access_external_airlocks, access_apcs, access_communications, access_shieldsystems)
		if("Atmospheric Technician")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_tool_storage,
				access_electrical_storage, access_atmospherics, access_admin_atmos)
		if("Chaplain")
			return list(access_morgue, access_chapel)
		if("Bartender")
			return list(access_bar)
		if("Janitor")
			return list(access_maintenance_hallway, access_disposal_units, access_custodial_closet)
		if("Lawyer")
			return list(/*access_legal_cabinet*/)
		if("Assistant")
			return list(access_maintenance_corridors, access_maintenance_hallway, access_tool_storage)
		else
			return list()

/proc/get_all_accesses()
	return list(access_maintenance_corridors, access_maintenance_hallway, access_disposal_units, access_custodial_closet, access_bar,
	access_morgue, access_chapel, access_tool_storage, access_solar_array, access_supply_shuttle,
	access_electrical_storage, access_atmospherics, access_engine, access_external_airlocks, access_eva,
	access_admin_atmos, access_apcs, access_eject_engine, access_hom, access_fire_station,
	access_medical_storage, access_medical_records, access_medbay, access_chemical_lab, access_genetics_lab,
	access_toxins_lab, access_hor, access_security_storage, access_forensics, access_brig,
	access_security_records, access_security, access_swat_locker, access_bridge, access_all_personal_lockers,
	access_hos, /*access_legal_cabinet,*/ access_judge_bench, access_change_ids, access_hop, access_teleporter,
	access_ai, access_captain, access_network, access_communications, access_medresearch, access_shieldsystems)

/proc/get_all_passwords()
	return list(password_smeg,password_firedoor,password_digitalvalve,password_router,password_heater,password_filterinlets,password_filtervents)

/proc/get_access_desc(A)
	switch(A)
		if(access_maintenance_corridors)
			return "access maintenance corridors"
		if(access_maintenance_hallway)
			return "access maintenance hallway"
		if(access_disposal_units)
			return "access disposal units"
		if(access_custodial_closet)
			return "the custodial closet"
		if(access_bar)
			return "access bar"
		if(access_morgue)
			return "access morgue"
		if(access_chapel)
			return "access chapel"
		if(access_tool_storage)
			return "access tool storage"
		if(access_solar_array)
			return "access solar arrays"
		if(access_supply_shuttle)
			return "access supply shuttle"
		if(access_electrical_storage)
			return "access electrical storage"
		if(access_atmospherics)
			return "access atmospherics"
		if(access_engine)
			return "access engine"
		if(access_external_airlocks)
			return "open external airlocks"
		if(access_eva)
			return "access EVA"
		if(access_admin_atmos)
			return "access administrative atmospheric controls"
		if(access_apcs)
			return "access APCs"
		if(access_eject_engine)
			return "eject the engine"
		if(access_hom)
			return "access the head of maintenance's quarters"
		if(access_fire_station)
			return "access fire station"
		if(access_medical_storage)
			return "access medical storage"
		if(access_medical_records)
			return "access medical records"
		if(access_medbay)
			return "access medical bay"
		if(access_chemical_lab)
			return "access chemical lab"
		if(access_genetics_lab)
			return "access genetics lab"
		if(access_toxins_lab)
			return "access plasma lab"
		if(access_hor)
			return "access the head of research's quarters"
		if(access_security_storage)
			return "access security storage"
		if(access_forensics)
			return "access forensics"
		if(access_brig)
			return "access the brig"
		if(access_security_records)
			return "access security records"
		if(access_security)
			return "access security stations"
		if(access_swat_locker)
			return "access SWAT locker"
		if(access_bridge)
			return "access bridge"
		if(access_all_personal_lockers)
			return "open all personal lockers"
		if(access_hos)
			return "access the head of security's quarters"
		if(access_judge_bench)
			return "access the judge's bench"
		/*if(access_legal_cabinet)
			return "access the lawyer's legal cabinet"*/
		if(access_change_ids)
			return "change IDs"
		if(access_hop)
			return "access head of personnel's quarters"
		if(access_teleporter)
			return "access teleporter"
		if(access_ai)
			return "access AI upload"
		if(access_captain)
			return "access the captain's quarters"
		if(access_network)
			return "access networking equipment and the network office"
		if(access_communications)
			return "access communications equipment"
		if(access_medresearch)
			return "access medical research"
		if(access_shieldsystems)
			return "access shielding systems"
/proc/get_all_jobs()
	return list("Captain", "Head of Personnel", "Head of Security", "Head of Research", "Head of Maintenance", "Security Officer", "Forensic Technician", "Plasma Researcher", "Geneticist", "Chemist", "Medical Doctor", "Fire Fighter", "Station Engineer", "Atmospheric Technician", "Network Technician", "Supply Officer", "Chaplain", "Bartender", "Janitor", "Lawyer", "Assistant")

