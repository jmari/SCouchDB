private
consume: aString returning: anObject
	aString do: [:c | stream next == c ifFalse: [SCJsonSyntaxError signal: 'Expected ''', aString, ''''] ].
	^ anObject