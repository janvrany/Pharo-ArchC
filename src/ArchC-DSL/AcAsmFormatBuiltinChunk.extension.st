Extension { #name : #AcAsmFormatBuiltinChunk }

{ #category : #'*ArchC-DSL' }
AcAsmFormatBuiltinChunk >> assembleDSL: operand into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx [
	| operandInstantation |

	(operand isAcDSLImmediate or:[operand isAcDSLSymbol]) ifFalse: [
	"FIXME: Hack.
	 Sigh, POWER model uses %imm for operands that are really registers.
	 This looks like a ugly abuse of a fact than in Power assembly, one
	 refer to registers just using numbers (no 'r' or '$' or similar like
	 all normal archs). So until we get better-quality POWER model, we have
	 to skip the check."
	(#(powerpc powerpc64) includes: instruction isa architectureName) ifFalse: [
		AcDSLInvalidOperandError signal:'Expecting immediate or symbol but got ' , operand printString , ' (', operand class name ,')'.
		^ 0
	]."End of hack"
	].

	operandInstantation := operandInstantiations at: operandInstantiationStartIdx.
	environment addAll: (operandInstantation asOperandInstantiation encodeValue: (self modifier new x: operand) accordingTo: instruction format).

	^ 1
]
