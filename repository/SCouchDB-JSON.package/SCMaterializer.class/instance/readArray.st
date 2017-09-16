private
readArray
	| a |
	a := OrderedCollection new.

	self skipWhitespace.
	(stream peekFor: $]) ifTrue: [ ^ #() ].	

	[
		a add: self readAny.
		self skipWhitespace.
		(stream peekFor: $]) ifTrue: [ ^ a asArray].
		(stream peekFor: $, ) ifFalse: [SCJsonSyntaxError signal: 'Missing comma'].
	] repeat.
