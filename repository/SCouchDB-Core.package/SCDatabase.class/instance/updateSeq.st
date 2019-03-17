query
updateSeq
	" Response includes an update_seq value indicating which sequence id of the underlying database the view reflects. Default is false"
	self adaptor znClient queryAt: 'update_seq' put: true.
	