Scriptname _sd_daymoyl_questtemplate extends Quest Hidden
{Copies from DAYMOL script for compatibility}

int	Property		iQuestID			Auto Hidden
int Property		iEnabledID			Auto Hidden
int Property 		iPriorityID			Auto Hidden
int Property		iProbabilityID		Auto Hidden


string Property 	sName = "Unknown Quest" 	Auto
{The name of the quest as it will appear in the configuration menu}


bool Property		bEnabled = true		Auto
{Is the quest enabled}


int Property		iQuestType = 0			Auto
{0: Unknown, 1: OnDefeat, 2: Radiant, 3: OnBleedout, 9: OnDeath}


int	_iPriority = 0
int Property		iPriority
{For OnBleedout, OnDefeat and OnDeath Triggers Only [0 - 99]}		
	int Function Get()
		return _iPriority
	endFunction
	
	Function Set(int value)
		if(value < 0)
			_iPriority = 0
		elseif(value >= 100)
			_iPriority = 99
		else
			_iPriority = value
		endif
	endFunction
endProperty


bool Property 		bDetrimental = false	Auto
{For Secondary Quests Only}


float _fProbability = 0.0
float Property		fProbability
{For Radiant (OnWakeup) triggers Only. Relative frequency [0.0 - 100.0]}
	float Function Get()
		return _fProbability
	endFunction
	
	Function Set(float value)
		if(value < 0.0)
			_fProbability = 0.0
		elseif(value > 100.0)
			_fProbability = 100.0
		else
			_fProbability = value
		endif
	endFunction
endProperty


float _fCumulative = 0.0
float Property		fCumulative
{Book keeping variable}
	float Function Get()
		return _fCumulative
	endFunction
endProperty


float Function CompileProbability(float CumulativeSum)
	_fCumulative = CumulativeSum + _fProbability
	return _fCumulative
endFunction


bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire.}
	return IsStopped()
endFunction


bool Function QuestStart(Location CurrentLocation, Actor akAggressor, Actor akFollower)
{Starts the quest and returns true on success.}
	return Start()
endFunction


Function QuestReset()
{If some items are removed from the player, define this function in the inheriting script to return them to the player when the cheat option is selected in the menu.}
	Debug.Trace("daymoyl - Nothing to reset for "+self)
endFunction