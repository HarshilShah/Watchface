import UIKit

/// A typealias just so autocomplete always fills in degrees so its
/// obvious whether radians or degrees are used in whichever area
public typealias Degrees = CGFloat

public extension Degrees {
    
    /// Returns the value of the current angle as converted to radians.
    /// Uses the relationship 2 * pi = 360 degrees
    public var inRadians: CGFloat {
        return self * CGFloat.pi / 180
    }
}
