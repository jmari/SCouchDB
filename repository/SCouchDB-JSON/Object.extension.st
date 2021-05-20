Extension { #name : #Object }

{ #category : #'*SCouchDB-JSON' }
Object >> asSCJsonObject [
	"we use the same procedure than Dictionary"
	^ self as: SCJsonObject
	 
]

{ #category : #'*SCouchDB-JSON' }
Object >> isSCAppContext [
	^ false
	 
]

{ #category : #'*SCouchDB-JSON' }
Object >> isSCJsonObject [
	^ false
	 
]
