logical operation
| aCondition
	^ SCOrOperator  
		conditions: (Array with: self with: aCondition)