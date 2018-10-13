import UIKit

public enum NumeralPosition: Int {
    case twelve = 0, one, two, three, four, five, six, seven, eight, nine, ten, eleven
}

/// A layer to draw larger numerals for the numerals
/// watchface
public class LargeNumeralsDrawingLayer: CAShapeLayer {
    
    // MARK:- Public variables
    
    /// The numeral to be drawn. Requires `String`s instead of
    /// `Int`s so it can hold data with custom formatting (Roman
    /// numerals, for example)
    public var data = "12" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var dataPosition = NumeralPosition(rawValue: 0)! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The font in which the numerals will be set
    public var font = UIFont.systemFont(ofSize: 20, weight: .light) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color for the numerals
    public var color = UIColor.white {
        didSet {
            strokeColor = color.cgColor
            setNeedsDisplay()
        }
    }
    
    // MARK:- Initialisers
    
    public override init() {
        super.init()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- Drawing
    
    /// A function which draws the numerals in the current
    /// context
    ///
    /// - Parameter ctx: The drawing context
    public override func draw(in ctx: CGContext) {
        
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

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.width/2
        
        /// Magic math to ensure that the text is rendered
        /// correctly.
        
        ctx.translateBy(x: 0.0, y: self.bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.setTextDrawingMode(.fill)
        
        /// The circle representing the text circumference
        /// is slightly inset to ensure that the centers of
        /// the strings are all on the circumference of a
        /// singular circle
        let points = get(
            nPoints: 12,
            aroundCircleWithCenter: center,
            radius: radius - 40)
        
        let point = points[dataPosition.rawValue]
        
        /// The gradient is used to ensure that adjustments to
        /// the x and y axes are proportional
        let grade = CGPoint(
            x: point.x - center.x,
            y: point.y - center.y)
        
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color]
        
        let attributedString = NSAttributedString(string: data, attributes: attr)
        let line = CTLineCreateWithAttributedString(attributedString)
        
        /// The initial position is set in accordance with the
        /// ring position, as for the normal numerals drawing
        /// layer
        
        let tempBounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
        let tempX = point.x - tempBounds.width/2
        let tempY = point.y - tempBounds.midY
        ctx.textPosition = CGPoint(x: tempX, y: tempY)
        
        let textBounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
        
        /// This math is a bit funky, since we're drawing in
        /// -ve y, but essentially we're setting the upper
        /// numerals to hug to bottom, and bottom numerals to
        /// hug the top, so that they look right when flipped
        /// back to the intended orientation
        switch dataPosition {
            
        case .eleven, .twelve, .one:
            let newY = bounds.maxY - textBounds.height / 2
            let yActualDelta = newY - ctx.textPosition.y
            let xActualDelta = yActualDelta * grade.x / grade.y
            let newX = ctx.textPosition.x + xActualDelta
            
            ctx.textPosition = CGPoint(x: newX, y: newY)
            
        case .two, .three, .four:
            let newX = bounds.maxX - textBounds.width
            let xActualDelta = newX - ctx.textPosition.x
            let yActualDelta = xActualDelta * grade.y / grade.x
            let newY = ctx.textPosition.y + yActualDelta
            
            ctx.textPosition = CGPoint(x: newX, y: newY)
            
        case .five, .six, .seven:
            let newY = bounds.minY
            let yActualDelta = newY - ctx.textPosition.y
            let xActualDelta = yActualDelta * grade.x / grade.y
            let newX = ctx.textPosition.x + xActualDelta
            
            ctx.textPosition = CGPoint(x: newX, y: newY)
            
        case .eight, .nine, .ten:
            let newX = bounds.minX
            let xActualDelta = newX - ctx.textPosition.x
            let yActualDelta = xActualDelta * grade.y / grade.x
            let newY = ctx.textPosition.y + yActualDelta
            
            ctx.textPosition = CGPoint(x: newX, y: newY)
        }
        
        CTLineDraw(line, ctx)
    }
    
}
