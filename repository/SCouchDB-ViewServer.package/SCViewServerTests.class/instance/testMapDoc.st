as yet unclassified
testMapDoc

| b s|
a:=self server.
a reset.
self testAddFun.
b:=a readFrom:'["map_doc", {"_id":"8877AFF9789988EE","_rev":"3-235256484","name":"John Smith","score": 60}]'.
s:= ReadStream on:(a mainLoop: b).
"[[[null, {'_id':'8877AFF9789988EE'...}]]]"
self assert: ((((((SCMaterializer readFrom:s) at:1 ) at:1) at:2) at:'_id') ='8877AFF9789988EE').
