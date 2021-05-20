Class {
	#name : #SCAppContext,
	#superclass : #SCDocument,
	#instVars : [
		'buf',
		'mime',
		'filter',
		'server',
		'buildInReduceFunctions',
		'renderer',
		'validator'
	],
	#category : 'SCouchDB-Core-Application'
}

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> compiledFunctions [
^  buildInReduceFunctions ifNil:[
	buildInReduceFunctions:=Dictionary new.
	buildInReduceFunctions at:'sum' hash put: self sum.
	buildInReduceFunctions at:'count' hash put: self count.
	buildInReduceFunctions at:'stats' hash put: self stats.
	buildInReduceFunctions at:'statistics' hash put: self stats.
	buildInReduceFunctions at:'min' hash put: self min.
	buildInReduceFunctions at:'max' hash put: self max.
	buildInReduceFunctions at:'quartiles' hash put: self quartiles.	
	buildInReduceFunctions at:'_sum' hash put: self sum.
	buildInReduceFunctions at:'_count' hash put: self count.
	buildInReduceFunctions at:'_stats' hash put: self stats.
	buildInReduceFunctions at:'_min' hash put: self min.
	buildInReduceFunctions at:'_max' hash put: self max.
	buildInReduceFunctions
	]
	ifNotNil:[buildInReduceFunctions]
]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> count [
^ [:k :v :rereduce|
	|result|
	result:=0.
	rereduce 
	ifTrue:[
		v do:[:e| 
			result:= result + e.
		]. 
	]
	ifFalse:[
		result := v size.
		].
	result "returns result"
	]


]

