as yet unclassified
at: appName ifAbsentPut:aBlock
	| compiledCode |
	self manageCacheSize.
	mutex critical:[ compiledCode := self cache at: appName ifAbsentPut:aBlock].
	^ compiledCode .


	