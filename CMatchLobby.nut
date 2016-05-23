class CMatchLobby
{
	/* 	Match Lobby attributes 
		----------------------------------------------------------------------------------- */
		id			= null;
		world		= 0;
		players		= [];
		countdown	= null;
		hasStarted	= false;
	
	/* 	-----------------------------------------------------------------------------------
		Initialize the match and set default state
		----------------------------------------------------------------------------------- */
		
		// Called when a match starts
		constructor( p1, p2 )
		{
			// Set a unique ID for this match
			this.id		= time();
			
			// Set the world to Virtual World not assigned to any other duel
			this.world 	= p1.pInstance.ID + 1;
			
			// Set the pre-match values
			p1.pInstance.World 		= this.world;
			p1.pInstance.Health 	= 100;
			p1.pInstance.CanAttack 	= false;
			p1.isReady				= false;
			
			p2.pInstance.World 		= this.world;
			p2.pInstance.Health 	= 100;
			p2.pInstance.CanAttack 	= false;
			p2.isReady				= false;
			
			// Assign the participants
			this.players.push( p1 );
			this.players.push( p2 );
			
			// The match aint started yet
			this.hasStarted			= false;
			
			// Start a 30 second timer to force start a match incase one of the players is AFK
			this.countdown = ::NewTimer( "ForceMatch", 30000, 1, this.id );
		}
	
	/* 	-----------------------------------------------------------------------------------
		Match Lobby methods
		----------------------------------------------------------------------------------- */
		
		function StartCountDown()
		{
			// 3,2,1 Go
			this.countdown = ::NewTimer( "Countdown", 1000, 4, this.players[0].pInstance.ID, this.players[1].pInstance.ID );
		}
		
		function StartMatch()
		{
			p1.pInstance.Health 	= 100;
			p1.pInstance.CanAttack 	= true;
			p2.pInstance.Health 	= 100;
			p2.pInstance.CanAttack 	= true;
		}
		
		function EndMatch( winner )
		{
			
		}
}

function ForceMatch( matchID )
{
	
}

function Countdown( p1, p2 )
{

}