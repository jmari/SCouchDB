debug
debugOff
	debugByDefault := false.
	self servers keys do:[:aPort|
		(self servers at:aPort ) debugOff.
		]