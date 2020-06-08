Class {
	#name : #AcSetAsm,
	#superclass : #Object,
	#instVars : [
		'source',
		'instruction',
		'formatChunks',
		'operands',
		'constraints'
	],
	#category : #'ArchC-Core'
}

{ #category : #'instance creation' }
AcSetAsm class >> format: aMnemonicFormat operandsAndConstraints: anArray [
	^self new
		format: aMnemonicFormat ;
		"Generally speaking, anArray will contain a mixture of operand names (Strings)
		and constraints which are operands pre-bound to values and therefore Associations."
		operands: (anArray select: [ :op | op isString ]);
		constraints: (Dictionary newFromAssociations: (anArray reject: [ :op | op isString ]));
		yourself
]

{ #category : #'API - assembly' }
AcSetAsm >> assembler [
	"Construct a parser which will parse the actual
	assembly statements."
	| chunkParsers |
	chunkParsers := self format collect: #assembler.
	^(PPSequenceParser withAll: chunkParsers) ==> [ :actualOperandsFromChunks |
		| actualOperands allOperands |
		actualOperands := actualOperandsFromChunks reject: #isNil.
		actualOperands := Dictionary newFromKeys: self operands andValues: actualOperands.
		allOperands := actualOperands copy addAll: constraints; yourself.
		self instruction inEnvironment: allOperands ]
]

{ #category : #accessing }
AcSetAsm >> constraints [
	^ constraints
]

{ #category : #accessing }
AcSetAsm >> constraints: anObject [
	constraints := anObject
]

{ #category : #'API - disassembly' }
AcSetAsm >> constraintsSatisfiedBy: aDictionary [
	"Answer whether the operand valuation given by aDictionary,
	satisfies the constraints of this syntactic form.
	Note that aDictionary MUST include everything in <constraints>."
	constraints associationsDo: [ :constraint |
		| thisValuation |
		thisValuation := aDictionary at: constraint key ifAbsent: [ nil ].
		thisValuation = constraint value ifFalse: [ ^false ] ].
	^true

]

{ #category : #'API - disassembly' }
AcSetAsm >> disassembleEnv: aDictionary [
	"Given the operand environment aDictionary,
	 answer a string of disassembly, or nil if
	 the environment does not fit this spec.
	 The answer is given in the form of Association,
	 whose key is the string of disassembly and the
	 value is an integer indicating the number of 
	 bound operands.  The latter is used to select
	 the most sepecific mnemonic form.
	OPERAND VALUES IN aDictionary MUST BE CONCRETE."
	
	| stream operandValues |
	(self constraintsSatisfiedBy: aDictionary) ifFalse: [ ^nil ].
	operandValues := (operands collect: [ :op | aDictionary at: op ]) asOrderedCollection.
	stream := WriteStream on: String new.
	self format do: [ :chunk | chunk  disassembleTo: stream inEnvironment: operandValues ].
	^stream contents -> constraints size
]

{ #category : #accessing }
AcSetAsm >> format [
	^ formatChunks
]

{ #category : #accessing }
AcSetAsm >> format: anObject [
	formatChunks := anObject
]

{ #category : #accessing }
AcSetAsm >> instruction [
	^ instruction
]

{ #category : #accessing }
AcSetAsm >> instruction: anObject [
	instruction := anObject
]

{ #category : #accessing }
AcSetAsm >> operands [
	^ operands
]

{ #category : #accessing }
AcSetAsm >> operands: anArray [
	
	operands := anArray 
]

{ #category : #printing }
AcSetAsm >> printOn: aStream [
	aStream nextPutAll: self source
]

{ #category : #accessing }
AcSetAsm >> source [
	^ source
]

{ #category : #accessing }
AcSetAsm >> source: anObject [
	source := anObject
]