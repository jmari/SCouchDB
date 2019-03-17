as yet unclassified
testDDocF

| b |
a:=self server. 
b:= SCSimpleApp  new create.
a designDocs at: (b at: '_id') put:b.
b server:a.
self assert: (a designDocs cache includesKey: '_design/scsimpleapp')