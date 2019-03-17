build-in-reduceFunctions
compiledFunctions
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