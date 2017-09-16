input-subsystem
readJsonFrom: aStream	
	| result buffer|
	buffer := self readFromStreamAndWriteABuffer: aStream.	
	[result := self materializer materializeFromStream: buffer] on:Error do:[:e| self debug:e messageText].
	result 
		ifNil:[self debug:'[ViewServer]-Read: nil']
		ifNotNil:[self debug:'[ViewServer]-Read: ', buffer contents].
	^ result
