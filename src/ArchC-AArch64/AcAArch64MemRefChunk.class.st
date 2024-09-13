Class {
	#name : #AcAArch64MemRefChunk,
	#superclass : #AcAsmMemRefChunk,
	#instVars : [
		'scale',
		'extend'
	],
	#category : #'ArchC-AArch64-Parsing'
}

{ #category : #'instance creation' }
AcAArch64MemRefChunk class >> base: base [
	^ self new
		base: base;
		yourself.
]

{ #category : #'instance creation' }
AcAArch64MemRefChunk class >> base: base offset: offset scale: scale [
	^ self new
		base: base;
		offset: offset;
		scale: scale;
		yourself.
]

{ #category : #'instance creation' }
AcAArch64MemRefChunk class >> base: base offset: offset scale: scale extend: extend [
	^ self new
		base: base;
		offset: offset;
		scale: scale;
		extend: extend;
		yourself.
]

{ #category : #'API - assembly' }
AcAArch64MemRefChunk >> assembler [
	"Return an `PPParser` responsible for parsing this chunk.
	 As a parse result the parser should return *an array* of
	 operand values."

	^ $[ asParser trim , base assembler , ($# asParser trim optional , offset assembler) optional , $] asParser trim
		==> [ :nodes | Array with: nodes second first with: nodes third second first ]
]

{ #category : #accessing }
AcAArch64MemRefChunk >> extend [
	^ extend
]

{ #category : #accessing }
AcAArch64MemRefChunk >> extend: something [
	extend := something.
]

{ #category : #accessing }
AcAArch64MemRefChunk >> instruction: aProcessorInstructionDeclaration [
	base instruction: aProcessorInstructionDeclaration.
	offset notNil ifTrue:[offset instruction: aProcessorInstructionDeclaration].
	scale notNil ifTrue:[scale instruction: aProcessorInstructionDeclaration].
	extend notNil ifTrue:[extend instruction: aProcessorInstructionDeclaration].
]

{ #category : #accessing }
AcAArch64MemRefChunk >> scale [
	^ scale
]

{ #category : #accessing }
AcAArch64MemRefChunk >> scale: something [
	scale := something.
]

{ #category : #'printing & storing' }
AcAArch64MemRefChunk >> unparseOn: aStream [

	aStream nextPut: $[.
	base unparseOn: aStream.
	offset isNil ifTrue: [
		aStream nextPutAll: '{, #0}'
	] ifFalse: [
		scale isNil ifTrue: [
			aStream nextPutAll: '{, '.
			offset unparseOn: aStream.
		] ifFalse: [
			aStream nextPutAll: ', '.
			offset unparseOn: aStream.
			extend isNil ifTrue: [
				aStream nextPutAll: '{, lsl '.
			] ifFalse: [
				aStream nextPutAll: ', '.
				extend unparseOn: aStream.
				aStream nextPut: ${.
			].
			scale unparseOn: aStream.
		].
		aStream nextPut: $}.
	].
	aStream nextPut: $].
]
