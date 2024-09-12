Extension { #name : #AcAsmFormatMapChunk }

{ #category : #'*ArchC-DSL' }
AcAsmFormatMapChunk >> assembleDSL: operand into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx [
	| operandInstantation |

	operand isAcDSLRegister ifFalse: [
		AcDSLInvalidOperandError signal:'Expecting register but got ' , operand printString , ' (', operand class name ,')'.
		^ 0
	].

	operandInstantation := operandInstantiations at: operandInstantiationStartIdx.
	environment addAll: (operandInstantation asOperandInstantiation encodeValue: (self modifier new x: operand) accordingTo: instruction format).

	^ 1
]
