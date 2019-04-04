Extension { #name : #SCAppContext }

{ #category : #'*SCouchDB-ViewServer' }
SCAppContext class >> fromDictionary:aDic on:aViewServer [
	| a |
	a:=self fromDictionary:aDic.
	a server:aViewServer.
	^ a
]

{ #category : #'*SCouchDB-ViewServer' }
SCAppContext class >> on:aViewServer [
	"We need to know the server instance to send print messages"
	| a |
	super initialize.
	a:=self new.
	a server:aViewServer.
	^a

]
