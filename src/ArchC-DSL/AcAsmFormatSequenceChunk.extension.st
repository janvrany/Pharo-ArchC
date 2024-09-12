Extension { #name : #AcAsmFormatSequenceChunk }

{ #category : #'*ArchC-DSL' }
AcAsmFormatSequenceChunk >> assembleDSL: operand into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx [
	| operandInstantiationsUsed |

	operandInstantiationsUsed := 0.
	subchunks do: [:chunk |
		| used  |

		used := chunk assembleDSL: operand into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx.
		operandInstantiationsUsed == 0 ifTrue: [
			"Operand was not yet encoded"
			operandInstantiationsUsed := used
		] ifFalse: [
			"Operand was encoded so subsequent chunk must not encode it again."
			self assert: used == 0.
		].
	].
	^ operandInstantiationsUsed
]
