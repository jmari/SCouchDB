accessing
at:anEventlyName onEvent:anEvent selector:aJQuerySelector
	| e |
	e:=self at:(anEventlyName).
	^(e onEvent:anEvent ) selector:aJQuerySelector