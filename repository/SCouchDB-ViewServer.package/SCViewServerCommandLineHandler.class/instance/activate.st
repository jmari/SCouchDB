activation
activate

	self activateHelp ifTrue: [  ^ self ].
	

	(self hasOption: 'debug')	
						ifTrue: [ SCViewServer debugOn ]
						ifFalse: [ SCViewServer debugOff]. 
	SCViewServer startOn:#stdio.
	^ self exitSuccess 