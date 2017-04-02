import UIKit

/// A layer to draw the bezels (I can't think of a more "correct" name
/// , sorry) for the watch. This will draw a set of "notches" (again,
/// sorry), with every fifth one being larger than the rest
public class BezelDrawingLayer: CAShapeLayer {
    
    // MARK:- Public variables
    
    /// The total number of points to draw.
    ///
    /// - NOTE: This should always be a multiple of 5
    public var numberOfPoints = 60 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The width of the ring. This represents the height of the larger
    /// notches
    public var ringWidth: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The ratio of the width of the ring formed by the smaller
    /// notches to that formed by the larger ones.
    ///
    /// This multiplied with the `ringWidth` gives the absolute
    /// height for the smaller notches
    public var widthRatio: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The line color for the notches
    public var color = UIColor.white {
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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        lineCap = kCALineCapRound
        lineJoin = kCALineJoinRound
    }
    
    // MARK:- Drawing
    
    public override func display() {
        self.path = getPath().cgPath
    }
    
    /// A method to get a bezier which consists of all the various
    /// notches appended into one massive bezier. Can possibly be
    /// refactored into multiple beziers/layers for the sake of better
    /// animation
    ///
    /// - Returns: A `UIBezierPath` representing the various notches
    /// which form the bezel
    private func getPath() -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let points = get(
            nPoints: numberOfPoints,
            aroundCircleWithCenter: center,
            radius: min(bounds.width, bounds.height) / 2)
        
        let path = UIBezierPath()
        
        for point in points.enumerated() {
            path.move(to: CGPoint(x: point.element.x, y: point.element.y))
            
            /// Every fifth notch is longer. The length is calculated
            /// as a ratio of the clockface radius so that the adjustments
            /// can be made without computing cos/sin each time
            
            let notchLength = point.offset % 5 == 0 ? ringWidth : ringWidth * widthRatio
            let lengthRatio = notchLength / (min(bounds.width, bounds.height) / 2)
            
            /// The ending point for a notch, with the start being
            /// around the circumference, is calculated as being
            /// away from the start point in proportion to the start
            /// point's distance from center along both dimensions
            
            let newX = point.element.x + (lengthRatio * (center.x - point.element.x))
            let newY = point.element.y + (lengthRatio * (center.y - point.element.y))
            
            path.addLine(to: CGPoint(x: newX, y: newY))
        }
        
        return path
    }
}
