views
reduce:rFunction  keys:keyArray values:valArray rereduce:aBoolean
	"Execute a reduce function
	keyArray: [[key1,id1],[key2,id2],...,[keyn,idn]
	valArray: [val1, val2, val3,...,valn]"
	| res rfun reduceFunction|
	[  
  		reduceFunction:= rFunction trimSpaces. 
		rfun:=self runner compiledFunctions at: reduceFunction hash ifAbsentPut:[		
				Compiler evaluate:reduceFunction for: self runner logged:false ].
		res:= rfun valueWithEnoughArguments:( Array with:keyArray with:valArray with:aBoolean).
		^res
	] on:Error do:[:err| 
			self log:err description.
			^Array with:false with:nil].

		