Extension { #name : #Object }

{ #category : #'*SCouchDB-JSON' }
Object >> asSCJsonObject [
	"we use the same procedure than Dictionary"
	^ self as: SCJsonObject
	 
]
