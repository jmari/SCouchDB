Class {
	#name : #SCCouchUUIDProvider,
	#superclass : #SCUUIDProvider,
	#instVars : [
		'adaptor'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #'as yet unclassified' }
SCCouchUUIDProvider class >> on: anAdaptor [
	^ self new adaptor: anAdaptor
]

{ #category : #accessing }
SCCouchUUIDProvider >> adaptor [
	^ adaptor
]

{ #category : #accessing }
SCCouchUUIDProvider >> adaptor: anObject [
	adaptor := anObject
]

{ #category : #'as yet unclassified' }
SCCouchUUIDProvider >> getIdRevisionAssociationFor: anObject [
	| id rev |

	id := self getUUIDFor: anObject.
	rev := self getRevFor: id.
	^ ( id -> rev)
	
]

{ #category : #'as yet unclassified' }
SCCouchUUIDProvider >> getRevFor: anUUID [
	^ SCObjectsCache instance revisionAt:anUUID. 
	
]

{ #category : #'as yet unclassified' }
SCCouchUUIDProvider >> getUUIDFor:obj [
	| uuid |

	uuid := SCObjectsCache instance keyAtValue:obj. 
	uuid ifNil: [ 
		uuid := self adaptor nextUUID.
		SCObjectsCache instance at:uuid put:obj ].
	^ uuid 
]
