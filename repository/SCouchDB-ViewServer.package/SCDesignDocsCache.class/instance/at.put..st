as yet unclassified
at: appName put:aCompiledSourceCode	
	self manageCacheSize.
	mutex critical: [	self cache at: appName put:aCompiledSourceCode	].

	