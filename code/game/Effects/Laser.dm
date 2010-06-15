/obj/laser/Bump()
	src.range--
	return

/obj/laser/Move()
	src.range--
	return

/atom/proc/laserhit(L as obj)
	return 1