
var/list/tempbans = new

/obj/tempban
	var/time = 0
	var/key = 0
	var/ip = 0

/proc/tempban_init()
	var/savefile/S=new("data/timed_unban.ban")
	var/entries = 0
	var/i
	var/time
	tempbans = list()
	S["entries"] >> entries
	for(i=0, i<entries, i++)
		S["entry-[i]/time"] >> time
		S["entry-[i]/key"] >> key
		S["entry-[i]/ip"] >> ip
		if(time < world.realtime)
			//unban them...

			//~~~~~~~~~~~~~~~~~~~~~~~
			//~TODO: FINISH THIS BIT~
			//~~~~~~~~~~~~~~~~~~~~~~~

		else
			//else keep them on the list
			var/obj/tempban/t = new
			t.time = time
			t.key = key
			t.ip = ip
			tempbans += t
	tempban_save()

/proc/tempban_save()
	var/savefile/S=new("data/timed_unban.ban")
	S["entries"] << tempbans.len
	var/i = 0
	for(var/obj/tempban/t in tempbans)
		S["entry-[i]/time"] << t.time
		S["entry-[i]/key"] << t.key
		S["entry-[i]/ip"] << t.ip
		i++
