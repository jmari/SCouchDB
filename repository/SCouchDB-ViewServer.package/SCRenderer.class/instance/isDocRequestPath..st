runner
isDocRequestPath:info
	|path|
	path:=info at:'path'.
	^ (path size >5)
