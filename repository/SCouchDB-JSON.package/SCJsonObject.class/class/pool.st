accessing
pool
	^ pool ifNil:[ pool := WeakIdentityKeyDictionary  new ]