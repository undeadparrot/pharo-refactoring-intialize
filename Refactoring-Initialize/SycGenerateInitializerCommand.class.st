Class {
	#name : #SycGenerateInitializerCommand,
	#superclass : #SycClassCommand,
	#category : #'Refactoring-Initialize'
}

{ #category : #execution }
SycGenerateInitializerCommand >> asRefactorings [

	| refactorings |
	refactorings := classes collect: [:eachClass |
		eachClass slots first createRefactoring: RBCreateInitializerForClassRefactoring for: eachClass].
	^refactorings
]

{ #category : #accessing }
SycGenerateInitializerCommand >> defaultMenuItemName [
	^'Generate initializer'
]

{ #category : #execution }
SycGenerateInitializerCommand >> execute [

	self executeRefactorings
]

{ #category : #testing }
SycGenerateInitializerCommand >> isComplexRefactoring [
	^true
]

{ #category : #execution }
SycGenerateInitializerCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	
	classes := classes collect: [:each | aToolContext currentMetaLevelOf: each]
]
