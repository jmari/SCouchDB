persistence
save: aDoc
	"insert or update a doc"
	self database documentPut:aDoc
