private
importVendorFilesFrom:aFolderPath relPath:relPath stack:currentJsonObject
	| dir elements  aStream  |

	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
	entry isDirectory 
		ifTrue:[
			(entry name = '_attachments') 
			ifTrue:[
				self importAttachmentsFrom: (aFolderPath , relPath ,DiskStore activeClass delimiter asString, entry name , DiskStore activeClass delimiter asString) relPath:'' prefix: (('vendor',relPath,'/' ) copyReplaceAll: '\' with: '/').
			]
			ifFalse:[
				(entry name = 'evently') 
					ifTrue:[
						self importEventlyFilesFrom: (aFolderPath , relPath ,DiskStore activeClass delimiter asString, entry name , DiskStore activeClass delimiter asString) relPath:'' stack: (currentJsonObject at: entry name put: SCJsonObject new)]
					ifFalse:[
						currentJsonObject at: entry name put: SCJsonObject new.
						self importVendorFilesFrom:aFolderPath 
							relPath:(relPath , DiskStore activeClass delimiter asString, entry name)
							stack:(currentJsonObject at: entry name).]]]
		ifFalse:[
			aStream :=  entry readStream.	
			[currentJsonObject at: entry name put: aStream contents] on:Error do:[Transcript show:entry name ,' is not a valid utf8 stream']
		]
	]