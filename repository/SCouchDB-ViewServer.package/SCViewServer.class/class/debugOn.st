debug
debugOn
	debugByDefault := true.
	self servers keys do:[:aPort|
		(self servers at:aPort ) debugOn.
		]
 