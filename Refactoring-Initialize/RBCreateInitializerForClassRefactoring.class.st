Class {
	#name : #RBCreateInitializerForClassRefactoring,
	#superclass : #RBVariableRefactoring,
	#instVars : [
		'getterMethod',
		'setterMethod',
		'classVariable',
		'needsReturn'
	],
	#category : #'Refactoring-Initialize'
}

{ #category : #'instance creation' }
RBCreateInitializerForClassRefactoring class >> model: aRBSmalltalk variable: aVarName class: aClass classVariable: aBoolean [ 
	^(self 
		model: aRBSmalltalk
		variable: aVarName
		class: aClass)
		classVariable: aBoolean;
		yourself
]

{ #category : #'instance creation' }
RBCreateInitializerForClassRefactoring class >> variable: aVarName class: aClass classVariable: aBoolean [ 
	^(self variable: aVarName class: aClass)
		classVariable: aBoolean; yourself
]

{ #category : #'initialize-release' }
RBCreateInitializerForClassRefactoring >> classVariable: aBoolean [ 
	classVariable := aBoolean
]

{ #category : #transforming }
RBCreateInitializerForClassRefactoring >> preconditions [
	^ RBCondition empty 
]

{ #category : #printing }
RBCreateInitializerForClassRefactoring >> storeOn: aStream [ 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' variable: '.
	variableName storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' classVariable: '.
	classVariable storeOn: aStream.
	aStream nextPut: $)
]

{ #category : #transforming }
RBCreateInitializerForClassRefactoring >> transform [
	|selector definingClass string |
	definingClass  := class.
	string := '<1s> <r>' , ((definingClass realClass allInstVarNames collect: [:varName| '<t> {1} := #typehere .' format: {varName} ]) joinUsing: '<r>'). 
	selector := #initialize.
	definingClass 
		compile: (string expandMacrosWith: selector with: variableName)
		classified: #initialize.
	^selector
]

{ #category : #testing }
RBCreateInitializerForClassRefactoring >> usesAssignmentOf: aString in: aClass classVariable: isClassVar [ 
	| matcher definingClass |
	matcher := RBParseTreeSearcher new.
	matcher
		answer: false;
		matches: aString , ' := ``@object'
			do: [ :aNode :answer | answer or: [ aNode isUsed and: [ aNode methodNode selector ~= aString] ] ].
	definingClass := isClassVar 
		ifTrue: [ aClass instanceSide ]
		ifFalse: [ aClass ].
	^ (definingClass withAllSubclasses , (isClassVar 
			ifTrue: [ definingClass classSide withAllSubclasses ]
			ifFalse: 
				[ #() ]) 
		detect: 
			[ :each | 
			((isClassVar 
				ifTrue: [ each whichSelectorsReferToClassVariable: aString ]
				ifFalse: [ each whichSelectorsReferToInstanceVariable: aString ]) 
				detect: 
					[ :sel | 
					self 
						checkClass: each
						selector: sel
						using: matcher ]
				ifNone: [ nil ]) notNil ]
		ifNone: [ nil ]) notNil
]
