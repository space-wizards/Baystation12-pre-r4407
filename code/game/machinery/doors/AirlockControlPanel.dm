
obj/machinery/airlock_control_panel
	icon = 'icons/ss13/door1.dmi'
	icon_state = "airlockpanel"
	var
		cycle_status = 0 //0 - no cycle, 1 - to interior, 2 - to exterior

		last_ext_pressure = 0
		last_ext_oxygen = 0
		last_ext_plasma = 0
		last_ext_co2 = 0
		last_ext_sl_gas = 0

		last_int_pressure = 1
		last_int_oxygen = 0
		last_int_plasma = 0
		last_int_co2 = 0
		last_int_sl_gas = 0

		last_ext_temperature = 2.7
		last_int_temperature = T20C

		last_airlock_pressure = 1
		last_airlock_oxygen = 0
		last_airlock_plasma = 0
		last_airlock_co2 = 0
		last_airlock_sl_gas = 0
		last_airlock_temperature = T20C

		id = ""

		obj/machinery/gas_sensor
			airlocksensor
			extsensor
			intsensor
		obj/machinery/atmoalter/siphs/airlock_reg
		obj/machinery/door
			int_airlock
			ext_airlock
	New()
		. = ..()
		sleep(5)
		for(var/obj/machinery/gas_sensor/G)
			if(G.id == id)
				airlocksensor = G
			else if(G.id == "[id]-gasext")
				extsensor = G
			else if(G.id == "[id]-gasint")
				intsensor = G
	process()
		switch(cycle_status)
			if(1)
				if(last_airlock_pressure < last_int_pressure - 0.05)
					if(airlock_reg.t_status != 4)
						createmessagetomachine(airlock_reg,"VALVE AUTO")
				else if(last_airlock_pressure > last_int_pressure + 0.05)
					if(airlock_reg.t_status != 1)
						createmessagetomachine(airlock_reg,"VALVE SIPHON")
					createmessagetomachine(airlock_reg,"VALVE RATE [1000000*abs(last_airlock_pressure - last_int_pressure)]")
				else
					if(airlock_reg.t_status != 3)
						createmessagetomachine(airlock_reg,"VALVE STOP")
			if(2)
				if(last_airlock_pressure < last_ext_pressure - 0.05)
					if(airlock_reg.t_status != 4)
						createmessagetomachine(airlock_reg,"VALVE AUTO")
				else if(last_airlock_pressure > last_ext_pressure + 0.05)
					if(airlock_reg.t_status != 1)
						createmessagetomachine(airlock_reg,"VALVE SIPHON")
					createmessagetomachine(airlock_reg,"VALVE RATE [1000000*abs(last_airlock_pressure - last_ext_pressure)]")
				else
					if(airlock_reg.t_status != 3)
						createmessagetomachine(airlock_reg,"VALVE STOP")

		createmessagetomachine(airlocksensor,"SENSE")
		createmessagetomachine(extsensor,"SENSE")
		createmessagetomachine(intsensor,"SENSE")


	receivemessage(message,var/obj/machinery/source)
		var/command = uppertext(stripnetworkmessage(message))
		var/list/listofcommand = dd_text2list(command," ",null)
		switch(listofcommand[1])
			if("REPORT") //Got our signal back! Yaaay."
				var
					pressure = text2num(listofcommand[10] / 100)
					temperature = text2num(listofcommand[11])

					oxygen = text2num(listofcommand[4])
					co2 = text2num(listofcommand[5])
					plasma = text2num(listofcommand[6])
					n2o = text2num(listofcommand[7])

				if(source == extsensor)
					last_ext_pressure = pressure
					last_ext_oxygen = oxygen
					last_ext_co2 = co2
					last_ext_plasma = plasma
					last_ext_sl_gas = n2o
					last_ext_temperature = temperature
				else if(source == intsensor)
					last_int_pressure = pressure
					last_int_oxygen = oxygen
					last_int_co2 = co2
					last_int_plasma = plasma
					last_int_sl_gas = n2o
					last_int_temperature = temperature
				else if(source == airlocksensor)
					last_airlock_pressure = pressure
					last_airlock_oxygen = oxygen
					last_airlock_co2 = co2
					last_airlock_plasma = plasma
					last_airlock_sl_gas = n2o
					last_airlock_temperature = temperature

	attack_hand(mob/user)
		var/tt = "<center><b><u>Airlock Controls</u></b></center><br><br>"
		tt += "Airlock Pressure: [round(last_airlock_pressure,0.1)] Bar"