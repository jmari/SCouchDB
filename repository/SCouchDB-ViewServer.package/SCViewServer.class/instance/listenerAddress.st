accessing
listenerAddress
	ip
	ifNil:[ 	^#[0 0 0 0]]
	ifNotNil:[ 	^ip]	
	