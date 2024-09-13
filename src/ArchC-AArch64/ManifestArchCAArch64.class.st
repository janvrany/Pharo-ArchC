Class {
	#name : #ManifestArchCAArch64,
	#superclass : #PackageManifest,
	#category : #'ArchC-AArch64-Manifest'
}

{ #category : #'stx - description' }
ManifestArchCAArch64 class >> mandatoryPreRequisites [
	"list packages which are mandatory as a prerequisite.
	 This are packages containing superclasses of my classes and classes which
	 are extended by myself.
	 They are mandatory, because we need these packages as a prerequisite for loading and compiling.
	 This method is generated automatically,
	 by searching along the inheritance chain of all of my classes.
	 Please take a look at the #referencedPreRequisites method as well."

	^ #(
		#'stx:libbasic'    "Object - superclass of AcAArch64OpcodeParser"
		#'stx:libcompat'    "PackageManifest - superclass of ManifestArchCAArch64"
	)
]

{ #category : #'stx - description' }
ManifestArchCAArch64 class >> referencedPreRequisites [
	"list packages which are a prerequisite, because they contain
	 classes which are referenced by my classes.
	 These packages are NOT needed as a prerequisite for compiling or loading,
	 however, a class from it may be referenced during execution and having it
	 unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
	 includes explicit checks for the package being present.
	 This method is generated automatically,
	 by searching all classes (and their packages) which are referenced by my classes.
	 Please also take a look at the #mandatoryPreRequisites method"

	^ #(
		#'ArchC-Core'    "AcInstructionBitfield - referenced by AcAArch64OpcodeParser>>parseFormatBitfield:"
		#'stx:goodies/xml2/parser'    "XMLDOMParser - referenced by AcAArch64OpcodeParser>>parseFile:"
		#'stx:goodies/xml2/xpath'
	)
]
