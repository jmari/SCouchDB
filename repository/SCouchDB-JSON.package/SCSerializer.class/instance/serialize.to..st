private
serialize: anObject to: aStream

	(self schemeFor: anObject class) value: anObject value: aStream.

