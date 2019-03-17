as yet unclassified
testSerializeObjectCircularReferences
	| obj sobj mobj|

	'{
		"_id":"68bo431p0vk4jdkwbn8hz5s2v",
		"#instanceOf":"SCDomainClassForTest",
		"a":1,
		"b":{"_id":"68bo431p0vk4jdkwbn8hz5s2v","#instanceOf":"SCDomainClassForTest"},
		"c":{	
				"_id":"dzo98pj9j4d4sxs2a79bsnlzs",
				"#instanceOf":"Dictionary",
				"me":{
							"_id":"68bo431p0vk4jdkwbn8hz5s2v",
							"#instanceOf":"SCDomainClassForTest"},
				"hola":"hello"}
	}'.

	obj := SCDomainClassForTest new.
	sobj := self serializer serialize: obj.
	mobj := self materializer materialize: sobj.
	self assert:  mobj b a equals:mobj a .
	mobj a:22.
		self assert:  mobj b a equals:mobj a .
