operations
new
	| jsonString result|

	jsonString := self database plainSerializer serialize: self.


	result:= self adaptor  post:(Array with:self database name with: self command)
						entity: ((ZnStringEntity 
										text:jsonString) contentType: ZnMimeType applicationJson ).
	self ddoc: (result at:'id').
	self name: (result at:'name').
	^ self 