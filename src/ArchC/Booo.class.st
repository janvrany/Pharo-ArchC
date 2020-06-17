Class {
	#name : #Booo,
	#superclass : #Object,
	#category : #'ArchC-Tests-Opal'
}

{ #category : #doodling }
Booo class >> disassembleInstructionAt: byteIndex In: bytes [
	| instrBytes instrBitVector instr |
	instrBytes := bytes copyFrom: byteIndex+1 to: byteIndex+4.
	instrBitVector := instrBytes asBitVectorLE.
	instr := AcProcessorDescriptions armv5 disassemble: instrBitVector.
	^instr disassemble
]

{ #category : #doodling }
Booo class >> disassembleInstructionAt: byteIndex In: bytes into: binaryBlock [ 
	| text |
	text := self disassembleInstructionAt: byteIndex In: bytes.
	^binaryBlock value: text value: nil
]
