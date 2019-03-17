as yet unclassified
create
	self language:'smalltalk'.
	self initViews.
	self initShows.
	self initLists.
	self connectTo:'localhost' port:5984 userName:'admin' password:'admin'.
	self upload.
	self initDocs.



