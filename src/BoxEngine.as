package  
{
	
import flash.geom.Rectangle;
import flash.utils.Dictionary;
	
	
	import starling.core.Starling;
	import starling.display.Sprite;
	

	
	
	
	import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
	
	/**
	 * ...
	 * @author djoker
	 */
	public class BoxEngine extends Sprite
	{
		public var timeStep:Number = 1 / 20;
		public var velocityIterations:uint = 8;
		public var positionIterations:uint = 8;
		
		private var entities:Vector.<Body>;
		public var tempMembers:Vector.<Body>;
		
		private var bound:Rectangle;
		
		
        public var ptm_ratio:Number = 30;
		public var dict:Dictionary;
		

		

		public var debugDraw:b2DebugDraw ;
        public var world:b2World;
        private var worldScale:int = 30;
		
		//public var container:Sprite;

       
		private var M2P:int=20;
        private var P2M:int = 1 / M2P;

		
		
		public function BoxEngine(world_posx:Number,world_posy:Number,World_width:Number,World_height:Number) 
		{
			super();
    		world = new b2World(new b2Vec2(0, 15), true);
            debugDraw = new b2DebugDraw();
            debugDraw.SetDrawScale(worldScale);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
            debugDraw.SetFillAlpha(0.3);
            world.SetDebugDraw(debugDraw);
		//	container = new Sprite();
			entities = new Vector.<Body>;
			tempMembers = new Vector.<Body>;
			bound = new Rectangle(world_posx, world_posy, World_width, World_height);
			PhysicsData();
		}
	public function remove(entity:Body):void
	 {
			var index:uint = entities.indexOf(entity);
			if (index >= 0) 
			{
				entities.splice(index, 1);
			}
			removeChild(entity.sprite);
			
	}
	public function Scroll(body:Body)
	{
		x = (bound.x) - body.GetX();
		y = (bound.y) - body.GetX();
		
		
		//	if (x >= 0) x = 0;
		//	if (x <= -360) x = -360;
		
		
		
		
	}
	
	public function update():void 
	{
		/*
		var i:int;
		var max:int;
		var bd:Body;
		if (entities.length > 0 )
		{
			i = 0;
			max = entities.length;
			do 
            { 
				
				bd = entities[i];
				if (!bd.active)
				{
					remove(bd);
					max--;
				} else
				{
					bd.update();
					i++;
				}
     
            } while (i >= max); 
			
		}
		
		*/
			for (var i:uint = 0; i < entities.length; i++) 
			{
				var entity:Body = entities[i];

			//	if (!entity.active) 
		//		{
			//		continue;
		//		}

				entity.update();
		
			}
			
	}
			public function cleanup():void
			{
			tempMembers.length = 0;
			for (var i:uint = 0; i < entities.length; i++) {
				var entity:Body = entities[i];
				if (entity != null && !entity.active) {
					tempMembers.push(entity);
				}
			}
			
			var temp:Vector.<Body> = entities;
			entities = tempMembers;
			tempMembers = temp;
		}
		
		public function addBody(bd:Body ):void
		{
				addChild(bd.sprite);
				entities.push(bd);
		}
			
		public function Con2B2D(num:Number):Number
		{
			return num / worldScale;
		}
	
		public function ConFromB2D(num:Number):Number
		{
			return num * worldScale;
		}
		
		public function Update(debug:Boolean)
		{
			
		world.Step(timeStep, velocityIterations, positionIterations);
    	world.ClearForces();
        if (debug) world.DrawDebugData();
		update();
		}

	
   	public function CreateBox(x:Number, y:Number, width:Number, height:Number, is_dynamic:Boolean, density:Number = 1, friction:Number=.5, fixed_rotation:Boolean = false, name:String="" ):b2Body
		{
			//first tranfer all the pixel units into box2d units
			x = Con2B2D(x);
			y = Con2B2D(y);
			width = Con2B2D(width);
			height = Con2B2D(height);
			
			var box_body:b2BodyDef = new b2BodyDef();
			//NEW
			box_body.fixedRotation = fixed_rotation;
			
			
			box_body.position.Set(x+width/2, y+height/2); //NOTE: box2d sets the position of the center of an object, not the top left like normal. So we have to add the middle (width/2, height/2) to the position to position where we actually want to have it
			
			if (is_dynamic)
				box_body.type = b2Body.b2_dynamicBody;
			
			var box_poly_shape:b2PolygonShape = new b2PolygonShape();
			box_poly_shape.SetAsBox(width / 2, height / 2);
			var box_fixture:b2FixtureDef = new b2FixtureDef();
			box_fixture.shape = box_poly_shape;
			box_fixture.density = density;
			box_fixture.friction = friction;
			
			//to store a custom value to a box2d object, you set it's fixture's "userData"- in this case so we can tell an object by it's name string
			box_fixture.userData = {name:name}
			var world_box_body:b2Body = world.CreateBody(box_body);
			world_box_body.CreateFixture(box_fixture);
			
			return world_box_body;
		}

   public function CreateWorldBounds(w:int, h:int)
   {
	   CreateBox(0, h, w, 50, false);
	

	}
	 public function PhysicsData(): void
		{
			dict = new Dictionary();
			

			dict["trunck"] = [

										[
											// density, friction, restitution
                                            2, 0, 0,
                                            // categoryBits, maskBits, groupIndex, isSensor
											1, 65535, 0, false,
											'POLYGON',
											[

                                                [   new b2Vec2(262.040802001953/ptm_ratio, 50.1224517822266/ptm_ratio)  ,  new b2Vec2(259.591827392578/ptm_ratio, 69.3061218261719/ptm_ratio)  ,  new b2Vec2(228.979583740234/ptm_ratio, 74.2040824890137/ptm_ratio)  ,  new b2Vec2(168.979583740234/ptm_ratio, 72.5714282989502/ptm_ratio)  ,  new b2Vec2(201.224487304688/ptm_ratio, 19.1020431518555/ptm_ratio)  ,  new b2Vec2(240.816314697266/ptm_ratio, 23.5918350219727/ptm_ratio)  ,  new b2Vec2(260/ptm_ratio, 30.9387741088867/ptm_ratio)  ] ,
                                                [   new b2Vec2(168.979583740234/ptm_ratio, 72.5714282989502/ptm_ratio)  ,  new b2Vec2(123.26530456543/ptm_ratio, 98.693877696991/ptm_ratio)  ,  new b2Vec2(102.448974609375/ptm_ratio, 72.9795932769775/ptm_ratio)  ,  new b2Vec2(83.673469543457/ptm_ratio, 47.673469543457/ptm_ratio)  ,  new b2Vec2(84.0816345214844/ptm_ratio, 26.4489822387695/ptm_ratio)  ,  new b2Vec2(94.6938781738281/ptm_ratio, -0.081634521484375/ptm_ratio)  ,  new b2Vec2(174.285705566406/ptm_ratio, -0.489791870117188/ptm_ratio)  ,  new b2Vec2(201.224487304688/ptm_ratio, 19.1020431518555/ptm_ratio)  ] ,
                                                [   new b2Vec2(123.26530456543/ptm_ratio, 98.693877696991/ptm_ratio)  ,  new b2Vec2(168.979583740234/ptm_ratio, 72.5714282989502/ptm_ratio)  ,  new b2Vec2(147.346939086914/ptm_ratio, 99.1020407676697/ptm_ratio)  ] ,
                                                [   new b2Vec2(5.71428537368774/ptm_ratio, 47.265308380127/ptm_ratio)  ,  new b2Vec2(1.63265299797058/ptm_ratio, 71.7551040649414/ptm_ratio)  ,  new b2Vec2(2.44897961616516/ptm_ratio, 28.0816345214844/ptm_ratio)  ,  new b2Vec2(5.71428537368774/ptm_ratio, 27.2653045654297/ptm_ratio)  ] ,
                                                [   new b2Vec2(83.673469543457/ptm_ratio, 47.673469543457/ptm_ratio)  ,  new b2Vec2(102.448974609375/ptm_ratio, 72.9795932769775/ptm_ratio)  ,  new b2Vec2(1.63265299797058/ptm_ratio, 71.7551040649414/ptm_ratio)  ,  new b2Vec2(5.71428537368774/ptm_ratio, 47.265308380127/ptm_ratio)  ] ,
                                                [   new b2Vec2(94.6938781738281/ptm_ratio, -0.081634521484375/ptm_ratio)  ,  new b2Vec2(84.0816345214844/ptm_ratio, 26.4489822387695/ptm_ratio)  ,  new b2Vec2(89.7959136962891/ptm_ratio, 6.04081726074219/ptm_ratio)  ]
											]
										]

									];

		}
	
	}
}