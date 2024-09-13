Class {
	#name : #AcDSLAArch64Assembler,
	#superclass : #AcDSLAssembler,
	#category : #'ArchC-DSL'
}

{ #category : #accessing }
AcDSLAArch64Assembler class >> isa [
	^ AcProcessorDescriptions aarch64
]
