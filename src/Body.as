package  
{
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Box2D.Common.b2Settings;
	import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;

	import starling.textures.Texture;
    import starling.display.Image;
	
	
	/**
	 * ...
	 * @author djoker
	 */
	public class Body 
	{
		private var worldScale:int = 30;
		public var radToDeg:Number = 180 / Math.PI;
		public var degToRad:Number = Math.PI / 180;
		
		private var engine:BoxEngine;
		public var active:Boolean;
		public var bd:b2Body;
	    public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public var sprite:Image;
		public var name:String;
		
		public function Body(world:BoxEngine) 
		{
			engine = world;
			active = true;
			
		}
		public function CreateBox( px:Number, py:Number, pwidth:Number, pheight:Number, is_dynamic:Boolean, density:Number = 1, friction:Number = .5, fixed_rotation:Boolean = false, fname:String = "" ):void
		{
			this.name = fname;
			this.x = Con2B2D(px);
			this.y = Con2B2D(py);
			this.width = Con2B2D(pwidth);
			this.height = Con2B2D(pheight);
			
			var box_body:b2BodyDef = new b2BodyDef();
			box_body.fixedRotation = fixed_rotation;
			box_body.position.Set(x+width/2, y+height/2); //NOTE: box2d sets the position of the center of an object, not the top left like normal. So we have to add the middle (width/2, height/2) to the position to position where we actually want to have it
			
			if (is_dynamic)		box_body.type = b2Body.b2_dynamicBody;
			
			var box_poly_shape:b2PolygonShape = new b2PolygonShape();
			box_poly_shape.SetAsBox(width / 2, height / 2);
			var box_fixture:b2FixtureDef = new b2FixtureDef();
			box_fixture.shape = box_poly_shape;
			box_fixture.density = density;
			box_fixture.friction = friction;
			
			
			box_fixture.userData = this;
			bd = engine.world.CreateBody(box_body);
			bd.CreateFixture(box_fixture);
			
	
			
		   // engine.addBody(this);
			
	    }
		public function CreateBoxBitmap(color:int, px:Number, py:Number, pwidth:Number, pheight:Number, is_dynamic:Boolean, density:Number = 1, friction:Number = .5, fixed_rotation:Boolean = false, fname:String = "" ):void
		{
			this.name = fname;
			this.x = Con2B2D(px);
			this.y = Con2B2D(py);
			this.width = Con2B2D(pwidth);
			this.height = Con2B2D(pheight);
			
			var box_body:b2BodyDef = new b2BodyDef();
			box_body.fixedRotation = fixed_rotation;
			box_body.position.Set(x+width/2, y+height/2); //NOTE: box2d sets the position of the center of an object, not the top left like normal. So we have to add the middle (width/2, height/2) to the position to position where we actually want to have it
			
			if (is_dynamic)		box_body.type = b2Body.b2_dynamicBody;
			
			var box_poly_shape:b2PolygonShape = new b2PolygonShape();
			box_poly_shape.SetAsBox(width / 2, height / 2);
			var box_fixture:b2FixtureDef = new b2FixtureDef();
			box_fixture.shape = box_poly_shape;
			box_fixture.density = density;
			box_fixture.friction = friction;
			
			
			box_fixture.userData = this;
			bd = engine.world.CreateBody(box_body);
			bd.CreateFixture(box_fixture);
			
			
			var debugBitmapData:BitmapData = new BitmapData(pwidth,pheight, true, color);
			sprite = new Image(Texture.fromBitmapData(debugBitmapData));
			sprite.x= x;
			sprite.y =y;
			sprite.pivotX = pwidth/2;
			sprite.pivotY = pheight / 2;
			
		    engine.addBody(this);
			
	    }
	
		public function CreateCircleBitmap(color:int, px:Number, py:Number, rad:Number, is_dynamic:Boolean, density:Number = 1, friction:Number = .5, fixed_rotation:Boolean = false, fname:String = "" ):void
		{
			this.name = fname;
			this.x = Con2B2D(px);
			this.y = Con2B2D(py);
			this.width = Con2B2D(rad*2);
			this.height = Con2B2D(rad*2);
			
				
			
			var box_body:b2BodyDef = new b2BodyDef();
			box_body.fixedRotation = fixed_rotation;
			box_body.position.Set(x+width/2, y+height/2); //NOTE: box2d sets the position of the center of an object, not the top left like normal. So we have to add the middle (width/2, height/2) to the position to position where we actually want to have it
			
			if (is_dynamic)		box_body.type = b2Body.b2_dynamicBody;
			
			//var box_poly_shape:b2PolygonShape = new b2PolygonShape();
			//box_poly_shape.SetAsBox(width / 2, height / 2);
			var box_poly_shape:b2CircleShape = new b2CircleShape(Con2B2D(rad));
				
			var box_fixture:b2FixtureDef = new b2FixtureDef();
			box_fixture.shape = box_poly_shape;
			box_fixture.density = density;
			box_fixture.friction = friction;
			
			
			box_fixture.userData = this;
			bd = engine.world.CreateBody(box_body);
			bd.CreateFixture(box_fixture);
			
			
			var debugBitmapData:BitmapData = new BitmapData(rad * 2, rad * 2, true, color);
			
			
			sprite = new Image(Texture.fromBitmapData(debugBitmapData));
			sprite.x= x;
			sprite.y =y;
			sprite.pivotX = (rad * 2)/2;
			sprite.pivotY = (rad * 2)/ 2;
			
		    engine.addBody(this);
			
	    }
	
		public function CreateBoxImage(tex:Texture, px:Number, py:Number,  is_dynamic:Boolean, density:Number = 1, friction:Number = .5, fixed_rotation:Boolean = false, name:String = "" ):void
		{
			
			sprite = new Image(tex);
			sprite.x=px;
			sprite.y=py;
			sprite.pivotX = sprite.width/2;
			sprite.pivotY = sprite.height/2;
			engine.addBody(this);
			
			this.name = name;
			this.x = Con2B2D(px);
			this.y = Con2B2D(py);
			this.width = Con2B2D(sprite.width);
			this.height = Con2B2D(sprite.height);
			
			var box_body:b2BodyDef = new b2BodyDef();
			box_body.fixedRotation = fixed_rotation;
			box_body.position.Set(x+width/2, y+height/2); 
			
			if (is_dynamic)		box_body.type = b2Body.b2_dynamicBody;
			
			var box_poly_shape:b2PolygonShape = new b2PolygonShape();
			box_poly_shape.SetAsBox(width / 2, height / 2);
			var box_fixture:b2FixtureDef = new b2FixtureDef();
			box_fixture.shape = box_poly_shape;
			box_fixture.density = density;
			box_fixture.friction = friction;
			
			
			box_fixture.userData = this;
			bd = engine.world.CreateBody(box_body);
			bd.CreateFixture(box_fixture);
			
			engine.addBody(this);
			
			
			
	    }
	
		public function CreateCircleImage(tex:Texture, px:Number, py:Number,scle:Number,  is_dynamic:Boolean, density:Number = 1, friction:Number = .5, fixed_rotation:Boolean = false, fname:String = "" ):void
		{
			
			sprite = new Image(tex);
			sprite.x=px;
			sprite.y=py;
			sprite.pivotX = sprite.width/2;
			sprite.pivotY = sprite.height/2;
			engine.addBody(this);
			
			var radius:Number = (sprite.width + sprite.height) * scle;

			
			this.name = name;
			this.x = Con2B2D(px);
			this.y = Con2B2D(py);
			this.width = Con2B2D(sprite.width);
			this.height = Con2B2D(sprite.height);
			
			var box_body:b2BodyDef = new b2BodyDef();
			box_body.fixedRotation = fixed_rotation;
			box_body.position.Set(x+width/2, y+height/2); 
			
			if (is_dynamic)		box_body.type = b2Body.b2_dynamicBody;
			
		    var box_poly_shape:b2CircleShape = new b2CircleShape(Con2B2D(radius));
		
			var box_fixture:b2FixtureDef = new b2FixtureDef();
			box_fixture.shape = box_poly_shape;
			box_fixture.density = density;
			box_fixture.friction = friction;
			box_fixture.userData = this;
			bd = engine.world.CreateBody(box_body);
			bd.CreateFixture(box_fixture);
			
			engine.addBody(this);
			
			
			
	    }
	
		public function update():void
		{
			
			x = ConFromB2D(bd.GetPosition().x) ;// -(sprite.width / 2);
			y = ConFromB2D(bd.GetPosition().y) ;// -(sprite.height / 2);
			//sprite.rotation =ConFromB2D( bd.GetAngle()* 180 / Math.PI);
			sprite.rotation = bd.GetAngle();

			
				
			sprite.x=x;
			sprite.y=y;
				
				
			
		}
		
		public function GetX():Number
		{
			return ConFromB2D(bd.GetPosition().x);
		}
		public function GetY():Number
		{
			return ConFromB2D(bd.GetPosition().y);
		}
		
		public function SetX(value:Number):void
		{
				var pos:b2Vec2 = bd.GetPosition();
				pos.x =Con2B2D(value);
				bd.SetTransform(new b2Transform(pos, b2Mat22.FromAngle(bd.GetAngle())));
		

		}
		public function SetY(value:Number):void
		{
			    var pos:b2Vec2 = bd.GetPosition();
				pos.y =Con2B2D(value);
				bd.SetTransform(new b2Transform(pos, b2Mat22.FromAngle(bd.GetAngle())));
		
		}
		
		public function SetLinearVelocity(vx:Number, vy:Number):void
		{
			bd.SetLinearVelocity(new b2Vec2(vx, vy));
		}
		
		public function GetLinearVelocityX():Number
		{
			return  bd.GetLinearVelocity().x;
			
		}
		public function GetLinearVelocityY():Number
		{
			return  bd.GetLinearVelocity().y;
			
		}
		
		public function ApplyImpulseCenter(vx:Number, vy:Number):void
		{
			bd.ApplyImpulse(new b2Vec2( vx, vy),bd.GetWorldCenter());
		}
		
		public function getrotation():Number
		{
				return bd.GetAngle() * 180 / Math.PI;
		}
		
		public function setrotation(value:Number):void
		{
			bd.SetTransform(new b2Transform(bd.GetPosition(), b2Mat22.FromAngle(value * Math.PI / 180)));
		}
		

		
		private function Con2B2D(num:Number):Number
		{
			return num / worldScale;
		}
	
		private function ConFromB2D(num:Number):Number
		{
			return num * worldScale;
		}
		
		
	 	public function CreateMesh(mesh:String,x:Number, y:Number,is_dynamic:Boolean, density:Number = 1, friction:Number=.5, fixed_rotation:Boolean = false, name:String="" ):void
		{
			
			
			x = Con2B2D(x);
			y = Con2B2D(y);
			//width = Con2B2D(width);
			//height = Con2B2D(height);
			
	
			
			
			
			
			var fixtures:Array = engine.dict[mesh];

   
            var f:Number;


            var bodyDef:b2BodyDef = new b2BodyDef();
         	if (is_dynamic)		bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.userData = this;
			bodyDef.position.Set(x, y);
	
					
            bd = engine.world.CreateBody(bodyDef);
            for(f=0; f<fixtures.length; f++)
            {
                var fixture:Array = fixtures[f];

                var fixtureDef:b2FixtureDef = new b2FixtureDef();


                fixtureDef.density=density;
                fixtureDef.friction=friction;


                var p:Number;
                var polygons:Array = fixture[8];
                for(p=0; p<polygons.length; p++)
                {
                    var polygonShape:b2PolygonShape = new b2PolygonShape();
                    polygonShape.SetAsArray(polygons[p], polygons[p].length);
                    fixtureDef.shape=polygonShape;

                    bd.CreateFixture(fixtureDef);
                }
            }

		//	engine.addBody(this);
		}
	
		
	  
	}
}