protected
triggering
	|oc|
	oc:=OrderedCollection new.
	oc addAll: self triggers.
	self values do:[:anEvenlyObject|
		(anEvenlyObject isKindOf:SCEvently) ifTrue: 
			[oc addAll: anEvenlyObject triggering]].
	^oc asArray