private
readETagFrom: response	
	| result |
	 ('*application/json*' match: response contentType) ifFalse: [
		self error: 'response is not json'.
		].
	
	result := self materializer materializeFromStream: response readStream.
	^ result