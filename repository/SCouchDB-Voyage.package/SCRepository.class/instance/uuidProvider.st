accessing
uuidProvider
	^ uuidProvider ifNil:[ uuidProvider := SCCouchUUIDProvider on:self database]