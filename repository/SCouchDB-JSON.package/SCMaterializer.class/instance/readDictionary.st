private
readDictionary
	| m k v needComma |
	m := SCJsonObject new.
	needComma := false.
	[
		self skipWhitespace.
		(stream peekFor: $}) ifTrue: [ ^ m].
		needComma
			ifTrue: [ (stream peekFor: $,) ifFalse: [SCJsonSyntaxError signal: 'Missing comma'].
					self skipWhitespace]
			ifFalse: [needComma := true].
"		k := self readAny. "
		(stream peekFor: $") ifFalse: [SCJsonSyntaxError signal: 'Key in dictionary must be string'].
		k := self readString.
		self skipWhitespace.
		(stream peekFor: $:) ifFalse: [SCJsonSyntaxError signal: 'Missing colon'].
		v := self readAny.
		m at: k put: v.
	] repeat.
