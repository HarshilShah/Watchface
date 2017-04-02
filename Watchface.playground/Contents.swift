//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class WatchfaceGallery: UIPageViewController, UIPageViewControllerDataSource {
    
    private let watchfaces = [
        ChunkyWatchFace(), AnalogWatchFace(), NumeralsWatchFace(),
        SevenSegmentWatchFace(), CalculatorWatchFace()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        setViewControllers([watchfaces.first!], direction: .forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = watchfaces.index(of: viewController) {
            index += watchfaces.count - 1
            index %= watchfaces.count
            return watchfaces[index]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = watchfaces.index(of: viewController) {
            index += 1
            index %= watchfaces.count
            return watchfaces[index]
        }
        
        return nil
    }
}

let gallery = WatchfaceGallery(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])

gallery.view.frame = CGRect(x: 0, y: 0, width: 312, height: 390)

PlaygroundPage.current.liveView = gallery.view
