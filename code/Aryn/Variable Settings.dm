var/global/vs_control/vsc = new()
vs_control
	var
		list/settings = list()
		list/bitflags = list("1","2","4","8","16","32","64","128","256","512","1024")
		pl_control/plc = new()
	New()
		. = ..()
		settings = vars.Copy()

		var/datum/D = new() //Ensure only unique vars are put through by making a datum and removing all common vars.
		for(var/V in D.vars)
			settings -= V

		for(var/V in settings)
			if(findtextEx(V,"_RANDOM") || findtextEx(V,"_DESC"))
				settings -= V

		settings -= "settings"
		settings -= "bitflags"
		settings -= "plc"

	proc/ChangeSettingDialog(mob/user)
		var/which = input(user,"Choose a setting:") in settings + plc.settings
		var/list/methods = list()
		var/vw
		if(which in plc.settings) vw = plc.vars[which]
		else vw = vars[which]
		if(isnum(vw))
			methods += "Numeric"
			methods += "Bit Flag"
			if(vw < 2 && vw > -1)
				methods += "Toggle"
		if(istext(vw))
			methods += "Text"
			methods += "Long Text"
		var/how = input(user,"Choose a method to change it:","Settings") in methods
		var/newvar = vw
		switch(how)
			if("Numeric")
				newvar = input(user,"Enter a number:","Settings",newvar) as num
			if("Bit Flag")
				var/flag = input(user,"Toggle which bit?","Settings") in bitflags
				flag = text2num(flag)
				if(newvar & flag)
					newvar &= ~flag
				else
					newvar |= flag
			if("Toggle")
				newvar = !newvar
			if("Text")
				newvar = input(user,"Enter a string:","Settings",newvar) as text
			if("Long Text")
				newvar = input(user,"Enter text:","Settings",newvar) as message
		vw = newvar
		if(which in plc.settings)
			plc.vars[which] = vw
		else
			vars[which] = vw
		world.log << "SETTINGS: [user] changed the setting [which] to [newvar]."
		user << "[which] has been changed to [newvar]."
		if(which == "PLASMA_COLOR")
			for(var/turf/T)
				if(T.has_plasma)
					T.overlays -= plmaster
			plmaster = image('plasma.dmi',icon_state=plc.PLASMA_COLOR,layer=MOB_LAYER+1)
			for(var/turf/T)
				if(T.has_plasma)
					T.overlays += plmaster
			user << "Plasma color updated."
	proc/RandomizeWithProbability()
		for(var/V in settings)
			var/newvalue
			if("[V]_RANDOM" in vars)
				if(isnum(vars["[V]_RANDOM"]))
					newvalue = prob(vars["[V]_RANDOM"])
				else if(istext(vars["[V]_RANDOM"]))
					newvalue = roll(vars["[V]_RANDOM"])
				else
					newvalue = vars[V]
			V = newvalue

	proc/ChangePlasma()
		for(var/V in plc.settings)
			plc.Randomize(V)
		////world << "Plasma randomized."

	proc/SetDefault(def)
		switch(def)
			if("Original")
				plc.CLOTH_CONTAMINATION = 0 //If this is on, plasma does damage by getting into cloth.

				plc.ALL_ITEM_CONTAMINATION = 0 //If this is on, any item can be contaminated, so suits and tools must be discarded or

				plc.PLASMAGUARD_ONLY = 0

				plc.CANISTER_CORROSION = 0         //If this is on, plasma must be stored in orange tanks and canisters,

				plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.

				plc.SKIN_BURNS = 0       //Plasma has an effect similar to mustard gas on the un-suited.

				plc.PLASMA_INJECTS_TOXINS = 0         //Plasma damage injects the toxins chemical to do damage over time.

				plc.EYE_BURNS = 0 //Plasma burns the eyes of anyone not wearing eye protection.

				plc.N2O_REACTION = 0 //Plasma can react with N2O, making sparks and starting a fire if levels are high.

				plc.PLASMA_COLOR = "onturf" //Plasma can change colors yaaaay!

				plc.PLASMA_DMG_OFFSET = 1
				plc.PLASMA_DMG_QUOTIENT = 10

				plc.CONTAMINATION_LOSS = 0
			if("Hazard-Low")
				plc.CLOTH_CONTAMINATION = 1 //If this is on, plasma does damage by getting into cloth.

				plc.ALL_ITEM_CONTAMINATION = 0 //If this is on, any item can be contaminated, so suits and tools must be discarded or

				plc.PLASMAGUARD_ONLY = 0

				plc.CANISTER_CORROSION = 0         //If this is on, plasma must be stored in orange tanks and canisters,

				plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.

				plc.SKIN_BURNS = 0       //Plasma has an effect similar to mustard gas on the un-suited.

				plc.PLASMA_INJECTS_TOXINS = 0         //Plasma damage injects the toxins chemical to do damage over time.

				plc.EYE_BURNS = 0 //Plasma burns the eyes of anyone not wearing eye protection.

				plc.N2O_REACTION = 0 //Plasma can react with N2O, making sparks and starting a fire if levels are high.

				plc.PLASMA_COLOR = "onturf" //RBPYB

				if(prob(20))
					plc.PLASMA_COLOR = pick("red","yellow","blue","purple")

				plc.PLASMA_DMG_OFFSET = 1.5
				plc.PLASMA_DMG_QUOTIENT = 8

				plc.CONTAMINATION_LOSS = 0.01

				var/s = pick(plc.settings)
				plc.Randomize(s)

			if("Hazard-High")
				plc.CLOTH_CONTAMINATION = 1 //If this is on, plasma does damage by getting into cloth.

				plc.ALL_ITEM_CONTAMINATION = 0 //If this is on, any item can be contaminated, so suits and tools must be discarded or

				plc.PLASMAGUARD_ONLY = 0

				plc.CANISTER_CORROSION = 1         //If this is on, plasma must be stored in orange tanks and canisters,

				plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.

				plc.SKIN_BURNS = 0       //Plasma has an effect similar to mustard gas on the un-suited.

				plc.PLASMA_INJECTS_TOXINS = 0         //Plasma damage injects the toxins chemical to do damage over time.

				plc.EYE_BURNS = 0 //Plasma burns the eyes of anyone not wearing eye protection.

				plc.N2O_REACTION = 0 //Plasma can react with N2O, making sparks and starting a fire if levels are high.

				plc.PLASMA_COLOR = pick("red","yellow","blue","purple") //RBPYB

				plc.PLASMA_DMG_OFFSET = 3
				plc.PLASMA_DMG_QUOTIENT = 5

				plc.CONTAMINATION_LOSS = 0.05

				for(var/i = rand(3,5),i>0,i--)
					var/s = pick(plc.settings)
					plc.Randomize(s)

			if("Everything")
				plc.CLOTH_CONTAMINATION = 1 //If this is on, plasma does damage by getting into cloth.

				plc.ALL_ITEM_CONTAMINATION = 1 //If this is on, any item can be contaminated, so suits and tools must be discarded or

				plc.PLASMAGUARD_ONLY = 1

				plc.CANISTER_CORROSION = 1         //If this is on, plasma must be stored in orange tanks and canisters,

				plc.GENETIC_CORRUPTION = 5 //Chance of genetic corruption as well as toxic damage, X in 1000.

				plc.SKIN_BURNS = 1       //Plasma has an effect similar to mustard gas on the un-suited.

				plc.PLASMA_INJECTS_TOXINS = 1         //Plasma damage injects the toxins chemical to do damage over time.

				plc.EYE_BURNS = 1 //Plasma burns the eyes of anyone not wearing eye protection.

				plc.N2O_REACTION = 1 //Plasma can react with N2O, making sparks and starting a fire if levels are high.

				plc.PLASMA_COLOR = "black" //RBPYB

				plc.PLASMA_DMG_OFFSET = 3
				plc.PLASMA_DMG_QUOTIENT = 5

				plc.CONTAMINATION_LOSS = 0.02
		for(var/turf/T)
			if(T.has_plasma)
				T.overlays -= plmaster
		plmaster = image('plasma.dmi',icon_state=plc.PLASMA_COLOR,layer=MOB_LAYER+1)
		for(var/turf/T)
			if(T.has_plasma)
				T.overlays += plmaster
		/////world << "Plasma color updated."

