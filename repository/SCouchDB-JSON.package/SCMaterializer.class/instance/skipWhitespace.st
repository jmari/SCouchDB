private
skipWhitespace
	stream peek ifNil:[^nil].
	[stream peek isSeparator] whileTrue: [stream next].
	self skipComment.