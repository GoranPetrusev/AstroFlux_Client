package core.states.ship
{
   import core.particle.Emitter;
   import core.particle.EmitterFactory;
   import core.scene.Game;
   import core.ship.PlayerShip;
   import core.states.IState;
   import core.states.StateMachine;
   import sound.ISound;
   import sound.SoundLocator;
   
   public class WarpJump implements IState
   {
       
      
      private var ship:PlayerShip;
      
      private var sm:StateMachine;
      
      private var g:Game;
      
      private var hyperDriveEngaged:Boolean = false;
      
      private var warpJumpEffect:Vector.<Emitter>;
      
      public function WarpJump(param1:Game, param2:PlayerShip)
      {
         super();
         this.g = param1;
         this.ship = param2;
      }
      
      public function enter() : void
      {
         var soundManager:ISound;
         core.states.§ship:WarpJump§.ship.engine.speed = 30000;
         core.states.§ship:WarpJump§.ship.rotation = 0;
         core.states.§ship:WarpJump§.ship.course.rotateLeft = false;
         core.states.§ship:WarpJump§.ship.course.rotateRight = false;
         warpJumpEffect = EmitterFactory.create("XCQvBR1tSES8xZSb36V2wQ",g,core.states.§ship:WarpJump§.ship.x,core.states.§ship:WarpJump§.ship.y,core.states.§ship:WarpJump§.ship,false);
         if(g.camera.isCircleOnScreen(core.states.§ship:WarpJump§.ship.x,core.states.§ship:WarpJump§.ship.y,300) || g.me.ship == core.states.§ship:WarpJump§.ship)
         {
            soundManager = SoundLocator.getService();
            soundManager.play("-TW1TY5ePE-mLbzmtSwdKg",function():void
            {
               core.states.§ship:WarpJump§.ship.accelerate = true;
            });
         }
         else
         {
            core.states.§ship:WarpJump§.ship.accelerate = true;
         }
      }
      
      public function execute() : void
      {
         core.states.§ship:WarpJump§.ship.rotation = 0;
         core.states.§ship:WarpJump§.ship.course.rotateLeft = false;
         core.states.§ship:WarpJump§.ship.course.rotateRight = false;
         core.states.§ship:WarpJump§.ship.accelerate = true;
         if(core.states.§ship:WarpJump§.ship.speed.length >= 700)
         {
            if(!hyperDriveEngaged)
            {
               for each(var _loc1_ in warpJumpEffect)
               {
                  _loc1_.posX = core.states.§ship:WarpJump§.ship.x;
                  _loc1_.posY = core.states.§ship:WarpJump§.ship.y;
                  _loc1_.play();
               }
               hyperDriveEngaged = true;
            }
         }
         core.states.§ship:WarpJump§.ship.updateHeading();
         core.states.§ship:WarpJump§.ship.engine.update();
      }
      
      public function exit() : void
      {
         for each(var _loc1_ in warpJumpEffect)
         {
            _loc1_.killEmitter();
         }
      }
      
      public function get type() : String
      {
         return "WarpJump";
      }
      
      public function set stateMachine(param1:StateMachine) : void
      {
         this.sm = param1;
      }
   }
}
