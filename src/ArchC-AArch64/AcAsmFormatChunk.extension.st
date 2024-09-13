Extension { #name : #AcAsmFormatChunk }

{ #category : #'*ArchC-AArch64' }
AcAsmFormatChunk >> isOptionalChunk [
	^ false
]

{ #category : #'*ArchC-AArch64' }
AcAsmFormatChunk >> isSequenceChunk [
	^ false
]

{ #category : #'*ArchC-AArch64' }
AcAsmFormatChunk class >> optional: anObject [
	self assert: anObject isCollection not.
	^ AcAArch64FormatOptionalChunk new subchunks: (Array with: anObject)
]
