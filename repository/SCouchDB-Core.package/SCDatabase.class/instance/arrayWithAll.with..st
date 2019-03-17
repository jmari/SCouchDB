helper methods
arrayWithAll: aCollection with: anObject

	| newArray |
	newArray := self new: aCollection size + 1.
	newArray
		replaceFrom: 1
		to: newArray size -1
		with: aCollection.
	newArray at: newArray size put: anObject.
	^newArray