class CParticipant
{
	/* 	Participant attributes 
		----------------------------------------------------------------------------------- */
		pInstance		= null;
		
		points			= 0;
		division		= BOTTOM_DIVISION;
		duelsWon		= 0;
		duelsLost		= 0;
		
		matchLobby		= null;
		state			= PlayerState.IDLE;
		isReady			= false;
		weapons			= [];
		
		/* 	If the player is not able to find an opponent, it will store the current ongoing matches in this array.
			from which the potential winner/loser would play next against this.player after their current match finishes */
		pendingMatches	= [];
	
	/* 	-----------------------------------------------------------------------------------
		Initialize a participant and set default state
		----------------------------------------------------------------------------------- */
		
		// Called when a player connects
		constructor( player )
		{
			// Save the connected player's instance
			this.pInstance 		= player;
			
			// Set default values
			this.points		= 0;
			this.duelsWon		= 0;
			this.duelsLost		= 0;
			
			// Set the player in bottom division
			this.SetDivision( BOTTOM_DIVISION );
			
			// Set the player state to idle until he/she spawns
			this.state		= PlayerState.IDLE;
			this.pendingMatches	= [];
		}
	
	/* 	-----------------------------------------------------------------------------------
		Participant methods
		----------------------------------------------------------------------------------- */
		
		function SetDivision( division )
		{
			// Set the player division
			this.division 	= division;
			
			// Store the player in the global table for that division
			g_divisionPlayers[division].rawset( this.pInstance.ID, this );
		}
		
		function FindMatch()
		{
			// Remove the player from IDLE state and set the it to MATCHMAKING
			this.state	= PlayerState.MATCHMAKING;
			
			// Make sure the pendingMatches array is empty
			this.pendingMatches.clear();
			
			// 	We will search for an opponent in the following divisions, ordered by priority:
			local searchDivisions = 	[ 	
								this.division, 
								this.division - 1,
								this.division + 1,
								this.division - 2,
								this.division + 2
							];
			//	Note that some of this divisions might not exist if the player is in top 2 or bottom 2 divisions. CODE FuckYou
			
			local index = 0;
			while( index < searchDivisions.length() )
			{
				// First, we make sure that this division exists, FuckYouToo
				if( searchDivisions[ index ]  >= 0 && searchDivisions[ index ] <= BOTTOM_DIVISION )
				{
					// Check if any opponent is available in this division
					foreach( participant in ::g_divisionPlayers[searchDivisions[ index ]] )
					{
						if( participant.state == PlayerState.MATCHMAKING )
						{
							/* 	Woohoo, opponent found!
								First, clear out any pending matches, then start the match */
							this.pendingMatches.clear();
							return ::StartMatch( this, participant );
						}
						
						if( participant.state == PlayerState.IDLE )
						{
							// Opponent found, but is AFK; Move on to next player
						}
						
						if( participant.state == PlayerState.PLAYING )
						{
							/* 	Opponent found, but is already in a different match
								So, we add the match to the player's pendingMatches */
							this.pendingMatches.push( participant.matchLobby );
						}
					}
				}
				// proceed to next searchable division
				index ++;
			}
			
			/* 	The code has reached this point because no match was found
				We add this player to the wait list and start his match when one of his pendingMatches finishes. */
				this.WaitList();
		}
		
		function WaitList()
		{
			::g_waitList.rawset( this.pInstance.ID, this );
			::MessagePlayer( COL_WARNING + "No opponent found yet.", player );
			
			if( this.pendingMatches.length > 0 )
			{
				::MessagePlayer( COL_GENERIC + "However, there are " + 
					COL_HIGHLIGHT + this.pendingMatches.length + COL_GENERIC
					" matches pending, where one of the opponents would fight you. So stay tuned!", player );
			}
		}
}
