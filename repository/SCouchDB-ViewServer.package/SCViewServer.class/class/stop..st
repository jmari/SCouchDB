instance creation
stop:aPort

	self servers 
				at:aPort 
				ifPresent:[:aServer|
								aServer stop.
								self servers removeKey: aPort]

 	
	

