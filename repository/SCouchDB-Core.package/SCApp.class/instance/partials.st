accessing
partials
	| templates |
	templates:= self at:'templates' ifAbsentPut:[SCJsonObject new].
	^ templates at:'partials' ifAbsentPut:[SCJsonObject new]