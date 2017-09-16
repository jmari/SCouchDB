runner
applyContentType:resp mime:responseContentType

	resp at:'headers' ifAbsentPut:[SCJsonObject new].
	responseContentType ifNotNil:[
		(resp at:'headers') at:'Content-Type' put: responseContentType.
	].
	^ resp