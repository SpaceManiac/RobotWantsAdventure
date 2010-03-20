package xplor 
{
	import org.flixel.*;
 
	public class Player extends FlxSprite
	{
		[Embed(source="../../data/player.png")] 
		protected var PlayerImage:Class;
		[Embed(source="../../data/rocket.png")]
		protected var rocketPic:Class;
		
		[Embed(source="../../data/die.mp3")] 
		protected var dieSnd:Class;
		[Embed(source="../../data/jump.mp3")] 
		protected var jumpSnd:Class;
		[Embed(source="../../data/rocket.mp3")] 
		protected var rocketSnd:Class;
		[Embed(source="../../data/powerup.mp3")] 
		protected var powerupSnd:Class;
		[Embed(source="../../data/door.mp3")] 
		protected var doorSnd:Class;
		[Embed(source="../../data/teleport.mp3")] 
		protected var teleportSnd:Class;
		
		protected static const PLAYER_RUN_SPEED:int = 80;
		protected static const GRAVITY_ACCELERATION:Number = 420;
		protected static const JUMP_ACCELERATION:Number = 200;
		
		protected static const POWER_JUMP:int = 0;
		protected static const POWER_SHOOT:int = 1;
		protected static const POWER_DOUBLEJUMP:int = 2;
		protected static const POWER_ROCKET:int = 3;
		protected static const POWER_DASH:int = 4;
		protected static const POWER_REDKEY:int = 5;
		protected static const POWER_BLUKEY:int = 6;
		protected static const POWER_GRNKEY:int = 7;
		protected static const POWER_RAPID:int = 8;
		protected static const POWER_MISSILE:int = 9;
		
		public var justdied:Boolean = false;
		protected var powers:Array,bullets:Array,missiles:Array;
		protected var map:FlxTilemap;
		public var startx:int, starty:int;
		protected var reload:int;
		protected var airjump:int;
		protected var rocket:FlxEmitter;
		protected var rocketTime:int;
		protected var timeToDoubleTap:int;
		protected var doubleTapDir:int;
		protected var dashTime:int;
		protected var dashed:Boolean;
		protected var justTeleported:Boolean = false;
		
		public var tx:int, ty:int;
		
		public function Player(x:int,y:int,map:FlxTilemap,bullets:Array,missiles:Array)
		{
			
			startx = x * 16;
			starty = y * 16;
			this.map = map;
			super(PlayerImage, x*16, y*16, true, true);
			this.offset.x = 4;
			this.offset.y = 2;
			this.width = 8;
			this.height = 14;
			drag.x = PLAYER_RUN_SPEED * 8;
			acceleration.y = GRAVITY_ACCELERATION;
			maxVelocity.x = PLAYER_RUN_SPEED;
			maxVelocity.y = 1200;

			addAnimation("idle", [0], 15, true);
			addAnimation("run", [1, 2], 8, true);
			addAnimation("jump", [3], 1, true);
			addAnimation("duck", [4], 0, true);
			addAnimation("dash", [5], 0, true);
			
			powers = new Array();
			this.bullets = bullets;
			this.missiles = missiles;
			reload = 0;
			airjump = 0;
			rocket = FlxG.state.add(new FlxEmitter(0, 0, 5, 5, null, 0.05, -10, 10, 0, 300, 0,0, 600, 5, rocketPic, 12, true)) as FlxEmitter;
			rocket.kill();

			timeToDoubleTap = 0;
			dashTime = 0;
			dashed = false;
			
			if (ConfigState.PowerStart) {
				for (var i:uint = 0; i <= 9; ++i) powers[i] = true;
			}
		}

		public function Die():void
		{
			justdied = true;
			x = startx;
			y = starty;
			velocity.x = 0;
			velocity.y = 0;
			play("idle");
			FlxG.play(dieSnd);
		}
		
		public override function update():void
		{
			var i:int;
			
			if (timeToDoubleTap > 0)
				timeToDoubleTap--;
			if (dashTime)
				dashTime--;
			else
				maxVelocity.x = PLAYER_RUN_SPEED;
				
			if (dashTime == 0) dashed = false;
				
			if (reload)
				reload--;
			if (rocketTime>0)
			{
				rocketTime--;
				if (!rocketTime)
					rocket.active = false;
			}
			
			rocket.x = x+width/2;
			rocket.y = y + height;
			
			acceleration.x = 0;
			if (FlxG.keys.DOWN && velocity.y==0)
			{
				play("duck");
				if (FlxG.keys.justPressed("Z")) //Rocket upwards
				{
					if (powers[POWER_ROCKET] == 1)
					{
						velocity.y = -1200;
						rocket.restart();
						rocketTime = 30;
						FlxG.play(rocketSnd);
					}
					else if(ConfigState.DuckJump || powers[POWER_JUMP])
					{
						velocity.y = -JUMP_ACCELERATION;
						FlxG.play(jumpSnd);
					}
				}
				else if (FlxG.keys.X) //Fire upwards missile
				{
					if (powers[POWER_MISSILE]==1 && reload == 0)
					{
						for each(var m:Missile in missiles)
						{
							var missilespeed:int;
							missilespeed = -200;
							
							if (m.exists == false)
							{
								reload = 50;
								if (powers[POWER_RAPID] == 1) {
									reload = 20;
								}
								m.shoot(x, y, 0, missilespeed);
								break;
							}
						}
					}
				}
			}
			else
			{
				if (powers[POWER_DASH]==1 && FlxG.keys.justPressed("LEFT") && dashTime==0 && dashed==false && (ConfigState.RocketOnFloor || velocity.y!=0))
				{
					if (timeToDoubleTap > 0 && doubleTapDir==LEFT)
					{
						// rocket left
						velocity.y = 0;
						velocity.x = -600;
						maxVelocity.x = 600;
						dashTime = 90;
						FlxG.play(rocketSnd);
						airjump = 1;
						dashed = true;
					}
					else
					{
						timeToDoubleTap = 15;
						doubleTapDir = LEFT;
					}
				}
				if (powers[POWER_DASH]==1 && FlxG.keys.justPressed("RIGHT") && dashTime==0 && dashed==false && (ConfigState.RocketOnFloor || velocity.y!=0))
				{
					if (timeToDoubleTap > 0 && doubleTapDir==RIGHT)
					{
						// rocket right
						velocity.y = 0;
						velocity.x = 600;
						maxVelocity.x = 600;
						dashTime = 90;
						FlxG.play(rocketSnd);
						airjump = 1;
						dashed = true;
					}
					else
					{
						timeToDoubleTap = 15;
						doubleTapDir = RIGHT;
					}
				}
				
				if(FlxG.keys.LEFT)
				{
					facing = LEFT;
					acceleration.x = -drag.x;
				}
				else if(FlxG.keys.RIGHT)
				{
					facing = RIGHT;
					acceleration.x = drag.x;
				}
				if(FlxG.keys.X)
				{
					if (powers[POWER_SHOOT]==1 && reload == 0)
					{
						var shotspeed:int;
						if (facing == LEFT)
							shotspeed = -180;
						else
							shotspeed = 180;
						reload = 30;
						if (powers[POWER_RAPID] == 1)
							reload = 5;
						
						for each(var b:Laser in bullets)
						{
							if (b.exists == false)
							{
								b.shoot(x, y, shotspeed, 0);
								break;
							}
						}
					}
				}
				if(FlxG.keys.justPressed("Z"))
				{
					if (powers[POWER_JUMP] == 1 && !velocity.y)
					{
						velocity.y = -JUMP_ACCELERATION;
						FlxG.play(jumpSnd);
					}
					else if (powers[POWER_DOUBLEJUMP] == 1 && airjump == 0)
					{
						airjump = 1;
						FlxG.play(jumpSnd);
						velocity.y = -JUMP_ACCELERATION;
					}
				}
				if (velocity.y == 0)
				{
					if(velocity.x == 0)
					{
						play("idle");
					}
					else
					{
						play("run");
					}
				}
			}
			
			tx = (x + 4) / 16;
			ty = (y + 8) / 16;
			var tile:uint = map.getTile(tx, ty);
			if (tile == 4)	// jump power!
			{
				map.setTile(tx, ty, 0);
				powers[POWER_JUMP] = 1;
				FlxG.play(powerupSnd);
			}
			else if (map.getTile(tx,ty) == 30)	// checkpoint!
			{
				if (map.getTile(int(startx / 16), int(starty / 16)) == 31)
				{
					map.setTile(int(startx / 16), int(starty / 16), 30);
				}
				startx = tx * 16 + 4;
				starty = ty * 16 + 2;
				map.setTile(tx, ty, 31);
				//PlayState(FlxG.state).SetHelp(x, y, "Robot Pattern Encorded!");
			}
			else if (tile == 5)	// shoot power!
			{
				map.setTile(tx, ty, 0);
				powers[POWER_SHOOT] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 6)	// deadly acid
			{
				Die();
			}
			else if (tile == 7)	// double jump power
			{
				map.setTile(tx, ty, 0);
				powers[POWER_DOUBLEJUMP] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 8)	// rocket jump power
			{
				map.setTile(tx, ty, 0);
				powers[POWER_ROCKET] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 9)	// dash power
			{
				map.setTile(tx, ty, 0);
				powers[POWER_DASH] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 11)	// red key
			{
				map.setTile(tx, ty, 0);
				powers[POWER_REDKEY] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 12)	// green key
			{
				map.setTile(tx, ty, 0);
				powers[POWER_GRNKEY] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 13)	// blue key
			{
				map.setTile(tx, ty, 0);
				powers[POWER_BLUKEY] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 15)	// rapid fire
			{
				map.setTile(tx, ty, 0);
				powers[POWER_RAPID] = 1;
				FlxG.play(powerupSnd);
			}
			else if (tile == 19)	// Missiles
			{
				map.setTile(tx, ty, 0);
				powers[POWER_MISSILE] = 1;
				FlxG.play(powerupSnd);
			}
			
			if (tile == 16 || tile == 17 || tile == 18) // green, blue, red teleporters
			{
				if (!justTeleported) {
					justTeleported = true;
					teleportToNearest(tile, tx, ty);
				}
			}
			else
			{
				justTeleported = false;
			}
			
			if(velocity.y != 0 && dashTime==0)
			{
				play("jump");
			}
			else if (dashTime)
				play("dash");
			
			super.update();
		}
		
		private function teleportToNearest(tile:uint, tx:uint, ty:uint):void {
			FlxG.log("Teleporting");
			var shortestDistance:Number = -1;
			var destx:uint = 256;
			var desty:uint = 256;
			
			for (var x:uint = 0; x < map.widthInTiles; ++x) {
				for (var y:uint = 0; y < map.heightInTiles; ++y) {
					if (x == tx && y == ty) continue;
					if (map.getTile(x, y) == tile) {
						var dx:int = tx - x;
						var dy:int = ty - y;
						var dist:Number = Math.sqrt(dx * dx + dy * dy);
						if (dist < shortestDistance || shortestDistance == -1) {
							destx = x;
							desty = y;
							shortestDistance = dist;
						}
					}
				}
			}
			
			if (destx != 256 && desty != 256) {
				this.x = destx * 16 + 4;
				this.y = desty * 16 + 1;
				this.velocity.x = 0;
				this.velocity.y = 0;
				FlxG.play(teleportSnd);
				FlxG.scroll.x = this.x;
				FlxG.scroll.y = this.y; 
			}
		}

		override public function hitFloor(Contact:FlxCore = null):Boolean 
		{
			velocity.y = 0; 
			airjump = 0;
			if(!ConfigState.RocketOnFloor) {
				dashTime = 0;
				dashed = false;
			}
			return true;
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			var tx:int, ty:int;
			
			if(facing==RIGHT)
				tx = (x + 8) / 16;
			else
				tx = (x - 8) / 16;
			ty = (y + 8) / 16;
			/*if (velocity.x > 0)
				tx++;
			else
				tx--;
				*/
			if (map.getTile(tx, ty) == 55 && powers[POWER_REDKEY]==1)	// red door
			{
				map.setTile(tx, ty, 0);
				FlxG.play(doorSnd);
			}
			if (map.getTile(tx, ty) == 56 && powers[POWER_GRNKEY]==1)	// green door
			{
				map.setTile(tx, ty, 0);
				FlxG.play(doorSnd);
			}
			if (map.getTile(tx, ty) == 57 && powers[POWER_BLUKEY]==1)	// blue door
			{
				map.setTile(tx, ty, 0);
				FlxG.play(doorSnd);
			}
			super.hitWall(Contact);
			return true;
		}
		
	}
}