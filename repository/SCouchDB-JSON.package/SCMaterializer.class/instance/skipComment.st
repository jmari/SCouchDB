private
skipComment
	stream peek == $/ ifTrue: [
		stream next.
		stream peek == $/
			ifTrue: [self skipToEndOfLine]
			ifFalse: [stream peek == $*
						ifTrue: [stream next. self skipCommentBody]
						ifFalse: [SCJsonSyntaxError signal: 'Invalid comment syntax']]]
