operations
get
	^ self adaptor get: (Array with: self database name with:'_index')
