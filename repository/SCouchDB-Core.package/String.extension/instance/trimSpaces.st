*SCouchDB-Core
trimSpaces
|i j|
i:=1. 
j:= self size.

(self size = 0) ifTrue:[^self].
[((self at: i) =  Character space) and:[i < self size] ] whileTrue:[i:= i + 1].
[((self at: j) =  Character space) and:[j >= i] ] whileTrue:[ j:= j - 1].

^ self copyFrom: i to: j