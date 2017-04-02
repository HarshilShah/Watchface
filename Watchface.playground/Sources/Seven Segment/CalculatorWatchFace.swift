import UIKit

public class CalculatorWatchFace: UIViewController {
    
    // MARK:- Private variables
    
    // MARK: Constants
    
    private let spacing: CGFloat = 5
    private let onColor = UIColor.black
    private let offColor = UIColor.black.withAlphaComponent(0.05)
    
    // MARK: Views
    
    private lazy var timeDisplayView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    private var timeDisplayHeightConstraint: NSLayoutConstraint?
    
    private let displayBackground = UIView()
    
    private let hourDisplayOne = SevenSegmentView()
    private let hourDisplayTwo = SevenSegmentView()
    private let hmColonDisplay = ColonView()
    private let minuteDisplayOne = SevenSegmentView()
    private let minuteDisplayTwo = SevenSegmentView()
    private let msColonDisplay = ColonView()
    private let secondDisplayOne = SevenSegmentView()
    private let secondDisplayTwo = SevenSegmentView()
    
    private lazy var resultDisplayView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var resultSegmentViews = [SevenSegmentView]()
    private lazy var leftChevronButton: ChevronButton = {
        let chevron = ChevronButton()
        chevron.direction = .left
        chevron.isEnabled = false
        return chevron
    }()
    private lazy var rightChevronButton: ChevronButton = {
        let chevron = ChevronButton()
        chevron.direction = .right
        chevron.isEnabled = false
        return chevron
    }()
    
    private var numberPadView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK:- UIViewController methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        view.addSubview(displayBackground)
        displayBackground.layer.cornerRadius = 12
        displayBackground.backgroundColor = UIColor(red: 0.62, green: 0.64, blue: 0.48, alpha: 1.00)
        
        timeDisplayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeDisplayView)
        timeDisplayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        timeDisplayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timeDisplayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timeDisplayView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        timeDisplayView.addArrangedSubview(hourDisplayOne)
        timeDisplayView.addArrangedSubview(hourDisplayTwo)
        timeDisplayView.addArrangedSubview(hmColonDisplay)
        timeDisplayView.addArrangedSubview(minuteDisplayOne)
        timeDisplayView.addArrangedSubview(minuteDisplayTwo)
        timeDisplayView.addArrangedSubview(msColonDisplay)
        timeDisplayView.addArrangedSubview(secondDisplayOne)
        timeDisplayView.addArrangedSubview(secondDisplayTwo)
        
        timeDisplayView.arrangedSubviews.forEach {
            if let view = $0 as? ColonView {
                view.color = view === hmColonDisplay ? onColor : .clear
            } else if let view = $0 as? SevenSegmentView {
                view.onColor = onColor
                view.offColor = offColor
            }
        }
        
        resultDisplayView.isHidden = true
        view.addSubview(resultDisplayView)
        
        leftChevronButton.color = offColor
        leftChevronButton.addTarget(self, action: #selector(shiftLeft(_:)), for: .touchUpInside)
        
        rightChevronButton.color = offColor
        rightChevronButton.addTarget(self, action: #selector(shiftRight(_:)), for: .touchUpInside)
        
        resultDisplayView.addArrangedSubview(leftChevronButton)
        for _ in 0 ..< resultNumerals {
            let segmentView = SevenSegmentView()
            segmentView.onColor = onColor
            segmentView.offColor = offColor
            resultDisplayView.addArrangedSubview(segmentView)
            resultSegmentViews.append(segmentView)
        }
        resultDisplayView.addArrangedSubview(rightChevronButton)
        
        numberPadView.spacing = spacing
        numberPadView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numberPadView)
        numberPadView.topAnchor.constraint(equalTo: timeDisplayView.bottomAnchor, constant: spacing).isActive = true
        numberPadView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        numberPadView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        numberPadView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let calculatorButtons: [[CalculatorButtonValue]] = {
            return [
                [BCD.seven,     BCD.eight,  BCD.nine,           Operator.divide],
                [BCD.four,      BCD.five,   BCD.six,            Operator.multiply],
                [BCD.one,       BCD.two,    BCD.three,          Operator.subtract],
                [ClearButton(), BCD.zero,   Operator.equals,    Operator.add]
            ]
        }()
        
        for row in calculatorButtons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = spacing
            numberPadView.addArrangedSubview(rowStack)
            
            for buttonValue in row {
                let button = CalculatorButton()
                button.value = buttonValue
                rowStack.addArrangedSubview(button)
                
                if buttonValue is BCD {
                    button.addTarget(self, action: #selector(numeralPressed(_:)), for: [.touchUpInside])
                } else if buttonValue is Operator {
                    button.addTarget(self, action: #selector(operatorPressed(_:)), for: [.touchUpInside])
                } else if buttonValue is ClearButton {
                    button.addTarget(self, action: #selector(clearPressed(_:)), for: [.touchUpInside])
                }
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let timeDisplayHeightConstraint = timeDisplayHeightConstraint {
            timeDisplayHeightConstraint.isActive = false
            timeDisplayView.removeConstraint(timeDisplayHeightConstraint)
            self.timeDisplayHeightConstraint = nil
        }
        
        let aspectRatio = timeDisplayView.arrangedSubviews.reduce(CGFloat(0)) {
            let size = $0.1.intrinsicContentSize
            return $0.0 + size.width / size.height
        }
        
        timeDisplayHeightConstraint = timeDisplayView.heightAnchor.constraint(equalTo: timeDisplayView.widthAnchor, multiplier: 1 / aspectRatio)
        timeDisplayHeightConstraint?.isActive = true

        resultDisplayView.frame = timeDisplayView.frame
        displayBackground.frame = timeDisplayView.frame
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [. repeat, .autoreverse, .curveEaseOut], animations: { [weak self] in
            self?.hmColonDisplay.alpha = 0.5
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
        secondDisplayOne.value = BCD(rawValue: (seconds/10) % 10)!
        secondDisplayTwo.value = BCD(rawValue: seconds % 10)!
        
        delay(0.25, closure: { [weak self] in
            DispatchQueue.main.async {
                self?.set()
            }
        })
    }
    
    // MARK:- Calculator logic
    
    private let resultNumerals = 5
    
    private lazy var calculatorModel = CalculatorModel()
    private var isInCalculatorMode = false
    private var isTypingNumber = false
    
    private var currentValue: Double = 0
    private var values = [(BCD, Bool)]()
    
    private var index = 0
    private var isLeftShiftAllowed = false
    private var isRightShiftAllowed = false
    
    @objc private func numeralPressed(_ button: CalculatorButton) {
        guard let bcdValue = button.value as? BCD else {
            return
        }
        
        if !isInCalculatorMode {
            enterCalculatorMode()
        }
        
        if !isTypingNumber {
            currentValue = 0
            isTypingNumber = true
        }
        
        activate(operator: nil)
        
        let numeral = bcdValue.rawValue
        currentValue *= 10
        currentValue += Double(numeral)
        updateDisplay(stayRightAligned: true)
    }
    
    @objc private func operatorPressed(_ button: CalculatorButton) {
        guard isInCalculatorMode, let op = button.value as? Operator else {
            return
        }
        
        calculatorModel.push(operand: currentValue)
        currentValue = 0
        
        if op == .equals {
            currentValue = calculatorModel.evaluate()
            updateDisplay()
        } else {
            calculatorModel.push(operator: op)
            activate(operator: op)
        }
        
        isTypingNumber = false
    }
    
    @objc private func clearPressed(_ button: CalculatorButton) {
        guard isInCalculatorMode else {
            return
        }
        
        if !calculatorModel.isClear() {
            calculatorModel.clear()
            currentValue = 0
            updateDisplay()
        } else {
            exitCalculatorMode()
        }
    }
    
    private func activate(operator op: Operator?) {
        numberPadView.arrangedSubviews.forEach {
            ($0 as? UIStackView)?.arrangedSubviews.forEach {
                if let button = $0 as? CalculatorButton {
                    if let op = op {
                        if let value = button.value as? Operator {
                            button.isLockedIn = (value == op)
                        }
                    } else {
                        button.isLockedIn = false
                    }
                }
            }
        }
    }
    
    private func updateDisplay(stayRightAligned rightAligned: Bool = false) {
        var tempValue = fabs(currentValue)
        var needsDecimal = true
        
        var values = [(BCD, Bool)]()
        
        let hundredthPlace = Int((tempValue * 100).truncatingRemainder(dividingBy: 10))
        let tenthPlace = Int((tempValue * 10).truncatingRemainder(dividingBy: 10))
        
        if hundredthPlace != 0 {
            values.append((BCD(rawValue: hundredthPlace)!, false))
            values.append((BCD(rawValue: tenthPlace)!, false))
        } else if tenthPlace != 0 {
            values.append((BCD(rawValue: tenthPlace)!, false))
        } else {
            needsDecimal = false
        }
        
        while tempValue.rounded(.down) > 0 {
            values.append((BCD(rawValue: Int(tempValue.truncatingRemainder(dividingBy: 10)))!, needsDecimal))
            tempValue /= 10
            needsDecimal = false
        }
        
        if needsDecimal { values.append((BCD.zero, needsDecimal)) }
        
        if currentValue < 0 { values.append((.minusSign, false)) }
        
        if values.count == 0 { values.append((.zero, false)) }
        
        while values.count < 5 { values.append((.nothing, false)) }
        
        values.reverse()
        
        self.values = values
        index = rightAligned ? values.count - resultNumerals : 0
        
        display()
    }
    
    private func display() {
        for i in index ..< (index + resultNumerals) {
            resultSegmentViews[i - index].value = values[i].0
            resultSegmentViews[i - index].shouldShowDecimalPoint = values[i].1
        }
        
        isLeftShiftAllowed = index > 0
        isRightShiftAllowed = values.count - index > resultNumerals
        
        leftChevronButton.isEnabled = isLeftShiftAllowed
        leftChevronButton.color = isLeftShiftAllowed ? onColor : offColor
        
        rightChevronButton.isEnabled = isRightShiftAllowed
        rightChevronButton.color = isRightShiftAllowed ? onColor : offColor
    }
    
    @objc private func shiftRight(_ button: ChevronButton) {
        index += 1
        display()
    }
    
    @objc private func shiftLeft(_ button: ChevronButton) {
        index -= 1
        display()
    }
    
    private func enterCalculatorMode() {
        guard !isInCalculatorMode else {
            return
        }
        
        resultDisplayView.alpha = 0
        resultDisplayView.transform = CGAffineTransform(translationX: 0, y: -resultDisplayView.frame.height / 2)
        resultDisplayView.isHidden = false
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { [weak self] in
                self?.timeDisplayView.alpha = 0
                self?.resultDisplayView.alpha = 1
                self?.resultDisplayView.transform = .identity
            }, completion: { [weak self] _ in
                self?.isInCalculatorMode = true
            }
        )
    }
    
    private func exitCalculatorMode() {
        guard isInCalculatorMode else {
            return
        }
        
        calculatorModel.clear()
        currentValue = 0
        updateDisplay()
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: { [weak self] in
                self?.timeDisplayView.alpha = 1
                self?.resultDisplayView.alpha = 0
                self?.resultDisplayView.transform = CGAffineTransform(translationX: 0, y: -(self?.resultDisplayView.frame.height ?? 100) / 2)
            }, completion: { [weak self] _ in
                self?.isInCalculatorMode = false
                self?.resultDisplayView.isHidden = true
            }
        )
        isInCalculatorMode = false
    }
    
}
