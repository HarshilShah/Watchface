import UIKit

internal class SevenSegmentView: UIView {
    
    // MARK:- Public variables
    
    internal var value: BCD = .zero {
        didSet {
            update()
        }
    }
    
    internal var shouldShowDecimalPoint = false {
        didSet {
            update()
        }
    }
    
    internal var onColor: UIColor = UIColor(red: 0.28, green: 0.99, blue: 0.21, alpha:1) {
        didSet {
            update()
        }
    }
    
    internal var offColor: UIColor = UIColor(red: 0.28, green: 0.99, blue: 0.21, alpha: 0.1) {
        didSet {
            update()
        }
    }
    
    // MARK:- Private variables
    
    private var segmentDict = [Segment: SegmentView]()
    
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
        for segment in Segment.allCases {
            let segmentView = SegmentView()
            segmentView.backgroundColor = .clear
            segmentView.segment = segment
            addSubview(segmentView)
            segmentDict[segment] = segmentView
        }
        
        transform = __CGAffineTransformMake(1, 0, -12 * .pi / 360, 1, 0, 0)
        update()
    }
    
    // MARK:- UIView methods
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        for (_, segmentView) in segmentDict {
            segmentView.frame = bounds
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 7, height: 12)
    }
    
    // MARK:- Segment update methods
    
    private func update() {
        let decoded = decode(value: value)
        
        for segment in Segment.allCases {
            segmentDict[segment]?.color = ((decoded[segment] ?? false) ? onColor : offColor)
        }
    }
    
    private func decode(value: BCD) -> [Segment: Bool] {
        var dict = [Segment: Bool]()
        
        dict[.a] = Set([.zero, .two, .three, .five, .six, .seven, .eight, .nine]).contains(value)
        
        dict[.b] = Set([.zero, .one, .two, .three, .four, .seven, .eight, .nine]).contains(value)
        
        dict[.c] = Set([.zero, .one, .three, .four, .five, .six, .seven, .eight, .nine]).contains(value)
        
        dict[.d] = Set([.zero, .two, .three, .five, .six, .eight, .nine]).contains(value)
        
        dict[.e] = Set([.zero, .two, .six, .eight]).contains(value)
        
        dict[.f] = Set([.zero, .four, .five, .six, .eight, .nine]).contains(value)
        
        dict[.g] = Set([.two, .three, .four, .five, .six, .eight, .nine, .minusSign]).contains(value)
        
        dict[.dot] = shouldShowDecimalPoint
        
        return dict
    }
    
}
