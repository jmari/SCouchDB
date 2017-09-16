activation
activate
	| server |
	self activateHelp
		ifTrue: [  ^ self ].
	
	server := SCViewServer startOn:#stdio.
			
	(self arguments includes: '--debug')
		ifFalse: [ server debugOff] 
		ifTrue: [ server debugOn ].	
				
	^ self exitSuccess 