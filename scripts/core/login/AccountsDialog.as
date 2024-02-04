package core.login
{
   import starling.display.Sprite;
   import starling.display.Quad;
   import goki.QuickloginAccounts;
   import feathers.controls.ScrollContainer;
   import core.hud.components.Text;
   
   public class AccountsDialog extends Sprite
   {
      private var accountsContainer:ScrollContainer;

      private var bg:Quad;

      private var test:Text;
      
      public function AccountsDialog()
      {
         super();
         acccountsContainer = new ScrollContainer();
         draw();
      }

      private function draw() : void
      {
         bg = new Quad(360, 600);
         test = new Text(0,0);
         test.text = "TEST";
         addChild(bg);
         addChild(test);
      }
   }
}
