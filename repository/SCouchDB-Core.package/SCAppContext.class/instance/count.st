build-in-reduceFunctions
count
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

