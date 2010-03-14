/datum/chemical
	//var/name = "chemical"
	var/moles = 0.0
	var/molarmass = 18.0
	var/density = 1.0
	var/chem_formula = "H2O"
	var/name = "water"

/datum/chemical/ch_cou
	molarmass = 270.0
	name = "CCS remedy"

/datum/chemical/epil
	molarmass = 230.0
	name = "Epilepsy remedy"

/datum/chemical/fever
	molarmass = 230.0
	name = "Fever remedy"

/datum/chemical/mixing
	molarmass = 1.0
	name = "mixing fluid"

/datum/chemical/potassium
	molarmass = 39.10
	name = "potassium"

/datum/chemical/nitrogen
	molarmass = 14.0
	name = "nitrogen"

/datum/chemical/mercury
	molarmass = 24.0
	name = "mercury"

/datum/chemical/acid
	molarmass = 1
	name = "acid"
	chem_formula = "H2SO4"

/datum/chemical/liion
	molarmass = 1.0
	name = "li-ion"
	chem_formula = "LiFePO4"

/datum/chemical/chloroform
	molarmass = 1.0
	name = "chloroform"
	chem_formula = "CHCl3"

/datum/chemical/lithium
	molarmass = 24.96
	name = "lithium"

/datum/chemical/hydrogen
	molarmass = 1.00
	name = "hydrogen"

/datum/chemical/sulfur
	molarmass = 32.06
	name = "sulfur"

/datum/chemical/jekyll
	molarmass = 1
	name = "jekyll"

/datum/chemical/carbon
	molarmass = 32.06
	name = "carbon"

/datum/chemical/chlorine
	molarmass = 14
	name = "chlorine"

/datum/chemical/phosphorus
	molarmass = 24
	name = "phosphorus"

/datum/chemical/aluminium
	molarmass = 24
	name = "aluminium"

/datum/chemical/iron
	molarmass = 24
	name = "iron"

/datum/chemical/radium
	molarmass = 24
	name = "radium"

/datum/chemical/silicon
	molarmass = 24
	name = "silicon"

/datum/chemical/oxygen
	molarmass = 16.00
	name = "oxygen"

/datum/chemical/blood
	molarmass = 1.00
	name = "blood"

/datum/chemical/sugar
	molarmass = 342.3
	name = "sugar"
	chem_formula = "C6H12O6"

/datum/chemical/l_plas
	name = "toxins"
	molarmass = 154.0

/datum/chemical/pathogen
	name = "pathogen"
	var/amount = 0.0
	var/structure_id = null

/datum/chemical/pathogen/antibody
	name = "antibody"
	var/tar_struct = null
	var/a_style = null

/datum/chemical/pathogen/blood
	name = "blood"
	var/antibodies = null
	var/antigens = null
	var/has_oxygen = null
	var/has_co = null


/datum/chemical/pathogen/virus
	name = "virus"

/datum/chemical/pl_coag
//	name = "pl coag"
	name = "antitoxins"
	molarmass = 176.0

/datum/chemical/rejuv
//	name = "rejuv"
	molarmass = 97.0
	name = "rejuvinators"

/datum/chemical/rejuvplus
//	name = "rejuv"
	molarmass = 1.0
	name = "rejuvinators+"

/datum/chemical/atoxplus
//	name = "s tox"
	name = "antitoxins+"
	molarmass = 1.0

/datum/chemical/s_tox
//	name = "s tox"
	name = "sleep toxins"
	molarmass = 45.0

/datum/chemical/waste
	name = "waste"
	name = "waste-l"
	molarmass = 200.0

/datum/chemical/water
	name = "water"
	molarmass = 1

/datum/chemical/silicate
	name = "silicate"
	molarmass = 1

/datum/chemical/thermite
	name = "thermite"
	molarmass = 1

/datum/chemical/spacedrug
	molarmass = 1
	name = "space drugs"
