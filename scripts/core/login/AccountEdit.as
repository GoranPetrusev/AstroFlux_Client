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

        public function AccountEdit(param1:Login)
        {
            super();
            var login:Login = param1;
            nameInput = new LoginInput("Name");
            addChild(nameInput);
            emailInput = new LoginInput("Email / UserID");
            emailInput.setPrevious(nameInput);
            addChild(emailInput);
            passwordInput = new LoginInput("Password / Auth Token");
            passwordInput.setPrevious(emailInput);
            passwordInput.input.displayAsPassword = true;
            addChild(passwordInput);

            saveButton = new LoginButton("Save", null);
            saveButton.y = passwordInput.y + 70;
            saveButton.x = passwordInput.width/2 - saveButton.width - 5;
            addChild(saveButton);
            cancelButton = new LoginButton("Cancel", function():void{
                login.setState("accounts");
            });
            cancelButton.y = saveButton.y;
            cancelButton.x = passwordInput.width/2 + cancelButton.width + 5;
            addChild(cancelButton);
        }

    }
}
