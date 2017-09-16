accessing
at:anEventlyName onEvent:anEvent data:aDataString
	| e |
	e:=self at:anEventlyName onEvent:anEvent.
	e data:aDataString.
	^ e
