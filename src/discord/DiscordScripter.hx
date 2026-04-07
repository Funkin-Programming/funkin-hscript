package discord;

import funkin.hscript.FunkinHScript;

// IMPORTANTE:
// você precisa ter um Discord RPC já implementado na engine
// aqui estou assumindo que existe uma classe tipo DiscordClient

class DiscordScripter
{
	public static var script:FunkinHScript;

	// Estado atual do RPC
	public static var details:String = "Friday Night Funkin'";
	public static var state:String = "In the Menus";
	public static var smallImage:String = "";
	public static var largeImage:String = "icon";
	public static var startTimestamp:Float = 0;

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init(scriptCode:String)
	{
		script = new FunkinHScript("DiscordScript");

		// API disponível pro script
		script.set("setRPC", setRPC);
		script.set("setDetails", setDetails);
		script.set("setState", setState);
		script.set("setImage", setImage);
		script.set("resetRPC", resetRPC);
		script.set("setTime", setTime);

		script.load(scriptCode);
		script.create();
	}

	// ==============================
	// 🎮 UPDATE LOOP
	// ==============================
	public static function update(elapsed:Float)
	{
		if(script != null)
		{
			script.update(elapsed);
		}

		updateRPC();
	}

	// ==============================
	// 🧠 API DO SCRIPT
	// ==============================

	public static function setRPC(d:String, s:String)
	{
		details = d;
		state = s;
	}

	public static function setDetails(d:String)
	{
		details = d;
	}

	public static function setState(s:String)
	{
		state = s;
	}

	public static function setImage(large:String, small:String = "")
	{
		largeImage = large;
		smallImage = small;
	}

	public static function setTime(time:Float)
	{
		startTimestamp = time;
	}

	public static function resetRPC()
	{
		details = "Friday Night Funkin'";
		state = "In the Menus";
		largeImage = "icon";
		smallImage = "";
		startTimestamp = 0;
	}

	// ==============================
	// 🔄 UPDATE DISCORD
	// ==============================
	static function updateRPC()
	{
		// ⚠️ Troca isso pela tua implementação real
		DiscordClient.changePresence(
			details,
			state,
			largeImage,
			smallImage,
			startTimestamp
		);
	}
}
