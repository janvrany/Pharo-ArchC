Class {
	#name : #BaselineOfArchC,
	#superclass : #BaselineOf,
	#category : #BaselineOfArchC
}

{ #category : #baselines }
BaselineOfArchC >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [
			spec baseline: 'PetitParser' with: [
				spec loads: 'Core'.
				spec loads: 'Analyzer'.
				"
				HACK: We have to use forked PetitParser with XInclude processing
				support forward-ported. This is not used by ArchC, but it *IS*
				used by ULD and we intend to use ULD.

				There are better ways to deal with this but no time now.
				"
				"spec repository: 'github://moosetechnology/PetitParser'"
				spec repository: 'github://shingarov/PetitParser:ULD'


			].

			spec baseline: 'MachineArithmetic' with: [
				spec repository: 'github://shingarov/MachineArithmetic:pure-z3'
			].

			spec baseline: 'XMLParser' with: [
				spec repository: 'github://pharo-contributions/XML-XMLParser/src';
				     loads: 'Core';
				     loads: 'Tools'.
			].

			spec baseline: 'XPath' with: [
				spec repository: 'github://pharo-contributions/XML-XPath/src';
				     loads: 'Core';
				     loads: 'Tools'.
			].

			spec
				package: #'ArchC-Core' with:[
					spec requires: 'PetitParser'	];
				package: #'ArchC-Core-Tests';
				package: #'ArchC-RISCV';
				package: #'ArchC-RISCV-Tests';
				package: #'ArchC-AArch64' with: [
					spec requires: 'XMLParser';
						 requires: 'XPath'			];
				package: #'ArchC-AArch64-Tests';
				package: #'ArchC-Extras-Pharo-Tests';
				package: #'ArchC-DSL' with: [
					spec requires: 'ArchC-RISCV';
						 requires: 'ArchC-AArch64'	];
				package: #'ArchC-DSL-Tests' with: [
					spec requires: 'ArchC-DSL'		].
		]
]
