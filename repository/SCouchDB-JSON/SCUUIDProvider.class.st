Class {
	#name : #SCUUIDProvider,
	#superclass : #Object,
	#instVars : [
		'idField'
	],
	#category : 'SCouchDB-JSON'
}

{ #category : #'as yet unclassified' }
SCUUIDProvider >> discoverIdFor: jsonObject [
	| possibleUUID |
	possibleUUID := (jsonObject isKindOf: Dictionary) ifTrue:[
								jsonObject at:self idField ifAbsent:[
								
										(jsonObject respondsTo:self idField asSymbol) 
											ifTrue:[ jsonObject perform: self idField asSymbol]
											ifFalse:[nil]]].
	possibleUUID 
		ifNil:[ possibleUUID := (SCObjectsCache instance  keyAtValue:jsonObject)].
	^ possibleUUID
]

{ #category : #'as yet unclassified' }
SCUUIDProvider >> getIdRevisionAssociationFor: anObject [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SCUUIDProvider >> getRevFor: anUUID [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SCUUIDProvider >> getUUIDFor:obj [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SCUUIDProvider >> idField [
	^idField ifNil:[idField := '_id']
]

{ #category : #accessing }
SCUUIDProvider >> idField: aField [
	idField := aField
]
