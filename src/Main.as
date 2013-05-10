package 
{
	import flash.events.Event;
	import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    
    
	import starling.core.Starling;
 
	

		
	[SWF(width="640", height="480", frameRate="60", backgroundColor="#000000")]
	
	public class Main extends Sprite 
	{
		  private var mStarling:Starling;
		  public static var debugSprite:Sprite;
        
        public function Main()
        {
			super();
			debugSprite = new Sprite();
			
            
          stage.align = StageAlign.TOP_LEFT;
		  stage.scaleMode = StageScaleMode.NO_SCALE;
		  
          Starling.handleLostContext = true; // required on Windows, needs more memory
		  Starling.multitouchEnabled = true ;
		  
			
			mStarling = new Starling(BoxWorld, stage);
			//mStarling.simulateMultitouch = true;
			//mStarling.enableErrorChecking = true;
			mStarling.antiAliasing = 1;
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
            mStarling.showStats = true;
			mStarling.start(); 		
            
			


        }
		
		 
		private function onContextCreated(e:Event):void
		{
			addChild(debugSprite);
			
		;
		}
        
     
    }
}


