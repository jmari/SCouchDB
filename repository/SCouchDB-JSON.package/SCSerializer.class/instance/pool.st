private
pool
	^ pool ifNil:[ pool := WeakIdentityKeyDictionary  new ]