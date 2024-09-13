Class {
	#name : #AcAArch64Tests,
	#superclass : #TestCase,
	#instVars : [
		'pdl'
	],
	#category : #'ArchC-AArch64-Tests'
}

{ #category : #accessing }
AcAArch64Tests class >> resources [
	^ Array with: AcProcessorDescriptionsResource
]

{ #category : #running }
AcAArch64Tests >> setUp [
	super setUp.
	pdl := AcProcessorDescriptions aarch64
]

{ #category : #'tests - AArch64' }
AcAArch64Tests >> testAArch64_ADC [
	| insn |

	insn := pdl assembler parse: 'adc w0, w15, w16'.
	self assert: insn emit32 = 16r1a1001e0.
	self assert: insn disassemble equals: 'adc w0, w15, w16'.

	insn := pdl assembler parse: 'adc x0, x15, x16'.
	self assert: insn emit32 = 16r9a1001e0.
	self assert: insn disassemble equals: 'adc x0, x15, x16'.
]
