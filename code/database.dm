world/proc/getdb()
	dbcon.Connect("dbi:mysql:[database]:[DB_SERVER]:3306","head","123456")
	if(!dbcon.IsConnected())
		world.log << "[dbcon.ErrorMsg()]"
		world.log << "Database Connection failed"
	else
		world.log << "Database Connection is okay!"
		keepalive()

world/proc/keepalive()
	spawn(0)
		while(1)
			if(!dbcon)
				getdb()
				return
			else
				var/DBQuery/my_query = dbcon.NewQuery("")
				my_query.Execute()
				sleep(100)

var
	DBConnection/dbcon = new()
