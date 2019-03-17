documents
documentAt: id

	"read a single json document"
	
	^ 	self adaptor get: (self arrayWith: self name with: id)		
