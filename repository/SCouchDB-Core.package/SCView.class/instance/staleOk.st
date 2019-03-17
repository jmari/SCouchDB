query
staleOk
	"Allow the results from a stale view to be used, without triggering a rebuild of all views within the encompassing design doc. Supported values: ok and update_after"
	self adaptor znClient queryAt: #staleOk put: 'ok'.
	