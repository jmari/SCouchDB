accessing
at: anUUID
	anUUID isArray ifTrue: [^ self at: ((anUUID at:1),'/',(anUUID at:2)) ].
	^ self at: anUUID ifAbsent: [ nil ]