build-in-reduceFunctions
sum
	^ [:k :v :rereduce|
		|result|
		result:=0.
		v do:[:aval|
			result:=result + aval
		].
		result]

