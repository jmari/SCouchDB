runner
resetList
	self gotRow:false.
	self lastRow:false.
	chunks :=Stack new.
	startResp:= SCJsonObject new

