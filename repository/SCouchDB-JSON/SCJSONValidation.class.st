Class {
	#name : #SCJSONValidation,
	#superclass : #Object,
	#instVars : [
		'gitDirectory',
		'logStream'
	],
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #private }
SCJSONValidation >> closeLog [
	logStream ifNotNil: [ 
		logStream close.
		logStream := nil ].
	^ self logFile exists
		ifTrue: [ self logFile contents ] 
		ifFalse: [ 'log file is empty' ]
]

{ #category : #private }
SCJSONValidation >> ensureLog [
	logStream ifNil: [ 
		logStream := self logFile ensureDelete; writeStream. 
		logStream setToEnd ]
	
]

{ #category : #accessing }
SCJSONValidation >> gitDirectory [
	^ gitDirectory ifNil: [ gitDirectory := FileLocator home / #Develop / #git ]
]

{ #category : #accessing }
SCJSONValidation >> gitDirectory: fileReference [
	gitDirectory := fileReference
]

{ #category : #accessing }
SCJSONValidation >> jsonTestSuiteDirectory [
	^ self gitDirectory / #JSONTestSuite
]

{ #category : #accessing }
SCJSONValidation >> jsonTestSuiteTestParsingDirectory [
	^ self jsonTestSuiteDirectory / 'test_parsing'
]

{ #category : #accessing }
SCJSONValidation >> jsonTestSuiteTestParsingFailFiles [
	^ self jsonTestSuiteTestParsingDirectory childrenMatching: 'n_*.json'
]

{ #category : #accessing }
SCJSONValidation >> jsonTestSuiteTestParsingInfoFiles [
	^ self jsonTestSuiteTestParsingDirectory childrenMatching: 'i_*.json'
]

{ #category : #accessing }
SCJSONValidation >> jsonTestSuiteTestParsingPassFiles [
	^ self jsonTestSuiteTestParsingDirectory childrenMatching: 'y_*.json'
]

{ #category : #accessing }
SCJSONValidation >> jsonTestSuiteTestTransformDirectory [
	^ self jsonTestSuiteDirectory / 'test_transform'
]

{ #category : #private }
SCJSONValidation >> log: message [
	self ensureLog.
	logStream nextPutAll: message; lf; flush

]

{ #category : #private }
SCJSONValidation >> logFile [
	^ 'neo-json-validation.log' asFileReference
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkDataDirectory [
	^ self nativeJsonBenchmarkDirectory / #data
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkDirectory [
	^ self gitDirectory / 'nativejson-benchmark'
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkJsonCheckerDirectory [
	^ self nativeJsonBenchmarkDataDirectory / #jsonchecker
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkJsonCheckerFailFiles [
	^ self nativeJsonBenchmarkJsonCheckerDirectory childrenMatching: 'fail*.json'
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkJsonCheckerPassFiles [
	^ self nativeJsonBenchmarkJsonCheckerDirectory childrenMatching: 'pass*.json'
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkRoundTripDirectory [
	^ self nativeJsonBenchmarkDataDirectory / #roundtrip
]

{ #category : #accessing }
SCJSONValidation >> nativeJsonBenchmarkRoundTripFiles [
	^ self nativeJsonBenchmarkRoundTripDirectory children
]

{ #category : #running }
SCJSONValidation >> runJsonTestSuiteTestParsingFailures [
	^ self
		validateFiles: self jsonTestSuiteTestParsingFailFiles 
		usingTest: [ :file | 
			| data success |
			success := false.
			[ data := file readStreamDo: [ :in | (NeoJSONReader on: in) next; failIfNotAtEnd ] ]
				on: NeoJSONParseError
				do: [ :exception | self log: exception printString. success := true ].
			success ]
]

{ #category : #running }
SCJSONValidation >> runJsonTestSuiteTestParsingInfo [
	^ self
		validateFiles: self jsonTestSuiteTestParsingInfoFiles 
		usingTest: [ :file | 
			| data success |
			success := true.
			[ data := file readStreamDo: [ :in | (NeoJSONReader on: in) next ] ]
				on: NeoJSONParseError
				do: [ :exception | self log: exception printString. success := false ].
			success ]
]

{ #category : #running }
SCJSONValidation >> runJsonTestSuiteTestParsingPasses [
	^ self
		validateFiles: self jsonTestSuiteTestParsingPassFiles 
		usingTest: [ :file | 
			| data success |
			success := true.
			[ data := file readStreamDo: [ :in | (NeoJSONReader on: in) next ] ]
				on: NeoJSONParseError
				do: [ :exception | self log: exception printString. success := false ].
			success ]
]

{ #category : #running }
SCJSONValidation >> runNativeJsonBenchmarkJsonCheckerFailures [
	^ self
		validateFiles: self nativeJsonBenchmarkJsonCheckerFailFiles
		usingTest: [ :file | 
			| data success |
			success := false.
			[ data := file readStreamDo: [ :in | (NeoJSONReader on: in) next; failIfNotAtEnd ] ]
				on: NeoJSONParseError
				do: [ :exception | self log: exception printString. success := true ].
			success ]
]

{ #category : #running }
SCJSONValidation >> runNativeJsonBenchmarkJsonCheckerPasses [
	^ self
		validateFiles: self nativeJsonBenchmarkJsonCheckerPassFiles
		usingTest: [ :file | 
			| data success |
			success := true.
			[ data := file readStreamDo: [ :in | (NeoJSONReader on: in) next ] ]
				on: NeoJSONParseError
				do: [ :exception | self log: exception printString. success := false ].
			success ]
]

{ #category : #running }
SCJSONValidation >> runNativeJsonBenchmarkRoundTrip [
	^ self 
		validateFiles: self nativeJsonBenchmarkRoundTripFiles
		usingTest: [ :file |
			| data json |
			data := file readStreamDo: [ :in | (NeoJSONReader on: in) next ].
			json := NeoJSONWriter toString: data.
			json = file contents ]
]

{ #category : #private }
SCJSONValidation >> validateFiles: files usingTest: block [
	| total succeeded failed |
	total := succeeded := failed := 0.
	files do: [ :file | 
		| success |
		self log: 'Running ' , file pathString.
		self log: ([ file contents contractTo: 64 ] on: Error do: [ :exception | exception printString ]).
		success := [ block value: file ]
			on: Error
			do: [ :exception | self log: '  Errored. ' , exception printString. false ].
		total := total + 1.
		success
			ifTrue: [ succeeded := succeeded + 1 ]
			ifFalse: [ failed := failed + 1 ].
		self log: (success ifTrue: [ '  Succeeded' ] ifFalse: [ '  Failed' ]); log: '' ].
	self log: ('{1} total = {2} succeeded + {3} failed' format: (Array with: total with: succeeded with: failed) ).
	^ self closeLog
]
