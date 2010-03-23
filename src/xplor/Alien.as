package xplor 
{
	import org.flixel.*;
	
	public class Alien extends FlxSprite
	{
		[Embed(source="../../data/alien.png")]
		protected var AlienImage:Class;
  
		[Embed(source="../../data/blast.png")]
		protected var BlastImage:Class;
  
		[Embed(source="../../data/aliendie.mp3")] 
		protected var dieSnd:Class;
		[Embed(source="../../data/alienhit.mp3")] 
		protected var hitSnd:Class;
		
		protected static const SPEED:Number = 20;
		protected static const HEALTH:int = 5;
		protected var map:FlxTilemap;
		protected var boom:FlxEmitter;
		public var justdied:Boolean;
		
		public function Alien(x:int,y:int,map:FlxTilemap) 
		{
			super(AlienImage, x*16, y*16, true,true);
   
			this.map = map;
			addAnimation("walk", [0, 1, 2, 3], 12, true);
			play("walk");
			health = ConfigState.RedAlienHealth;
			velocity.x = ConfigState.RedAlienSpeed;
			
			boom = FlxG.state.add(new FlxEmitter(0,0,10,10,null,-1,-60,60,-60,
				60,-720,720,10,0,BlastImage,8,true)) as FlxEmitter;
		}
		
		public override function update():void
		{
			var xx:int,yy:int;
			
			super.update();
			
			xx = this.x + 8 + velocity.x/5;
			yy = this.y + 16;
			xx /= 16;
			yy /= 16;
			
			if (map.getTile(xx, yy) <50)	// can't go, would fall
			{
				velocity.x = -velocity.x;
			}
			if (velocity.x > 0)
				facing = RIGHT;
			else
				facing = LEFT;
		}

		override public function hurt(dmg:Number):void
		{
			super.hurt(dmg);
			if (dead)
			{
				FlxG.play(dieSnd);
				boom.x = x +width / 2;
				boom.y = y + height / 2;
				boom.restart();
				justdied = true;
				return;
			}
			else
				FlxG.play(hitSnd);
			velocity.x = -velocity.x;
			if (velocity.x > 0)
				facing = RIGHT;
			else
				facing = LEFT;
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