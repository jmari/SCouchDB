runner
runFilter:fun ddoc:ddoc args:args
	|results docs req |
	results:= Stack new.
	docs:=(args at:1).
	req:=(args at:2).
	docs do:[:aDoc|
		results push:( fun valueWithEnoughArguments:(Array 
													with:aDoc
													with: req) )].
	self respond:(Array with:true with:results).
	^ self doNotReturnAnything 
