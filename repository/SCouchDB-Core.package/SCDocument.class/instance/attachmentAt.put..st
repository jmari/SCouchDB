as yet unclassified
attachmentAt: aString put: aFileReference
	"aString is the node name"
	^ self attachments at: aString  put: (SCAttachment 
																fromFileRef: aFileReference 
																withName: aString)