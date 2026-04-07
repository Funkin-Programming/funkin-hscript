#pragma once

#ifdef __cplusplus
extern "C" {
#endif

void discord_init();
void discord_shutdown();

void discord_update_presence(
	const char* details,
	const char* state,
	const char* largeImage,
	const char* smallImage,
	double startTimestamp
);

#ifdef __cplusplus
}
#endif
