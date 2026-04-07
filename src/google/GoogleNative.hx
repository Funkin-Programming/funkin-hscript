package google;

@:include("google.h")
extern class GoogleNative
{
	@:native("google_init")
	public static function init():Void;

	@:native("google_login")
	public static function login():Void;

	@:native("google_logout")
	public static function logout():Void;

	@:native("google_is_logged")
	public static function isLogged():Bool;

	@:native("google_save")
	public static function save(data:String):Void;

	@:native("google_load")
	public static function load():String;

	@:native("google_log")
	public static function log(msg:String):Void;
}