instance creation
stop:aPort
	| s |
	s:=servers at:aPort ifAbsent:[^ nil].
	s stop.
	servers removeKey: aPort
 	
	

