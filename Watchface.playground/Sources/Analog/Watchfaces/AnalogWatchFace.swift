import UIKit

public class AnalogWatchFace: UIViewController {
    
    private static let dateFormatter = DateFormatter()
    
    private lazy var bezelLayer: BezelDrawingLayer = {
        let bezelLayer = BezelDrawingLayer()
        bezelLayer.numberOfPoints = 240
        bezelLayer.ringWidth = 12
        bezelLayer.widthRatio = 0.5
        bezelLayer.lineWidth = 1
        bezelLayer.color = .lightGray
        return bezelLayer
    }()
    
    private lazy var numeralsLayer: NumeralsDrawingLayer = {
        let numeralsLayer = NumeralsDrawingLayer()
        numeralsLayer.font = UIFont.systemFont(ofSize: 24, weight: .light)
        return numeralsLayer
    }()
    
    private lazy var hourHandLayer: WatchHandDrawingLayer = {
        let hourLayer = WatchHandDrawingLayer()
        hourLayer.type = .hour
        hourLayer.fillColor = UIColor.black.cgColor
        hourLayer.lineWidth = 2
        return hourLayer
    }()
    
    private lazy var minuteHandLayer: WatchHandDrawingLayer = {
        let minuteLayer = WatchHandDrawingLayer()
        minuteLayer.type = .minute
        minuteLayer.fillColor = UIColor.black.cgColor
        minuteLayer.lineWidth = 2
        return minuteLayer
    }()
    
    private lazy var secondHandLayer: WatchHandDrawingLayer = {
        let secondLayer = WatchHandDrawingLayer()
        secondLayer.type = .second
        secondLayer.color = UIColor.orange
        secondLayer.fillColor = UIColor.black.cgColor
        secondLayer.lineWidth = 2
        return secondLayer
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.smallCapsSystemFont(ofSize: 24)
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.layer.addSublayer(bezelLayer)
        view.layer.addSublayer(numeralsLayer)
        
        /// The hour hand is small so needs to be before i.e.
        /// added after minute, and the second hand needs to be
        /// on top
        
        view.layer.addSublayer(minuteHandLayer)
        view.layer.addSublayer(hourHandLayer)
        view.layer.addSublayer(secondHandLayer)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        set()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bezelLayer.frame = view.bounds
        bezelLayer.setNeedsDisplay()
        
        numeralsLayer.frame = view.bounds.insetBy(dx: 15, dy: 15)
        numeralsLayer.setNeedsDisplay()
        
        hourHandLayer.frame = view.bounds
        hourHandLayer.setNeedsDisplay()
        
        minuteHandLayer.frame = view.bounds
        minuteHandLayer.setNeedsDisplay()
        
        secondHandLayer.frame = view.bounds
        secondHandLayer.setNeedsDisplay()
    }
    
    public func set(date: Date = Date()) {
        let calendar = Calendar.autoupdatingCurrent
        
        let hours = calendar.component(.hour, from: date) % 12
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        AnalogWatchFace.dateFormatter.dateFormat = "E"
        let day = AnalogWatchFace.dateFormatter.string(from: date)
        let dayOfMonth = " \(calendar.component(.day, from: date))"
        
        let attributed = NSMutableAttributedString(string: day)
        attributed.addAttributes(
            [.foregroundColor: UIColor.white],
            range: NSRange(location: 0, length: day.count))
        
        let attributedDayOfMonth = NSMutableAttributedString(string: dayOfMonth)
        attributedDayOfMonth.addAttributes(
            [.foregroundColor: UIColor.orange],
            range: NSRange(location: 0, length: dayOfMonth.count))
        attributed.append(attributedDayOfMonth)
        dateLabel.attributedText = attributed
        
        /// The seconds layer is rotated by 360 degrees for 60 seconds
        /// i.e. one second = 6 degrees rotation
        ///
        /// The minutes layer is rotated by 360 degrees for 60 minutes
        /// i.e. one minute = 6 degrees rotation. Additionally, for every
        /// 360 degree progress in the seconds layer (1 minute), it needs
        /// to be rotated by 6 degrees. Thus, it is rotated by 1/60 of a
        /// degree for every degree the seconds layer is rotated
        ///
        /// The hour layer is rotated by 360 degrees for 12 hours i.e.
        /// one hour = 30 degrees rotation. Additionally, for every 360
        /// degree progress in the minutes layer (1 hour), it needs to be
        /// rotated by 30 degrees. Thus, it is rotated by 1/12 of a degree
        /// for every degree the minutes layer is rotated
        
        let secondsProgress = Degrees(seconds) * 360 / 60
        let minutesProgress = (Degrees(minutes) * 360 / 60) + secondsProgress/60
        let hourProgress = (Degrees(hours) * 360 / 12) + minutesProgress/12
        
        rotate(layer: secondHandLayer, from: secondsProgress.inRadians, withDuration: 60)
        rotate(layer: minuteHandLayer, from: minutesProgress.inRadians, withDuration: 60 * 60)
        rotate(layer: hourHandLayer, from: hourProgress.inRadians, withDuration: 60 * 60 * 12)
        
        delay(Double(60 - seconds), closure: { [weak self] in
            DispatchQueue.main.async {
                self?.set()
            }
        })
    }
    
    private func rotate(layer: CALayer, from initialRotation: CGFloat?, withDuration duration: TimeInterval) {
        
        let fromValue: CGFloat = {
            if let rotation = initialRotation {
                return rotation
            } else {
                let transform = layer.transform
                return atan2(transform.m12, transform.m11)
            }
        }()
        
        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.duration = duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotationAnimation.repeatCount = HUGE
        rotationAnimation.fromValue = fromValue
        rotationAnimation.toValue = fromValue + Degrees(360).inRadians
        layer.add(rotationAnimation, forKey:"rotate")
    }
    
}