pl_control
	var/list/settings = list()
	New()
		. = ..()
		settings = vars.Copy()

		var/datum/D = new() //Ensure only unique vars are put through by making a datum and removing all common vars.
		for(var/V in D.vars)
			settings -= V

		for(var/V in settings)
			if(findtextEx(V,"_RANDOM") || findtextEx(V,"_DESC"))
				settings -= V

		settings -= "settings"
	proc/Randomize(V)
		//world << "Randomizing [V]"
		var/newvalue
		if("[V]_RANDOM" in vars)
			if(isnum(vars["[V]_RANDOM"]))
				newvalue = prob(vars["[V]_RANDOM"])
				if(newvalue)
					//world << "Probability [vars["[V]_RANDOM"]]%: Success."
				else
					//world << "Probability [vars["[V]_RANDOM"]]%: Failure."
			else if(istext(vars["[V]_RANDOM"]))
				var/txt = vars["[V]_RANDOM"]
				if(findtextEx(txt,"PROB"))
					//world << "Probability/Roll Combo \..."
					txt = dd_text2list(txt,"/")
					txt[1] = dd_replacetext(txt[1],"PROB","")
					var/p = text2num(txt[1])
					var/r = txt[2]
					//world << "Prob:[p]% Roll:[r]"
					if(prob(p))
						newvalue = roll(r)
						//world << "Success. New value: [newvalue]"
					else
						newvalue = vars[V]
						//world << "Probability check failed."
				else if(findtextEx(txt,"PICK"))
					txt = dd_replacetext(txt,"PICK","")
					//world << "Pick: [txt]"
					txt = dd_text2list(txt,",")
					newvalue = pick(txt)
					//world << "Picked: [newvalue]"
				else
					newvalue = roll(txt)
					//world << "Roll: [txt] - [newvalue]"
			else
				newvalue = vars[V]
			vars[V] = newvalue
			if(V == "PLASMA_COLOR")
				for(var/turf/T)
					if(T.has_plasma)
						T.overlays -= plmaster
				plmaster = image('plasma.dmi',icon_state=PLASMA_COLOR,layer=MOB_LAYER+1)
				for(var/turf/T)
					if(T.has_plasma)
						T.overlays += plmaster
				////world << "Plasma color updated."