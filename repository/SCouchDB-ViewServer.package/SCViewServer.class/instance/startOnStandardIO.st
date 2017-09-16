socket-subsystem
startOnStandardIO
	"Starts the server reading on standard io"

	|  jsonArray msg  |	
		
	"debug := self class debug."
	self port: #stdio.
	FileStream stdout wantsLineEndConversion: true; converter.
	self session: VTermOutputDriver stdout.
	self commStream: FileStream stdin.

	 [ (jsonArray:=self readJsonFrom:self commStream) isNil] whileFalse:[  
		[[[
					msg:=self mainLoop:jsonArray.
					msg ifNotNil:[self println:msg].
					Processor yield]	
					on:SCViewServerException  do:[:ex| self handleException: ex ]]
					on:SCViewServerError do:[:ex| self handleFatalError: ex ]]
					on:Error do:[:ex| self handleAnyError: ex ]].
		SessionManager default snapshot:false andQuit:true.