as yet unclassified
testLog

| b s c|

a:=self server.
b:=a readFrom:'["log", "A kuku!"]'.
c := (a mainLoop: b).
self assert: ( c isNil)
