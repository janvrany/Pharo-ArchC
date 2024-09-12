Extension { #name : #AcAsmFormatChunk }

{ #category : #'*ArchC-DSL' }
AcAsmFormatChunk >> assembleDSL: operand into: environment usingOperandInstantiations: operandInstantiations startingAt: operandInstantiationStartIdx [
	"Given an operand (instance of `AcDSLOperand`) , update environment according to passed
	 operand instantiations and operandInstantiationStartIdx.

	 If this chunk encodes the operand (that is, updates environment according to encoding and operand value),
	 it returns  a number of operand instantations used to assemble the operand and operand is assumed to
	 be encoded.

	 If the chunk does not encode this operand but it is no error, return 0 (zero) and operand is assumed
	 not encoded.

	 If the operand is incompatible raise `AcDSLInvalidOperandError` (for example, when the operand is
	 expected to be a memory reference but we're given an immediate or when a register operand is of wrong
	 kind)."

	self subclassResponsibility
]
