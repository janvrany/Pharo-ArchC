Class {
	#name : #AsmOperandInstantiation,
	#superclass : #Object,
	#instVars : [
		'operands'
	],
	#category : #'ArchC-Core'
}

{ #category : #'instance creation' }
AsmOperandInstantiation class >> operands: opsArray [
	"See AcAsmOperandsParser>>operand.
	ops is essentially a lisp-like list represented in cons pairs.
	Here in Smalltalk, each pair is an Array with: car with: cdr.
	This representation is chosen because this is directly what
	comes out of the parser.
	"
	| car cdr |
	car := opsArray first.
	cdr := opsArray second.
	cdr isNil ifTrue: [ ^self singleOperand: car ].
	"This is for when the operand spans several fields.
	For example, on RISC-V:
	JAL rd, imm4+imm3+imm2+imm1"
	cdr := cdr second. "artefact of parsing"
	cdr operands addFirst: car.
	^cdr
]

{ #category : #'instance creation' }
AsmOperandInstantiation class >> singleOperand: op [
	^self new operands: (OrderedCollection with: op)
]

{ #category : #rewriting }
AsmOperandInstantiation >> inEnvironment: aDictionary format: f [
	^self operands collect: [ :subfield |
		| width v |
		width := f widthOf: subfield.
		v := aDictionary at: subfield.
		v asBitVector: width ]
]

{ #category : #testing }
AsmOperandInstantiation >> isMultiField [
	^self operands size ~= 1
]

{ #category : #accessing }
AsmOperandInstantiation >> operand [
	self isMultiField ifTrue: [ self error ].
	^self operands first
]

{ #category : #accessing }
AsmOperandInstantiation >> operands [
	^ operands
]

{ #category : #accessing }
AsmOperandInstantiation >> operands: anObject [
	operands := anObject
]
