as yet unclassified
importAttachmentsFrom:aFolderPath relPath:relPath prefix: aPrefix
	| dir a elements attchPath |

	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
		entry isDirectory 
		ifTrue:[
		(relPath='') 
			ifTrue:[	self importAttachmentsFrom:aFolderPath relPath:(entry name) prefix:aPrefix]
			ifFalse:[	self importAttachmentsFrom:aFolderPath relPath:(relPath , DiskStore activeClass delimiter asString, entry name) prefix:aPrefix]]
		ifFalse:[	
			a := SCAttachment fromFileRef: (aFolderPath,relPath , DiskStore activeClass delimiter asString, entry name ,  DiskStore activeClass delimiter asString) asFileReference.  

		(relPath='') 
			ifFalse:[attchPath:=(relPath , DiskStore activeClass delimiter asString, entry name)]
			ifTrue:[attchPath:=( entry name)].
		attchPath:= attchPath copyReplaceAll: '\' with: '/'.
		a fileName:  (aPrefix,attchPath).
		self attachments at: (aPrefix,attchPath) put: a  

		]
	]