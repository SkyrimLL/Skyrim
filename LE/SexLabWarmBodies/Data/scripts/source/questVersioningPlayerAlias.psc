Scriptname questVersioningPlayerAlias extends ReferenceAlias  

event OnPlayerLoadGame()
	questVersioning me = self.GetOwningQuest() as questVersioning

	me.qvUpdate( me.qvCurrentVersion )
	me.qvCurrentVersion = me.qvGetVersion()
endEvent



