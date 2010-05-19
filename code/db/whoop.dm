world/New()

world

mob/verb/test()
	var/database = "bay12"
	var/dbi = "dbi:mysql:[database]:[DB_SERVER]:[DB_PORT]"
	var/username = "bay12test"// This variable contains the username data.
	var/password = "eYXjCEeJUZA4aS4D"// This variable contains the password data.
	var
		DBConnection/dbcon = new()
	var/M
	dbcon.Connect("dbi:mysql:[database]:[DB_SERVER]:3306","head","123456")
	var/list/keytest = list()
	var/list/iptest = list()
	var/list/keys = list()
	var/list/ips = list()
	var/DBQuery/key_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ckey='Joshuaxz'")
	var/DBQuery/ip_query = dbcon.NewQuery("SELECT * FROM `crban`WHERE ips='70.131.131.190'")
	var/DBQuery/my_query2 = dbcon.NewQuery("SELECT ckey FROM `crban` WHERE ckey='Joshuaxz'")
	var/DBQuery/my_query3 = dbcon.NewQuery("SELECT ips FROM `crban` WHERE ips='70.131.131.190'")
	if(my_query3.Execute())
		while(my_query3.NextRow())
			ips  = my_query3.GetRowData()
	if(my_query2.Execute())
		while(my_query2.NextRow())
			keys  = my_query2.GetRowData()
	if(!key_query.Execute())
	else
		while(key_query.NextRow())
			var/list/column_data = key_query.GetRowData()
			//var/list/keys = column_data
			for(var/p in keys)
				keytest += column_data["ckey"]
	if(!ip_query.Execute())
	else
		while(ip_query.NextRow())
			var/list/column_data = ip_query.GetRowData()
			for(var/x in ips)
				iptest += column_data["ips"]
	for(var/K in iptest)
		if(K == "70.131.131.190")
			usr << "YES!"
		else
			usr << "no"
	for(var/X in keytest)
		if(X == "joshuaxz")
			usr << "YES!"
		else
			usr << "no"