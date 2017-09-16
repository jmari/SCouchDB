accessing
onEvent:anEvent data:aDataString
	| e |
	e:=self onEvent:anEvent.
	e data:aDataString.
	^ e
