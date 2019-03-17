views
compileMapFunction: aMethodSource 
	[
		self mapFunctions 
				add: (self runner compiledFunctions 
											at: aMethodSource hash 
											ifAbsentPut:[	
												Compiler evaluate:aMethodSource 
															for: self runner 
															logged:false ]).
		^'true'] 
		on: SyntaxErrorNotification , Error do:
		[:err| SCSyntaxException signal:  
			(err description ,'::', err messageText ,' on function:',aMethodSource)]