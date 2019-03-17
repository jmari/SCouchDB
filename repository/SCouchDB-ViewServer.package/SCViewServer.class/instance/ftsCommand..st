fts
ftsCommand:aJsonRequestObject
	| ddoc indexer searchString response|
	"full text search needs an OIndexer"
	response:= SCJsonObject new.
	[ddoc:= self designDocs at:('_design/' , (aJsonRequestObject path at:3)).
	indexer:=ddoc indexerAt:(aJsonRequestObject path at:4).
	searchString:= aJsonRequestObject path at:5.
	] on: Exception do:[
		response code:510.
		self println:( self serializer  serialize:response).
		^self].
	response code:200.
	response json: (indexer findPhrase:searchString).
	self println:( self serializer  serialize:response)
