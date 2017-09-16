error handling
handleFatalError: e

	self handleException:e.	
	"we tell the client it was a fatal error by clossing the connection"
	self commStream close