package core.login
{
   import core.hud.components.Button;
   import core.hud.components.LoginButton;
   import core.hud.components.Text;
   import feathers.controls.ScrollContainer;
   import feathers.layout.VerticalLayout;
   import goki.QuickloginAccounts;
   import starling.display.Quad;
   import starling.display.Sprite;
   
   public class AccountsDialog extends Sprite
   {
       
      
      private var accountsContainer:ScrollContainer;
      
      private var width:int;
      
      private var height:int;
      
      private var addButton:LoginButton;
      
      private var login:Login;
      
      public function AccountsDialog(param1:Login)
      {
         super();
         login = param1;
         width = 360;
         height = 340;
         initComponents();
      }
      
      private function initComponents() : void
      {
         addButton = new LoginButton("add",function():void
         {
            login.removeChild(login.editDialog);
            login.editDialog = new AccountEdit(login);
            login.addChild(login.editDialog);
            login.setState("edit");
         });
         addButton.x = width / 2 - addButton.width / 2;
         addButton.y = height - addButton.height - 10;
         addChild(addButton);
         initContainer();
         populateContainer();
         addChild(accountsContainer);
      }
      
      private function populateContainer() : void
      {
         for(var acc in QuickloginAccounts.accounts)
         {
            addAccountEntry(acc);
         }
      }
      
      public function repopulateContainer() : void
      {
         accountsContainer.removeChildren(0,-1,true);
         populateContainer();
      }

      private function addAccountEntry(s:String) : void
      {
         var name:Text;
         var deleteButton:Button;
         var editButton:Button;
         var c:Sprite = new Sprite();
         var background:Quad = new Quad(width,35,0);
         background.alpha = 0.5;
         c.addChild(background);
         name = new Text();
         name.text = s;
         name.size = 16;
         name.y = background.height / 2 - name.height / 2 + 3;
         name.x = 5;
         c.addChild(name);
         deleteButton = new Button(function():void
         {
            QuickloginAccounts.removeAccount(s);
            QuickloginAccounts.saveConfig();
            repopulateContainer();
         },"delete","negative");
         deleteButton.x = accountsContainer.width - deleteButton.width - 5;
         deleteButton.y = background.height / 2 - deleteButton.height / 2;
         deleteButton.enabled = true;
         c.addChild(deleteButton);
         editButton = new Button(function():void
         {
            login.removeChild(login.editDialog);
            login.editDialog = new AccountEdit(login, s, QuickloginAccounts.accounts[s][0], QuickloginAccounts.accounts[s][1], true);
            login.addChild(login.editDialog);
            login.setState("edit");
            editButton.enabled = true;
         },"edit");
         editButton.x = accountsContainer.width - editButton.width - deleteButton.width - 10;
         editButton.y = background.height / 2 - editButton.height / 2;
         editButton.enabled = true;
         c.addChild(editButton);
         accountsContainer.addChild(c);
      }
      
      private function initContainer() : void
      {
         accountsContainer = new ScrollContainer();
         accountsContainer.width = width - 10;
         accountsContainer.x = 5;
         accountsContainer.height = height - addButton.height - 20;
         accountsContainer.y = 5;
         var layout:VerticalLayout = new VerticalLayout();
         layout.gap = 5;
         accountsContainer.layout = layout;
      }
   }
}
