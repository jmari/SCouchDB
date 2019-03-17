as yet unclassified
testDDocRFilter

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
