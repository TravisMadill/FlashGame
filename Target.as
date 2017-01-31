package
{	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Target extends MovieClip
	{
		public function Target(pos:Point)
		{
			super();
			this.x = pos.x;
			this.y = pos.y;
		}
		
		public function occupyingBox():Rectangle{
			return new Rectangle(this.x, this.y, this.width, this.height);
		}
	}
}