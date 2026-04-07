package google;

import funkin.hscript.HScripter;

class Google
{
	public static var initialized:Bool = false;
	public static var isAndroid:Bool = false;

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init()
	{
		if(initialized) return;

		#if android
		isAndroid = true;
		#else
		isAndroid = false;
		#end

		if(!isAndroid)
		{
			trace("[Google] Not running on Android");
		}

		initialized = true;

		setupAPI();

		trace("[Google] Initialized");
	}

	// ==============================
	// 🔗 INJECT API (HScript)
	// ==============================
	static function setupAPI()
	{
		HScripter.setGlobal("googleLogin", login);
		HScripter.setGlobal("googleLogout", logout);
		HScripter.setGlobal("googleOpenURL", openURL);
		HScripter.setGlobal("googleIsLogged", isLoggedIn);
	}

	// ==============================
	// 🔐 LOGIN (PLACEHOLDER)
	// ==============================
	public static function login()
	{
		if(!isAndroid)
		{
			trace("[Google] Login not supported on this platform");
			return;
		}

		trace("[Google] Login requested");

		// 🔥 Aqui entra integração real com Google Play Games (hxcpp no futuro)
	}

	// ==============================
	// 🔓 LOGOUT
	// ==============================
	public static function logout()
	{
		if(!isAndroid) return;

		trace("[Google] Logout requested");

		// futura implementação
	}

	// ==============================
	// ✅ CHECK LOGIN
	// ==============================
	public static function isLoggedIn():Bool
	{
		// placeholder
		return false;
	}

	// ==============================
	// 🌐 OPEN URL
	// ==============================
	public static function openURL(url:String)
	{
		try
		{
			lime.system.System.openURL(url);
		}
		catch(e)
		{
			trace("[Google] URL error: " + e);
		}
	}

	// ==============================
	// 🏆 ACHIEVEMENTS (BASE)
	// ==============================
	public static function unlockAchievement(id:String)
	{
		if(!isAndroid) return;

		trace("[Google] Unlock achievement: " + id);

		// futura implementação real
	}

	// ==============================
	// 📊 LEADERBOARD (BASE)
	// ==============================
	public static function submitScore(id:String, score:Int)
	{
		if(!isAndroid) return;

		trace("[Google] Submit score: " + id + " = " + score);

		// futura implementação real
	}

	// ==============================
	// 🔥 DEBUG
	// ==============================
	public static function log(msg:String)
	{
		trace("[Google] " + msg);
	}
}
