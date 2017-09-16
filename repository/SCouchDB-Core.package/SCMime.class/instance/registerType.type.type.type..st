as yet unclassified
registerType:key type:type type:type2 type:type3

	type2 
		ifNil:[
			mimesByKey at:key put: (Array with:type).
			keysByMime at:type put:key]
		ifNotNil:[
			type3
				ifNil:[
					mimesByKey at:key put: (Array with:type with:type2).
					keysByMime at:type put:key.
					keysByMime at:type2 put:key]
				ifNotNil:[
					mimesByKey at:key put: (Array with:type with:type2 with:type3).
					keysByMime at:type put:key.
					keysByMime at:type2 put:key.
					keysByMime at:type3 put:key]]