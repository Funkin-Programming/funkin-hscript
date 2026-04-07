#include "discord_rpc.h"
#include <discord_rpc.h>
#include <cstring>

static bool initialized = false;

void discord_init()
{
	if (initialized) return;

	DiscordEventHandlers handlers;
	memset(&handlers, 0, sizeof(handlers));

	Discord_Initialize("YOUR_APP_ID", &handlers, 1, NULL);

	initialized = true;
}

void discord_shutdown()
{
	if (!initialized) return;

	Discord_Shutdown();
	initialized = false;
}

void discord_update_presence(
	const char* details,
	const char* state,
	const char* largeImage,
	const char* smallImage,
	double startTimestamp
)
{
	if (!initialized) return;

	DiscordRichPresence presence;
	memset(&presence, 0, sizeof(presence));

	presence.details = details;
	presence.state = state;
	presence.largeImageKey = largeImage;
	presence.smallImageKey = smallImage;

	if (startTimestamp > 0)
	{
		presence.startTimestamp = (int64_t)startTimestamp;
	}

	Discord_UpdatePresence(&presence);
}
