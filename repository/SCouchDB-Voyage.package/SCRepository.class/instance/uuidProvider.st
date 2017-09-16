accessing
uuidProvider
	^ uuidProvider ifNil:[ uuidProvider := SCUUIDProvider on:self database]