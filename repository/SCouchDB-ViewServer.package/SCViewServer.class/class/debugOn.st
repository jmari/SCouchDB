debug
debugOn
	debug := true.
	servers keys do:[:aPort|
		(servers at:aPort ) debugOn.
		]
 