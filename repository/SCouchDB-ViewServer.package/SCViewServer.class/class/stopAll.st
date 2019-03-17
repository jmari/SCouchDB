instance creation
stopAll
	self servers keys do:[:aPort| self stop: aPort]
 
	

