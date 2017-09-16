instance creation
stopAll
	servers keys do:[:aPort|
		(servers at:aPort ) stop.
		servers removeKey: aPort
		]
 
	

