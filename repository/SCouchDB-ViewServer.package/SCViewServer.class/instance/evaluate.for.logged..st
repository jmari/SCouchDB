compile
evaluate:fun for:contextInstance logged:logged

	(fun isKindOf:BlockClosure) ifTrue:[^fun].
	^ Compiler evaluate:fun for: contextInstance logged: logged
	

