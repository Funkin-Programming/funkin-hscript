package funkin.hscript;

import haxe.ds.StringMap;
import sys.io.File;
import sys.FileSystem;

// Sistemas integrados
import funkin.menus.MenuScripter;
import discord.DiscordScripter;
import google.GoogleCloud;

class HScripter
{
	public static var scripts:StringMap<FunkinHScript> = new StringMap();
	public static var scriptOrder:Array<String> = [];

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init()
	{
		GoogleCloud.init(); // 🔗 integração com cloud

		trace("[HScripter] Initialized");
	}

	// ==============================
	// 📥 LOAD SCRIPT
	// ==============================
	public static function loadScript(name:String, path:String, ?tag:String = "default")
	{
		if(!FileSystem.exists(path))
		{
			trace('[HScripter] Script not found: ' + path);
			return;
		}

		var code:String = File.getContent(path);
		var script = new FunkinHScript(name);

		injectGlobals(script);

		script.set("scriptTag", tag);

		script.load(code);
		script.create();

		scripts.set(name, script);
		scriptOrder.push(name);

		trace('[HScripter] Loaded: ' + name + ' (tag: ' + tag + ')');
	}

	// ==============================
	// 📂 LOAD FOLDER
	// ==============================
	public static function loadFolder(folder:String)
	{
		if(!FileSystem.exists(folder)) return;

		for(file in FileSystem.readDirectory(folder))
		{
			if(file.endsWith(".hscript"))
			{
				loadScript(file, folder + "/" + file);
			}
		}
	}

	// ==============================
	// 🔗 GLOBAL API
	// ==============================
	static function injectGlobals(script:FunkinHScript)
	{
		// ================= CORE =================
		script.set("callGlobal", call);
		script.set("setGlobal", setGlobal);
		script.set("getGlobal", getGlobal);

		// ================= MENU =================
		script.set("addMenuItem", MenuScripter.addItem);
		script.set("setMenuItemPos", MenuScripter.setItemPos);
		script.set("setMenuItemText", MenuScripter.setItemText);

		// ================= DISCORD =================
		script.set("setRPC", DiscordScripter.setRPC);

		// ================= GOOGLE CLOUD =================
		script.set("cloudSet", GoogleCloud.set);
		script.set("cloudGet", GoogleCloud.get);
		script.set("cloudSave", GoogleCloud.save);
		script.set("cloudLoad", GoogleCloud.load);

		// ================= DEBUG =================
		script.set("print", trace);
	}

	// ==============================
	// 🔄 UPDATE
	// ==============================
	public static function update(elapsed:Float)
	{
		for(name in scriptOrder)
		{
			var script = scripts.get(name);
			if(script != null)
				script.update(elapsed);
		}

		MenuScripter.update(elapsed);
		DiscordScripter.update(elapsed);
	}

	public static function updatePost(elapsed:Float)
	{
		call("onUpdatePost", [elapsed]);
	}

	// ==============================
	// 🎮 EVENTS
	// ==============================
	public static function create()
	{
		call("onCreate");
	}

	public static function beatHit(curBeat:Int)
	{
		call("onBeatHit", [curBeat]);
	}

	public static function stepHit(curStep:Int)
	{
		call("onStepHit", [curStep]);
	}

	public static function songStart()
	{
		call("onSongStart");
	}

	public static function pause()
	{
		call("onPause");
		GoogleCloud.save(); // 🔗 salva automaticamente
	}

	public static function resume()
	{
		call("onResume");
	}

	public static function gameOver()
	{
		call("onGameOver");
		GoogleCloud.save(); // 🔗 salva automaticamente
	}

	// ==============================
	// 📡 CALL GLOBAL
	// ==============================
	public static function call(func:String, args:Array<Dynamic> = null)
	{
		for(name in scriptOrder)
		{
			var script = scripts.get(name);
			if(script != null)
				script.call(func, args);
		}
	}

	// ==============================
	// 🧠 GLOBAL VARS
	// ==============================
	public static function setGlobal(name:String, value:Dynamic)
	{
		for(script in scripts)
		{
			script.set(name, value);
		}
	}

	public static function getGlobal(name:String):Dynamic
	{
		for(script in scripts)
		{
			var val = script.get(name);
			if(val != null) return val;
		}
		return null;
	}

	// ==============================
	// 🔄 HOT RELOAD (BASE)
	// ==============================
	public static function reloadScript(name:String, path:String)
	{
		if(scripts.exists(name))
		{
			scripts.get(name).destroy();
			scripts.remove(name);
		}

		loadScript(name, path);

		trace("[HScripter] Reloaded: " + name);
	}

	// ==============================
	// ❌ REMOVE
	// ==============================
	public static function removeScript(name:String)
	{
		if(!scripts.exists(name)) return;

		scripts.get(name).destroy();
		scripts.remove(name);
		scriptOrder.remove(name);

		trace("[HScripter] Removed: " + name);
	}

	// ==============================
	// 🔥 CLEAR
	// ==============================
	public static function clear()
	{
		for(script in scripts)
		{
			script.destroy();
		}

		scripts = new StringMap();
		scriptOrder = [];

		trace("[HScripter] Cleared all scripts");
	}
}