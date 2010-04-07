//Config File for the new Admin Panel.  This should make basic maintenance (e.g. adding game modes) a lot easier
//than digging through code.  Adding functionality will require you to still dig into the code, though.

client/var/list/modes = list(   ModeItem("Extended Role-Play", "extended"),
								ModeItem("Traitor", "traitor"),
								ModeItem("Section 13", "centcom"),
								ModeItem("Nuclear Emergency", "nuclear emergency"),
								ModeItem("Sandbox Mode", "sandbox"),
								ModeItem("Random (Don't Announce)", "secret"),
								ModeItem("Random (Announce)", "random")	)

client/var/list/ranks = list(	"User",
								"Moderator",
								"Administrator",
								"Primary Administrator",
								"Super Administrator",
								"Host-Level Administrator"  )

#define LEVEL_HOST 5
#define LEVL_SUPER_ADMIN 4
#define LEVEL_PRIMARY_ADMIN 3
#define LEVEL_ADMIN 2
#define LEVEL_MODERATOR 1
#define LEVEL_USER = 0