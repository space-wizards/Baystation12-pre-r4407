/*
Dantom.DB
by BYOND

Release History:
v0.5 Mar 23, 2008
v0.4 Mar 19, 2008 (Nadrew)
v0.3 Feb 08, 2006 (Nadrew)
v0.2 Jan 31, 2003 (Dan)
v0.1 Nov 30, 2002 (Dan)

Updates:
v0.5 - Added DBConnection.SelectDB() see db.html for details.
	   Changed all global constants to quicker #defines.
	   Added global variables DB_SERVER and DB_PORT to help SelectDB() out.
	   Moved this information and the core code into seperate files.


v0.4 - Cleaned up the code even more.
	   Rewrote the argument names for the procs to be less cryptic (you know, Dancode-y).
	   Added a few comments here and there.
	   Sped up various procs by "modernizing" some of the code inside of them.
	   Wrote some actual documentation for the library, since as of 4.13 it should get a bit more usage.

v0.3 - Fixed long-standing bug with the connection process, adding a workaround to a strange BYOND bug.
	   Updated all of the command arguments to not match local variables, as it was causing tons of issues.
	   The arguments aren't named very well, but you can tell what they do.
	   Added GetColumnData() function to the DBQuery datum, this function will allow you to obtain a list of
	   table data referenced by name and not by index number.

v0.2 - Cleaned up the code significantly.

See db.html for documentation.
See core.dm for guts.
*/
