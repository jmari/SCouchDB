private
stream: anObject
	"Set the value of stream"

	stream := anObject.
	(stream respondsTo: #reset) ifTrue: [
		stream reset.
	].
