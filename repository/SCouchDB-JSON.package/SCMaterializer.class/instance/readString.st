private
readString
	| s c |
	s := WriteStream on: ''.
	[
		c := stream next.
		c == $\
			ifTrue: [s nextPut: self interpretStringEscape.]
			ifFalse: [c == $" ifTrue: [^ s contents.].
					s nextPut: c]
	] repeat.