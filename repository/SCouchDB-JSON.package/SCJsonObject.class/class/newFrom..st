instance creation
newFrom: anObject

	| jsonObj |
	

	^ (anObject isKindOf: Dictionary )
			ifTrue:[ self fromDictionary: anObject]
			ifFalse:[ 
				(anObject isKindOf: String )
				ifTrue:[ anObject]
				ifFalse:[
				(anObject isKindOf: Collection )
					ifTrue: [  self fromCollection: anObject ]
					ifFalse: [ 
						jsonObj := self new.
						anObject class allInstVarNames do:[ :aiName|
							jsonObj at:aiName put: (anObject instVarNamed:aiName ) asSCJsonObject].
					jsonObj]]]