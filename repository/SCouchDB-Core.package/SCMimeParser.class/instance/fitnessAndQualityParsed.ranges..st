public
fitnessAndQualityParsed:mimeType ranges:parsedRanges
	|bestFitness bestFitQ target targetType targetSubtype targetParams fitness|
	bestFitness:=-1.
	bestFitQ:=0.
	target:= self parseMediaRange:mimeType.
	targetType:=(target at:1).
	targetSubtype:=(target at:2).
	targetParams:=(target at:3).
	parsedRanges do:[:parsed|
		|type subtype params|
		type:=(parsed at:1).
		subtype:=(parsed at:2).
		params:=(parsed at:3).
		(((type=targetType) or:[(type='*') or:[targetType='*']]) and:[
			((subtype=targetSubtype) or:[(subtype='*') or:[targetSubtype='*']])])
			 ifTrue:[
				|matchCount|
				matchCount:=0.
				targetParams do:[:param|
					((param = 'q') not and: 
					[(params includesKey:param)  and:
					[(params at:param) = (targetParams at:param)]])
							ifTrue:[matchCount := matchCount +1]].
						
				fitness:= ((type=targetType) 
							ifTrue:[100] 
							ifFalse:[0]).
				fitness:= fitness +((subtype=targetSubtype) 
							ifTrue:[10]
							ifFalse:[0]).
				fitness:=fitness + matchCount.
				
				(fitness > bestFitness) ifTrue:[
					bestFitness:=fitness.
					bestFitQ:=(params at:'q')]		
			]	
	].
	^ (Array with:bestFitness with:(bestFitQ asFloat))