package xplor 
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source="../../data/die.mp3")] 
		protected var dieSnd:Class;
		
		[Embed(source = "../../data/tiles.png")] 
		protected var TilesImage:Class;
		private const mapWidth:int = 256;
		
		[Embed(source = "../../data/map.raw", mimeType="application/octet-stream")]
		protected static var BackupMap:Class;
		
		protected var tileMap:FlxTilemap;
		protected var player:Player;
		protected var enemies:Array;
		protected var timerTxt:FlxText;
		protected var timer:Number;
		protected var bullets:Array;
		protected var missiles:Array;
		protected var kitty:Kitty;
		protected var bombs:Array;
		protected var bg:Background;
		
		public function LoadMap():void
		{
			FlxG.log("Loading map");
			// get the loaded byte stream into a ByteArray
			var b:ByteArray;
			if (AdvSelectState.Map == null) {
				b = new BackupMap();
			} else {
				b = AdvSelectState.Map;
			}
			var a:Array = new Array();
			b.position = 0;
			// move that ByteArray into an Array
			for (var i:int = 0; i < b.length; i++)
			{
				a[i] = (int)(b.readUnsignedByte());
			}
			
			// and finally convert that array into a CSV for FlxTilemap to comprehend!
			tileMap = new FlxTilemap(FlxTilemap.arrayToCSV(a,mapWidth), TilesImage, 16, 50, 1);
			this.add(tileMap);
			
			// populate the map
			for (i = 0; i < b.length; i++)
			{
				if (a[i] == 255)	// player start
				{
					player = new Player(i%256,i/256,tileMap,bullets,missiles);
					this.add(player);
					FlxG.follow(player, 2.5);
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
				}
				if (a[i] == 254)	// KITTY!!
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					kitty = new Kitty(i % 256, i / 256);
					this.add(kitty);
				}
				if (a[i] == 24)	// Drippazorg
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					enemies.push(this.add(new Drip(i % 256, i / 256, a, bombs, player)));
				}
				if (a[i] == 3)	// sideways walkers
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					enemies.push(this.add(new Alien(i % 256, i / 256, tileMap)));
				}
				if (a[i] == 10)	// flyers
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					enemies.push(this.add(new Alien2(i % 256, i / 256, a)));
				}
				if (a[i] == 14)	// big boss
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					enemies.push(this.add(new Boss(i % 256, i / 256, a,bombs,player)));
				}
				if (a[i] == 20)	// tall guy
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					enemies.push(this.add(new AlienTall(i % 256, i / 256, tileMap)));
				}
				if (a[i] == 21)	// ouchtopus
				{
					a[i] = 0;
					tileMap.setTileByIndex(i, 0);
					enemies.push(this.add(new Ouchtopus(i % 256, i / 256,bombs)));
				}
				if (a[i] == 50)	// check to see about making it a big one
				{
					if ((i%2)==0 && (i % 256) < 255 && a[i + 1] == 50 && (i / 256) < 255 && a[i + 256] == 50 && a[i + 256 + 1] == 50)	// this is the upper left of a square of these
					{
						if (Math.random() < (ConfigState.LargeBlockFactor / 100))
						{
							a[i] = 51;
							a[i + 1] = 52;
							a[i + 256] = 53;
							a[i + 256 + 1] = 54;
							tileMap.setTileByIndex(i, 51);
							tileMap.setTileByIndex(i+1, 52);
							tileMap.setTileByIndex(i+256, 53);
							tileMap.setTileByIndex(i+256+1, 54);
						}
					}
				}
			}
			
			FlxG.followAdjust(0.5,0.0);
			tileMap.follow();
			FlxG.log("Done");
		}
		
		public function TimerText():void
		{
			var s:String;
			
			var m:int = int(timer / 60);
			
			if (timer < 0) timer = 0;
			s = m.toString();
			s += ":";
			if (timer % 60 < 10) {
				s += "0";
			}
			s += int(timer % 60).toString();
			timerTxt.text = s;
			timerTxt.x = Math.abs( FlxG.scroll.x) - 38;
			timerTxt.y = Math.abs( FlxG.scroll.y);//player.y + 10;
		}
		
		override public function create()
		{
			FlxG.log("PlayState opened");
			
			bg = new Background();
			add(bg);
			
			enemies = new Array();
			bullets = new Array();
			missiles = new Array();
			bombs = new Array();
				
			timer = 0;
			LoadMap();
			timerTxt = new FlxText(0, 0, 100, "0:00", 0xffffffff, null, 8, "center");
			if (ConfigState.Timer) add(timerTxt);
			TimerText();
			
			for (var i:int = 0; i < 20; i++)
				bullets.push(this.add(new Laser()));
			for (i = 0; i < 20; i++)
				missiles.push(this.add(new Missile(tileMap)));
			for (i= 0; i < 20; i++)
				bombs.push(this.add(new Bomb()));
			
		}
		
		private function LaserShotGuy(laser:FlxSprite,guy:FlxSprite):void
		{
			laser.hurt(0);
			guy.hurt(1);
			var justdied:Boolean = false;
			if (guy is Alien) justdied = Alien(guy).justdied;
			if (guy is Alien2) justdied = Alien2(guy).justdied;
			if (justdied) timer -= ConfigState.KillBonus;
		}
		
		private function MissileShotGuy(missile:FlxSprite,guy:FlxSprite):void
		{
			missile.hurt(0);
			guy.hurt(5); //Not sure what this value should be
			var justdied:Boolean = false;
			if (guy is Alien) justdied = Alien(guy).justdied;
			if (guy is Alien2) justdied = Alien2(guy).justdied;
			if (justdied) timer -= ConfigState.KillBonus;
		}

		private function PlayerBumped(enemy:FlxSprite, player:FlxSprite):void
		{
			Player(player).Die();
		}
		
		public override function update():void
		{
			super.update();
			tileMap.collide(player);
			tileMap.collideArray(enemies);
			tileMap.collideArray(bullets);
			tileMap.collideArray(missiles);
			tileMap.collideArray(bombs);
			FlxG.overlapArray(bombs, player, PlayerBumped);
			FlxG.overlapArrays(bullets, enemies, LaserShotGuy);
			FlxG.overlapArrays(missiles, enemies, MissileShotGuy);
			FlxG.overlapArray(enemies, player, PlayerBumped);
			if (Math.abs(player.x - kitty.x) < 30 && Math.abs(player.y - kitty.y) < 30)
			{
				TimerText();
				WinState.time = "Your time: " + timerTxt.text;
				FlxG.switchState(WinState);
			}
			if (FlxG.keys.justPressed("R")) {
				player.Die();
			}
				
			if (player.x > kitty.x) {
				kitty.facing = FlxSprite.RIGHT;
			} else if (player.x < kitty.x) {
				kitty.facing = FlxSprite.LEFT;
			}
			
			if (FlxG.keys.justPressed("Q")) {
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 0.5, onFade);
				FlxG.play(dieSnd);
			}
			timer += FlxG.elapsed;
			TimerText();
			
			if (player.justdied) {
				player.justdied = false;
				timer += ConfigState.DeathPenalty;
			}
		}
		
		private function onFade():void {
			FlxG.switchState(TitleState);
		}
	}
	
}