"
Specialized format to parse ARM's <asmtemplate/> into `AcAsmFormat` object

"
Class {
	#name : #AcAArch64FormatParser,
	#superclass : #AcAsmFormatParser,
	#instVars : [
		'const0',
		'memref0',
		'memref1',
		'memref2',
		'memref3a',
		'memref3b'
	],
	#category : #'ArchC-AArch64-Parsing'
}

{ #category : #grammar }
AcAArch64FormatParser >> builtin [
   "From GNU Assembler manual [1]:

	The '#' can be optionally used to indicate immediate operands.

	[1] https://sourceware.org/binutils/docs/as/AArch64_002dChars.html"

	^ $# asParser trim optional , super builtin
	==> [ :nodes |
		nodes first isNil
			ifTrue: [ nodes second ]
			ifFalse:[ AcAsmFormatChunk sequence:
						(Array with: (AcAsmFormatChunk text: '#')
							   with: (AcAsmFormatChunk space:' ')
							   with: (nodes second))]
	].
]

{ #category : #grammar }
AcAArch64FormatParser >> const0 [
	^ $# asParser trim optional , $0 asParser trim
	==> [ :ignored|
		AcAsmFormatChunk sequence:
						(Array with: (AcAsmFormatChunk text: '#')
							   with: (AcAsmFormatChunk space:' ')
							   with: (AcAsmFormatChunk text: '0'))
	].
]

{ #category : #grammar }
AcAArch64FormatParser >> memref [
   ^ memref0 / memref1 / memref2 / memref3a / memref3b
]

{ #category : #grammar }
AcAArch64FormatParser >> memref0 [
	"Base (no offset).
	 Ex: [ %gpr66{, #0}]
	"
	^ ($[ asParser trim , map , '{,' asParser trim , const0 , $} asParser trim , $] asParser trim)
		==> [:nodes | AcAArch64MemRefChunk base: nodes second ]
]

{ #category : #grammar }
AcAArch64FormatParser >> memref1 [
	"Base plus offset (immediate)
	 Ex: [ %gpr66{, # %imm}]
	"
	^ ($[ asParser trim , map , '{,' asParser trim , builtin , $} asParser trim , $] asParser trim)
		==> [:nodes | AcAArch64MemRefChunk base: nodes second offset: nodes fourth ]
]

{ #category : #grammar }
AcAArch64FormatParser >> memref2 [
	"Base plus offset (register * scale)
	"

	^ $[ asParser trim , map , $, asParser trim , map , '{,' asParser trim , 'lsl' asParser trim , builtin , $} asParser trim , $] asParser trim
	==> [ :nodes |AcAArch64MemRefChunk base: nodes second offset: (nodes at:4) scale: (nodes at:7)   ]
]

{ #category : #grammar }
AcAArch64FormatParser >> memref3a [
	"Base plus offset (extended register * scale)

	 Ex: [ %gpr64sp, ( %gpr32 | %gpr64), %[extend]{ %imm}]
	"
	| offset |

	offset := $( asParser trim , '%gpr32' asParser, $| asParser trim , '%gpr64' asParser , $) asParser trim ==> [ :ignored | AcAsmFormatChunk map:'gpr32' ].


	^ $[ asParser trim , map , $, asParser trim , offset , $, asParser trim, map , ${ asParser trim , builtin , $} asParser trim , $] asParser trim
	==> [ :nodes |AcAArch64MemRefChunk base: nodes second offset: (nodes at:4) scale: (nodes at:8) extend: (nodes at:6) ]
]

{ #category : #grammar }
AcAArch64FormatParser >> memref3b [
	"Base plus offset (extended register * scale)

	 Ex: [ %gpr64sp, ( %gpr32| %gpr64){, %[extend]{ %[amount]}}]
	"
	| offset |

	offset := $( asParser trim , '%gpr32' asParser, $| asParser trim , '%gpr64' asParser , $) asParser trim ==> [ :ignored | AcAsmFormatChunk map:'gpr32' ].


	^ $[ asParser trim , map , $, asParser trim , offset , '{,' asParser trim, map , ${ asParser trim , map , $} asParser trim , $} asParser trim , $] asParser trim
	==> [ :nodes |AcAArch64MemRefChunk base: nodes second offset: (nodes at:4) scale: (nodes at:8) extend: (nodes at:6) ]
]

{ #category : #grammar }
AcAArch64FormatParser >> operand [
	| operand0 |

	operand0 := (memref / builtin / map / token / special / space) plus
				==> [ :nodes | AcAsmFormatChunk sequence: nodes ].

	^ operand0 , (${ asParser , operand0, $} asParser) optional
	==> [ :nodes |
			nodes second isNil ifTrue: [
				nodes first
			] ifFalse: [
				nodes first isSequenceChunk ifTrue: [
					AcAsmFormatChunk sequence: nodes first subchunks , (Array with: (AcAsmFormatChunk optional: nodes second second))
				] ifFalse: [
					AcAsmFormatChunk sequence: (Array with: nodes first with: (AcAsmFormatChunk optional: nodes second second))
				].
			].
	].

	"
	AcAArch64FormatParser new operand end parse: '%imm'
	AcAArch64FormatParser new operand end parse: '%imm {%imm}'
	AcAArch64FormatParser new operand end parse: '%[extend]{# %imm}'
	"
]

{ #category : #grammar }
AcAArch64FormatParser >> operands [
	| operands0 |

	operands0 := super operands.

	^ (${ asParser trim , operands0 , $} asParser
	==> [ :nodes |
		AcAsmFormatChunk optional: nodes second
	])
	/ (operands0 , ('{,' asParser trim , operands0 , $} asParser) optional
	==> [ :nodes |
		| mandatory optional |

		mandatory := optional := #().
		nodes first notNil ifTrue: [
			mandatory := nodes first subchunks.
		].
		nodes second notNil ifTrue: [
			optional := nodes second second subchunks collect: [ :e|AcAsmFormatChunk optional: e ]
		].
		AcAsmFormatChunk operands: mandatory , optional.
	])


	"
	AcAArch64FormatParser new operands end parse: '%gpr32{, %[extend]{# %imm}}'
	AcAArch64FormatParser new operands end parse: '%gpr64, [ %gpr64sp{, # %imm}]'
	"
]

{ #category : #grammar }
AcAArch64FormatParser >> special [
	^('\%' asParser
	/ (PPPredicateObjectParser anyExceptAnyOf: ' ,\%";{}')) flatten
	==> [ :token | AcAsmFormatChunk text: (self unescape: token) ]
]

{ #category : #grammar }
AcAArch64FormatParser >> token [
   "a-zA-Z 0-9 $.#"
   ^ (#letter asParser / #digit asParser / $_ asParser / $. asParser / $$ asParser / $# asParser) plus flatten
   ==> [ :token | AcAsmFormatChunk text: token ]
]
