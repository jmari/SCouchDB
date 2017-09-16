as yet unclassified
at: appName ifAbsent:aBlock
	| compiledCode |
	mutex critical:[ compiledCode := self cache at: appName ifAbsent:[nil]].
	^ compiledCode ifNil:[aBlock value].


	