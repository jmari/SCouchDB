instance creation
newFrom: anObject

	| jsonObj |
	"basic types"
	(anObject isKindOf: Boolean ) ifTrue:[^ anObject].
	(anObject isKindOf: String ) ifTrue:[^ anObject].
	(anObject isKindOf: Number  ) ifTrue:[^ anObject].
	
	^ (anObject isKindOf: Dictionary )
			ifTrue:[ self fromDictionary: anObject]
			ifFalse:[ 
					(anObject isKindOf: Collection )
					ifTrue: [  super newFrom: anObject ]
					ifFalse: [ 
						jsonObj := self new.
						anObject class allInstVarNames do:[ :aiName|
							jsonObj at:aiName put: (anObject instVarNamed:aiName )].
					jsonObj]]