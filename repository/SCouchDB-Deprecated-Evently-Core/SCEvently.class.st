Class {
	#name : #SCEvently,
	#superclass : #SCJsonObject,
	#instVars : [
		'events',
		'triggers'
	],
	#category : 'SCouchDB-Deprecated-Evently-Core'
}

{ #category : #private }
SCEvently >> addTriggersFromJSCode:eV [
	| i j k eventName eventlyEvent|
	eventlyEvent:=eV asString.
	i:=1.j:=1.k:=1.
	eventName := ''.
	[i = 0] whileFalse:[
		i:= eventlyEvent findString:'.trigger' startingAt:i. 
		(i>0) ifTrue:[
			i:= eventlyEvent findString: '(' startingAt: i.
			j:= eventlyEvent findString: ')' startingAt: i.
	
			eventName:=(eventlyEvent copyFrom:i to: j) trimBoth.
			eventName:=eventName copyFrom:2 to:(eventName size -1). 
			k:= eventName findString:','.
			(k=0 and:[(i ~= 0 and:[j~=0])]) ifTrue: [eventName:= (eventName copyFrom:2 to:(eventName size -1))].
			(k>0 and:[(i ~= 0 and:[j~=0])]) ifTrue: [eventName:= (eventName copyFrom:2 to:(k -2))]].
			(eventName notNil and:[eventName size>1 and:[(eventName at:1) ~=$_]]) 				ifTrue:[self triggers add:eventName]]

]

{ #category : #accessing }
SCEvently >> at:anEventlyName [

	^super at:(anEventlyName) ifAbsentPut:[SCEvently new] 
]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent [
	| e |
	e:=self at:(anEventlyName).
	^e onEvent:anEvent
]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent data:aDataString [
	| e |
	e:=self at:anEventlyName onEvent:anEvent.
	e data:aDataString.
	^ e

]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent data:aDataString mustache:aMustacheString [
	| e |
	e:=self at:anEventlyName onEvent:anEvent.
	e data:aDataString.
	e mustache:aMustacheString.
	^ e


]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent do:anObject [
	| e |
	e:=self at:(anEventlyName).
	^e onEvent:anEvent do:anObject
]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent mustache:aMustacheString [
	| e |
	e:=self at:anEventlyName onEvent:anEvent.
	e mustache:aMustacheString.
	^ e

]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent  mustache:aMustacheString data:aDataString [
	| e |
	e:=self at:anEventlyName onEvent:anEvent.
	e data:aDataString.
	e mustache:aMustacheString.
	^e

]

{ #category : #accessing }
SCEvently >> at:anEventlyName onEvent:anEvent selector:aJQuerySelector [
	| e |
	e:=self at:(anEventlyName).
	^(e onEvent:anEvent ) selector:aJQuerySelector
]

{ #category : #accessing }
SCEvently >> data: aStringData [
	self at:'data' put:aStringData
]

{ #category : #accessing }
SCEvently >> data: aStringData mustache:aMustacheTemplate [
	self data:aStringData.
	self mustache:aMustacheTemplate
]

{ #category : #private }
SCEvently >> events [
	^ events 
]

{ #category : #'as yet unclassified' }
SCEvently >> initialize: size [
	super initialize:size.
	events := OrderedCollection new.
	triggers:= OrderedCollection new.
]

{ #category : #protected }
SCEvently >> isAJQueryEventListener [

	(self triggers isEmpty) ifFalse:[^true].
	self values do:[:aSCEvenlyObject|
		(aSCEvenlyObject isAJQueryEventListener) ifTrue:[^true]].
	^false
 

]

{ #category : #protected }
SCEvently >> listeningAt:anEventlyNode [
	|la at en |

	"get triggers"
	en :=Set new.
	at:=(self at:anEventlyNode) triggering. 
	self keys do:[:aNode|
		la:= Set new.
		la addAll: (at select:[:aE| aNode~=anEventlyNode and:[(self at:aNode) listeningTo includes: aE]]).
		la size>0 ifTrue:[en add:(Array with:aNode with:la asArray)]].
	^en asArray
]

{ #category : #protected }
SCEvently >> listeningTo [
	|oc|
	oc:=OrderedCollection new.
	oc addAll: self events.
	self values do:[:anEvenlyObject|
		(anEvenlyObject isKindOf:SCEvently) ifTrue: 
			[oc addAll: anEvenlyObject events]].
	^oc asArray

]

{ #category : #accessing }
SCEvently >> mustache: aMustacheTemplate [
	(aMustacheTemplate isKindOf:MustacheTemplate)
		ifTrue:[self at:'mustache' put: aMustacheTemplate render]
		ifFalse:[self at:'mustache' put: aMustacheTemplate asString]
]

{ #category : #accessing }
SCEvently >> mustache:aMustacheTemplate data: aStringData [ 
	self data:aStringData.
	self mustache:aMustacheTemplate
]

{ #category : #accessing }
SCEvently >> onEvent:anEventlyEvent [
	((anEventlyEvent at:1 )~=$_) ifTrue:[self events add:anEventlyEvent].
	^self at:anEventlyEvent 
]

{ #category : #accessing }
SCEvently >> onEvent:anEvent data:aDataString [
	| e |
	e:=self onEvent:anEvent.
	e data:aDataString.
	^ e

]

{ #category : #accessing }
SCEvently >> onEvent:anEvent data:aDataString mustache:aMustacheString [
	| e |
	e:=self onEvent:anEvent.
	e data:aDataString.
	e mustache:aMustacheString.
	^e


]

{ #category : #accessing }
SCEvently >> onEvent:anEvent do:anObject [
anObject isArray ifTrue:[triggers addAll: anObject ]
	ifFalse:[self addTriggersFromJSCode:anObject].
	((anEvent at:1 )~=$_) ifTrue:[self events add:anEvent].
self at:anEvent put:anObject.
^self at:anEvent 
]

{ #category : #accessing }
SCEvently >> onEvent:anEvent mustache:aMustacheString [
	| e |
	e:=self  onEvent:anEvent.
	e mustache:aMustacheString.
	^e

]

{ #category : #accessing }
SCEvently >> onEvent:anEvent  mustache:aMustacheString data:aDataString [
	| e |
	e:=self onEvent:anEvent.
	e data:aDataString.
	e mustache:aMustacheString.
	^e

]

{ #category : #accessing }
SCEvently >> onEvent:anEvent selector:aJQuerySelector [

	^ (self onEvent:anEvent ) selector:aJQuerySelector
]

{ #category : #accessing }
SCEvently >> query [
	^ self at:'query' ifAbsentPut: [ SCEventlyQuery new ]
]

{ #category : #accessing }
SCEvently >> selector:aSelector [
	^ self selectors at:aSelector ifAbsentPut:[SCEventlySelector new]
]

{ #category : #'form-events' }
SCEvently >> selector:aSelector onBlur: eventHandler [
	self selector:aSelector  onEvent:'blur' do:eventHandler
]

{ #category : #'form-events' }
SCEvently >> selector: aSelector onChange: eventHandler [
	self selector:aSelector  onEvent:'change' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onClick: eventHandler [
	self selector:aSelector onEvent:'click' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onDblClick: eventHandler [
	self selector:aSelector onEvent:'dblclick' do:eventHandler
]

{ #category : #'browser-events' }
SCEvently >> selector: aSelector onError: eventHandler [
	self selector:aSelector onEvent:'error' do:eventHandler
]

{ #category : #accessing }
SCEvently >> selector:aSelector onEvent:jqueryEvent do:eventlyEvent [
	|tSelector|
 	eventlyEvent isArray 
						ifTrue:[triggers addAll: eventlyEvent ]
	 					ifFalse:[self addTriggersFromJSCode:eventlyEvent].
	tSelector:=aSelector asString.
	(aSelector isKindOf:Symbol) ifTrue:[tSelector:= '#',tSelector].
^	(self selector:tSelector) onEvent:jqueryEvent do:eventlyEvent 
]

{ #category : #'form-events' }
SCEvently >> selector:aSelector onFocus: eventHandler [
	self selector:aSelector onEvent:'focus' do:eventHandler
]

{ #category : #'keyboard-events' }
SCEvently >> selector:aSelector onFocusIn: eventHandler [
	self selector:aSelector onEvent:'focusin' do:eventHandler
]

{ #category : #'keyboard-events' }
SCEvently >> selector:aSelector onFocusOut: eventHandler [
	self selector:aSelector onEvent:'focusout' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onHover: eventHandler [
	self selector:aSelector onEvent:'hover' do:eventHandler
]

{ #category : #'keyboard-events' }
SCEvently >> selector:aSelector onKeyDown: eventHandler [
	self selector:aSelector onEvent:'keydown' do:eventHandler
]

{ #category : #'keyboard-events' }
SCEvently >> selector:aSelector onKeyPress: eventHandler [
	self selector:aSelector onEvent:'keypress' do:eventHandler
]

{ #category : #'keyboard-events' }
SCEvently >> selector:aSelector onKeyUp: eventHandler [
	self selector:aSelector onEvent:'keyup' do:eventHandler
]

{ #category : #'document-events' }
SCEvently >> selector:aSelector onLoad: eventHandler [
	self selector:aSelector  onEvent:'load' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseDown: eventHandler [
	self selector:aSelector onEvent:'mousedown' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseEnter: eventHandler [
	self selector:aSelector onEvent:'mouseenter' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseLeave: eventHandler [
	self selector:aSelector onEvent:'mouseleave' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseMove: eventHandler [
	self selector:aSelector onEvent:'mousemove' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseOut: eventHandler [
	self selector:aSelector onEvent:'mouseout' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseOver: eventHandler [
	self selector:aSelector onEvent:'mouseover' do:eventHandler
]

{ #category : #'mouse-events' }
SCEvently >> selector:aSelector onMouseUp: eventHandler [
	self selector:aSelector onEvent:'mouseup' do:eventHandler
]

{ #category : #'document-events' }
SCEvently >> selector:aSelector onReady: eventHandler [
	self selector:aSelector onEvent:'ready' do:eventHandler
]

{ #category : #'browser-events' }
SCEvently >> selector:aSelector onResize: eventHandler [
	self selector:aSelector  onEvent:'resize' do:eventHandler
]

{ #category : #'browser-events' }
SCEvently >> selector:aSelector onScroll: eventHandler [
	self selector:aSelector onEvent:'scroll' do:eventHandler
]

{ #category : #'form-events' }
SCEvently >> selector:aSelector onSelect: eventHandler [
	self selector:aSelector  onEvent:'select' do:eventHandler
]

{ #category : #'form-events' }
SCEvently >> selector:aSelector onSubmit: eventHandler [
	self selector:aSelector  onEvent:'submit' do:eventHandler
]

{ #category : #'document-events' }
SCEvently >> selector:aSelector onUnload: eventHandler [
	self selector:aSelector onEvent:'unload' do:eventHandler
]

{ #category : #private }
SCEvently >> selectors [
	^ self at:'selectors' ifAbsent:[self at:'selectors' put:(SCJsonObject new)].
]

{ #category : #protected }
SCEvently >> triggering [
	|oc|
	oc:=OrderedCollection new.
	oc addAll: self triggers.
	self values do:[:anEvenlyObject|
		(anEvenlyObject isKindOf:SCEvently) ifTrue: 
			[oc addAll: anEvenlyObject triggering]].
	^oc asArray
]

{ #category : #private }
SCEvently >> triggers [
	^ triggers 
]
