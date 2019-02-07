"
A RBCreateInitializerForClassRefactoringTest is a test class for testing the behavior of RBCreateInitializerForClassRefactoring
"
Class {
	#name : #RBCreateInitializerForClassRefactoringTest,
	#superclass : #RBRefactoringTest,
	#category : #'Refactoring-Initialize-Tests'
}

{ #category : #test }
RBCreateInitializerForClassRefactoringTest >> testTransform [
	| refactoring |
	refactoring := RBCreateInitializerForClassRefactoring
		variable: #none
		class: RefactoringInitializeSampleClass.
	self executeRefactoring: refactoring.
	self
		assert: refactoring model changes first
		equals:
			'initialize 
	 one := #typehere .
	 two := #typehere .
	 three := #typehere .'
]
