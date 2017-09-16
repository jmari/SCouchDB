database
getDatabasePath: aPath

	^ self adaptor get: (self arrayWith: self name with: aPath).
