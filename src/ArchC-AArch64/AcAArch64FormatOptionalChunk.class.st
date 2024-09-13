Class {
	#name : #AcAArch64FormatOptionalChunk,
	#superclass : #AcAsmFormatSequenceChunk,
	#category : #'ArchC-AArch64-Parsing'
}

{ #category : #testing }
AcAArch64FormatOptionalChunk >> isOptionalChunk [
	^ true
]

{ #category : #'printing & storing' }
AcAArch64FormatOptionalChunk >> unparseOn: aStream [
	self unparseOn: aStream withComma: false
]

{ #category : #'printing & storing' }
AcAArch64FormatOptionalChunk >> unparseOn: aStream withComma: withComma [
	aStream nextPut: ${.
	withComma ifTrue: [ 
		aStream nextPut: $,.
	].
	subchunks do: [:each | each unparseOn: aStream ].
	aStream nextPut: $}.
]
