socket-subsystem
startOn:aPort
	"Starts the server and reads the a Json Array from net"
	
	self class stop:aPort.
	self port: aPort..
	self session:nil.
	exit:=false.


aServer:=[
	[ 	
	|  jsonArray msg  |
	[exit] whileFalse:[
	Transcript show: '- listening socket';cr.
			[self session isNil and:[self exit not]] whileTrue:[
				socket:=Socket newTCP. 			
				socket listenOn:port backlogSize:50 interface:self listenerAddress.
				Transcript show: '- Socket created';cr.
				socket isValid ifFalse: [ self error: 'Cannot listen on port ' , port asString ].
				"we need to wait a very high value...serial conection 
				will be up all the time the couchdb is running"
				self session: (socket waitForAcceptFor:604800000 ifTimedOut:[	
						Processor yield.
						(Delay forMilliseconds: 10) wait.
						socket destroy.
						])
			].
			self commStream: (SocketStream on: self session).
			jsonArray:=self readJsonFrom:commStream.
			jsonArray 
				ifNil:[
					Transcript show: '- Socket destroyed';cr.
					socket closeAndDestroy.
					self commStream close.
					self session:nil]
				ifNotNil:[	
					[[[[msg:=self mainLoop:jsonArray.
						msg ifNotNil:[self println:msg]]
					on:NetworkError do:["Nothing"]]
					on:SCViewServerException  do:[:ex| self handleException: ex ]]
					on:SCViewServerError do:[:ex| self handleFatalError: ex ]]
					on:Error do:[:ex| 
						socket closeAndDestroy.
						self handleAnyError: ex ].	
				] 				
			 ] 
	] ensure:
		[
		socket closeAndDestroy.
		self commStream ifNotNil:[self commStream close].
		self session ifNotNil:[self session closeAndDestroy].
		self session:nil].
	] forkNamed:('SCouchViewServerOn-' , port asString).

