Class {
	#name : #ClyASMMethodQuery,
	#superclass : #ClyMethodQuery,
	#category : #'ArchC-DUI'
}

{ #category : #gui }
ClyASMMethodQuery >> decorateMethodGroupTableCell: anItemCellMorph of: groupItem [
	super decorateMethodGroupTableCell: anItemCellMorph of: groupItem.
	
	anItemCellMorph definitionIcon: #tools
]

{ #category : #printing }
ClyASMMethodQuery >> description [
	^'assembler'
]

{ #category : #testing }
ClyASMMethodQuery >> selectsMethod: aMethod [
	^ aMethod isASMMethod
]
