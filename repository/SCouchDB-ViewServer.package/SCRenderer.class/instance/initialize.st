runner
initialize
	super initialize.
	chunks:=Stack new.
	lastRow:=false.
	gotRow:=false.
	html:=self htmlCanvas.
	xml:=self xmlCanvas.

