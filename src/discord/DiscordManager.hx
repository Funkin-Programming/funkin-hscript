package discord;

import haxe.Timer;
import discord.DiscordClient;

class DiscordManager
{
	public static var initialized:Bool = false;

	// Estado atual
	public static var details:String = "";
	public static var state:String = "";
	public static var largeImage:String = "icon";
	public static var smallImage:String = "";
	public static var startTimestamp:Float = 0;

	// Cache anti-spam
	static var lastDetails:String = "";
	static var lastState:String = "";
	static var lastLarge:String = "";
	static var lastSmall:String = "";
	static var lastTime:Float = -1;

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init()
	{
		if(initialized) return;

		DiscordClient.initialize();
		initialized = true;

		trace("[DiscordManager] Initialized");
	}

	// ==============================
	// ❌ SHUTDOWN
	// ==============================
	public static function shutdown()
	{
		if(!initialized) return;

		DiscordClient.shutdown();
		initialized = false;

		trace("[DiscordManager] Shutdown");
	}

	// ==============================
	// 🧠 SET PRESENCE
	// ==============================
	public static function setPresence(
		d:String,
		s:String,
		large:String = "icon",
		small:String = "",
		time:Float = 0
	)
	{
		details = d;
		state = s;
		largeImage = large;
		smallImage = small;
		startTimestamp = time;

		updatePresence();
	}

	// ==============================
	// 🔄 UPDATE LOOP
	// ==============================
	public static function update()
	{
		if(!initialized) return;

		updatePresence();
	}

	// ==============================
	// ⚡ UPDATE REAL
	// ==============================
	static function updatePresence()
	{
		if(!initialized) return;

		// Evita spam
		if(
			details == lastDetails &&
			state == lastState &&
			largeImage == lastLarge &&
			smallImage == lastSmall &&
			startTimestamp == lastTime
		)
		{
			return;
		}

		lastDetails = details;
		lastState = state;
		lastLarge = largeImage;
		lastSmall = smallImage;
		lastTime = startTimestamp;

		try
		{
			DiscordClient.changePresence(
				details,
				state,
				largeImage,
				smallImage,
				startTimestamp
			);
		}
		catch(e)
		{
			trace("[DiscordManager ERROR]: " + e);
		}
	}

	// ==============================
	// ⏱️ HELPERS
	// ==============================
	public static function setElapsedTime()
	{
		startTimestamp = Timer.stamp();
		updatePresence();
	}

	public static function reset()
	{
		setPresence(
			"Friday Night Funkin'",
			"In the Menus",
			"icon",
			"",
			0
		);
	}
}