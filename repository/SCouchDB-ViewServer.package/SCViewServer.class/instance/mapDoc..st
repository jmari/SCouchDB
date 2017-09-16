views
mapDoc: aDoc
	|resultArray|
	funs ifNil: [^ nil].
	resultArray:= OrderedCollection new.
	funs do:[:aBlock|
		[	aBlock value:aDoc.
			"the method fills the buffer doing emit..."
			resultArray add: self runner mapDoc.
		] on:Error do:[:err| 
			err resignalAs:(SCRuntimeException new messageText:  (err signaler asString, '::',err messageText ))].
	].
	^ resultArray