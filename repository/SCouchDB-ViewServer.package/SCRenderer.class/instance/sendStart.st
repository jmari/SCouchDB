runner
sendStart

	startResp:= self applyContentType: startResp mime: (mime responseContentType).

	self respond:(Array 
		with: 'start'
		with: chunks
		with: startResp).
	chunks:= Stack new.
	startResp:= SCJsonObject new
		