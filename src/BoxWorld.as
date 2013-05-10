package  
{

	 import flash.ui.Keyboard;
	 import flash.display.BitmapData;
	 import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	

    import flash.geom.Point;
	import flash.utils.getTimer;
     
    import starling.animation.Juggler;
    import starling.core.Starling;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.*;
	import starling.textures.Texture;
    import starling.textures.TextureAtlas;
	 import starling.display.Image;
	 

	import Box2D.Collision.b2WorldManifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2ContactEdge;


	/**
	 * ...
	 * @author djoker
	 */

    public class BoxWorld extends Sprite {
		
		[Embed(source = "assets/control_knob.png")]
        private var pl_image:Class;

	  public var phy:BoxEngine;	
			 
       public var keys_down:Array;
	   

	    public var player:Body;
		public var hero_speed:Number; //the amount we'll add to the impulse of the hero when moving left or right
		public var hero_max_speed:Number; //the maximum amount we will let the hero's linear velocity move sideways (x direction)
		public var jump_speed:Number; //the amount of impulse to make the hero "jump"
		public var hero_size:int; //The hero total width/ height in pixels
		public var hero_normal:b2Vec2; //the normal vector of the hero - which direction and the amount it is colliding with other objects
 
		

        public function BoxWorld() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            
	
	   }

        public override function dispose():void
        {
            
            super.dispose();
        }


		
public function onAddedToStage():void
{
        phy = new BoxEngine(stage.stageWidth * 0.5,0,1000,640);
		phy.debugDraw.SetSprite(Main.debugSprite);
		addChild(phy);


{
	var bd:Body;
	bd = new Body(phy);
	//bd.CreateBoxBitmap(0xffffffff, 0, 470, 2000, 20, false);
	bd.CreateBox( 0, 470, 4000, 20, false);
}

{
	var bd:Body;
	bd = new Body(phy);
	bd.CreateBoxBitmap(0xffffffff, 200, stage.stageHeight - 50 * 4, 50, 50, false);
}

{
	var bd:Body;
	bd = new Body(phy);
	bd.CreateBoxBitmap(0xffffffff, 850, stage.stageHeight - 20 * 4, 80, 20,false);
}

{
	var bd:Body;
	bd = new Body(phy);
	bd.CreateBoxBitmap(0xffffffff, 400, stage.stageHeight - 20 * 4, 80, 20, false);
}
{
	var bd:Body;
	bd = new Body(phy);
	bd.CreateMesh("trunck", 300, 100, true);
}


{
	
	player = new Body(phy);
	player.CreateBoxBitmap(0xffffffff, 200,200, 50, 50, true,1,1,true,"player");
}
			
		


		    hero_speed = 2; 
			hero_max_speed = 4;
			hero_normal = new b2Vec2(0, 0);
			jump_speed = 16;
	
			keys_down = new Array();
			
	
			
			

		
		this.stage.addEventListener(TouchEvent.TOUCH, onTouch);
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		
}
 
//
public function onEnterFrame(event:Event, passedTime:Number):void
{
	phy.Update(true);
	
	var pos_x:Number;
	var pos_y:Number;

	
	if (KeyIsDown(Keyboard.A))
	{
	    	var bmp1:Bitmap = new pl_image();
			var bd:Body = new Body(phy);
			bd.CreateCircleImage(Texture.fromBitmap(bmp1), 200, 10,0.19,true);
			
	}
			
			
	    if (hero_normal.x >= 0) 
				if (KeyIsDown(Keyboard.LEFT))
					if (player.GetLinearVelocityX() > - hero_max_speed) 	player.ApplyImpulseCenter( -hero_speed, 0);
 
			if (hero_normal.x <= 0)			
				if (KeyIsDown(Keyboard.RIGHT))
					if (player.GetLinearVelocityY() <  hero_max_speed)	player.ApplyImpulseCenter( hero_speed, 0);
						
 
			hero_normal.x = 0;
			hero_normal.y = 0;
			var can_jump:Boolean = false;
			var edge:b2ContactEdge = player.bd.GetContactList(); //get all the objects the hero is contacting with
			while (edge)
				{
					var a:b2WorldManifold = new b2WorldManifold();
					edge.contact.GetWorldManifold(a);
					var normal1:b2Vec2 = a.m_normal;	
					if (edge.contact.IsTouching())
					{	
						
						if (normal1.y >0) //if the normal is positive/ the hero is being pushed up/ sitting on top of another object
						{
							
							var bodya:Body=Body(edge.contact.GetFixtureA().GetUserData());
							var bodyb:Body=Body(edge.contact.GetFixtureB().GetUserData());
							
							if ( bodya.name == "player")
							{
							can_jump = true;
							}
							
						//	if ( bodyb.name == "enemy")
						//	{
								//player.bd.SetLinearVelocity(new b2Vec2(hero_box.GetLinearVelocity().x, -jump_speed / 2));
						//	}
						}
						//if the hero is touching an enemy on the side, re-spawn him
						//if (normal1.x !=0)
						//	if (edge.contact.GetFixtureB().GetUserData().name == "enemy"||edge.contact.GetFixtureA().GetUserData().name == "enemy")
							//	hero_box.SetPosition(new b2Vec2(phy.Con2B2D(100), phy.Con2B2D(100)));
								
						hero_normal = normal1;						
					}	
					edge = edge.next;
				}
			
			if(can_jump)
				if (KeyIsDown(Keyboard.SPACE))
						player.ApplyImpulseCenter(0,  -jump_speed);
				
			

				
	//phy.Scroll(player);
	
		phy.x= (stage.stageWidth * 0.5) - player.GetX();
		Main.debugSprite.x = (stage.stageWidth * 0.5) - player.GetX();
				
			

		//	if (x >= 0) x = 0;
		//	if (x <= -360) x = -360;
			
		
			
				
}

 public function KeyIsDown(keycode:int):Boolean
		{
			for (var i in keys_down)
				if (keys_down[i] == keycode)
					return true;
			return false;
		}
public function onKeyUp(event:Event, keyCode:uint):void
{
            var pos:int = -1;
			for (var i in keys_down)
				if (keys_down[i] == keyCode)
				{
					pos = i;
					break;
				}

			keys_down.splice(pos,1);		
}
public function onKeyDown(event:Event, keyCode:uint):void
{
	for (var i in keys_down)
				if (keys_down[i] == keyCode)
					return; 
			keys_down.push(keyCode);	
}

private function onTouch(event:TouchEvent):void
{

    var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
    if (touch)
    {
        var localPos:Point = touch.getLocation(this);
        trace("Touched object at position: " + localPos);
    }
}

		
		
    }
}