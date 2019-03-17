as yet unclassified
testReduce

| b|

self testMapDoc.
b:=a readFrom:'["reduce",["sum"],[[[1,"699b524273605d5d3e9d4fd0ff2cb272"],10],[[2,"c081d0f69c13d2ce2050d684c7ba2843"],20],[[null,"foobar"],3]]]\n'.

self assert: (a mainLoop: b) equals: '[true,[33]]'
