Class {
	#name : #ClyPDLEnvironmentPlugin,
	#superclass : #ClySystemEnvironmentPlugin,
	#category : #'ArchC-DUI'
}

{ #category : #testing }
ClyPDLEnvironmentPlugin class >> isAutoActivated [ 
	^true

]

{ #category : #'groups collecting' }
ClyPDLEnvironmentPlugin >> collectMethodGroupProviders [ 
	^#() "{ClyFFIMethodGroupProvider new}"
]

{ #category : #'item decoration' }
ClyPDLEnvironmentPlugin >> decorateBrowserItem: anItem ofMethod: aMethod [
	aMethod selector = #and1 ifTrue: [ self halt ].
	.
	aMethod isASMMethod ifTrue: [ 
		anItem markWith: ClyASMMethodTag]
]
