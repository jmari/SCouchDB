socket-subsystem
stop
	"stop this server"
	self exit:true.
	aServer ifNotNil:[
			aServer terminate.
			aServer:=nil
	].