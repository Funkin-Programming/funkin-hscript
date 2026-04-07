package mobile.android;

import openfl.Lib;
import openfl.system.System;
import openfl.events.Event;
import lime.app.Application;
import haxe.Timer;

import funkin.hscript.HScripter;

class AndroidManager
{
	public static var isAndroid:Bool = false;
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

		#if android
		isAndroid = true;
		#else
		isAndroid = false;
		#end

		if(!isAndroid)
		{
			trace("[AndroidManager] Not running on Android");
			return;
		}

		initialized = true;

		setupLifecycle();
		setupPerformance();

		trace("[AndroidManager] Initialized");
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
		trace("[Android] App Paused");

		HScripter.pause();
	}

	static function onResume(e:Event)
	{
		trace("[Android] App Resumed");

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
			trace("[Android] Low Quality Enabled");
		}
		else
		{
			setFPS(60);
			trace("[Android] Low Quality Disabled");
		}
	}

	// ==============================
	// 📳 VIBRATION
	// ==============================
	public static function vibrate(time:Int = 100)
	{
		#if android
		try
		{
			lime.system.System.vibrate(time);
		}
		catch(e)
		{
			trace("[Android] Vibration error: " + e);
		}
		#end
	}

	// ==============================
	// 📱 TOUCH (BÁSICO)
	// ==============================
	public static function updateTouches()
	{
		#if android
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

		// envia pro sistema global
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

		trace("[AndroidManager] Destroyed");
	}
}
