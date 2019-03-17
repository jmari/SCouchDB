testing
isNew: anObject 
	"checks the revision field (HEAD is the most lighweight call)"
	| isNew |
	isNew := false.
	[self database documentCurrentRevAt: anObject ] on:SCError do:[ isNew := true ].
	^ isNew
 