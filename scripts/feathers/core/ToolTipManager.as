package feathers.core
{
   import flash.utils.Dictionary;
   import starling.display.DisplayObjectContainer;
   import starling.display.Stage;
   
   public class ToolTipManager
   {
      
      protected static const STAGE_TO_MANAGER:Dictionary = new Dictionary(true);
      
      public static var toolTipManagerFactory:Function = defaultToolTipManagerFactory;
       
      
      public function ToolTipManager()
      {
         super();
      }
      
      public static function getToolTipManagerForStage(param1:Stage) : IToolTipManager
      {
         return IToolTipManager(STAGE_TO_MANAGER[param1]);
      }
      
      public static function defaultToolTipManagerFactory(param1:DisplayObjectContainer) : IToolTipManager
      {
         return new DefaultToolTipManager(param1);
      }
      
      public static function isEnabledForStage(param1:Stage) : Boolean
      {
         return IToolTipManager(STAGE_TO_MANAGER[param1]) !== null;
      }
      
      public static function setEnabledForStage(param1:Stage, param2:Boolean) : void
      {
         var _loc3_:IToolTipManager = IToolTipManager(STAGE_TO_MANAGER[param1]);
         if(param2 && _loc3_ || !param2 && !_loc3_)
         {
            return;
         }
         if(param2)
         {
            STAGE_TO_MANAGER[param1] = toolTipManagerFactory(param1);
         }
         else
         {
            _loc3_.dispose();
            delete STAGE_TO_MANAGER[param1];
         }
      }
      
      public function disableAll() : void
      {
         var _loc1_:Stage = null;
         var _loc2_:IToolTipManager = null;
         for(var _loc3_ in STAGE_TO_MANAGER)
         {
            _loc1_ = Stage(_loc3_);
            _loc2_ = IToolTipManager(STAGE_TO_MANAGER[_loc1_]);
            _loc2_.dispose();
            delete STAGE_TO_MANAGER[_loc1_];
         }
      }
   }
}
