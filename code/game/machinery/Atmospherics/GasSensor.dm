
/obj/machinery/gas_sensor/receivemessage(message, srcmachine)
	if(..())
		return
	var/list/mess = dd_text2list(stripnetworkmessage(message), " ")
	if(mess.len < 1)
		return
	if(checkcommand(mess,1,"SENSE"))
		var/turf/T = src.loc
		var/turf_total = T.tot_gas()
		var/g1 = "[round(T.oxygen()/turf_total * 100, 0.1)] [round(T.co2()/turf_total * 100, 0.1)]"
		var/g2 = "[round(T.poison()/turf_total * 100, 0.1)]  [round(T.sl_gas()/turf_total * 100, 0.1)]"
		var/g3 = "[round(T.n2()/turf_total * 100, 0.1)]  [round(turf_total / CELLSTANDARD * 100, 0.1)]"
		transmitmessage(createmessagetomachine("REPORT GAS [tag] [g1] [g2] [g3] [round(T.temp() - T0C,0.1)]", srcmachine))


/obj/machinery/gas_sensor/proc/sense_string()

	var/t = ""

	var/turf/T = src.loc

	var/turf_total = T.tot_gas()

	var/t1 = add_tspace("[round(turf_total / CELLSTANDARD * 100, 0.1)]%",6)
	t += "<PRE>Pressure: [t1] Temperature: [round(T.temp() - T0C,0.1)]&deg;C<BR>"

	if(turf_total == 0)
		t+="O2: 0 N2: 0 CO2: 0><BR>Plasma: 0 N20: 0"
	else
		t1 = add_tspace(round(T.oxygen()/turf_total * 100, 0.1),5)

		t += "O2: [t1] "

		t1 = add_tspace(round(T.n2()/turf_total * 100, 0.1),5)

		t += "N2: [t1] "

		t1 = add_tspace(round(T.co2()/turf_total * 100, 0.01),5)

		t += "CO2: [t1]<BR>"

		t1 = add_tspace(round(T.poison()/turf_total * 100, 0.001),5)

		t += "Plasma: [t1] "

		t1 = add_tspace(round(T.sl_gas()/turf_total * 100, 0.001),5)

		t += "N2O: [t1]"

	t += "</PRE>"

	return t