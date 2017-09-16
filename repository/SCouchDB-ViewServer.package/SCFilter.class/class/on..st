as yet unclassified
on:aViewServer
"We need to know the server instance to send print messages"
	| a |
	super initialize.
	a:=self new.
	a server:aViewServer.
	^a
