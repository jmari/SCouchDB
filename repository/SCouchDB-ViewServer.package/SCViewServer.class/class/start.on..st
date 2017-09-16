instance creation
start: anIPAdress on:aPort
	|aServer|
	servers ifNil:[servers:= Dictionary new].
	aServer:=SCViewServer new.
	aServer listenerAddress: anIPAdress.
	aServer startOn:aPort.
	^ servers at:aPort put:aServer
 
	

