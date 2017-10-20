private
uuidProvider
	^ uuidProvider ifNil:[ uuidProvider := SCSmalltalkUUIDProvider 
																					new
																						idField: self idField;
																						yourself	]