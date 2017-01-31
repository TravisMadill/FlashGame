package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class customBtn extends SimpleButton
	{
		public var txtBox:TextField = new TextField();
		
		public function customBtn(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			
			//Set the formatting for the textbox
			var formatting:TextFormat = new TextFormat();
			formatting.size = 15;
			formatting.align = TextFormatAlign.CENTER;
			txtBox.defaultTextFormat = formatting;
		}
		
		//Creates a new custom button using the point given and the string given
		//The textbox must be added manually by the stage
		function initBtn(pos:Point, msg:String){
			this.x = pos.x;
			this.y = pos.y;
			this.txtBox.text = msg;
			this.txtBox.x = pos.x + 20;
			this.txtBox.y = pos.y + 10;
		}
	}
}