import UIKit

/// A method to get an array of points representing the circumference of
/// a circle.
///
/// The points are calculated starting from the top-center, moving in a
/// clockwise direction from there.
///
/// - Parameters:
///   - nPoints: The number of points into which the circle
///     must be split into
///   - center: The center of the circle
///   - radius: The radius of the circle
/// - Returns: An `Array` of `CGPoint`s
public func get(nPoints numberOfPoints: Int, aroundCircleWithCenter center: CGPoint, radius: CGFloat) -> [CGPoint] {
    let rotationAdjustment = Degrees(270).inRadians
    let rotationPerPoint = Degrees(360/CGFloat(numberOfPoints)).inRadians
    
    var points = [CGPoint]()
    for i in 0 ..< numberOfPoints {
        let currentAngle = (rotationPerPoint * CGFloat(i) * -1) + rotationAdjustment
        
        /// Equation of a circle is given as (Rcos(theta), Rsin(theta))
        
        let newX = center.x - (radius * cos(currentAngle))
        let newY = center.y - (radius * sin(currentAngle))
        
        let newPoint = CGPoint(x: newX, y: newY)
        points.append(newPoint)
    }
    
    return points
}
