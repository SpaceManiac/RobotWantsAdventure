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
		
		[Embed(source="../../data/highlight.png")] 
		protected var HighlightImg:Class;
		
		private var highlight:FlxSprite;
		
		private var fading:Boolean = false;
		private var finishedStage:Boolean = false;
		
		public static var Map:ByteArray = null;
		public static var MapI:int = -1;
		public static var FirstMap:int = 0;
		private var timeout:uint = 0;
		
		private static const MT_NUM:int = 0;
		private static const MT_NAME:int = 1;
		private static const MT_AUTH:int = 2;
		private var mapTexts:Array;
		
		private var maplist:Array;
		
		private var upbtn:ArrowButton;
		private var dnbtn:ArrowButton;
		
		private function mapname():void {
			//mapT.text = maplist[MapI]['name'] + "\n  by " + maplist[MapI]['author'];
			//maplT.text = (MapI + 1).toString() + "/" + maplist.length.toString();
		}
		
		private function loadMaps():void {
			FlxG.log("Downloading map list");
			mapTexts[0][MT_NAME].text = "Downloading list...";
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
			mapTexts[0][MT_NAME].text = "Processing list...";
			maplist = new Array();
			var xml:XML = new XML(event.target.data);
			for (var i:uint = 0; i < xml.level.length(); ++i) {
				var mapd:Array = new Array();
				mapd['id'] = xml.level[i].@id;
				mapd['name'] = xml.level[i].name;
				if (xml.level[i].@testing == 1) mapd['name'] += " *";
				mapd['author'] = xml.level[i].author;
				mapd['filename'] = xml.level[i].filename;
				maplist.push(mapd);
			}
			MapI = 0;
			mapname();
			writeMapList();
			FlxG.log("Done");
		}
		
		private function loadMapsTimeout():void {
			timeout = 0;
			mapTexts[0][MT_NAME] = "Download timed out!";
			MapI = -1;
		}
		
		override public function create():void 
		{
			FlxG.log("AdvSelectState opened");
			add(new Background());
            add(new FlxText(0, 8, FlxG.width, "Select Adventure").setFormat(null, 16, 0xffffffff, "center"));
            add(new MenuButton(FlxG.width / 2, 210, finish, "Main Menu"));
			
			add(highlight = new FlxSprite(0, 43, HighlightImg));
			
			add(new FlxText(20, 32, 30, "Num"));
			add(new FlxText(50, 32, 140, "Adventure Name"));
			add(new FlxText(200, 32, 200, "Author"));
			
			add(upbtn = new ArrowButton(300, 50, upbtnCallback, "up"));
			add(dnbtn = new ArrowButton(300, 60, dnbtnCallback, "down"));
			
			mapTexts = new Array();
			for (var i:int = 1; i <= 15; ++i) {
				var txt_num:FlxText = new FlxText(20, 32 + 11 * i, 30, "-");
				var txt_name:FlxText = new FlxText(50, 32 + 11 * i, 150, "");
				var txt_author:FlxText = new FlxText(200, 32 + 11 * i, 200, "");
				add(txt_num);
				add(txt_name);
				add(txt_author);
				
				var mapEl:Array = [txt_num, txt_name, txt_author];
				mapTexts.push(mapEl);
			}
			
			loadMaps();
			add(new Cursor());
		}
		
		private function writeMapList():void
		{
			var found:Boolean = false;
			for (var i:int = 0; i < 15; ++i) {
				var mapData:Array = maplist[FirstMap + i];
				var mapText:Array = mapTexts[i];
				mapText[MT_NUM].text = (FirstMap + i + 1).toString();
				mapText[MT_NAME].text = mapData["name"];
				mapText[MT_AUTH].text = mapData["author"];
				if (FirstMap + i == MapI) {
					highlight.y = 33 + 11 * (i + 1);
					found = true;
				}
			}
			if (!found) {
				highlight.y = -40;
			}
		}
		
		override public function update():void
		{
			if (FlxG.keys.Z) {
				finish();
			}
			
			if (FlxG.mouse.justPressed()) {
				var y:int = FlxG.mouse.y;
				if (y >= 43 && y < 208 && FlxG.mouse.x < 299) {
					MapI = FirstMap + int((y-43) / 11);
					writeMapList();
				}
			}
			
			if (FlxG.keys.justPressed("DOWN")) {
				dnbtnCallback();
			}
			if (FlxG.keys.justPressed("UP")) {
				upbtnCallback();
			}
			
			super.update();
		}
		
		private function finish():void {
			if (!fading) {
				fading = true;
				finishedStage = false;
				downloadMap();
				FlxG.flash.start(0xffffffff, 0.75);
				FlxG.fade.start(0xff000000, 0.5, onFade);
				FlxG.play(hitSnd);
			}
		}
		
		private function downloadMap():void {
			if (MapI == -1) {
				FlxG.log("No map chosen, skipping download");
				if (finishedStage) {
					// don't update since we didn't download
					FlxG.state = new TitleState;
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
				FlxG.state = new TitleState;
			} else {
				finishedStage = true;
			}
			FlxG.log("Done");
		}
		
        private function onFade():void {
            if (finishedStage) {
				FlxG.state = new TitleState;
			} else {
				finishedStage = true;
			}
        }
		
		private function upbtnCallback():void {
			if (FirstMap > 0) FirstMap--;
			writeMapList();
		}
		
		private function dnbtnCallback():void {
			if (FirstMap < maplist.length - 15) FirstMap++;
			writeMapList();
		}
	}
}