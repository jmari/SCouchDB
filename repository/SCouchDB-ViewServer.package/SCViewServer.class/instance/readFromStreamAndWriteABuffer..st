input-subsystem
readFromStreamAndWriteABuffer: aStream	
	|  aBuffer  char |
	"can not read the stdin stream directly..."

	aBuffer := ReadWriteStream on:String new.	
	[char :=aStream next.
	[ (char = Character lf)  | (char = Character cr) ] whileFalse: [
		aBuffer nextPut:char.
      char :=aStream next ]] on:Error do:[:ex| self handleAnyError: ex ].
		self flag: #todo. "Reading from stdin does not work directly, hence we load everything a buffer first"	
	
	^ aBuffer
