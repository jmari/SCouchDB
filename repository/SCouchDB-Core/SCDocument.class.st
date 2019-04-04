Class {
	#name : #SCDocument,
	#superclass : #SCJsonObject,
	#category : 'SCouchDB-Core'
}

{ #category : #'as yet unclassified' }
SCDocument class >> newFrom: anObject [
	| scObj uuid rev|
	scObj := super newFrom:anObject.
	uuid := SCObjectsCache instance keyAtValue: anObject. 
	rev := SCObjectsCache instance revisionAt: uuid.
	uuid ifNotNil:[ scObj id: uuid].
	rev ifNotNil:[ scObj rev: rev].
	^ scObj
]

{ #category : #'as yet unclassified' }
SCDocument >> attachmentAt: aString put: aFileReference [
	"aString is the node name"
	^ self attachments at: aString  put: (SCAttachment 
																fromFileRef: aFileReference 
																withName: aString)
]

{ #category : #'as yet unclassified' }
SCDocument >> attachments [
	^ self at: '_attachments' ifAbsentPut:[SCJsonObject new].
]

{ #category : #'as yet unclassified' }
SCDocument >> hasAttachments [
	
	^  self at: '_attachments' ifPresent:[ (self at: '_attachments') size > 0] ifAbsent:[ false ] .
	
]

{ #category : #'as yet unclassified' }
SCDocument >> id [
	^ self at:'_id'
]

{ #category : #'as yet unclassified' }
SCDocument >> id:anId [
	self at:'_id' put:anId asString
	
]

{ #category : #'as yet unclassified' }
SCDocument >> importAttachmentsFrom:aFolderPath [
	self importAttachmentsFrom:aFolderPath relPath:'' prefix:''
]

{ #category : #'as yet unclassified' }
SCDocument >> importAttachmentsFrom:aFolderPath relPath:relPath prefix: aPrefix [
	| dir a elements attchPath |

	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
		entry isDirectory 
		ifTrue:[
		(relPath='') 
			ifTrue:[	self importAttachmentsFrom:aFolderPath relPath:(entry name) prefix:aPrefix]
			ifFalse:[	self importAttachmentsFrom:aFolderPath relPath:(relPath , DiskStore activeClass delimiter asString, entry name) prefix:aPrefix]]
		ifFalse:[	
			a := SCAttachment fromFileRef: (aFolderPath,relPath , DiskStore activeClass delimiter asString, entry name ,  DiskStore activeClass delimiter asString) asFileReference.  

		(relPath='') 
			ifFalse:[attchPath:=(relPath , DiskStore activeClass delimiter asString, entry name)]
			ifTrue:[attchPath:=( entry name)].
		attchPath:= attchPath copyReplaceAll: '\' with: '/'.
		a fileName:  (aPrefix,attchPath).
		self attachments at: (aPrefix,attchPath) put: a  

		]
	]
]

{ #category : #'as yet unclassified' }
SCDocument >> isDeleted [
	^ self at:'_deleted' ifAbsent:[false]
]

{ #category : #'as yet unclassified' }
SCDocument >> removeAttachment:aString [
	^ self attachments removeKey:aString ifAbsent:[nil]
]

{ #category : #'as yet unclassified' }
SCDocument >> rev [
	^ self at:'_rev'
]

{ #category : #'as yet unclassified' }
SCDocument >> rev:aRev [
	self at:'_rev' put:aRev
	
]
