Extension { #name : #AcAsmSyntax }

{ #category : #'*ArchC-DSL' }
AcAsmSyntax >> assembleDSL: mnemonic operands: operandList [
	| operandInstantiationIdx environment insn reloc |

	self assert: format operands size == format operands size.

	environment := Dictionary new.
	operandInstantiationIdx := 1.
	format mnemonic isTextChunk ifFalse: [ 
		"Mnemonic is composed from text and mapped values, for example in POWER
		 'bc%[lk]%[aa]' or in ARM 'ldm%cond%lstype'. Handle this case here."

		(format mnemonic assembler parse: mnemonic) do: [:operandValue |
			| operandDef  |

			operandDef := self operands at: operandInstantiationIdx.
			environment addAll: (operandDef asOperandInstantiation encodeValue: operandValue
									  accordingTo: instruction format).
			operandInstantiationIdx := operandInstantiationIdx + 1.
		].
	].

	operandList with: format operands  do: [:operandValue :operandFormat |
		| operandInstantationsUsed |

		operandInstantationsUsed := operandFormat assembleDSL: operandValue into: environment usingOperandInstantiations: operands startingAt: operandInstantiationIdx.
		operandInstantiationIdx := operandInstantiationIdx + operandInstantationsUsed.
	].
	self assert: operandInstantiationIdx = (self operands size + 1).

	self constraints keysAndValuesDo: [:operandDef :operandValue |
		environment addAll: (operandDef asOperandInstantiation encodeValue: operandValue
								  accordingTo: instruction format)
	]. 
	insn := self instruction inEnvironment: environment.
	reloc := operandList relocation.
	reloc notNil ifTrue: [
		insn relocation: operandList relocation
	].
	^ insn
]
