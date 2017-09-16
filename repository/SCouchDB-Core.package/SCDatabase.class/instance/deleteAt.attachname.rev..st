documents-attachment
deleteAt: id attachname: attName rev: aRev

	self adaptor znClient queryAt:'rev' put: aRev.
	^ self adaptor delete: (self self arrayWith: self name with: id with: attName).
					