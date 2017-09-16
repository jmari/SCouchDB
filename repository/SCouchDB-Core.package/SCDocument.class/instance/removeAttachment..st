as yet unclassified
removeAttachment:aString
	^ self attachments removeKey:aString ifAbsent:[nil]