documents-attachment
documentAt: id attach: fileReference rev:oldDocRev
	|stream type length|
	
	stream := ZnFileSystemUtils fileStreamFor: fileReference.
	stream binary.
	type := ZnMimeType forFilenameExtension: (ZnFileSystemUtils extensionFor: fileReference).
	length := ZnFileSystemUtils fileSizeFor: fileReference.

	self adaptor znClient queryAt:'rev' put: oldDocRev.
	^ self adaptor put: (self self arrayWith:self name with:id  with:fileReference fullName)
					 entity:(ZnStreamingEntity readFrom: stream usingType: type andLength: length).


