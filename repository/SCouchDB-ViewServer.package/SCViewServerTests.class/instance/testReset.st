as yet unclassified
testReset

| a b |
a:=SCViewServer new. 
b:=a readFrom:'["reset",{"timeout":5000,"reduce_limit":true}]'.

self assert: ((a mainLoop: b)= 'true').
self assert: (a mapFunctions isNil)