as yet unclassified
testDDocRunShow

| b |
a:=self server debugOn.
a reset.
self testDDocNew.
b:=a readFrom: '["ddoc","_design/musalbums",["shows","album-add"],[{"_rev":"1-f4cd6fbaa38f0e3fe2bf867c6ef91a2a","artist":"Mark Knopfler","_id":"31f9c19475a9950275cbfcd76506d88a","user":"jmari","_revisions":{"start":1,"ids":["f4cd6fbaa38f0e3fe2bf867c6ef91a2a"]},"album":"Get Lucky","description":" sixth solo album released on 14 September 2009"},{"uuid":"19c5956567607e2f00a820339c000bfc","id":"31f9c19475a9950275cbfcd76506d88a","form":{},"requested_path":["albums","_design","musalbums","_show","album","31f9c19475a9950275cbfcd76506d88a"],"headers":{"Host":"127.0.0.1:5984","Referer":"http://127.0.0.1:5984/albums/_design/musalbums/_list/albumIndex/albums","X-Requested-With":"XMLHttpRequest","User-Agent":"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22","Accept-Encoding":"gzip,deflate,sdch","Connection":"keep-alive","Accept-Language":"es-ES,es;q=0.8","Accept":"text/html, */*; q=0.01","Accept-Charset":"ISO-8859-1,utf-8;q=0.7,*;q=0.3"},"secObj":{"members":{"names":[],"roles":[]},"admins":{"names":["jmari","admin"],"roles":["albums-user"]}},"path":["albums","_design","musalbums","_show","album","31f9c19475a9950275cbfcd76506d88a"],"cookie":{},"raw_path":"/albums/_design/musalbums/_show/album/31f9c19475a9950275cbfcd76506d88a","userCtx":{"name":null,"roles":[],"db":"albums"},"method":"GET","info":{"doc_del_count":106,"instance_start_time":"1363794928956730","doc_count":4,"disk_size":409067626,"purge_seq":0,"data_size":1671020,"db_name":"albums","disk_format_version":6,"committed_update_seq":1868,"compact_running":false,"update_seq":1868},"body":"undefined","query":{},"peer":"127.0.0.1"}]]'.


"we do not create the socket then we can not get nextRow"
self assert: ((a mainLoop: b;lastPrinted)='["resp",{"body":"hello show"}]').
