accessing
appName

	^ appName ifNil:[
			self at:'_id' 
		  		ifPresent:[ appName :=  ((self at:'_id') findTokens: $/) at:2]
		  		ifAbsent:[ appName := self className asLowercase ]]
	