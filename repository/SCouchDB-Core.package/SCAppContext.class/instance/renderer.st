accessing
renderer
	^ renderer ifNil:[renderer:=SCRenderer on:server]