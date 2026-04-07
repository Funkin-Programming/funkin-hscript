package funkin.hscript;

import haxe.ds.StringMap;
import sys.io.File;
import sys.FileSystem;

// integrações
import funkin.menus.MenuScripter;
import discord.DiscordScripter;

class HScripter
{
	public static var scripts:StringMap<FunkinHScript> = new StringMap();

	// ==============================
	// 🚀 LOAD SCRIPT
	// ==============================
	public static function loadScript(name:String, path:String)
	{
		if(!FileSystem.exists(path))
		{
			trace('[HScripter] Script not found: ' + path);
			return;
		}

		var code:String = File.getContent(path);
		var script = new FunkinHScript(name);

		// 🔗 INTEGRAÇÃO GLOBAL API
		injectGlobals(script);

		script.load(code);
		script.create();

		scripts.set(name, script);

		trace('[HScripter] Loaded: ' + name);
	}

	// ==============================
	// 🔗 INJECT GLOBAL API
	// ==============================
	static function injectGlobals(script:FunkinHScript)
	{
		// ================= MENU =================
		script.set("addMenuItem", MenuScripter.addItem);
		script.set("setMenuItemPos", MenuScripter.setItemPos);
		script.set("setMenuItemText", MenuScripter.setItemText);

		// ================= DISCORD =================
		script.set("setRPC", DiscordScripter.setRPC);
		script.set("setRPCDetails", DiscordScripter.setDetails);
		script.set("setRPCState", DiscordScripter.setState);

		// ================= GLOBAL =================
		script.set("callGlobal", call);
		script.set("setGlobal", setGlobal);
		script.set("getGlobal", getGlobal);
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
	// 🔄 UPDATE
	// ==============================
	public static function update(elapsed:Float)
	{
		for(script in scripts)
		{
			script.update(elapsed);
		}

		// integração com sistemas
		MenuScripter.update(elapsed);
		DiscordScripter.update(elapsed);
	}

	// ==============================
	// 🎮 GAMEPLAY EVENTS
	// ==============================
	public static function create()
	{
		call("onCreate");
	}

	public static function updatePost(elapsed:Float)
	{
		call("onUpdatePost", [elapsed]);
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
	}

	public static function resume()
	{
		call("onResume");
	}

	public static function gameOver()
	{
		call("onGameOver");
	}

	// ==============================
	// 📡 CALL GLOBAL
	// ==============================
	public static function call(func:String, args:Array<Dynamic> = null)
	{
		for(script in scripts)
		{
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
	// 🔥 CLEAR
	// ==============================
	public static function clear()
	{
		for(script in scripts)
		{
			script.destroy();
		}

		scripts = new StringMap();
		trace('[HScripter] Cleared all scripts');
	}
}