package mobile.backend;

import funkin.hscript.HScripter;

class Vibration
{
	public static var supported:Bool = false;

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init()
	{
		#if android
		supported = true;
		#elseif ios
		supported = true;
		#else
		supported = false;
		#end

		trace('[Vibration] Supported: ' + supported);

		// integração com scripts
		HScripter.setGlobal("vibrate", vibrate);
		HScripter.setGlobal("vibratePattern", vibratePattern);
	}

	// ==============================
	// 📳 VIBRATE (SIMPLES)
	// ==============================
	public static function vibrate(time:Int = 100)
	{
		if(!supported) return;

		#if android
		try
		{
			lime.system.System.vibrate(time);
		}
		catch(e)
		{
			trace('[Vibration] Android error: ' + e);
		}
		#elseif ios
		try
		{
			// iOS não suporta duração custom via OpenFL
			lime.system.System.vibrate(0);
		}
		catch(e)
		{
			trace('[Vibration] iOS error: ' + e);
		}
		#end
	}

	// ==============================
	// 🔁 VIBRATE PATTERN
	// ==============================
	public static function vibratePattern(pattern:Array<Int>)
	{
		if(!supported || pattern == null) return;

		#if android
		runPattern(pattern);
		#elseif ios
		// fallback simples: vibra várias vezes
		for(i in 0...pattern.length)
		{
			if(i % 2 == 0)
			{
				vibrate();
			}
		}
		#end
	}

	// ==============================
	// ⚙️ PATTERN ANDROID
	// ==============================
	static function runPattern(pattern:Array<Int>)
	{
		if(pattern.length == 0) return;

		var index:Int = 0;

		function nextStep()
		{
			if(index >= pattern.length) return;

			var duration = pattern[index];

			if(index % 2 == 0)
			{
				// pausa
			}
			else
			{
				vibrate(duration);
			}

			index++;

			haxe.Timer.delay(nextStep, duration);
		}

		nextStep();
	}

	// ==============================
	// 🧠 CHECK SUPPORT
	// ==============================
	public static function isSupported():Bool
	{
		return supported;
	}
}
