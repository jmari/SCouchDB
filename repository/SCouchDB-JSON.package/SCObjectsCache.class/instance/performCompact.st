private
performCompact 
	| deadKeys |
	
	deadKeys := Set new.
	objects keysAndValuesDo:  [ :key :value | 
		((value isNil) | (value = #deleted)) ifTrue: [ deadKeys add: key ] ].
	deadKeys do: [ :each | 
		objects removeKey: each ifAbsent:[].
		versions removeKey: each ifAbsent:[]].
	objects compact.
	reversedObjects finalizeValues; compact.
	versions compact.
	