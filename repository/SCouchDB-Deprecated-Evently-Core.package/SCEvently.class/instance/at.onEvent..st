accessing
at:anEventlyName onEvent:anEvent
	| e |
	e:=self at:(anEventlyName).
	^e onEvent:anEvent