import UIKit

internal class SegmentView: UIView {
    
    // MARK:- Public variables
    
    internal var segment: Segment = .a {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var color: UIColor = UIColor(red: 0.28, green: 0.99, blue: 0.21, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK:- Private variables
    
    private let points: [(x: CGFloat, y: CGFloat)] = [
        (0, 0), (42, 42), (42, 370), (0, 412), (-42, 370), (-42, 42) ]
    
    // MARK:- Drawing methods
    
    internal override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        color.setFill()
        
        ctx.saveGState()
        
        let baseRect = CGRect(x: 0, y: 0, width: 700, height: 1200)
        
        let scale = min(rect.width/baseRect.width, rect.height/baseRect.height)
        
        var resizedRect = baseRect.standardized
        resizedRect.size.width *= scale
        resizedRect.size.height *= scale
        resizedRect.origin.x = rect.minX + (rect.width - resizedRect.width) / 2
        resizedRect.origin.y = rect.minY + (rect.height - resizedRect.height) / 2
        ctx.translateBy(x: resizedRect.minX, y: resizedRect.minY)
        ctx.scaleBy(x: resizedRect.width / baseRect.width, y: resizedRect.height / baseRect.height)
        
        switch segment {
            
        case .dot:
            let dotContainer = CGRect(origin: segment.originOffset, size: CGSize(width: 84, height: 84))
            let dotPath = UIBezierPath(ovalIn: dotContainer)
            dotPath.fill()
            
        default:
            let path = UIBezierPath()
            for (index, value) in points.enumerated() {
                let newX = segment.originOffset.x
                    + (segment.orientation == .vertical ? value.x : value.y)
                let newY = segment.originOffset.y
                    + (segment.orientation == .vertical ? value.y : value.x)
                let newPoint = CGPoint(x: newX, y: newY)
                
                if index == 0 {
                    path.move(to: newPoint)
                } else {
                    path.addLine(to: newPoint)
                }
            }
            path.fill()
            
        }
        
        ctx.restoreGState()
    }
    
}
