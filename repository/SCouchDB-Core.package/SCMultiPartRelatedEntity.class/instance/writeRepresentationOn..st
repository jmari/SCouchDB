writing
writeRepresentationOn: stream
	| boundary |
	boundary := self getBoundary.
	self parts do: [ :each |
		stream nextPutAll: '--'; nextPutAll: boundary; nextPutAll: String crlf.
		stream nextPutAll: 'Content-Type: '; nextPutAll:  each contentType asString; nextPutAll: String crlf; nextPutAll: String crlf.
		each writeOn: stream.
		stream nextPutAll: String crlf ].
	stream nextPutAll: '--'; nextPutAll: boundary; nextPutAll: '--'
