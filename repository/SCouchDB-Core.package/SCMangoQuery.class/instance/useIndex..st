accessing
useIndex: anIndex
	"'design-doc' 'index_name'"
	self at:'use_index' put: (Array with:anIndex ddoc with:anIndex name)