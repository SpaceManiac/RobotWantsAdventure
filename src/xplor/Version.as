package xplor 
{
	public class Version extends Object
	{
		
		public static var kills:uint = 0;
		public static var v:String = "Hamumu";
		public static var deaths:uint = 0;
		public function Version()
		{
			super();
			return;
		}
		
		public static function GetKill():void
		{
			var loc1:*;
			kills ++;
			if (v == "Gameshed")
			{
				if (kills == 30)
				{
				}
			}
			if (v == "Kong")
			{
			}
			return;
		}
		
		{
			v = "Wombat";
			kills = 0;
			deaths = 0;
		}
	}
}