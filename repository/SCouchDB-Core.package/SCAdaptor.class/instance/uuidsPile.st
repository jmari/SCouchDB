private
uuidsPile
	^ uuidsPile ifNil:[
			uuidsPile:= Stack new.
			self uuids: self class maxUUIDsInMemory. 
			uuidsPile
			]