out-subsystem
debug:aMessage
|aStream m fr |
	debug ifFalse: [^self].
	m:= '[', DateAndTime now asString,']' ,  (aMessage "truncateTo:256").
	fr := ( FileLocator home / (Date today yyyymmdd ,'ViewServer-debug.txt')) ensureCreateFile.
 	aStream := fr writeStream.
	aStream ifNil:[Transcript show:('Unable to write debug info, check for permissions' ). ^self].
	aStream setToEnd.
	aStream
		nextPutAll:m;
		nextPutAll:String crlf.
	aStream flush.
	aStream close.
	Transcript show:m , String cr

	

