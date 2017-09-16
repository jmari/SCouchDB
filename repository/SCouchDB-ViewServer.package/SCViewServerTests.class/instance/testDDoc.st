as yet unclassified
testDDoc

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