import Foundation

enum Operator {
    case add, subtract, divide, multiply, equals
    
    var sign: String {
        switch self {
        case .add:          return "+"
        case .subtract:     return "-"
        case .divide:       return "÷"
        case .multiply:     return "×"
        case .equals:       return "="
        }
    }
    
    func operate(lhs: Double, rhs: Double) -> Double {
        switch self {
        case .add:          return lhs + rhs
        case .subtract:     return lhs - rhs
        case .divide:       return lhs / rhs
        case .multiply:     return lhs * rhs
        case .equals:       return 0
        }
    }
}

extension Operator: CalculatorButtonValue {
    var type: CalculatorButtonType {
        return .operation
    }
    
    var text: String {
        return sign
    }
}
