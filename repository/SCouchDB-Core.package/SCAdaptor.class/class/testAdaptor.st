as yet unclassified
testAdaptor
	^ testAdaptor ifNil:[ testAdaptor := self new. testAdaptor host:testAdaptor defaultHost ]