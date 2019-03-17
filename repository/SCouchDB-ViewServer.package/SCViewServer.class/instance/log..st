out-subsystem
log:aMessage

	self println:( self serializer  serialize:(Array with:'log' with:aMessage)).
 
	

