package funkin.menus;

import funkin.hscript.FunkinHScript;
import haxe.ds.StringMap;

// Você pode adaptar isso pro teu tipo de menu (FlxText, sprites, etc)
typedef MenuItem = {
	var id:String;
	var x:Float;
	var y:Float;
	var label:String;
	var visible:Bool;
}

class MenuScripter
{
	public static var script:FunkinHScript;

	public static var items:Array<MenuItem> = [];
	public static var curSelected:Int = 0;

	public static var variables:StringMap<Dynamic> = new StringMap();

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init(scriptCode:String)
	{
		script = new FunkinHScript("MenuScript");

		// API pro script
		script.set("addItem", addItem);
		script.set("setItemPos", setItemPos);
		script.set("setItemText", setItemText);
		script.set("setItemVisible", setItemVisible);
		script.set("getSelected", getSelected);
		script.set("setSelected", setSelected);
		script.set("getItem", getItem);
		script.set("removeItem", removeItem);

		// util
		script.set("Math", Math);
		script.set("Std", Std);

		script.load(scriptCode);
		script.create();
	}

	// ==============================
	// 🔄 UPDATE
	// ==============================
	public static function update(elapsed:Float)
	{
		if(script != null)
		{
			script.update(elapsed);
		}
	}

	public static function onKeyPress(key:String)
	{
		if(script != null)
		{
			script.call("onKeyPress", [key]);
		}
	}

	public static function onAccept()
	{
		if(script != null)
		{
			script.call("onAccept", [curSelected]);
		}
	}

	public static function onBack()
	{
		if(script != null)
		{
			script.call("onBack");
		}
	}

	// ==============================
	// 📦 MENU API
	// ==============================

	public static function addItem(id:String, label:String, x:Float, y:Float)
	{
		items.push({
			id: id,
			label: label,
			x: x,
			y: y,
			visible: true
		});
	}

	public static function removeItem(id:String)
	{
		items = items.filter(item -> item.id != id);
	}

	public static function getItem(id:String):MenuItem
	{
		for(item in items)
		{
			if(item.id == id) return item;
		}
		return null;
	}

	public static function setItemPos(id:String, x:Float, y:Float)
	{
		var item = getItem(id);
		if(item != null)
		{
			item.x = x;
			item.y = y;
		}
	}

	public static function setItemText(id:String, text:String)
	{
		var item = getItem(id);
		if(item != null)
		{
			item.label = text;
		}
	}

	public static function setItemVisible(id:String, visible:Bool)
	{
		var item = getItem(id);
		if(item != null)
		{
			item.visible = visible;
		}
	}

	public static function getSelected():Int
	{
		return curSelected;
	}

	public static function setSelected(i:Int)
	{
		if(i >= 0 && i < items.length)
		{
			curSelected = i;
		}
	}

	// ==============================
	// 🎯 NAVIGAÇÃO PADRÃO
	// ==============================
	public static function changeSelection(dir:Int)
	{
		curSelected += dir;

		if(curSelected < 0) curSelected = items.length - 1;
		if(curSelected >= items.length) curSelected = 0;

		if(script != null)
		{
			script.call("onSelectionChange", [curSelected]);
		}
	}
}
