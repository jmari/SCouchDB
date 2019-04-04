Class {
	#name : #SCViewServerTests,
	#superclass : #TestCase,
	#instVars : [
		'a'
	],
	#category : 'SCouchDB-ViewServer-Tests'
}

{ #category : #'as yet unclassified' }
SCViewServerTests >> server [
a ifNil:[a:=SCViewServer new.
		a commStream: (ReadWriteStream on:'').
		a commStream nextPutAll: '["list_end"]'.
		a commStream position: 0
		].
^a. 
]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testAddFun [

| b |
a:=self server.
a reset.
b:=a readFrom:'["add_fun","[:doc | self\r\t\temit: (doc)\r\t\tkey: nil]"]'.

self assert: ((a mainLoop: b)= 'true').
self assert: (a mapFunctions first isKindOf:BlockClosure)
]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDoc [

| b |
a:=self server. 
b:=a readFrom:'[
    "ddoc",
    "new",
    "_design/temp",
    {
        "_id": "_design/temp",
        "_rev": "8-d7379de23a751dc2a19e5638a7bbc5cc",
        "language": "javascript",
        "shows": {
            "request": "function(doc,req){ return {json: req}; }",
            "hello": "function(doc,req){ return {body: ''Hello, '' + (doc || {})._id + ''!''}; }"
        }
    }
]'.

self assert: ((a mainLoop: b)= 'true').
self assert: (a designDocs isKindOf:SCDesignDocsCache).
self assert: (a designDocs cache includesKey: '_design/temp')
]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDocF [

| b |
a:=self server. 
b:= SCChatExample new create.
a designDocs at: (b at: '_id') put:b.
b server:a.
self assert: (a designDocs cache includesKey: '_design/backbone_example')
]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDocMissingList [

| b result |
a:=self server.
a reset.
self testDDocNew.
b:=a readFrom:'["ddoc","_design/musalbums",["lists","albumIndex"],[{"total_rows":2,"update_seq":1867,"offset":0},{"uuid":"84aa61e42921b91eb8f898f320002ce8","id":null,"form":{},"requested_path":["albums","_design","musalbums","_list","albumIndex","albums"],"headers":{"Connection":"keep-alive","Host":"127.0.0.1:5984","If-None-Match":"\"6TSVEURSXGOTUO3Q6U5W43XH2\"","User-Agent":"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22","Cache-Control":"max-age=0","Accept-Encoding":"gzip,deflate,sdch","Accept-Language":"es-ES,es;q=0.8","Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8","Accept-Charset":"ISO-8859-1,utf-8;q=0.7,*;q=0.3"},"secObj":{"members":{"names":[],"roles":[]},"admins":{"names":["jmari","admin"],"roles":["albums-user"]}},"path":["albums","_design","musalbums","_list","albumIndex","albums"],"cookie":{},"raw_path":"/albums/_design/musalbums/_list/albumIndex/albums","userCtx":{"name":null,"roles":[],"db":"albums"},"method":"GET","info":{"doc_del_count":106,"instance_start_time":"1363667149974990","doc_count":4,"disk_size":408522858,"purge_seq":0,"data_size":1670972,"db_name":"albums","disk_format_version":6,"committed_update_seq":1867,"compact_running":false,"update_seq":1867},"body":"undefined","query":{},"peer":"127.0.0.1"}]]'.
result :=a mainLoop: b.


]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDocNew [

| b |
a:=self server. 
b:=a readFrom:'["ddoc","new","_design/musalbums",{"views":{"albums":{"map":"[:doc | self\r\t\temit: doc\r\t\tkey: (doc at: ''_id'')]"},"recent-items":{"reduce":"sum","map":"[:doc | self\r\t\temit: (doc at: ''creation_date'')\r\t\tkey: (doc at: ''creation_date'')]"}},"_rev":"266-3783602ebf95e5c752d5e234d2710bdf","_id":"_design/musalbums","lists":{"albumIndex":"[:head :req | self\r\t\tprovides: ''html''\r\t\twith: [:aHead :aReq | \r\t\t\t ''hello list'']]"},"shows":{"album-add":"[:aDoc :req | \r ''hello show'']"},"_attachments":{"javascript/images/icons-18-black.png":{"length":1968,"stub":true,"content_type":"image/png","revpos":266,"digest":"md5-JlZ8DjeHZvOLrzS7xzzw3Q=="},"javascript/images/icons-18-white.png":{"length":1988,"stub":true,"content_type":"image/png","revpos":266,"digest":"md5-vMN5e17iZZXekEU4/oTiiQ=="},"javascript/jquery-migrate-1.1.1.js":{"length":16689,"stub":true,"content_type":"application/x-javascript","revpos":266,"digest":"md5-cMbqTWdmgCpVE+AXoE+XVA=="},"javascript/images/ajax-loader.gif":{"length":7825,"stub":true,"content_type":"image/gif","revpos":266,"digest":"md5-CKMCj9qR1EP01ekzB8lvzQ=="},"javascript/jquery.mobile.theme-1.3.0.css":{"length":49688,"stub":true,"content_type":"text/css","revpos":266,"digest":"md5-Y2uRZFwFqxyqyThY76AuMQ=="},"javascript/jquery.mobile-1.3.0.js":{"length":355848,"stub":true,"content_type":"application/x-javascript","revpos":266,"digest":"md5-bjKTJm9kXhmpHkFfhBiqSQ=="},"javascript/jquery.mobile.structure-1.3.0.css":{"length":79733,"stub":true,"content_type":"text/css","revpos":266,"digest":"md5-oTMsCSwx89aAqweuhEOh9w=="},"javascript/images/icons-36-black.png":{"length":3859,"stub":true,"content_type":"image/png","revpos":266,"digest":"md5-AmbP70AXMHVm54HYFcoH9A=="},"javascript/jquery.mobile-1.3.0.css":{"length":136008,"stub":true,"content_type":"text/css","revpos":266,"digest":"md5-Q+fn+kVBe4UuMu4Y2NAMBQ=="},"javascript/images/icons-36-white.png":{"length":3861,"stub":true,"content_type":"image/png","revpos":266,"digest":"md5-y9pqDhr95ph1wQT26AnxsQ=="},"javascript/jquery-1.9.1.min.js":{"length":92629,"stub":true,"content_type":"application/x-javascript","revpos":266,"digest":"md5-OXdUuknp4M9OfBkNp43aBQ=="}},"language":"smalltalk"}]'.

self assert: ((a mainLoop: b)= 'true').
self assert: (a designDocs isKindOf:SCDesignDocsCache).
self assert: (a designDocs cache includesKey: '_design/musalbums')
]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDocRFilter [

| b |
a:=self server debugOn.
a reset.
self testDDocF.
b:=a readFrom: '[
    "ddoc",
    "_design/backbone_example",
    [
        "filters",
        "messages"
    ],
    [
        [
            {
                "_id": "431926a69504bde41851eb3c18a27b1f",
                "_rev": "1-967a00dff5e02add41819138abb3284d",
                "_revisions": {
                    "start": 1,
                    "ids": [
                        "967a00dff5e02add41819138abb3284d"
                    ]
                }
            },
				{
                "_id": "431926a69504bde41851eb3c18a27b1f",
                "_rev": "1-967a00dff5e02add41819138abb3284d",
                "_revisions": {
                    "start": 1,
                    "ids": [
                        "967a00dff5e02add41819138abb3284d"
                    ]
                }
            },
            {
                "_id": "0cb42c267fe32d4b56b3500bc503e030",
                "_rev": "1-967a00dff5e02add41819138abb3284d",
                "_revisions": {
                    "start": 1,
                    "ids": [
                        "967a00dff5e02add41819138abb3284d"
                    ]
                }
            }
        ],
        {
            "info": {
                "db_name": "test",
                "doc_count": 5,
                "doc_del_count": 0,
                "update_seq": 19,
                "purge_seq": 0,
                "compact_running": false,
                "disk_size": 8056936,
                "data_size": 7979745,
                "instance_start_time": "1374612186131612",
                "disk_format_version": 6,
                "committed_update_seq": 19
            },
            "id": null,
            "uuid": "7b695cb34a03df0316c15ab529023a81",
            "method": "GET",
            "requested_path": [
                "test",
                "_changes?filter=test",
                "random"
            ],
            "path": [
                "test",
                "_changes"
            ],
            "raw_path": "/test/_changes?filter=test/random",
            "query": {
                "filter": "test/random"
            },
            "headers": {
                "Accept": "application/json",
                "Accept-Encoding": "identity, gzip, deflate, compress",
                "Content-Length": "0",
                "Content-Type": "application/json; charset=utf-8",
                "Host": "localhost:5984"
            },
            "body": "",
            "peer": "127.0.0.1",
            "form": {},
            "cookie": {},
            "userCtx": {
                "db": "test",
                "name": null,
                "roles": [
                    "_admin"
                ]
            },
            "secObj": {}
        }
    ]
]'.


