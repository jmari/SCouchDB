accessing
selector:aSelector onEvent:jqueryEvent do:eventlyEvent
	|tSelector|
 	eventlyEvent isArray 
						ifTrue:[triggers addAll: eventlyEvent ]
	 					ifFalse:[self addTriggersFromJSCode:eventlyEvent].
	tSelector:=aSelector asString.
	(aSelector isKindOf:Symbol) ifTrue:[tSelector:= '#',tSelector].
^	(self selector:tSelector) onEvent:jqueryEvent do:eventlyEvent 