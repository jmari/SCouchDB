as yet unclassified
testReReduce

| b s|

self testReduce.
b:=a readFrom:'["rereduce",["sum"],[33,55,66]]'.

self assert: ((a mainLoop: b) = '[true,[154]]')
