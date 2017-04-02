import UIKit

internal protocol CalculatorButtonValue {
    var text: String { get }
    var type: CalculatorButtonType { get }
}

internal enum CalculatorButtonType {
    case numeral, operation, clear
    
    internal var colors: [UIColor] {
        switch self {
            
        case .numeral:
            return [
                UIColor(red: 0.25, green: 0.24, blue: 0.22, alpha: 1.00),
                UIColor(red: 0.20, green: 0.19, blue: 0.17, alpha: 1.00) ]
            
        case .operation:
            return [
                UIColor(red: 0.11, green: 0.64, blue: 0.94, alpha: 1.00),
                UIColor(red: 0.00, green: 0.44, blue: 0.74, alpha: 1.00) ]
            
        case .clear:
            return [.red, .red]
        }
    }
    
    internal var gradient: CGGradient {
        return CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors.map { $0.cgColor } as CFArray,
            locations: [0, 1])!
    }
}

struct ClearButton: CalculatorButtonValue {
    var text: String {
        return "C"
    }
    
    var type: CalculatorButtonType {
        return .clear
    }
}
