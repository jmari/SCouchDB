as yet unclassified
newFrom: anObject

	| jsonObj |
	^ (anObject isKindOf: Dictionary )
			ifTrue:[ self fromDictionary: anObject]
			ifFalse:[ 
				jsonObj := self new.
				anObject class allInstVarNames do:[ :aiName|
					jsonObj at:aiName put: (anObject instVarNamed:aiName )].
				jsonObj]