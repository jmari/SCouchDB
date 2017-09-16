query
batch
	"batchs the operation, it will be in memory until is is commited by Couchdb"
	self adaptor znClient queryAt: 'batch' put: true.
	