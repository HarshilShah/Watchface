import UIKit

public class SevenSegmentWatchFace: UIViewController {
    
    // MARK:- Private variables
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let hourDisplayOne = SevenSegmentView()
    private let hourDisplayTwo = SevenSegmentView()
    private let colonDisplay = ColonView()
    private let minuteDisplayOne = SevenSegmentView()
    private let minuteDisplayTwo = SevenSegmentView()
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK:- UIViewController methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        stackView.addArrangedSubview(hourDisplayOne)
        stackView.addArrangedSubview(hourDisplayTwo)
        stackView.addArrangedSubview(colonDisplay)
        stackView.addArrangedSubview(minuteDisplayOne)
        stackView.addArrangedSubview(minuteDisplayTwo)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let heightConstraint = heightConstraint {
            heightConstraint.isActive = false
            stackView.removeConstraint(heightConstraint)
            self.heightConstraint = nil
        }
        
        let aspectRatio = stackView.arrangedSubviews.reduce(CGFloat(0)) {
            let size = $0.1.intrinsicContentSize
            return $0.0 + size.width / size.height
        }
        
        heightConstraint = stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / aspectRatio)
        heightConstraint?.isActive = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [. repeat, .autoreverse, .curveEaseOut], animations: { [weak self] in
            self?.colonDisplay.alpha = 0.5
            }, completion: nil)
        
        set()
    }
    
    public func set(date: Date = Date()) {
        let calendar = Calendar.autoupdatingCurrent
        
        let hours: Int = {
            let tempHours = calendar.component(.hour, from: date) % 12
            return tempHours == 0 ? 12 : tempHours
        }()
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        hourDisplayOne.value = hours >= 10 ? BCD(rawValue: hours/10)! : .nothing
        hourDisplayTwo.value = BCD(rawValue: hours % 10)!
        minuteDisplayOne.value = BCD(rawValue: (minutes/10) % 10)!
        minuteDisplayTwo.value = BCD(rawValue: minutes % 10)!
        
        delay(Double(60 - seconds), closure: { [weak self] in
            DispatchQueue.main.async {
                self?.set()
            }
        })
    }
    
}
