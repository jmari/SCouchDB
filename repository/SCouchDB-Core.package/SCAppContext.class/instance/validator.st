accessing
validator
	^ validator ifNil:[validator:=SCValidator new].
	