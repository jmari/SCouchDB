initialize
fromFileRef: fileLocator withName: aFileName
	| newAtt  |
	newAtt := self new.
	newAtt 
		stream: (ZnFileSystemUtils fileStreamFor: fileLocator) binary;
		contentType:  (ZnMimeType forFilenameExtension: (ZnFileSystemUtils extensionFor: fileLocator)) asString;
	 	contentLength: (ZnFileSystemUtils fileSizeFor: fileLocator);
		fileName: aFileName.
	^ newAtt