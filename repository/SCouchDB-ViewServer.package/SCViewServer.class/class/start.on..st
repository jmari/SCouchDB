instance creation
start: anIPAdress on:aPort
	|aServer|

	aServer:=SCViewServer new.
	aServer listenerAddress: anIPAdress.
	aServer startOn:aPort.
	^ self servers at:aPort put:aServer
 
	

