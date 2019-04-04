Class {
	#name : #SCViewServerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : 'SCouchDB-ViewServer'
}

{ #category : #accessing }
SCViewServerCommandLineHandler class >> commandName [
	^ 'viewserver'
]

{ #category : #accessing }
SCViewServerCommandLineHandler class >> description [
	^ 'Couchdb viewserver processes the standard input'
]

{ #category : #activation }
SCViewServerCommandLineHandler >> activate [
	| server |
	self activateHelp
		ifTrue: [  ^ self ].
	
	server := SCViewServer startOn:#stdio.
			
	(self arguments includes: '--debug')
		ifFalse: [ server debugOff] 
		ifTrue: [ server debugOn ].	
				
	^ self exitSuccess 
]
