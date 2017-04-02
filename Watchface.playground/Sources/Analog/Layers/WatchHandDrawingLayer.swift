import UIKit

/// An enum to help abstract away various calculations
/// for drawing the hand paths
public enum HandType {
    case second, minute, hour
    
    public var centerRadius: CGFloat {
        switch self {
            
        case .second:
            return 4
            
        case .minute, .hour:
            return 5
            
        }
    }
}

public class WatchHandDrawingLayer: CAShapeLayer {
    
    // MARK:- Public variables
    
    public var type: HandType = .second {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var color: UIColor = .white {
        didSet {
            strokeColor = color.cgColor
            setNeedsDisplay()
        }
    }
    
    // MARK:- Initialisers
    
    public override init() {
        super.init()
        setup()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        fillColor = nil
        
        lineCap = kCALineCapRound
        lineJoin = kCALineJoinRound
        
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: 1)
        shadowRadius = 10
        shadowOpacity = 1
    }
    
    // MARK:- Drawing methods
    
    public override func display() {
        strokeColor = color.cgColor
        
        let newPath = getPath().cgPath
        self.path = newPath
        shadowPath = newPath
    }
    
    private func getPath() -> UIBezierPath {
        
        /// A square, centered `CGRect` is used for the
        /// bounds in order to leave space for the
        /// complications
        let bounds: CGRect = {
            if self.bounds.width > self.bounds.height {
                let diff = self.bounds.width - self.bounds.height
                return self.bounds.insetBy(dx: diff/2, dy: 0)
            } else if self.bounds.width < self.bounds.height {
                let diff = self.bounds.height - self.bounds.width
                return self.bounds.insetBy(dx: 0, dy: diff/2)
            } else {
                return self.bounds
            }
        }()
        
        let centerRect = CGRect(
            x: bounds.midX - type.centerRadius,
            y: bounds.midY - type.centerRadius,
            width: type.centerRadius * 2,
            height: type.centerRadius * 2)
        
        let path = UIBezierPath(ovalIn: centerRect)
        
        switch type {
            
        case .second:
            path.move(to: CGPoint(x: bounds.midX, y: bounds.midY + type.centerRadius))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + type.centerRadius + type.centerRadius * 4))
            path.move(to: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.minY))
            
        case .minute:
            path.move(to: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius))
            path.addLine(to: CGPoint(x: bounds.midX, y: (bounds.midY - type.centerRadius * 4)))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius * 5), radius: type.centerRadius , startAngle: Degrees(90).inRadians, endAngle: Degrees(180).inRadians, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.midX - type.centerRadius , y: bounds.minY + type.centerRadius ))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.minY + type.centerRadius ), radius: type.centerRadius , startAngle: Degrees(180).inRadians, endAngle: Degrees(360).inRadians, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.midX + type.centerRadius , y: bounds.midY - type.centerRadius * 5))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius * 5), radius: type.centerRadius , startAngle: Degrees(0).inRadians, endAngle: Degrees(90).inRadians, clockwise: true)
            
        case .hour:
            path.move(to: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius))
            path.addLine(to: CGPoint(x: bounds.midX, y: (bounds.midY - type.centerRadius * 4)))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius * 5), radius: type.centerRadius , startAngle: Degrees(90).inRadians, endAngle: Degrees(180).inRadians, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.midX - type.centerRadius , y: (bounds.minY + bounds.midY)/2 + type.centerRadius ))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: (bounds.minY + bounds.midY)/2 + type.centerRadius ), radius: type.centerRadius , startAngle: Degrees(180).inRadians, endAngle: Degrees(360).inRadians, clockwise: true)
            path.addLine(to: CGPoint(x: bounds.midX + type.centerRadius , y: bounds.midY - type.centerRadius * 5))
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY - type.centerRadius * 5), radius: type.centerRadius , startAngle: Degrees(0).inRadians, endAngle: Degrees(90).inRadians, clockwise: true)
            
        }
        
        return path
    }
    
}
