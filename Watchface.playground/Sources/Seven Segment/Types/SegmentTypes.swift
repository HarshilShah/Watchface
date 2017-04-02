import UIKit

public enum SegmentOrientation {
    case horizontal, vertical
}

public enum Segment {
    case a, b, c, d, e, f, g, dot
    
    public static var allCases: [Segment] {
        return [.a, .b, .c, .d, .e, .f, .g, .dot]
    }
    
    public var originOffset: CGPoint {
        switch self {
        case .a:    return CGPoint(x: 136, y:  168)
        case .b:    return CGPoint(x: 558, y:  178)
        case .c:    return CGPoint(x: 558, y:  610)
        case .d:    return CGPoint(x: 136, y: 1032)
        case .e:    return CGPoint(x: 126, y:  610)
        case .f:    return CGPoint(x: 126, y:  178)
        case .g:    return CGPoint(x: 136, y:  600)
        case .dot:  return CGPoint(x: 632, y:  990)
        }
    }
    
    public var orientation: SegmentOrientation {
        switch self {
        case .a, .d, .g, .dot:
            return .horizontal
        case .b, .c, .e, .f:
            return .vertical
        }
    }
}
