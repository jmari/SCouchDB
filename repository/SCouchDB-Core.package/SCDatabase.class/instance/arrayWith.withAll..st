helper methods
arrayWith: anObject withAll: aCollection

	| newArray |
	newArray := Array new: aCollection size + 1.
	newArray at: 1 put: anObject.
	newArray
		replaceFrom: 2
		to: newArray size
		with: aCollection.
	^newArray