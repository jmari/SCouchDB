out-subsystem
println:aMessage	

	self debug:'[ViewServer]-Response: ',aMessage.
	"----just for testing package"
	self lastPrinted:aMessage.
	"-----"

	self session ifNotNil:[
		(self port = #stdio ) 
			ifTrue:[self session 
									nextPutAll: aMessage;
									lf]
			ifFalse:[
				self session 
						sendCommand: aMessage.].
	]
	
