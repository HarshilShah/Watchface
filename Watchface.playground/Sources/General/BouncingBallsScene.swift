import SpriteKit

class BouncingBallsScene: SKScene {
    
    private let colors: [UIColor] = [
        UIColor(red:0.63, green:0.24, blue:0.45, alpha:1.00),
        UIColor(red:0.26, green:0.36, blue:0.94, alpha:1.00)  ]
    
    override func didMove(to view: SKView) {
        self.size = view.bounds.size
        
        physicsWorld.gravity = .zero
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody!.friction = 0
        physicsBody!.restitution = 1
        
        for _ in 0 ..< 5 {
            let ball = SKShapeNode(circleOfRadius: 50)
            ball.fillColor = colors[Int(arc4random()) % colors.count]
            ball.strokeColor = .clear
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
            ball.physicsBody!.allowsRotation = false
            ball.physicsBody!.friction = 0
            ball.physicsBody!.linearDamping = 0
            ball.physicsBody!.restitution = 1
            ball.physicsBody!.velocity = CGVector(dx: 20, dy: 20)
            ball.position = CGPoint(
                x: CGFloat(arc4random()%(UInt32(self.size.width.rounded(.down)))),
                y: CGFloat(arc4random()%(UInt32(self.size.height.rounded(.down)))))
            self.addChild(ball)
        }
    }
}
