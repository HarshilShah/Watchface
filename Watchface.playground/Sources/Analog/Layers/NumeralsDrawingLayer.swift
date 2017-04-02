import UIKit

/// A layer to draw the various numerals that make up the
/// watchface
public class NumeralsDrawingLayer: CAShapeLayer {
    
    // MARK:- Public variables
    
    
    /// The numerals to be drawn. Requires `String`s instead of
    /// `Int`s so it can hold data with custom formatting (Roman
    /// numerals, for example)
    ///
    /// The values are displayed starting from top-center, and
    /// moving in a clockwise direction from there. The first value
    /// will always remain in the top-center position, and to
    /// display objects at custom positions (say to only show one
    /// numeral which represents the current hour), the others
    /// should be represented as empty strings
    public var data = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The font in which the numerals will be set
    public var font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight) {
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
        let radius = min(bounds.width, bounds.height) / 2
        
        /// Magic math to ensure that the text is rendered
        /// correctly.
        
        ctx.translateBy(x: 0.0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        /// The circle representing the text circumference
        /// is slightly inset to ensure that the centers of
        /// the strings are all on the circumference of a
        /// singular circle
        let points = get(
            nPoints: data.count,
            aroundCircleWithCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: radius - font.pointSize/2)
        
        for (text, point) in zip(data, points) {
            let attr = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color] as CFDictionary
            let attrStr = CFAttributedStringCreate(nil, text as CFString!, attr)
            
            let line = CTLineCreateWithAttributedString(attrStr!)
            let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
            
            ctx.setLineWidth(1.5)
            ctx.setTextDrawingMode(.fill)
            
            /// Text is placed such that their centers are
            /// equidistant points on the circumference of
            /// a circle within the bounds of the layer
            
            let newX = point.x - bounds.width/2
            let newY = point.y - bounds.midY
            ctx.textPosition = CGPoint(x: newX, y: newY)
            CTLineDraw(line, ctx)
        }
        
    }
    
}
