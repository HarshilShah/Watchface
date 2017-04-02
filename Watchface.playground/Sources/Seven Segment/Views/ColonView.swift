import UIKit

internal class ColonView: UIView {
    
    // MARK:- Public variables
    
    internal var color: UIColor = UIColor(red: 0.28, green: 0.99, blue: 0.21, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK:- Initialisation
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        transform = __CGAffineTransformMake(1, 0, -12 * .pi / 360, 1, 0, 0)
    }
    
    // MARK:- UIView methods
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 2, height: 12)
    }
    
    // MARK:- Drawing methods
    
    internal override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        color.setFill()
        
        ctx.saveGState()
        
        let baseRect = CGRect(x: 0, y: 0, width: 200, height: 1200)
        
        let scale = min(rect.width/baseRect.width, rect.height/baseRect.height)
        
        var resizedRect = baseRect.standardized
        resizedRect.size.width *= scale
        resizedRect.size.height *= scale
        resizedRect.origin.x = rect.minX + (rect.width - resizedRect.width) / 2
        resizedRect.origin.y = rect.minY + (rect.height - resizedRect.height) / 2
        ctx.translateBy(x: resizedRect.minX, y: resizedRect.minY)
        ctx.scaleBy(x: resizedRect.width / baseRect.width, y: resizedRect.height / baseRect.height)
        
        let topDot = CGRect(x: 58, y: 344, width: 84, height: 84)
        let topDotPath = UIBezierPath(ovalIn: topDot)
        topDotPath.fill()
        
        let bottomDot = CGRect(x: 58, y: 772, width: 84, height: 84)
        let bottomDotPath = UIBezierPath(ovalIn: bottomDot)
        bottomDotPath.fill()

        ctx.restoreGState()
    }
}
