package google;

import haxe.Timer;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

import funkin.hscript.HScripter;

class GoogleCloud
{
	public static var initialized:Bool = false;
	public static var loggedIn:Bool = false;

	public static var autoSave:Bool = true;
	public static var saveInterval:Float = 10; // segundos

	public static var savePath:String = "save/cloud_save.json";

	public static var data:Dynamic = {};

	static var timer:Timer;

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init()
	{
		if(initialized) return;

		initialized = true;

		setupAPI();
		autoLogin();
		loadLocal();

		if(autoSave)
			startAutoSave();

		trace("[GoogleCloud] Initialized");
	}

	// ==============================
	// 🔗 API (HScript)
	// ==============================
	static function setupAPI()
	{
		HScripter.setGlobal("cloudSet", set);
		HScripter.setGlobal("cloudGet", get);
		HScripter.setGlobal("cloudSave", save);
		HScripter.setGlobal("cloudLoad", load);
	}

	// ==============================
	// 🔐 AUTO LOGIN
	// ==============================
	static function autoLogin()
	{
		// 🔥 placeholder (futuro: Google Play / Firebase)
		loggedIn = true;

		trace("[GoogleCloud] Auto login success");
	}

	// ==============================
	// 📦 SET / GET
	// ==============================
	public static function set(key:String, value:Dynamic)
	{
		data[key] = value;
	}

	public static function get(key:String):Dynamic
	{
		return data.exists(key) ? data[key] : null;
	}

	// ==============================
	// 💾 SAVE LOCAL
	// ==============================
	static function saveLocal()
	{
		try
		{
			var json = Json.stringify(data);

			if(!FileSystem.exists("save"))
				FileSystem.createDirectory("save");

			File.saveContent(savePath, json);

			trace("[GoogleCloud] Local save complete");
		}
		catch(e)
		{
			trace("[GoogleCloud] Save error: " + e);
		}
	}

	// ==============================
	// 📥 LOAD LOCAL
	// ==============================
	static function loadLocal()
	{
		try
		{
			if(!FileSystem.exists(savePath)) return;

			var content = File.getContent(savePath);
			data = Json.parse(content);

			trace("[GoogleCloud] Local load complete");
		}
		catch(e)
		{
			trace("[GoogleCloud] Load error: " + e);
		}
	}

	// ==============================
	// ☁️ SAVE CLOUD (SIMULADO)
	// ==============================
	static function saveCloud()
	{
		if(!loggedIn) return;

		trace("[GoogleCloud] Syncing to cloud...");

		// 🔥 futura integração real (Firebase / Google API)
	}

	// ==============================
	// ☁️ LOAD CLOUD (SIMULADO)
	// ==============================
	static function loadCloud()
	{
		if(!loggedIn) return;

		trace("[GoogleCloud] Syncing from cloud...");

		// 🔥 futura integração real
	}

	// ==============================
	// 🔄 SAVE (TOTAL)
	// ==============================
	public static function save()
	{
		saveLocal();
		saveCloud();
	}

	// ==============================
	// 🔄 LOAD (TOTAL)
	// ==============================
	public static function load()
	{
		loadLocal();
		loadCloud();
	}

	// ==============================
	// 🔁 AUTO SAVE
	// ==============================
	static function startAutoSave()
	{
		if(timer != null)
			timer.stop();

		timer = new Timer(saveInterval * 1000);

		timer.run = function()
		{
			save();
		};

		trace("[GoogleCloud] AutoSave started (" + saveInterval + "s)");
	}

	// ==============================
	// ⏹️ STOP AUTO SAVE
	// ==============================
	public static function stopAutoSave()
	{
		if(timer != null)
		{
			timer.stop();
			timer = null;
		}
	}

	// ==============================
	// 🔥 FORCE SYNC
	// ==============================
	public static function sync()
	{
		save();
		load();
	}

	// ==============================
	// 🧠 DEBUG
	// ==============================
	public static function log(msg:String)
	{
		trace("[GoogleCloud] " + msg);
	}
}
