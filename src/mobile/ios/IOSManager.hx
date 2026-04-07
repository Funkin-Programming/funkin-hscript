package mobile.ios;

import openfl.Lib;
import openfl.system.System;
import openfl.events.Event;
import lime.app.Application;
import haxe.Timer;

import funkin.hscript.HScripter;

class IOSManager
{
	public static var isIOS:Bool = false;
	public static var initialized:Bool = false;

	// Performance
	public static var targetFPS:Int = 60;
	public static var lowQuality:Bool = false;

	// Touch
	public static var touchCount:Int = 0;

	// ==============================
	// 🚀 INIT
	// ==============================
	public static function init()
	{
		if(initialized) return;

		#if ios
		isIOS = true;
		#else
		isIOS = false;
		#end

		if(!isIOS)
		{
			trace("[IOSManager] Not running on iOS");
			return;
		}

		initialized = true;

		setupLifecycle();
		setupPerformance();

		trace("[IOSManager] Initialized");
	}

	// ==============================
	// 🔄 LIFECYCLE
	// ==============================
	static function setupLifecycle()
	{
		Lib.current.stage.addEventListener(Event.DEACTIVATE, onPause);
		Lib.current.stage.addEventListener(Event.ACTIVATE, onResume);
	}

	static function onPause(e:Event)
	{
		trace("[iOS] App Paused");

		HScripter.pause();
	}

	static function onResume(e:Event)
	{
		trace("[iOS] App Resumed");

		HScripter.resume();
	}

	// ==============================
	// ⚙️ PERFORMANCE
	// ==============================
	static function setupPerformance()
	{
		Application.current.window.frameRate = targetFPS;
	}

	public static function setFPS(fps:Int)
	{
		targetFPS = fps;
		Application.current.window.frameRate = fps;
	}

	public static function enableLowQuality(enable:Bool)
	{
		lowQuality = enable;

		if(enable)
		{
			setFPS(30);
			trace("[iOS] Low Quality Enabled");
		}
		else
		{
			setFPS(60);
			trace("[iOS] Low Quality Disabled");
		}
	}

	// ==============================
	// 📳 VIBRATION (LIMITADO NO iOS)
	// ==============================
	public static function vibrate()
	{
		#if ios
		try
		{
			// iOS não suporta duração custom no OpenFL
			lime.system.System.vibrate(0);
		}
		catch(e)
		{
			trace("[iOS] Vibration error: " + e);
		}
		#end
	}

	// ==============================
	// 📱 TOUCH
	// ==============================
	public static function updateTouches()
	{
		#if ios
		touchCount = lime.ui.Touch.getTouchCount();
		#end
	}

	// ==============================
	// 🔄 UPDATE LOOP
	// ==============================
	public static function update(elapsed:Float)
	{
		if(!initialized) return;

		updateTouches();

		// integração com scripts
		HScripter.setGlobal("touchCount", touchCount);
	}

	// ==============================
	// 🔋 MEMORY INFO
	// ==============================
	public static function getMemory():Float
	{
		return System.totalMemory / 1024 / 1024; // MB
	}

	// ==============================
	// 🔥 CLEANUP
	// ==============================
	public static function destroy()
	{
		if(!initialized) return;

		Lib.current.stage.removeEventListener(Event.DEACTIVATE, onPause);
		Lib.current.stage.removeEventListener(Event.ACTIVATE, onResume);

		initialized = false;

		trace("[IOSManager] Destroyed");
	}
}
