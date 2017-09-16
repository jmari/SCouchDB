build-in-reduceFunctions
max
^ [:k :v :rereduce|
	|result|
	result:=v at:1.
	v do:[:aval|
		(aval>result) ifTrue:[result:=aval].
	].
	result]

