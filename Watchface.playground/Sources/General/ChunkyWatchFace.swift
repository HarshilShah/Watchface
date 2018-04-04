import UIKit

public class ChunkyWatchFace: UIViewController {
    
    // MARK:- Constants
    
    private let font = UIFont.centeredColonSystemFont(ofSize: 220)
    
    private let color = UIColor(red: 0.47, green: 0.76, blue: 0.98, alpha: 1)
    
    // MARK:- Views
    
    private var stackView = UIStackView()
    private var secondaryStackView = UIStackView()
    
    private var hourLabel = UILabel()
    private var colonLabel = UILabel()
    private var minuteLabel = UILabel()
    
    // MARK:- View controller lifecycle methods
    
    override public func viewDidLoad() {
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
        
        let fontSize = font.pointSize
        hourLabel.set(text: "10", withLineHeight: fontSize + 20)
        colonLabel.set(text: ":", withLineHeight: fontSize + 20)
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
