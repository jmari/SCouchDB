instance creation
startOn:aPort
	|aServer|

	aServer:=SCViewServer new.
	(aPort = #stdio) 
		ifTrue:[aServer startOnStandardIO ]
		ifFalse:[
			aServer startOn:aPort.
			self servers at:aPort put:aServer].
	^ aServer

