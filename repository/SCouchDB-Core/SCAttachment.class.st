Class {
	#name : #SCAttachment,
	#superclass : #SCJsonObject,
	#instVars : [
		'name',
		'fileName',
		'stream'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #initialize }
SCAttachment class >> fromFileRef: fileLocator [

	^ self fromFileRef: fileLocator withName: fileLocator basename.

]

{ #category : #initialize }
SCAttachment class >> fromFileRef: fileLocator withName: aFileName [
	| newAtt  |
	newAtt := self new.
	newAtt 
		stream: (ZnFileSystemUtils fileStreamFor: fileLocator) binary;
		contentType:  (ZnMimeType forFilenameExtension: (ZnFileSystemUtils extensionFor: fileLocator)) asString;
	 	contentLength: (ZnFileSystemUtils fileSizeFor: fileLocator);
		fileName: aFileName.
	^ newAtt
]

{ #category : #'as yet unclassified' }
SCAttachment >> contentLength [
	^ self at:'length'
]

{ #category : #'as yet unclassified' }
SCAttachment >> contentLength:lenght [
	self at:'length' put:lenght
]

{ #category : #'as yet unclassified' }
SCAttachment >> contentType [
	^ self at:'content_type' ifAbsentPut:[ZnMimeType text ]
]

{ #category : #'as yet unclassified' }
SCAttachment >> contentType:type [
	self at:'content_type' put:type
]

{ #category : #'as yet unclassified' }
SCAttachment >> fileName [
	^fileName
]

{ #category : #'as yet unclassified' }
SCAttachment >> fileName:aName [
	fileName:=aName
]

{ #category : #'as yet unclassified' }
SCAttachment >> initialize:size [
	super initialize:size.
	self at:'follows' put:true.
]

{ #category : #'as yet unclassified' }
SCAttachment >> stream [
	|a|
	"stream is only setted when the instance creation is done with fromStream:withName:"
	stream ifNotNil: [^stream reset].
	a:=StandardFileStream readOnlyFileNamed:fileName .
	a binary.
	^a


]

{ #category : #'as yet unclassified' }
SCAttachment >> stream:aStream [
	stream:=aStream.


]
