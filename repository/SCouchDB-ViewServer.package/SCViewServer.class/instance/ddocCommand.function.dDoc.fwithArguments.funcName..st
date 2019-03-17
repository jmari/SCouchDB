design-docs
ddocCommand: cmd function: fun dDoc: ddoc fwithArguments: funArgs funcName: funcName
| function|
"commands:= #('lists' 'shows' 'filters' 'views' 'updates' 'validate_doc_update')."

(cmd='lists') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc listAt:funcName put:function.
			^ddoc renderer runList:function ddoc:ddoc args:funArgs].


(cmd='shows') 
ifTrue:[
			function:= self evaluate:fun for:ddoc  logged:false.
			ddoc showAt:funcName put:function.
			^ddoc renderer runShow:function ddoc:ddoc args:funArgs	].
			
(cmd='updates') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc updateHandlerAt:funcName put:function.
			^ddoc renderer runUpdate:function ddoc:ddoc args:funArgs ].

(cmd='filters') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc filterAt:funcName put:function.
			^ddoc filter runFilter:function ddoc:ddoc args:funArgs ].

(cmd='views') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc viewAt:funcName put:function.
			^ddoc filter runFilterView:function ddoc:ddoc args:funArgs
	].

(cmd='validate_doc_update') 
ifTrue:[
			function:= self evaluate:fun for:(ddoc validator) logged:false.
			ddoc validateDocUpdate:function.
			ddoc validator args:funArgs.
			^ddoc validator runValidate:function ddoc:ddoc args:funArgs	]