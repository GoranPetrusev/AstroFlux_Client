package core.login
{
   import starling.display.Sprite;
   import starling.display.Quad;
   import goki.QuickloginAccounts;
   import feathers.controls.ScrollContainer;
   import core.hud.components.Text;
   import core.hud.components.LoginButton;
   
   public class AccountsDialog extends Sprite
   {
      private var accountsContainer:ScrollContainer;

      private var bg:Quad;

      private var width:int;

      private var height:int;

      private var addButton:LoginButton;

      public function AccountsDialog(param1:Login)
      {
         var login:Login = param1;
         super();
         width = 360;
         height = 400;
         acccountsContainer = new ScrollContainer();
         draw(login);
      }

      private function draw(login:Login) : void
      {
         bg = new Quad(width, height, 0x000000);
         bg.alpha = 0.2;
         addChild(bg);
         addButton = new LoginButton("add",function():void{
            login.setState("edit");
         });
         addChild(addButton);
      }

      private function addAccountEntry() : void
      {

      }
   }
}
