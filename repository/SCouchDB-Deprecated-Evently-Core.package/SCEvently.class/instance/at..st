accessing
at:anEventlyName

	^super at:(anEventlyName) ifAbsentPut:[SCEvently new] 