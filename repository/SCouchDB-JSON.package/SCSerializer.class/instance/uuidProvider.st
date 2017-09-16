private
uuidProvider
	^ uuidProvider ifNil:[ uuidProvider := SCSmalltalkUUIDProvider new]