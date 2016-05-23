const BOTTOM_DIVISION	= 9;	// The lowest division where the players start. 0-9, means 10 total divisions

enum PlayerState
{
	IDLE,			// Player is in spawn screen, idle.
	MATCHMAKING,	// Player is waiting for match making, no valid opponent found yet.
	PLAYING			// Player is currently participating in a duel. 
}

/* Global table to store all connected players.
{ playerID : Participant } */
g_allPlayers	<- {};

/* Global tables which stores players in the divisions (0-9)
{ playerID : Participant } */
for( local i = 0; i <= BOTTOM_DIVISION; i++ )
	g_divisionPlayers[i]	<- {};
	
/* Global tables which stores players who were not able to find an opponent and are waiting for a match.
{ playerID : Participant } */
g_waitList	<- {};

dofile( "Scripts/Configuration.nut" );
dofile( "Scripts/CParticipant.nut" );
dofile( "Scripts/CMatchLobby.nut" );

function onPlayerJoin( player )
{
	// Create an instance of CParticipant
	local pSession = CParticipant( player );
	
	// Add the participant to allPlayers global table
	g_allPlayers.rawset( player.ID, pSession );
}

function onPlayerPart( player, reason )
{
	// remove from allPlayers global table(If it exists)
	if( g_allPlayers.rawin( player.ID ) )
		g_allPlayers.rawdelete( player.ID );
}

function onPlayerSpawn( player )
{
	if( g_allPlayers.rawin( player.ID ) )
	{
		// Fetch the instance of CParticipant from the global g_allPlayers table
		local pSession = g_allPlayers.rawget( player.ID );
		
		// Find a match for our player and assign it to the matchLobby
		pSession.matchLobby = pSession.FindMatch();
	}
}

