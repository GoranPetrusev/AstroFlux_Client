package goki
{
    import core.scene.Game;
    import core.ship.ShipManger;
    import core.ship.Ship;
    import core.ship.EnemyShip;
    import flash.geom.Point;
    
    public class AFutil
    {
        
        
        public function AFutil()
        {
            super();
        }

        public static function distanceSquaredToShip(g:Game, target:Ship) : Number
        {
            return (g.me.ship.x - target.x) * (g.me.ship.x - target.x) + (g.me.ship.y - target.y) * (g.me.ship.y - target.y);
        }

        public static function directionToShip(g:Game, target:Ship) : Number
        {
            return Math.atan2(g.me.ship.x - target.x, g.me.ship.y - target.y);
        }

        public static function sendCommand(command:int, active:Boolean) : void
        {
            g.commandManager.addCommand(command, active);
        }
    }
}

