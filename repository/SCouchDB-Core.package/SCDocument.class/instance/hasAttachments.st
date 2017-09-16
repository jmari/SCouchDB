as yet unclassified
hasAttachments
	
	^  self at: '_attachments' ifPresent:[ (self at: '_attachments') size > 0] ifAbsent:[ false ] .
	