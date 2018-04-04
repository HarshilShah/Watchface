import UIKit

public class WatchfaceGallery: UIPageViewController, UIPageViewControllerDataSource {
    
    private let watchfaces = [
        AnalogWatchFace(), NumeralsWatchFace(),
        ChunkyWatchFace(), BouncingBallsWatchFace(),
        SevenSegmentWatchFace(), CalculatorWatchFace(),
    ]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        setViewControllers([watchfaces.first!], direction: .forward, animated: false, completion: nil)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = watchfaces.index(of: viewController) {
            index += watchfaces.count - 1
            index %= watchfaces.count
            return watchfaces[index]
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = watchfaces.index(of: viewController) {
            index += 1
            index %= watchfaces.count
            return watchfaces[index]
        }
        
        return nil
    }
}
