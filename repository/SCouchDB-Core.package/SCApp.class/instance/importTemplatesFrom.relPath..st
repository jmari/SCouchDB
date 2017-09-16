private
importTemplatesFrom:aFolderPath relPath:relPath
	| dir elements attchPath fileName aStream |

	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
		entry isDirectory 
		ifTrue:[
			(relPath='') 
				ifTrue:[	self importTemplatesFrom:aFolderPath relPath:(entry name)]
				ifFalse:[	self importTemplatesFrom:aFolderPath relPath:(relPath , DiskStore activeClass delimiter asString, entry name)]]
		ifFalse:[
			fileName:= entry name copyFrom:1 to:((entry name indexOf:$.) - 1). 
			(relPath='') 
				ifFalse:[
					attchPath:=(relPath , DiskStore activeClass delimiter asString, fileName).
					attchPath:= attchPath copyReplaceAll: '\' with: '/'.
					aStream :=  entry readStream.	
					self partials at: attchPath put: (aStream contents)]
				ifTrue:[
					attchPath:= fileName.
					aStream := entry readStream.	
					[self templates at: attchPath put: (aStream contents)] on:Error do:[Transcript show:entry name ,' is not a valid utf8 stream']]
		]
	]