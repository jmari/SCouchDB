private
doNotneedIdRev: anObject
	^ ((anObject isKindOf: SCJsonObject) & 	((anObject isKindOf: SCAppContext ) not))