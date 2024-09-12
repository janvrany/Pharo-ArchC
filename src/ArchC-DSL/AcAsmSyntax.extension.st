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
		self assert: operandValue isAcDSLMemRef == operandFormat isMemRefChunk.

		"FIXME: this is not the best thing to to, we need to come up with nicer,
		 more extensible code! But for now it will do."
		operandValue isAcDSLMemRef ifTrue: [ 
			| offsetDef offsetMod baseDef baseMod |

			offsetDef := self operands at: operandInstantiationIdx.
			offsetMod := operandFormat offset modifier.

			baseDef := self operands at: operandInstantiationIdx + 1.
			baseMod := operandFormat base modifier.

			environment addAll: (offsetDef asOperandInstantiation encodeValue: (offsetMod new x: operandValue offset)
									  accordingTo: instruction format).
			environment addAll: (baseDef asOperandInstantiation encodeValue: (baseMod new x: operandValue base)
									  accordingTo: instruction format).

			operandInstantiationIdx := operandInstantiationIdx + 2.
		] ifFalse: [
			| operandDef operandModifier  |

			operandDef := self operands at: operandInstantiationIdx.
			operandModifier := operandFormat modifier.

			environment addAll: (operandDef asOperandInstantiation encodeValue: (operandModifier new x: operandValue)
									  accordingTo: instruction format).

			operandInstantiationIdx := operandInstantiationIdx + 1.
		].    
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
