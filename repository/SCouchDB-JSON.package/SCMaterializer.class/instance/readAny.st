parsing
readAny
	"This is the main entry point for the JSON parser. See also readFrom: on the class side."
	| c |
	(self skipWhitespace) ifNil:[^nil].
	c := stream peek asLowercase.
	c == ${ ifTrue: [stream next. ^ self readDictionary].
	c == $[ ifTrue: [stream next. ^ self readArray].
	c == $" ifTrue: [stream next. ^ self readString].
	c == $t ifTrue: [^ self consume: 'true' returning: true].
	c == $f ifTrue: [^ self consume: 'false' returning: false].
	c == $n ifTrue: [^ self consume: 'null' returning: nil].
	
	(self numbersMayContain: c) ifTrue: [^ self readNumber].
	SCJsonSyntaxError signal: 'Unknown Json input'