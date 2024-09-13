Class {
	#name : #AcDSLAssemblerTests,
	#superclass : #TestCase,
	#category : #'ArchC-DSL-Tests'
}

{ #category : #'tests - AArch64' }
AcDSLAssemblerTests >> test_AArch64_ADC [
	| gpr32 w0 w1 w2 gpr64 x0 x1 x2 asm |

	gpr32 := AcProcessorDescriptions aarch64 maps at: 'gpr32'.
	w0 := AcDSLRegister value: (gpr32 lookup: 'w0').
	w1 := AcDSLRegister value: (gpr32 lookup: 'w1').
	w2 := AcDSLRegister value: (gpr32 lookup: 'w2').

	gpr64 := AcProcessorDescriptions aarch64 maps at: 'gpr64'.
	x0 := AcDSLRegister value: (gpr64 lookup: 'x0').
	x1 := AcDSLRegister value: (gpr64 lookup: 'x1').
	x2 := AcDSLRegister value: (gpr64 lookup: 'x2').


	asm := AcDSLAArch64Assembler new.
	asm adc: w0, w1, w2.
	asm adc: x0, x1, x2.

	self assert: asm memory instructions first disassemble equals: 'adc w0, w1, w2'.
	self assert: asm memory instructions second disassemble equals: 'adc x0, x1, x2'.

	self should: [ asm adc: x0, w1, w2. ] raise: AcDSLInvalidOperandError.
]
