public enum BCD: Int {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine, nothing = 10, minusSign = -1
}

extension BCD: CalculatorButtonValue {
    var type: CalculatorButtonType {
        return .numeral
    }
    
    var text: String {
        if self == .minusSign {
            return "-"
        } else {
            return "\(rawValue)"
        }
    }
}
