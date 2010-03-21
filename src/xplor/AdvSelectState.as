package xplor 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
    import org.flixel.*;
	
	public class AdvSelectState extends FlxState
	{
		[Embed(source="../../data/powerup.mp3")] 
		protected var hitSnd:Class;
		
		private var fading:Boolean = false;
		private var finishedStage:Boolean = false;
		
		public static var Map:ByteArray = null;
		public static var MapI:int = -1;
		private var timeout:uint = 0;
		
		private var maplist:Array;
		private var mapT:FlxText;
		private var maplT:FlxText;
		
		private function mapname():void {
			//mapT.text = maplist[MapI]['name'] + "\n  by " + maplist[MapI]['author'];
			//maplT.text = (MapI + 1).toString() + "/" + maplist.length.toString();
		}
		
		private function loadMaps():void {
			FlxG.log("Downloading map list");
			mapT.text = "Downloading list...";
			var req:URLRequest = new URLRequest("http://wombat.platymuus.com/rwa/levellist.php?testing=" + ConfigState.testing.toString());
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadMapsCallback);
			timeout = setTimeout(loadMapsTimeout, 5000);
			loader.load(req);
		}
		
		private function loadMapsCallback(event:Event):void {
			if (timeout == 0) {
				return;
			}
			clearTimeout(timeout);
			timeout = 0;
			FlxG.log("Processing map list");
			mapT.text = "Processing list...";
			maplist = new Array();
			var xml:XML = new XML(event.target.data);
			for (var i:uint = 0; i < xml.level.length(); ++i) {
				var mapd:Array = new Array();
				mapd['id'] = xml.level[i].@id;
				mapd['name'] = xml.level[i].name;
				if (xml.level[i].@testing == 1) mapd['name'] += " *";
				mapd['author'] = xml.level[i].author;
				mapd['filename'] = xml.level[i].filename;
				maplist[maplist.length] = mapd;
			}
			MapI = 0;
			mapname();
			FlxG.log("Done");
		}
		
		private function loadMapsTimeout():void {
			timeout = 0;
			mapT.text = "Download timed out!\nOnly classic is available";
			MapI = -1;
		}
		
		public function AdvSelectState() 
		{
			FlxG.log("AdvSelectState opened");
			add(new Background());
			
			
			//loadMaps();
			add(new Cursor());
		}
		
		override public function update():void
		{
			if (FlxG.keys.Z) {
				finish();
			}
			super.update();
		}
		
		private function finish():void {
			if (!fading) {
				fading = true;
				finishedStage = false;
				downloadMap();
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 0.5, onFade);
				FlxG.play(hitSnd);
			}
		}
		
		private function downloadMap():void {
			if (MapI == -1) {
				FlxG.log("No map chosen, skipping download");
				if (finishedStage) {
					// don't update since we didn't download
					FlxG.switchState(TitleState);
				} else {
					finishedStage = true;
				}
				return;
			}
			FlxG.log("Downloading map " + maplist[MapI]['filename']);
			var req:URLRequest = new URLRequest("http://wombat.platymuus.com/rwa/levels/" + maplist[MapI]['filename']);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, downloadMapCallback);
			loader.load(req);
		}
		
		private function downloadMapCallback(event:Event):void {
			FlxG.log("Processing map");
			var b:ByteArray = new ByteArray();
			var data:String = event.target.data;
			b.position = 0;
			for (var i:uint = 0; i < data.length; ++i) {
				b.writeByte(data.charCodeAt(i));
			}
			Map = b;
			
			TitleState.Adventure = maplist[MapI]['name'] + " by " + maplist[MapI]['author'];
            if (finishedStage) {
				FlxG.switchState(TitleState);
			} else {
				finishedStage = true;
			}
			FlxG.log("Done");
		}
		
        private function onFade():void {
            if (finishedStage) {
				FlxG.switchState(TitleState);
			} else {
				finishedStage = true;
			}
        }
	}
}