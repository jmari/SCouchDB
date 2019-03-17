as yet unclassified
execute
	^ sourceApp 
			ifNil:[self database listAt: self app appName named: self name appliedTo: self data]
			ifNotNil:[self database listAt: self app appName named: self name appliedTo: self data inApp: self sourceApp]