"
SCSmalltalkUUIDProvider
Provides uuid's for the serialization process

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	prefix:		<Object>


    Implementation Points
"
Class {
	#name : #SCSmalltalkUUIDProvider,
	#superclass : #SCUUIDProvider,
	#instVars : [
		'prefix'
	],
	#category : #'SCouchDB-JSON-Core'
}

{ #category : #'as yet unclassified' }
SCSmalltalkUUIDProvider >> generateUUID [
	^ UUID new asString36

]

{ #category : #'as yet unclassified' }
SCSmalltalkUUIDProvider >> getIdRevisionAssociationFor: anObject [
	| id rev |
	id := self getUUIDFor: anObject .
	rev := nil.
	^ ( id -> rev)
	
]

{ #category : #'as yet unclassified' }
SCSmalltalkUUIDProvider >> getRevFor: anUUID [
	^ SCObjectsCache instance revisionAt:anUUID. 
]

{ #category : #'as yet unclassified' }
SCSmalltalkUUIDProvider >> getUUIDFor:obj [
	| uuid |
	"saving the id in the cache allows us to serialize recursive structures"
	uuid := SCObjectsCache instance keyAtValue:obj. 
	uuid ifNil: [ 
		uuid := self generateUUID.
		SCObjectsCache instance at:uuid put:obj ].
	^ uuid 
]
