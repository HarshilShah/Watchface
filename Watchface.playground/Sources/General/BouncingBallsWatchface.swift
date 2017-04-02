import UIKit
import SpriteKit

public class BouncingBallsWatchFace: UIViewController {
    
    // MARK:- Constants
    
    private let font = UIFont.systemFont(ofSize: 72, weight: UIFontWeightLight)
    private let color = UIColor.white
    
    // MARK:- Views
    
    private let spriteKitView = SKView(frame: CGRect(x: 0, y: 0, width: 312, height: 390))
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private var hourLabel = UILabel()
    private var colonLabel = UILabel()
    private var minuteLabel = UILabel()
    
    // MARK:- View controller lifecycle methods
    
    override public func viewDidLoad() {
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        view.addSubview(spriteKitView)
        let scene = BouncingBallsScene()
        spriteKitView.presentScene(scene)
        
        view.addSubview(blurView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let labels: [UILabel] = [hourLabel, colonLabel, minuteLabel]
        
        for label in labels {
            label.font = font
            label.textColor = color
            label.layer.shadowColor = UIColor.black.cgColor
            label.layer.shadowOffset = .zero
            label.layer.shadowRadius = 10
            label.layer.shadowOpacity = 1
            stackView.addArrangedSubview(label)
        }
        
        let fontSize = font.pointSize
        
        let attributedColon = NSMutableAttributedString(string: ":")
        attributedColon.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: -Double(fontSize)/3), range: NSMakeRange(0, attributedColon.length))
        
        hourLabel.set(text: "10", withLineHeight: fontSize + 20)
        colonLabel.set(text: ":", withLineHeight: fontSize + 20)
        colonLabel.set(attributedText: attributedColon, withLineHeight: fontSize + 20)
        minuteLabel.set(text: "09", withLineHeight: fontSize + 20)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [. repeat, .autoreverse, .curveEaseOut], animations: { [weak self] in
            self?.colonLabel.alpha = 0.5
            }, completion: nil)
        
        set()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spriteKitView.frame = view.bounds
        blurView.frame = view.bounds
    }
    
    public func set(date: Date = Date()) {
        let fontSize = font.pointSize
        
        let calendar = Calendar.autoupdatingCurrent
        let hour: Int = {
            let tempHour = calendar.component(.hour, from: date) % 12
            return tempHour == 0 ? 12 : tempHour
        }()
        
        hourLabel.set(text: "\(hour)", withLineHeight: fontSize + 20)
        minuteLabel.set(text: String(format: "%02d", calendar.component(.minute, from: date)), withLineHeight: fontSize + 20)
        
        let seconds = calendar.component(.second, from: date)
        
        delay(Double(60 - seconds), closure: { [weak self] in
            DispatchQueue.main.async {
                self?.set()
            }
        })
    }
    
}

private extension UILabel {
    func set(text: String, withLineHeight lineHeight: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        set(attributedText: attributedString, withLineHeight: lineHeight)
    }
    
    func set(attributedText: NSMutableAttributedString, withLineHeight lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        let attributedString = attributedText
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
        self.attributedText = attributedString
    }
}
