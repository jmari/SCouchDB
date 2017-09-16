as yet unclassified
runProvides:req
	| bestFun bestKey |

	bestKey := self bestKeyForRequest: req.
	bestKey ifNotNil:[
		mimeFuns do:[:mimeFun|
			(bestKey = (mimeFun first)) ifTrue:[bestFun:= (mimeFun at:2)]]].

	bestFun 
		ifNil:[
			SCError new  
					messageText:(
						'not_acceptable:Content-type ',
						bestKey asString);
					signal]
		ifNotNil:[^ bestFun]
