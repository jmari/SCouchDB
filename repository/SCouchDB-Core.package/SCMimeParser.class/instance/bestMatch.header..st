public
bestMatch:supported header:header
	|parsedHeader  best besti|

	parsedHeader:=self parseRanges:header.

	supported do:[:supportedi|
		best ifNil:[
			best:= (self fitnessAndQualityParsed:supportedi ranges:parsedHeader).
			besti:=supportedi].	
			((best at:1) <  ((self fitnessAndQualityParsed:supportedi ranges:parsedHeader) at:1)) ifTrue:[
				best:= (self fitnessAndQualityParsed:supportedi ranges:parsedHeader).
				besti:=supportedi]].

	^ besti
