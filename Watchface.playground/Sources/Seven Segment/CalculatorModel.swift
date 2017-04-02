internal class CalculatorModel {
    
    private var operandStack = [Double]()
    private var operatorStack = [Operator]()
    
    private var lastPushedValueWasOperator = true
    
    internal func push(operand: Double) {
        if !lastPushedValueWasOperator {
            operandStack.removeLast()
        }
        
        operandStack.append(operand)
        lastPushedValueWasOperator = false
    }
    
    internal func push(operator value: Operator) {
        if lastPushedValueWasOperator {
            operatorStack.removeLast()
        }
        
        operatorStack.append(value)
        lastPushedValueWasOperator = true
    }
    
    internal func evaluate() -> Double {
        if lastPushedValueWasOperator {
            operatorStack.removeLast()
        }
        
        var hierarchy: [Operator] = [.divide, .multiply, .add, .subtract]
        
        while !hierarchy.isEmpty {
            if !find(operator: hierarchy.first!) {
                hierarchy.removeFirst()
            }
        }
        
        return operandStack.first!
    }
    
    private func find(operator value: Operator) -> Bool {
        for (index, op) in operatorStack.enumerated() {
            if op == value {
                operatorStack.remove(at: index)
                let valueOne = operandStack.remove(at: index)
                let valueTwo = operandStack.remove(at: index)
                let result = op.operate(lhs: valueOne, rhs: valueTwo)
                operandStack.insert(result, at: index)
                
                return true
            }
        }
        
        return false
    }
    
    internal func clear() {
        operandStack.removeAll()
        operatorStack.removeAll()
    }
    
    internal func isClear() -> Bool {
        return operandStack.isEmpty
    }
}
