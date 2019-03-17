accessing
onEvent:anEvent data:aDataString mustache:aMustacheString
	| e |
	e:=self onEvent:anEvent.
	e data:aDataString.
	e mustache:aMustacheString.
	^e