"we do not create the socket then we can not get nextRow"
self assert: (a mainLoop: b;lastPrinted) equals:'[true,[false,false,false]]'.

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDocRunList [

| b |
a:=self server.
a reset.
self testDDocNew.
b:=a readFrom:'["ddoc","_design/musalbums",["lists","albumIndex"],[{"total_rows":2,"update_seq":1867,"offset":0},{"uuid":"84aa61e42921b91eb8f898f320002ce8","id":null,"form":{},"requested_path":["albums","_design","musalbums","_list","albumIndex","albums"],"headers":{"Connection":"keep-alive","Host":"127.0.0.1:5984","If-None-Match":"\"6TSVEURSXGOTUO3Q6U5W43XH2\"","User-Agent":"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22","Cache-Control":"max-age=0","Accept-Encoding":"gzip,deflate,sdch","Accept-Language":"es-ES,es;q=0.8","Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8","Accept-Charset":"ISO-8859-1,utf-8;q=0.7,*;q=0.3"},"secObj":{"members":{"names":[],"roles":[]},"admins":{"names":["jmari","admin"],"roles":["albums-user"]}},"path":["albums","_design","musalbums","_list","albumIndex","albums"],"cookie":{},"raw_path":"/albums/_design/musalbums/_list/albumIndex/albums","userCtx":{"name":null,"roles":[],"db":"albums"},"method":"GET","info":{"doc_del_count":106,"instance_start_time":"1363667149974990","doc_count":4,"disk_size":408522858,"purge_seq":0,"data_size":1670972,"db_name":"albums","disk_format_version":6,"committed_update_seq":1867,"compact_running":false,"update_seq":1867},"body":"undefined","query":{},"peer":"127.0.0.1"}]]'.

"we do not create the socket then we can not get nextRow"
self assert: (a mainLoop: b;lastPrinted) equals:'["end",["hello list"]]'.

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testDDocRunShow [

| b |
a:=self server debugOn.
a reset.
self testDDocNew.
b:=a readFrom: '["ddoc","_design/musalbums",["shows","album-add"],[{"_rev":"1-f4cd6fbaa38f0e3fe2bf867c6ef91a2a","artist":"Mark Knopfler","_id":"31f9c19475a9950275cbfcd76506d88a","user":"jmari","_revisions":{"start":1,"ids":["f4cd6fbaa38f0e3fe2bf867c6ef91a2a"]},"album":"Get Lucky","description":" sixth solo album released on 14 September 2009"},{"uuid":"19c5956567607e2f00a820339c000bfc","id":"31f9c19475a9950275cbfcd76506d88a","form":{},"requested_path":["albums","_design","musalbums","_show","album","31f9c19475a9950275cbfcd76506d88a"],"headers":{"Host":"127.0.0.1:5984","Referer":"http://127.0.0.1:5984/albums/_design/musalbums/_list/albumIndex/albums","X-Requested-With":"XMLHttpRequest","User-Agent":"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22","Accept-Encoding":"gzip,deflate,sdch","Connection":"keep-alive","Accept-Language":"es-ES,es;q=0.8","Accept":"text/html, */*; q=0.01","Accept-Charset":"ISO-8859-1,utf-8;q=0.7,*;q=0.3"},"secObj":{"members":{"names":[],"roles":[]},"admins":{"names":["jmari","admin"],"roles":["albums-user"]}},"path":["albums","_design","musalbums","_show","album","31f9c19475a9950275cbfcd76506d88a"],"cookie":{},"raw_path":"/albums/_design/musalbums/_show/album/31f9c19475a9950275cbfcd76506d88a","userCtx":{"name":null,"roles":[],"db":"albums"},"method":"GET","info":{"doc_del_count":106,"instance_start_time":"1363794928956730","doc_count":4,"disk_size":409067626,"purge_seq":0,"data_size":1671020,"db_name":"albums","disk_format_version":6,"committed_update_seq":1868,"compact_running":false,"update_seq":1868},"body":"undefined","query":{},"peer":"127.0.0.1"}]]'.


"we do not create the socket then we can not get nextRow"
self assert: ((a mainLoop: b;lastPrinted)='["resp",{"body":"hello show"}]').

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testLog [

| b s c|

a:=self server.
b:=a readFrom:'["log", "A kuku!"]'.
c := (a mainLoop: b).
self assert: ( c isNil)

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testMapDoc [

| b s|
a:=self server.
a reset.
self testAddFun.
b:=a readFrom:'["map_doc", {"_id":"8877AFF9789988EE","_rev":"3-235256484","name":"John Smith","score": 60}]'.
s:= ReadStream on:(a mainLoop: b).
"[[[null, {'_id':'8877AFF9789988EE'...}]]]"
self assert: ((((((SCMaterializer readFrom:s) at:1 ) at:1) at:2) at:'_id') ='8877AFF9789988EE').

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testReReduce [

| b s|

self testReduce.
b:=a readFrom:'["rereduce",["sum"],[33,55,66]]'.

self assert: ((a mainLoop: b) = '[true,[154]]')

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testReduce [

| b|

self testMapDoc.
b:=a readFrom:'["reduce",["sum"],[[[1,"699b524273605d5d3e9d4fd0ff2cb272"],10],[[2,"c081d0f69c13d2ce2050d684c7ba2843"],20],[[null,"foobar"],3]]]\n'.

self assert: (a mainLoop: b) equals: '[true,[33]]'

]

{ #category : #'as yet unclassified' }
SCViewServerTests >> testReset [

| a b |
a:=SCViewServer new. 
b:=a readFrom:'["reset",{"timeout":5000,"reduce_limit":true}]'.

self assert: ((a mainLoop: b)= 'true').
self assert: (a mapFunctions isNil)
]
