initalize
initialize
	super initialize.
	providesUsed:=false.
	mimeFuns:=OrderedCollection new.
	keysByMime := SCJsonObject new.
	mimesByKey := SCJsonObject new.
	mimeParser:=SCMimeParser new.
	self registerType:'all' type:'*/*'.
	self registerType:'text' type:'text/plain; charset=utf-8' type:'txt'.
	self registerType:'html' type:'text/html; charset=utf-8'.
	self registerType:'xhtml' type:'application/xhtml;+xml' type:'xhtml'.
	self registerType:'xml' type:'application/xml' type:'text/xml' 	type:'application/x-xml'.
	self registerType:'js' type:'text/javascript' type:'application/javascript' 	type:'application/x-javascript'.
	self registerType:'css' type:'text/css'.
	self registerType:'ics' type:'text/calendar'.
	self registerType:'csv' type:'text/csc'.
	self registerType:'rss' type:'application/rss+xml'.
	self registerType:'atom' type:'application/atom+xml'.
	self registerType:'yaml' type:'application/yaml' type:'text/yaml'.
	self registerType:'multipart_form' type:'multipart/form-data'.
	self registerType:'url_encoded_form' type:'application/x-www-form-urlencoded'.
	self registerType:'json' type:'application/json' type:'text/x-json'

