documents-attachment
documentAt: id attach: fileReference
	^ self documentAt: id attach: fileReference rev:(self documentCurrentRevAt: id).