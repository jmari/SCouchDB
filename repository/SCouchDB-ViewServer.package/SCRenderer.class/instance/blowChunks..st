runner
blowChunks:label

	label 
		ifNil:[ self respond: (Array with:'chunks' with:chunks)] 
		ifNotNil:[ self respond: (Array with:label asString with:chunks) ].
	chunks isEmpty ifFalse: [chunks pop]
