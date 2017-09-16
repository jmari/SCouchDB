accessing
onEvent:anEvent mustache:aMustacheString
	| e |
	e:=self  onEvent:anEvent.
	e mustache:aMustacheString.
	^e
