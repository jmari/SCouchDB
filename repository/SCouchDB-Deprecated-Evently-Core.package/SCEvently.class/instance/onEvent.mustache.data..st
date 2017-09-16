accessing
onEvent:anEvent  mustache:aMustacheString data:aDataString
	| e |
	e:=self onEvent:anEvent.
	e data:aDataString.
	e mustache:aMustacheString.
	^e
