Scriptname pchstunnelchutelock extends ObjectReference  

ObjectReference Property tunnelchutetrapref  Auto  

Event OnTriggerEnter(ObjectReference akActionRef)
	tunnelchutetrapref.lock()
EndEvent