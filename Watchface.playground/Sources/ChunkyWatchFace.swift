import UIKit

public class ChunkyWatchFace: UIViewController, WatchFace {
    
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
        let fontURL = Bundle.main.url(forResource: "SF-Compact-Display-Light", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        let font = UIFont(name: "SFCompactDisplay-Light", size: fontSize)!
//        let font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
        
        hourLabel.font = font
        colonLabel.font = font.withSize(fontSize - 70)
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
        
        secondaryStackView.alignment = .top
        secondaryStackView.addArrangedSubview(colonLabel)
        secondaryStackView.addArrangedSubview(minuteLabel)
        
        hourLabel.set(text: "10", withLineHeight: fontSize + 20)
        colonLabel.set(text: ":", withLineHeight: fontSize - 50)
        minuteLabel.set(text: "09", withLineHeight: fontSize + 20)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [. repeat, .autoreverse, .curveEaseInOut], animations: { [weak self] in
            self?.colonLabel.alpha = 0.5
        }, completion: nil)
    }
    
    public func set(date: Date) {
        let calendar = Calendar.autoupdatingCurrent
        hourLabel.set(text: "\((calendar.component(.hour, from: date) - 1) % 12 + 1)", withLineHeight: fontSize + 20)
        minuteLabel.set(text: String(format: "%02d", calendar.component(.minute, from: date)), withLineHeight: fontSize + 20)
    }
    
}

private extension UILabel {
    func set(text: String, withLineHeight lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}
