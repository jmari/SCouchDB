documents
documentAt: id ifAbsent: aBlock
	^ [self documentAt: id] on:Error do:[aBlock value]