private
importEventlyFilesFrom:aFolderPath relPath:relPath stack:currentJsonObject
	| dir elements fileName aStream content |
	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
	entry isDirectory 
		ifTrue:[
			currentJsonObject at: entry name put: SCJsonObject new.
			self 	importEventlyFilesFrom:aFolderPath 
					relPath:(relPath , DiskStore activeClass delimiter asString, entry name)
					stack:(currentJsonObject at: entry name)]
		ifFalse:[
			aStream := entry readStream.	
			content := [self materializer materializeFromStream: aStream]
							on:Exception 
							do:[nil].
			content ifNotNil:[
				fileName := entry name copyFrom:1 to:((entry name indexOf:$.) - 1).
				currentJsonObject at: fileName put: content]
		]
	]