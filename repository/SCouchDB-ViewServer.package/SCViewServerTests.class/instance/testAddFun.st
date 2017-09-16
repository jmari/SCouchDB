as yet unclassified
testAddFun

| b |
a:=self server.
a reset.
b:=a readFrom:'["add_fun","[:doc | self\r\t\temit: (doc)\r\t\tkey: nil]"]'.

self assert: ((a mainLoop: b)= 'true').
self assert: (a mapFunctions first isKindOf:BlockClosure)