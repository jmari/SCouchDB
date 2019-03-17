utils
couchdb

	^ couchdb ifNil:[couchdb := SCAdaptor new host: self host port: self port userName:'admin' password:'admin'].
