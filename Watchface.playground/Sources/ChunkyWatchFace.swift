import UIKit

public class ChunkyWatchFace: UIViewController {
    
    // MARK:- Constants
    
    private let fontSize: CGFloat = 230
    private let color = UIColor(red: 0.47, green: 0.76, blue: 0.98, alpha: 1)
    
    // MARK:- Views
    
    private var stackView = UIStackView()
    private var secondaryStackView = UIStackView()
    
    private var hourLabel = UILabel()
    private var colonLabel = UILabel()
    private var minuteLabel = UILabel()
    
    // MARK:- View controller lifecycle methods
    
    override public func viewDidLoad() {
        let font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
        
        hourLabel.font = font
        colonLabel.font = font
        minuteLabel.font = font
        
        hourLabel.textColor = color
        colonLabel.textColor = color
        minuteLabel.textColor = color
        
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(secondaryStackView)
        
        secondaryStackView.addArrangedSubview(colonLabel)
        secondaryStackView.addArrangedSubview(minuteLabel)
        
        let attributedColon = NSMutableAttributedString(string: ":")
        attributedColon.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: -Double(fontSize)/3.33), range: NSMakeRange(0, attributedColon.length))
        
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
    
    public func set(date: Date = Date()) {
        let calendar = Calendar.autoupdatingCurrent
        hourLabel.set(text: "\((calendar.component(.hour, from: date) - 1) % 12 + 1)", withLineHeight: fontSize + 20)
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
