Extension { #name : #AcProcessorDescription }

{ #category : #'*ArchC-DSL' }
AcProcessorDescription >> assembleDSL: mnemonic operands: operands [
	"Given a `mnemonic` (as String) and `operands` (as AcDSLOperandList),
	 return assembled (encoded) instruction (ProcessorInstruction).

	 If there's no instruction with such `mnemonic`,
	 raise `AcDSLInvalidInstructionError`.

	 If there's such an instruction but the operands are invalid,
	 raise AcDSLInvalidOperandError.
	"
	| error |

	error := nil.
	self instructions do: [:instruction | 
		instruction syntax do: [:syntax | 
			syntax format operands size = operands size ifTrue: [
				syntax mnemonics do: [:each | 
					mnemonic = each ifTrue: [
						[
							^ syntax assembleDSL: mnemonic operands: operands
						] on: AcDSLInvalidOperandError do:[ :ex|
							error := ex.
						].
					].
				].
			].
		].
	].

	error notNil ifTrue: [
		error signal
	] ifFalse: [
		AcDSLInvalidInstructionError signal: 'Invalid instruction: ', mnemonic
	].
]
