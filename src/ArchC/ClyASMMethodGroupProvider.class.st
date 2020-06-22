Class {
	#name : #ClyASMMethodGroupProvider,
	#superclass : #ClySingleMethodGroupProvider,
	#category : #'ArchC-DUI'
}

{ #category : #'building groups' }
ClyASMMethodGroupProvider >> createMethodGroupFor: aMethodQuery from: aClassScope [
	^ClyMethodGroup named: 'assembler' on: aMethodQuery
]

{ #category : #'building groups' }
ClyASMMethodGroupProvider >> createMethodQueryFrom: aClassScope [
	^ClyASMMethodQuery from: aClassScope
]
