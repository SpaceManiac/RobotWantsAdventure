package xplor 
{
	import org.flixel.*;
	
	public class Boss extends FlxSprite
	{
		[Embed(source="../../data/boss.png")]
		protected var AlienImage:Class;
  
		[Embed(source="../../data/blast.png")]
		protected var BlastImage:Class;
  
		[Embed(source="../../data/bossdie.mp3")] 
		protected var dieSnd:Class;
		[Embed(source="../../data/bosshit.mp3")] 
		protected var hitSnd:Class;
		
		protected static const SPEED:Number = 20;
		protected static const HEALTH:int = 50;
		protected var map:Array;
		protected var boom:FlxEmitter;
		protected var bombs:Array;
		protected var reload:int;
		protected var player:Player;
		private var justhit:Boolean = false;
		
		private var healthbar:HealthBar = null;
		
		public function Boss(x:int,y:int,map:Array,bombs:Array,player:Player) 
		{
			super(AlienImage, x * 16, y * 16, true, true);
   
			this.player = player;
			this.bombs = bombs;
			this.map = map;
			addAnimation("chomp", [0, 1, 2, 3,2,1], 5, true);
			play("chomp");
			health = ConfigState.BossHealth;
			velocity.x = ConfigState.BossSpeed;
			acceleration.y = 420;
			
			this.offset.x = 0;
			this.offset.y = 28;
			this.width = 64;
			this.height = 34;
		
			reload = 30;
			boom = FlxG.state.add(new FlxEmitter(0,28,64,34,null,-3,-60,60,-60,
				60, -720, 720, 10, 0, BlastImage, 30, true)) as FlxEmitter;
		}
		
		public override function update():void
		{
			justhit = false;
			var xx:int,yy:int;
			
			//if (player.x<x-240 || player.x>x+240 || player.y<y-180 || player.y>y+180)
				//return;	// inactive when player is away!
				
			if (reload)
				reload--;
				
			if (healthbar == null) {
				healthbar = new HealthBar(this.x, this.y, ConfigState.BossHealth, 64);
				FlxG.state.add(healthbar);
			}
			
			healthbar.x = this.x;
			healthbar.y = this.y - 10;
			healthbar.current = this.health;
				
			xx = x + width / 2;
			yy = y + height / 2;
			
			super.update();
			
			if (reload == 0)
			{
				reload = 90;
				for each(var b:Bomb in bombs)
				{
					if (b.exists == false)
					{
						b.shoot(xx, yy, -120, -200);
						break;
					}
				}
				for each(b in bombs)
				{
					if (b.exists == false)
					{
						b.shoot(xx, yy, 120, -200);
						break;
					}
				}
			}
		}

		override public function hurt(dmg:Number):void
		{
			super.hurt(dmg);
			if (dead)
			{
				healthbar.exists = false;
				FlxG.play(dieSnd);
				boom.x = x + width / 2;
				boom.y = y + height / 2;
				boom.restart();
				return;
			}
			else
				FlxG.play(hitSnd);
		}
		
		public override function hitWall(Contact:FlxObject=null):Boolean
		{
			this.velocity.x = -this.velocity.x;
			if (velocity.x > 0)
				facing = RIGHT;
			else
				facing = LEFT;
			return true;
		}

	}
	
}