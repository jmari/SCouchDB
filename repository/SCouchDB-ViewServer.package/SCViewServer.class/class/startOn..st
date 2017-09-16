instance creation
startOn:aPort
	|aServer|
	servers ifNil:[servers:= Dictionary new].
	aServer:=SCViewServer new.
	(aPort = #stdio) 
		ifTrue:[aServer startOnStandardIO ]
		ifFalse:[
			aServer startOn:aPort.
			servers at:aPort put:aServer].
	^ aServer

