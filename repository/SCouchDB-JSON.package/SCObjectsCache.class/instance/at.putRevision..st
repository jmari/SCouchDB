accessing
at: anUUID putRevision: aNumber
	anUUID isArray ifTrue: [^ self at: ((anUUID at:1),'/',(anUUID at:2)) putRevision: aNumber ].
	self mutex critical: [ 
		versions at: anUUID put: aNumber ]