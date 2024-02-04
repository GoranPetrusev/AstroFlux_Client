package core.login
{
   import core.hud.components.LoginButton;
   import core.hud.components.LoginInput;
   import starling.display.Sprite;
   import goki.QuickloginAccounts;
  
   public class AccountEdit extends Sprite
   {
        private var nameInput:LoginInput;
        
        private var emailInput:LoginInput;
        
        private var passwordInput:LoginInput;

        private var saveButton:LoginButton;

        private var cancelButton:LoginButton;

        public function AccountEdit(login:Login, name:String = "", email:String = "", pass:String = "")
        {
            super();
            nameInput = new LoginInput("Name");
            nameInput.text = name;
            addChild(nameInput);
            emailInput = new LoginInput("Email / UserID");
            emailInput.setPrevious(nameInput);
            emailInput.text = email;
            addChild(emailInput);
            passwordInput = new LoginInput("Password / Auth Token");
            passwordInput.setPrevious(emailInput);
            passwordInput.input.displayAsPassword = true;
            passwordInput.text = pass;
            addChild(passwordInput);

            saveButton = new LoginButton("Save", null);
            saveButton.y = passwordInput.y + 70;
            saveButton.x = passwordInput.width/2 - saveButton.width - 5;
            addChild(saveButton);
            cancelButton = new LoginButton("Cancel", function():void{
                login.setState("accounts");
            });
            cancelButton.y = saveButton.y;
            cancelButton.x = passwordInput.width/2 + 5;
            addChild(cancelButton);
        }
    }
}
