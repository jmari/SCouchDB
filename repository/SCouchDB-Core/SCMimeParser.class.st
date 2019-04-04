Class {
	#name : #SCMimeParser,
	#superclass : #Object,
	#category : 'SCouchDB-Core'
}

{ #category : #public }
SCMimeParser >> bestMatch:supported header:header [
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

]

{ #category : #public }
SCMimeParser >> fitnessAndQualityParsed:mimeType ranges:parsedRanges [
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
]

{ #category : #public }
SCMimeParser >> parseMediaRange:aRange [
	|q parsedType nq |

	parsedType:= self parseMimeType:aRange.
	q:= (parsedType at:3) at:'q' ifAbsent:['1'].
	[nq:= q asFloat] on:Error do:[ 
			(parsedType at:3) at:'q' put:'1'.	
			nq := 1].
	(nq <0 or:[nq>1]) ifTrue:[
			(parsedType at:3) at:'q' put:'1'].
	^ parsedType



]

{ #category : #public }
SCMimeParser >> parseMimeType: mimeType [
	"Caves up a mime-type and return an array of the type [type,subtype,{params}]"
	|fullType typeParts params parts p|
	params:= SCJsonObject new.
	parts:= mimeType subStrings:$;.
	parts do:[:aPart|
		p:=aPart subStrings:$=.
		((p size )= 2) ifTrue:[
			params at:(self strip: (p at:1)) put:(self strip: (p at:2)).
			]
		].
	fullType:= (self strip: (parts at:1)).
	fullType='*' ifTrue:[fullType:='*/*'].
	typeParts := fullType subStrings:$/.
	^ (Array with: (typeParts at:1) with: (typeParts at:2) with:params)
]

{ #category : #private }
SCMimeParser >> parseRanges:ranges [
	|rangeParts|

	rangeParts := ranges subStrings:$,.
	^ rangeParts collect:[:part| self parseMediaRange:part ].
	

]

{ #category : #public }
SCMimeParser >> quality:mimeType ranges:ranges [
	^ (self qualityParsed:mimeType ranges:ranges)
]

{ #category : #public }
SCMimeParser >> qualityParsed:mimeType ranges:parsedRanges [
	^ (self fitnessAndQualityParsed:mimeType ranges:parsedRanges) at:2
]

{ #category : #private }
SCMimeParser >> strip:aMimeHeader [
	^ aMimeHeader decodeMimeHeader
]
