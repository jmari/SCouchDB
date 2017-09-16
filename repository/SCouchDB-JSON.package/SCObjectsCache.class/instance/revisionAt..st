accessing
revisionAt: anUUID

	^ versions at: anUUID ifAbsent: [ nil ]