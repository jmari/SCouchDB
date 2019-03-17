runner
runFilterView:fun ddoc:ddoc args:args
"recompile"
	|results  docs |
	results:= Stack new.

	docs:=args at:1.

	docs do:[:doc|
		viewEmit:=false.
		fun valueWithEnoughArguments:args.
		results push:(self viewEmit).
		self viewEmit:false ].
	self respond:(Array with:true with:results).
	^ self doNotReturnAnything 
