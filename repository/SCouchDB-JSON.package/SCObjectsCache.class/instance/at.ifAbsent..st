accessing
at: anUUID ifAbsent: aBlock

	^ objects at: anUUID ifAbsent:[ aBlock value]