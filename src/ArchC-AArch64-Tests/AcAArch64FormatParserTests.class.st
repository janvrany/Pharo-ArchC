Class {
	#name : #AcAArch64FormatParserTests,
	#superclass : #TestCase,
	#category : #'ArchC-AArch64-Tests'
}

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_builtin_01 [
	| fmt |

	fmt := AcAArch64FormatParser new builtin end parse: '# %imm'.
	self assert: fmt unparse equals: '# %imm'.
	self assert: fmt isSequenceChunk.
	self assert: fmt subchunks size = 3.
	self assert: fmt subchunks last isBuiltinChunk
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_memref_01 [
	| fmt |

	fmt := AcAArch64FormatParser new memref end parse: '[ %gpr64sp{, # %imm}]'.
	self assert: fmt unparse equals: '[%[gpr64sp]{, # %imm}]'.
	self assert: fmt isMemRefChunk.
	self assert: fmt base isMapChunk.
	self assert: fmt offset isSequenceChunk.
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_memref_02 [
	| fmt |

	fmt := AcAArch64FormatParser new memref end parse: '[ %gpr64sp{, #0}]'.
	self assert: fmt unparse equals: '[%[gpr64sp]{, #0}]'.
	self assert: fmt isMemRefChunk.
	self assert: fmt base isMapChunk.
	self assert: fmt offset isNil
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_memref_03 [
	| fmt |

	fmt := AcAArch64FormatParser new memref end parse: '[ %gpr64sp, ( %gpr32 | %gpr64), %[extend]{ %imm}]'.
	self assert: fmt unparse equals: '[%[gpr64sp], %[gpr32], %[extend]{%imm}]'.

	fmt := AcAArch64FormatParser new memref end parse: '[ %gpr64sp, ( %gpr32| %gpr64){, %[extend]{ %[amount]}}]'.
	self assert: fmt unparse equals: '[%[gpr64sp], %[gpr32], %[extend]{%[amount]}]'.
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_operand_01 [
	| fmt |

	fmt := AcAArch64FormatParser new operand end parse: '%imm'.
	self assert: fmt unparse equals: '%imm'.
	self assert: fmt isBuiltinChunk.

	fmt := AcAArch64FormatParser new operand end parse: '%imm {%imm}'.
	self assert: fmt unparse equals: '%imm {%imm}'.
	self assert: fmt isSequenceChunk.
	self assert: fmt subchunks first isBuiltinChunk.
	self assert: fmt subchunks last isOptionalChunk.

	fmt := AcAArch64FormatParser new operand end parse: '%[extend]{# %imm}'.
	self assert: fmt unparse equals: '%[extend]{# %imm}'.
	self assert: fmt isSequenceChunk.
	self assert: fmt subchunks last isOptionalChunk.
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_operands_01 [
	| fmt |

	fmt := AcAArch64FormatParser new operands end parse: '%gpr64, [ %gpr64sp{, # %imm}]'.
	self assert: fmt unparse equals: '%[gpr64], [%[gpr64sp]{, # %imm}]'.
	self assert: fmt subchunks size = 2.
	self assert: fmt subchunks first isMapChunk.
	self assert: fmt subchunks second isMemRefChunk
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_operands_02 [
	| fmt |

	fmt := AcAArch64FormatParser new operands end parse: '{ %gpr64, %imm}'.
	self assert: fmt unparse equals: '{%[gpr64], %imm}'.
	self assert: fmt isOptionalChunk.
	self assert: fmt subchunks size = 1.
	self assert: fmt subchunks first subchunks size = 2.
	self assert: fmt subchunks first subchunks first isMapChunk.
	self assert: fmt subchunks first subchunks second isBuiltinChunk.
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_operands_03 [
	| fmt |

	fmt := AcAArch64FormatParser new operands end parse: '%gpr32{, %imm}'.
	self assert: fmt unparse equals: '%[gpr32]{,%imm}'.
	self assert: fmt subchunks size = 2.
	self assert: fmt subchunks first isMapChunk.
	self assert: fmt subchunks second isOptionalChunk.
	self assert: fmt subchunks second subchunks size = 1.
	self assert: fmt subchunks second subchunks first isBuiltinChunk.
]

{ #category : #'tests - AArch64' }
AcAArch64FormatParserTests >> test_operands_tst [
	| fmt |

	fmt := AcAArch64FormatParser new operands end parse: '%gpr32, %gpr32{, %[shift]# %imm}'.
	self assert: fmt unparse equals: '%[gpr32], %[gpr32]{,%[shift]# %imm}'.
	self assert: fmt subchunks size = 3.
	self assert: fmt subchunks first isMapChunk.
	self assert: fmt subchunks second isMapChunk.
	self assert: fmt subchunks third isOptionalChunk.
	self assert: fmt subchunks third subchunks size = 1.
	self assert: fmt subchunks third subchunks first isSequenceChunk.
]
