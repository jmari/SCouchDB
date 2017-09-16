build-in-reduceFunctions
stats

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
			sqSum:= sqSum+ (e at:'sumSqr').
			count:= count + e at:'count'.
		].
		avg := (count > 0)
					ifFalse:[0.0 ] 
					ifTrue:[sum / count].
		variance:= (count > 0)
					ifFalse:[0.0 ] 
					ifTrue:[ (((sqSum / count) - ((sum /count ) squared)) )].
		stdDev :=variance sqrt.
		result :={
							'min'-> min.
							'max'-> max.
							'avg'-> avg.
							'sum'-> sum.
							'count'-> count.
							'variance'->variance.
							'stdDev'->stdDev.
							'sumSqr'->sqSum
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
			sqSum:= sqSum+ (value* value)]
		].
		avg := (count > 0)
					ifFalse:[0.0 ] 
					ifTrue:[sum / count].
		variance:= (count > 0)
					ifFalse:[0.0 ] 
					ifTrue:[ (((sqSum / count) - ((sum/count ) squared)) )].
		stdDev :=variance sqrt.
		result :={
							'min'-> min.
							'max'-> max.
							'avg'-> avg.
							'sum'-> sum.
							'count'-> count.
							'variance'->variance.
							'stdDev'->stdDev.
							'sumSqr'->sqSum
							} asDictionary .
		].
	]
