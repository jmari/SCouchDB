public
sendOnCanvas: aBlock
	|chunk|
	chunk:= html render:aBlock.
	chunks push: chunk asString