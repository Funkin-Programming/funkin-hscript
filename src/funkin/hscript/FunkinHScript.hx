package funkin.hscript;

import hscript.Parser;
import hscript.Interp;
import haxe.ds.StringMap;

class FunkinHScript
{
	public var interp:Interp;
	public var parser:Parser;
	public var variables:StringMap<Dynamic>;
	public var scriptName:String;

	public function new(name:String)
	{
		scriptName = name;

		parser = new Parser();
		parser.allowTypes = true;
		parser.allowJSON = true;

		interp = new Interp();
		variables = new StringMap<Dynamic>();

		setupDefaults();
	}

	// ==============================
	// 🔧 DEFAULT VARIABLES / API
	// ==============================
	function setupDefaults()
	{
		// Básico
		set("trace", trace);
		set("Math", Math);
		set("Std", Std);

		// Tempo (exemplo)
		set("elapsed", 0);

		// Função custom
		set("setVar", function(name:String, value:Dynamic)
		{
			set(name, value);
		});

		set("getVar", function(name:String)
		{
			return get(name);
		});
	}

	// ==============================
	// 📥 SET / GET
	// ==============================
	public function set(name:String, value:Dynamic)
	{
		variables.set(name, value);
		interp.variables.set(name, value);
	}

	public function get(name:String):Dynamic
	{
		return variables.get(name);
	}

	// ==============================
	// 📜 LOAD SCRIPT
	// ==============================
	public function load(code:String)
	{
		try
		{
			var program = parser.parseString(code);
			interp.execute(program);
		}
		catch(e)
		{
			trace('[HScript ERROR][' + scriptName + ']: ' + e);
		}
	}

	// ==============================
	// ▶️ CALL FUNCTION
	// ==============================
	public function call(func:String, args:Array<Dynamic> = null):Dynamic
	{
		if(args == null) args = [];

		if(interp.variables.exists(func))
		{
			var f = interp.variables.get(func);
			if(Reflect.isFunction(f))
			{
				try
				{
					return Reflect.callMethod(null, f, args);
				}
				catch(e)
				{
					trace('[HScript CALL ERROR][' + scriptName + ']: ' + e);
				}
			}
		}
		return null;
	}

	// ==============================
	// 🔄 UPDATE LOOP
	// ==============================
	public function update(elapsed:Float)
	{
		set("elapsed", elapsed);
		call("onUpdate", [elapsed]);
	}

	public function beatHit(curBeat:Int)
	{
		call("onBeatHit", [curBeat]);
	}

	public function stepHit(curStep:Int)
	{
		call("onStepHit", [curStep]);
	}

	public function create()
	{
		call("onCreate");
	}

	public function destroy()
	{
		call("onDestroy");
	}
}
