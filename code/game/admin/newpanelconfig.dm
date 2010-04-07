//DO NOT ALTER THIS.  DO NOT EVEN THINK ABOUT ALTERING THIS.  DO NOT EVEN THINK ABOUT NOT ALTERING THIS.
#define ModeItem new /datum/ModeSelectionItem


//Config File for the new Admin Panel.  This should make basic maintenance (e.g. adding game modes) a lot easier
//than digging through code.  Adding functionality will require you to still dig into the code/interface, though.

//Note that this list allows the use of HTML and \color values in the friendly name (first parameter)
//The second parameter is the internal name of the game mode

client/var/global/list/modes = list(   ModeItem("Extended Role-Play", "extended"),
								ModeItem("Traitor", "traitor"),
								ModeItem("Section 13", "centcom"),
								ModeItem("Nuclear Emergency", "nuclear emergency"),
								ModeItem("Sandbox Mode", "sandbox"),
								ModeItem("Corporate Restructuring", "restructuring"),
								ModeItem("Syndicate Revolution", "revolution"),
								ModeItem("Monkey", "monkey"),
								ModeItem("Zombie Nights", "zombie"),
								ModeItem("Meteor Shower", "meteor"),
								ModeItem("AI Malfunction", "malfunction"),
								ModeItem("\green <B>Blob</B>", "blob"),
								ModeItem("\red ARMOK HOLE", "armok"), //"OH FUCK" mode
								ModeItem("Secret", "secret"),
								ModeItem("Random", "random")	)

client/var/global/list/ranks = list(	"User",
								"Moderator",
								"Administrator",
								"Primary Administrator",
								"Super Administrator",
								"Host-Level Administrator"  )


//==============================
//Don't change this, it's reference only.
#define LEVEL_HOST 5
#define LEVEL_SUPER_ADMIN 4
#define LEVEL_PRIMARY_ADMIN 3
#define LEVEL_ADMIN 2
#define LEVEL_MODERATOR 1
#define LEVEL_USER = 0
//==============================

//Minimum access levels for sections in the admin panel
#define MINLEVEL_CONTROLVOTES LEVEL_ADMIN
#define MINLEVEL_STARTRESTART LEVEL_MODERATOR
#define MINLEVEL_REBOOTWORLD  LEVEL_SUPER_ADMIN