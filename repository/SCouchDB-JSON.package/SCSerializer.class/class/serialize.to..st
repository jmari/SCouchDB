static-methods
serialize: anObject to: aStream
	| serializer |
	serializer:= self new.
	serializer pool removeAll.
	serializer serialize: anObject to:aStream