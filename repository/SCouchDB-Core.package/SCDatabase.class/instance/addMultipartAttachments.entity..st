private
addMultipartAttachments:  attachmentsDictionary entity:entity
	| stream type length|
	attachmentsDictionary values do: [:value|
		stream := value stream ifNil:[ReadStream on:value data].
		type := value contentType.
		length := value contentLength.
		entity addPart:(ZnStreamingEntity readFrom: stream usingType: type andLength: length)]
	