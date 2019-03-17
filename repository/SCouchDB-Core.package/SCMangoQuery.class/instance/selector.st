options
selector
	|selector |
	^ selector :=self at:'selector' ifAbsent: [nil].
	