accessing
at:anEventlyName onEvent:anEvent do:anObject
	| e |
	e:=self at:(anEventlyName).
	^e onEvent:anEvent do:anObject