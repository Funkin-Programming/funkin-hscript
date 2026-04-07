#pragma once

#ifdef __cplusplus
extern "C" {
#endif

void google_init();
void google_login();
void google_logout();
bool google_is_logged();

void google_save(const char* data);
const char* google_load();

void google_log(const char* msg);

#ifdef __cplusplus
}
#endif
