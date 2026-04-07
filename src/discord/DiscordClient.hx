package discord;

@:buildXml('
<target id="haxe">
	<lib name="discord-rpc"/>
	<flag value="-I${haxelib:funkin-hscript}/native"/>
</target>
')

@:include("discord_rpc.h")
extern class DiscordClient
{
	// INIT
	@:native("discord_init")
	public static function initialize():Void;

	// SHUTDOWN
	@:native("discord_shutdown")
	public static function shutdown():Void;

	// PRESENCE
	@:native("discord_update_presence")
	public static function changePresence(
		details:String,
		state:String,
		largeImage:String,
		smallImage:String,
		startTimestamp:Float
	):Void;
}
