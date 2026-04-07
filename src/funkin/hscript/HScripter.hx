package funkin.hscript;

import haxe.ds.StringMap;
import sys.io.File;
import sys.FileSystem;

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

		script.load(code);
		script.create();

		scripts.set(name, script);

		trace('[HScripter] Loaded: ' + name);
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
	// ❌ REMOVE SCRIPT
	// ==============================
	public static function removeScript(name:String)
	{
		if(scripts.exists(name))
		{
			var script = scripts.get(name);
			script.destroy();

			scripts.remove(name);

			trace('[HScripter] Removed: ' + name);
		}
	}

	// ==============================
	// 🔄 RELOAD SCRIPT
	// ==============================
	public static function reloadScript(name:String, path:String)
	{
		removeScript(name);
		loadScript(name, path);
	}

	// ==============================
	// 🔄 UPDATE ALL
	// ==============================
	public static function update(elapsed:Float)
	{
		for(script in scripts)
		{
			script.update(elapsed);
		}
	}

	// ==============================
	// 🎵 EVENTS
	// ==============================
	public static function beatHit(curBeat:Int)
	{
		for(script in scripts)
		{
			script.beatHit(curBeat);
		}
	}

	public static function stepHit(curStep:Int)
	{
		for(script in scripts)
		{
			script.stepHit(curStep);
		}
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
	// 🧠 GLOBAL VARIABLES
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
	// 🔥 CLEAR ALL
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