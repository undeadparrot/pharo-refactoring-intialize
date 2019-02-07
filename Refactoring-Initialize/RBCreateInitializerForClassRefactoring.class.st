Class {
	#name : #RBCreateInitializerForClassRefactoring,
	#superclass : #RBVariableRefactoring,
	#instVars : [
		'classVariable'
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
