as yet unclassified
testDDocRunList

| b |
a:=self server.
a reset.
self testDDocNew.
b:=a readFrom:'["ddoc","_design/musalbums",["lists","albumIndex"],[{"total_rows":2,"update_seq":1867,"offset":0},{"uuid":"84aa61e42921b91eb8f898f320002ce8","id":null,"form":{},"requested_path":["albums","_design","musalbums","_list","albumIndex","albums"],"headers":{"Connection":"keep-alive","Host":"127.0.0.1:5984","If-None-Match":"\"6TSVEURSXGOTUO3Q6U5W43XH2\"","User-Agent":"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22","Cache-Control":"max-age=0","Accept-Encoding":"gzip,deflate,sdch","Accept-Language":"es-ES,es;q=0.8","Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8","Accept-Charset":"ISO-8859-1,utf-8;q=0.7,*;q=0.3"},"secObj":{"members":{"names":[],"roles":[]},"admins":{"names":["jmari","admin"],"roles":["albums-user"]}},"path":["albums","_design","musalbums","_list","albumIndex","albums"],"cookie":{},"raw_path":"/albums/_design/musalbums/_list/albumIndex/albums","userCtx":{"name":null,"roles":[],"db":"albums"},"method":"GET","info":{"doc_del_count":106,"instance_start_time":"1363667149974990","doc_count":4,"disk_size":408522858,"purge_seq":0,"data_size":1670972,"db_name":"albums","disk_format_version":6,"committed_update_seq":1867,"compact_running":false,"update_seq":1867},"body":"undefined","query":{},"peer":"127.0.0.1"}]]'.

"we do not create the socket then we can not get nextRow"
self assert: (a mainLoop: b;lastPrinted) equals:'["end",["hello list"]]'.
