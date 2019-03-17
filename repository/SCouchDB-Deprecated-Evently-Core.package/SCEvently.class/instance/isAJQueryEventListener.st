protected
isAJQueryEventListener

	(self triggers isEmpty) ifFalse:[^true].
	self values do:[:aSCEvenlyObject|
		(aSCEvenlyObject isAJQueryEventListener) ifTrue:[^true]].
	^false
 
