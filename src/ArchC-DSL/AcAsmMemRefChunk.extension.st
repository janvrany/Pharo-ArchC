Extension { #name : #AcAsmMemRefChunk }

{ #category : #'*ArchC-DSL' }
AcAsmMemRefChunk >> assembleDSL: operand into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx [
	| usedByOffset usedByBase |

	operand isAcDSLMemRef ifFalse: [
		AcDSLInvalidOperandError signal:'Expecting memory reference but got ' , operand printString , ' (', operand class name ,')'.
		^ 0
	].

	usedByOffset := offset assembleDSL: operand offset into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx.
	self assert: usedByOffset > 0 description: 'offset (displacement) not encoded!'.

	usedByBase := base assembleDSL: operand base into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx + usedByOffset.
	self assert: usedByBase > 0 description: 'base not encoded!'.

	^ usedByOffset + usedByBase.
]
