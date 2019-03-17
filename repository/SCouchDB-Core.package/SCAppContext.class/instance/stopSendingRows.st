render-wrapper
stopSendingRows
"Still not working, Why?"
	| s |
	
	s:=SCJsonObject  new.
	s at:'stop' put:true.
	^ s