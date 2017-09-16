design-docs
ddoc: jArg 
	| cmd ddocId funPath funArgs ddoc fun validateDocUpdate |

	cmd := jArg at: 2.
	cmd = 'new'
		ifTrue: [ddocId := jArg at: 3.
			self designDocs 
						at: ddocId
						put:(SCApp fromDictionary: (jArg at: 4) on:self).
			^ #true].
	"cmd is 'new' or docId"
	ddocId := cmd.
	ddoc := self designDocs 
						at: ddocId
						ifAbsent:[SCDdocNotFoundException 
										signal:'uncached design doc:' , ddocId asString].
	funPath := jArg at: 3.
	cmd := funPath at: 1.
	funArgs := jArg at: 4.
	validateDocUpdate:= (cmd ='validate_doc_update').
	
	fun := ddoc at: cmd ifAbsent:[SCMissingFunction signal: 'missing: ',cmd,' on Design doc' , ddocId].
	fun :=validateDocUpdate  
						ifTrue:[ ddoc at: (funPath at: 1)]
						ifFalse:[ fun at: (funPath at: 2)].
	^ self
		ddocCommand: cmd
		function: fun
		dDoc: ddoc
		fwithArguments: funArgs	
		funcName: (validateDocUpdate  
						ifTrue:[ cmd ]
						ifFalse:[funPath 
										at: 2 
										ifAbsent:[ SCMissingFunction 
														signal: 
															'missing: ',
															(funPath at: 2),
															' on Design doc',ddocId]]).