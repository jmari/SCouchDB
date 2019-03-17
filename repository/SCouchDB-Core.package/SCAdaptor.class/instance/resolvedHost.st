private
resolvedHost 

	^ resolvedHost ifNil: [
		resolvedHost := (NetNameResolver addressForName: self host) ]