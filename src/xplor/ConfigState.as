package xplor
{
	// this is just a skeleton, since we don't actually need real configuration menus
    public class ConfigState
    {
		public static const CNT_C:int = 0;
		public static const CNT_DT:int = 1;
		public static var Controls:int = 0; // 0 = C/Duck-C, 1 = Double-tap/Duck-jump
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
		
		public static var testing:int = 0;
    }
}