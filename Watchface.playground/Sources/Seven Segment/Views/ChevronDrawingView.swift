import UIKit

internal enum ChevronDirection {
    case left, right
}

internal class ChevronButton: UIButton {
    
    // MARK:- Public variables
    
    internal var direction: ChevronDirection = .left {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var color: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK:- Private variables
    
    private lazy var maskLayer = CALayer()
    
    // MARK:- Initialisers
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setBackgroundImage(nil, for: .normal)
        backgroundColor = .clear
        layer.cornerRadius = 12
        clipsToBounds = true
        
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.opacity = 0
        layer.insertSublayer(maskLayer, at: 0)
        
        addTarget(
            self,
            action: #selector(handleTouchDown),
            for: [.touchDown, .touchDragInside])
        
        addTarget(
            self,
            action: #selector(handleTouchUp),
            for: [.touchUpInside, .touchDragOutside, .touchCancel])
    }
    
    @objc private func handleTouchDown() {
        animateButton(opacity: 0.5)
    }
    
    @objc private func handleTouchUp() {
        animateButton(opacity: 0)
    }
    
    private func animateButton(opacity: Float) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: { [weak self] in
                self?.maskLayer.opacity = opacity
            }, completion: nil
        )
    }
    
    // MARK:- UIView methods
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = self.bounds
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 6.5, height: 12)
    }
    
    // MARK:- Drawing methods
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        color.setFill()
        
        ctx.saveGState()
        
        if direction == .right {
            ctx.translateBy(x: bounds.width, y: 0)
            ctx.scaleBy(x: -1, y: 1)
        }
        
        let baseRect = CGRect(x: 0, y: 0, width: 650, height: 1200)
        
        let scale = min(rect.width/baseRect.width, rect.height/baseRect.height)
        
        var resizedRect = baseRect.standardized
        resizedRect.size.width *= scale
        resizedRect.size.height *= scale
        resizedRect.origin.x = rect.minX + (rect.width - resizedRect.width) / 2
        resizedRect.origin.y = rect.minY + (rect.height - resizedRect.height) / 2
        ctx.translateBy(x: resizedRect.minX, y: resizedRect.minY)
        ctx.scaleBy(x: resizedRect.width / baseRect.width, y: resizedRect.height / baseRect.height)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 535, y: 180))
        path.addLine(to: CGPoint(x: 535, y: 1020))
        path.addLine(to: CGPoint(x: 115, y: 600))
        path.addLine(to: CGPoint(x: 535, y: 180))
        path.fill()
        
        ctx.restoreGState()

    }
}
