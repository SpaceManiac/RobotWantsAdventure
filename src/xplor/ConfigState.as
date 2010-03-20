package xplor
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
    import org.flixel.*;
	
    public class ConfigState extends FlxState
    {
		[Embed(source="../../data/powerup.mp3")] 
		protected var hitSnd:Class;
		
		/*
		[Embed(source = "../../data/maps/classic.raw", mimeType="application/octet-stream")]
		protected static var MClassic:Class;
		[Embed(source = "../../data/maps/kittycaptured_rb.raw", mimeType="application/octet-stream")]
		protected static var MKittyCaptured:Class;
		[Embed(source = "../../data/maps/awesometown_molt.raw", mimeType="application/octet-stream")]
		protected static var MAwesomeTown:Class;
		[Embed(source = "../../data/maps/another_megadog.raw", mimeType="application/octet-stream")]
		protected static var MAnotherLevel:Class;
		[Embed(source = "../../data/maps/koopacavern_pk.raw", mimeType="application/octet-stream")]
		protected static var MKoopaCavern:Class;
		[Embed(source = "../../data/maps/smallmap_cliffy.raw", mimeType="application/octet-stream")]
		protected static var MSmallMap:Class;
		[Embed(source = "../../data/maps/thetower_bowserfan.raw", mimeType="application/octet-stream")]
		protected static var MTheTower:Class;
		[Embed(source = "../../data/maps/yesh_yourter.raw", mimeType="application/octet-stream")]
		protected static var MYesh:Class;
		*/
		
		//public static var Map:Class = MClassic; //
		public static var Map:ByteArray;
		public static var MapI:int = -1; //
		public static var PowerStart:Boolean = false; //
		public static var DuckJump:Boolean = false; //
		
		public static var Timer:Boolean = true;
		public static var KillBonus:uint = 1;
		public static var DeathPenalty:uint = 20;
		
		public static var RedAlienHealth:uint = 3; //
		public static var BlueAlienHealth:uint = 1; //
		public static var BossHealth:uint = 50; //
		
		public static var RedAlienSpeed:uint = 20; //
		public static var BlueAlienSpeed:uint = 20; //
		public static var BossSpeed:uint = 20; //
		
		public static var RocketOnFloor:Boolean = true;
		public static var LargeBlockFactor:uint = 50;
		
		private var maplist:Array;
		
		private var arrow:FlxText;
		private var mapT:FlxText;
		private var maplT:FlxText;
		private var powerT:FlxText;
		private var duckjT:FlxText;
		private var timerT:FlxText;
		private var killbT:FlxText;
		private var deathpT:FlxText;
		private var rahT:FlxText;
		private var bahT:FlxText;
		private var bosshT:FlxText;
		private var rasT:FlxText;
		private var basT:FlxText;
		private var bosssT:FlxText;
		private var rfloorT:FlxText;
		private var lbfT:FlxText;
		
		public static var testing:uint = 0;
		
		/* private var mapnames:Array = ["Original Level\n by Hamumu",
				"Kitty Got Captured!\n by Redbone",
				"Awesome Town\n by Moltanem2000",
				"Another Level\n by Megadog",
				"Koopa Cavern\n by PurpleKoopa",
				"Small Map\n by Cliffy1000",
				"The Tower\n by Bowserfan",
				"YESH!\n by Yourter12"]; */
		
		private var fading:Boolean = false;
		private var finishedStage:Boolean = false;
		private var selection:uint = 0;
		
		private var timeout:uint = 0;
		
		private function loadMaps():void {
			FlxG.log("Downloading map list");
			mapT.text = "Downloading list...";
			var req:URLRequest = new URLRequest("http://wombat.platymuus.com/rwa/levellist.php?testing=" + testing.toString());
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
		
        override public function ConfigState() {
			FlxG.log("ConfigState opened");
            add(new FlxText(0, 8, FlxG.width, "Settings Screen", 0xffffffff, null, 16, "center"));
            add(new FlxText(0, FlxG.height  -20, FlxG.width, "Up/down to select, l/r to change", 0xffffffff, null, 8, "center"));
            add(new FlxText(0, FlxG.height  -12, FlxG.width, "Press Z to return", 0xffffffff, null, 8, "center"));
			
			// pointer
			arrow = new FlxText(70, 32, 10, ">");
			add(arrow);
			var i:uint = 11, y:uint = 32 - i;
			// map
			add(new FlxText(80, y += i, 120, "Adventure: "));
			add(mapT = new FlxText(200, y, 200, ""));
			add(maplT = new FlxText(100, y + 10, 120, ""));
			y += i;
			// super start
			add(new FlxText(80, y += i, 120, "Start Superpowered: "));
			add(powerT = new FlxText(200, y, 200, boolstr(PowerStart)));
			// duckjump
			add(new FlxText(80, y += i, 120, "Duck-Jump Glitch: "));
			add(duckjT = new FlxText(200, y, 200, boolstr(DuckJump)));
			// timer
			add(new FlxText(80, y += i, 120, "Timer Display: "));
			add(timerT = new FlxText(200, y, 200, boolstr(Timer)));
			// kill bonus
			add(new FlxText(80, y += i, 120, "Kill Time Bonus: "));
			add(killbT = new FlxText(200, y, 200, KillBonus.toString()));
			// death penalty
			add(new FlxText(80, y += i, 120, "Death Time Penalty: "));
			add(deathpT = new FlxText(200, y, 200, DeathPenalty.toString()));
			// red enemy health
			add(new FlxText(80, y += i, 120, "Red Alien Health: "));
			add(rahT = new FlxText(200, y, 200, RedAlienHealth.toString()));
			// blue enemy health
			add(new FlxText(80, y += i, 120, "Blue Alien Health: "));
			add(bahT = new FlxText(200, y, 200, BlueAlienHealth.toString()));
			// boss health
			add(new FlxText(80, y += i, 120, "Boss Monster Health: "));
			add(bosshT = new FlxText(200, y, 200, BossHealth.toString()));
			// red enemy speed
			add(new FlxText(80, y += i, 120, "Red Alien Speed: "));
			add(rasT = new FlxText(200, y, 200, RedAlienSpeed.toString()));
			// blue enemy speed
			add(new FlxText(80, y += i, 120, "Blue Alien Speed: "));
			add(basT = new FlxText(200, y, 200, BlueAlienSpeed.toString()));
			// boss speed
			add(new FlxText(80, y += i, 120, "Boss Monster Speed: "));
			add(bosssT = new FlxText(200, y, 200, BossSpeed.toString()));
			// rocket on floor
			add(new FlxText(80, y += i, 120, "Dashing on Floor: "));
			add(rfloorT = new FlxText(200, y, 200, boolstr(RocketOnFloor)));
			// large block factor
			add(new FlxText(80, y += i, 120, "Large Block Factor: "));
			add(lbfT = new FlxText(200, y, 200, LargeBlockFactor.toString() + "%"));
			
			loadMaps();
        }
		
		private function boolstr(x:Boolean):String {
			if (x) return "on";
			else return "off";
		}
		
		private function mapname():void {
			mapT.text = maplist[MapI]['name'] + "\n  by " + maplist[MapI]['author'];
			maplT.text = (MapI + 1).toString() + "/" + maplist.length.toString();
		}
		
        override public function update():void {
            if (FlxG.keys.Z && !fading) {
				fading = true;
				downloadMap();
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 0.5, onFade);
				FlxG.play(hitSnd);
			}
			
			if (FlxG.keys.justPressed("UP")) {
				if (selection > 0) selection--;
			}
			if (FlxG.keys.justPressed("DOWN")) {
				if (selection < 13) selection++;
			}
			arrow.y = 32 + 11 * selection;
			if (selection > 0) arrow.y += 11;
			
			
			if (FlxG.keys.justPressed("LEFT")) {
				if (selection == 0 && MapI >= 0) {
					if (MapI > 0) MapI--;
					mapname();
				} else if (selection == 1) {
					PowerStart = !PowerStart;
					powerT.text = boolstr(PowerStart);
				} else if (selection == 2) {
					DuckJump = !DuckJump;
					duckjT.text = boolstr(DuckJump);
				} else if (selection == 3) {
					Timer = !Timer;
					timerT.text = boolstr(Timer);
				} else if (selection == 4) {
					if (KillBonus > 0) KillBonus--;
					killbT.text = KillBonus.toString();
				} else if (selection == 5) {
					if (DeathPenalty > 0) DeathPenalty--;
					deathpT.text = DeathPenalty.toString();
				} else if (selection == 6) {
					if (RedAlienHealth > 1) RedAlienHealth--;
					rahT.text = RedAlienHealth.toString();
				} else if (selection == 7) {
					if (BlueAlienHealth > 1) BlueAlienHealth--;
					bahT.text = BlueAlienHealth.toString();
				} else if (selection == 8) {
					if (BossHealth > 10) BossHealth -= 5;
					bosshT.text = BossHealth.toString();
				} else if (selection == 9) {
					if (RedAlienSpeed > 10) RedAlienSpeed--;
					rasT.text = RedAlienSpeed.toString();
				} else if (selection == 10) {
					if (BlueAlienSpeed > 10) BlueAlienSpeed--;
					basT.text = BlueAlienSpeed.toString();
				} else if (selection == 11) {
					if (BossSpeed > 10) BossSpeed--;
					bosssT.text = BossSpeed.toString();
				} else if (selection == 12) {
					RocketOnFloor = !RocketOnFloor;
					rfloorT.text = boolstr(RocketOnFloor);
				} else if (selection == 13) {
					if (LargeBlockFactor > 0) LargeBlockFactor -= 5;
					lbfT.text = LargeBlockFactor.toString() + "%";
				}
			}
			
			if (FlxG.keys.justPressed("RIGHT")) {
				if (selection == 0 && MapI != -1) {
					if (MapI < maplist.length - 1) MapI++;
					mapname();
				} else if (selection == 1) {
					PowerStart = !PowerStart;
					powerT.text = boolstr(PowerStart);
				} else if (selection == 2) {
					DuckJump = !DuckJump;
					duckjT.text = boolstr(DuckJump);
				} else if (selection == 3) {
					Timer = !Timer;
					timerT.text = boolstr(Timer);
				} else if (selection == 4) {
					if (KillBonus < 10) KillBonus++;
					killbT.text = KillBonus.toString();
				} else if (selection == 5) {
					if (DeathPenalty < 30) DeathPenalty++;
					deathpT.text = DeathPenalty.toString();
				} else if (selection == 6) {
					if (RedAlienHealth < 8) RedAlienHealth++;
					rahT.text = RedAlienHealth.toString();
				} else if (selection == 7) {
					if (BlueAlienHealth < 8) BlueAlienHealth++;
					bahT.text = BlueAlienHealth.toString();
				} else if (selection == 8) {
					if (BossHealth < 100) BossHealth += 5;
					bosshT.text = BossHealth.toString();
				} else if (selection == 9) {
					if (RedAlienSpeed < 60) RedAlienSpeed++;
					rasT.text = RedAlienSpeed.toString();
				} else if (selection == 10) {
					if (BlueAlienSpeed < 60) BlueAlienSpeed++;
					basT.text = BlueAlienSpeed.toString();
				} else if (selection == 11) {
					if (BossSpeed < 60) BossSpeed++;
					bosssT.text = BossSpeed.toString();
				} else if (selection == 12) {
					RocketOnFloor = !RocketOnFloor;
					rfloorT.text = boolstr(RocketOnFloor);
				} else if (selection == 13) {
					if (LargeBlockFactor < 100) LargeBlockFactor += 5;
					lbfT.text = LargeBlockFactor.toString() + "%";
				}
			}
			
            super.update();
        }
		
		private function downloadMap():void {
			if (MapI == -1) {
				FlxG.log("No map chosen, skipping download");
				if (finishedStage) {
					TitleState.Adventure = maplist[MapI]['name'] + " by " + maplist[MapI]['author'];
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
			
            if (finishedStage) {
				TitleState.Adventure = maplist[MapI]['name'] + " by " + maplist[MapI]['author'];
				FlxG.switchState(TitleState);
			} else {
				finishedStage = true;
			}
			FlxG.log("Done");
		}
		
        private function onFade():void {
            if (finishedStage) {
				TitleState.Adventure = maplist[MapI]['name'] + " by " + maplist[MapI]['author'];
				FlxG.switchState(TitleState);
			} else {
				finishedStage = true;
			}
        }
    }
}