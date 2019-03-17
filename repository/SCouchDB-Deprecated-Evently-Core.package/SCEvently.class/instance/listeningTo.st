protected
listeningTo
	|oc|
	oc:=OrderedCollection new.
	oc addAll: self events.
	self values do:[:anEvenlyObject|
		(anEvenlyObject isKindOf:SCEvently) ifTrue: 
			[oc addAll: anEvenlyObject events]].
	^oc asArray
