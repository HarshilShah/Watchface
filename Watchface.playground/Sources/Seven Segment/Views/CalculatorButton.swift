import UIKit

internal class CalculatorButton: UIButton {
    
    // MARK:- Public variables
    
    internal var value: CalculatorButtonValue? {
        didSet {
            update()
        }
    }
    
    internal var isLockedIn = false {
        didSet {
            update()
        }
    }
    
    // MARK:- Private variables
    
    private lazy var gradientLayer = CircularGradientLayer()
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
        layer.cornerRadius = 5
        clipsToBounds = true
        
        layer.addSublayer(gradientLayer)
        
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.opacity = 0
        layer.insertSublayer(maskLayer, above: gradientLayer)
        
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
        animateButton(transform: CGAffineTransform(scaleX: 0.9, y: 0.9), opacity: 0.5)
    }
    
    @objc private func handleTouchUp() {
        animateButton(transform: .identity, opacity: 0)
    }
    
    private func animateButton(transform: CGAffineTransform, opacity: Float) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: { [weak self] in
                self?.transform = transform
                self?.maskLayer.opacity = opacity
            }, completion: nil
        )
    }
    
    // MARK:- UIView methods
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        maskLayer.frame = self.bounds
        
        gradientLayer.frame = self.bounds
        gradientLayer.startCenter = CGPoint(x: bounds.midX, y: bounds.midY - 10)
        gradientLayer.endCenter = CGPoint(x: bounds.midX, y: bounds.midY + 10)
        gradientLayer.internalRadius = 0
        gradientLayer.externalRadius = max(bounds.width, bounds.height)
        gradientLayer.setNeedsDisplay()
    }
    
    private func update() {
        guard let value = value else {
            return
        }
        
        setTitle(value.text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 32)
        titleLabel?.layer.shadowColor = UIColor.white.cgColor
        titleLabel?.layer.shadowOffset = .zero
        titleLabel?.layer.shadowRadius = 5
        titleLabel?.layer.shadowOpacity = 0.5
        gradientLayer.gradient = value.type.gradient
        gradientLayer.setNeedsDisplay()
        
        if isLockedIn && value is Operator {
            animateButton(transform: .identity, opacity: 0.5)
            isEnabled = false
        } else {
            animateButton(transform: .identity, opacity: 0)
            isEnabled = true
        }
    }
    
}