{ #category : #views }
SCAppContext >> emit:aJsonDoc [
	self emit: aJsonDoc key: 'null'

	

]

{ #category : #views }
SCAppContext >> emit:aJsonDoc key:aKey [
	buf ifNil:[buf:= Stack new].
	buf push:( Array with:aKey with: aJsonDoc).
	self filter viewEmit:true.

	

]

{ #category : #'validate-wrapper' }
SCAppContext >> enforce:aBlock [
	^ self validator enforce:aBlock
]

{ #category : #'validate-wrapper' }
SCAppContext >> field:aField shouldBe:value [
	^ self validator field:aField shouldBe:value
]

{ #category : #'validate-wrapper' }
SCAppContext >> field:aField shouldNotBe:value [
	^ self validator field:aField shouldNotBe:value
]

{ #category : #accessing }
SCAppContext >> filter [
	^ filter ifNil:[filter:= SCFilter on:server].


]

{ #category : #accessing }
SCAppContext >> filter: anObject [
	filter := anObject
]

{ #category : #'render-wrapper' }
SCAppContext >> getRow [
	^ self renderer getRow
]

{ #category : #builders }
SCAppContext >> htmlCanvas [
	| a |
	a := Smalltalk at:#WAHtmlCanvas ifAbsent:[^nil].
	^ a builder
]

{ #category : #accessing }
SCAppContext >> indexers [
	^ self validator indexers
]

{ #category : #'validate-wrapper' }
SCAppContext >> isAdmin [
	^ self validator isAdmin
]

{ #category : #testing }
SCAppContext >> isSCAppContext [ 
	^ true
]

{ #category : #'render-wrapper' }
SCAppContext >> lastRow [
	^ self renderer lastRow
]

{ #category : #views }
SCAppContext >> mapDoc [
	| arr|
	^ buf 
		ifNil:[Stack new]
		ifNotNil: [ 	
					arr := buf.
					buf := Stack new.
					arr ]


	

]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> max [
^ [:k :v :rereduce|
	|result|
	result:=v at:1.
	v do:[:aval|
		(aval>result) ifTrue:[result:=aval].
	].
	result]


]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> median: v from:a to:b [ 
	|median pos tmp |

	pos:=b - a.
	pos even
	ifTrue:[
		median:= v at:((pos / 2.0) + a)
	]
	ifFalse:[
		tmp:=a + ((pos + 1.0) / 2.0) - 1.0.
		pos:=tmp + 1.0.
		median:=(( v at: tmp)  + (v at: pos)) asFloat  / 2.0.
	].

	^ median


]

{ #category : #accessing }
SCAppContext >> mime [
	^ mime ifNil:[mime := SCMime new]
]

{ #category : #accessing }
SCAppContext >> mime: anObject [
	^ mime := anObject
]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> min [
^ [:k :v :rereduce|
	|result|
	result:=v at:1.
	v do:[:aval|
		(aval< result) ifTrue:[result:=aval].
	].
	result]


]

{ #category : #'mime-wrapper' }
SCAppContext >> provides:mimeKey with:aBlock [

	self mime provides:mimeKey aBlock:aBlock
]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> quartiles [
^ [:k :v :rereduce|
	self flag: #todo. "how to do it in map reduce..."
	]


]

{ #category : #'render-wrapper' }
SCAppContext >> redirectTo: anUrl [
	| s |

	s := SCJsonObject new.
	s code:302.
	s body:'See other'.
	s headers: (SCJsonObject new Location:anUrl;yourself).
	^ s.

]

{ #category : #accessing }
SCAppContext >> renderer [
	^ renderer ifNil:[renderer:=SCRenderer on:server]
]

{ #category : #'validate-wrapper' }
SCAppContext >> required:aField [
	^ self validator required:aField
]

{ #category : #'render-wrapper' }
SCAppContext >> send:aBlock [
	^ renderer send:aBlock
]

{ #category : #accessing }
SCAppContext >> server [
	^ server
]

{ #category : #accessing }
SCAppContext >> server: anObject [
	server := anObject
]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> stats [

| value |
^ [:k :v :rereduce|
	|avg min max sum  count sqSum stdDev variance result|

	avg:=0.0.min:=0.0.max:=0.0.sum:=0.0.count:=0.0.stdDev:=0.0.sqSum:=0.0.variance:=0.0.

	rereduce 
	ifTrue:[
		min:= (v at:1) at:'min' .
		max:= (v at:1) at:'max'.
	
		v do:[:e| 
			((e at:'min') < min) ifTrue:[min:=(e at:'min')].
			((e at:'max') > max) ifTrue:[max:=(e at:'max')].
			sum:= sum + (e at:'sum').
			sqSum:= sqSum + (e at:'sqSum').
			count:= count + (e at:'count').
		].
		avg := (count > 0)
					ifFalse:[sum] 
					ifTrue:[sum / count].
		(count > 1)
					ifFalse:[variance:=stdDev := 0.0 ] 
					ifTrue:[ 
						variance:= ((sqSum  - (count * (avg  squared))) / (count - 1.0)) asFloat.
						stdDev := variance>0 ifTrue:[variance sqrt] ifFalse:[0]].
		result :={
							'min'-> min.
							'max'-> max.
							'avg'-> avg.
							'sum'-> sum.
							'count'-> count.
							's2'->variance.
							'stdDev'->stdDev.
							'sqSum'->sqSum
							} asDictionary .
	]
	ifFalse:[
		min:= (v at:1) asFloat.
		max:= (v at:1) asFloat.
		sum:= 0.0.
		
		count:= v size asFloat.
		v do:[:e| 
			value := e isNumber ifTrue:[e asFloat] ifFalse:[nil].
			value ifNotNil:[
			(value < min) ifTrue:[min:=value].
			(value > max) ifTrue:[max:=value].
			sum:= sum + value.
			sqSum:= sqSum + (value squared)]
		].
		avg := (count > 0)
					ifFalse:[sum] 
					ifTrue:[sum / count].
		(count > 1)
					ifFalse:[variance:=stdDev := 0.0 ] 
					ifTrue:[ 
						variance:= ((sqSum  - (count * ( avg  squared))) / (count - 1.0)) asFloat.
						stdDev := variance>0 ifTrue:[variance sqrt] ifFalse:[0]].
		
		result :={
							'min'-> min.
							'max'-> max.
							'avg'-> avg.
							'sum'-> sum.
							'count'-> count.
							's2'->variance.
							'stdDev'->stdDev.
							'sqSum'->sqSum
							} asDictionary .
		].
	]
]

{ #category : #'render-wrapper' }
SCAppContext >> stopSendingRows [
"Still not working, Why?"
	| s |
	
	s:=SCJsonObject  new.
	s at:'stop' put:true.
	^ s
]

{ #category : #'build-in-reduceFunctions' }
SCAppContext >> sum [
	^ [:k :v :rereduce|
		|result|
		result:=0.
		v do:[:aval|
			result:=result + aval
		].
		result]


]

{ #category : #'validate-wrapper' }
SCAppContext >> unchanged:aField [
	^ self validator unchanged:aField
]

{ #category : #'validate-wrapper' }
SCAppContext >> userIs:aRol [
	^ self validator userIs:aRol
]

{ #category : #accessing }
SCAppContext >> validator [
	^ validator ifNil:[validator:=SCValidator new].
	
]

{ #category : #builders }
SCAppContext >> xmlCanvas [
	| a |
	a := Smalltalk at:#WAXmlCanvas ifAbsent:[^ nil].
	^ a builder
]
