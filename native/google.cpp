#include <hxcpp.h>
#include <stdio.h>

#ifdef ANDROID
#include <jni.h>
#include <android/log.h>
#endif

#define LOG_TAG "GoogleNative"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)

static bool initialized = false;
static bool loggedIn = false;

// ==============================
// 🚀 INIT
// ==============================
extern "C" void google_init()
{
	if (initialized) return;

#ifdef ANDROID
	LOGI("Google Init");
#endif

	initialized = true;
}

// ==============================
// 🔐 LOGIN
// ==============================
extern "C" void google_login()
{
	if (!initialized) return;

#ifdef ANDROID
	LOGI("Google Login Requested");
#endif

	// 🔥 FUTURO:
	// Aqui você conecta com Google Play Games / Firebase Auth via JNI

	loggedIn = true;
}

// ==============================
// 🔓 LOGOUT
// ==============================
extern "C" void google_logout()
{
	if (!initialized) return;

#ifdef ANDROID
	LOGI("Google Logout");
#endif

	loggedIn = false;
}

// ==============================
// ✅ CHECK LOGIN
// ==============================
extern "C" bool google_is_logged()
{
	return loggedIn;
}

// ==============================
// ☁️ SAVE CLOUD
// ==============================
extern "C" void google_save(const char* data)
{
	if (!initialized || !loggedIn) return;

#ifdef ANDROID
	LOGI("Saving to cloud: %s", data);
#endif

	// 🔥 FUTURO:
	// Enviar JSON para Firebase / Google Drive
}

// ==============================
// 📥 LOAD CLOUD
// ==============================
extern "C" const char* google_load()
{
	if (!initialized || !loggedIn)
		return "";

#ifdef ANDROID
	LOGI("Loading from cloud");
#endif

	// 🔥 FUTURO:
	// Retornar JSON real do servidor

	return "{}";
}

// ==============================
// 🔥 DEBUG
// ==============================
extern "C" void google_log(const char* msg)
{
#ifdef ANDROID
	LOGI("%s", msg);
#else
	printf("[GoogleNative] %s\n", msg);
#endif
}
