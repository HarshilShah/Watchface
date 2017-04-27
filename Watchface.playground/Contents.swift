//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

struct Constants {
    static let watchfaceSize = CGSize(width: 312, height: 390)
    static let watchfaceInsets = CGPoint(x: 75, y: 75)
    static let watchCornerRadius = CGFloat(90)
}

let backboard = UIView()
backboard.backgroundColor = .white
backboard.frame = CGRect(
    x: 0,
    y: 0,
    width: Constants.watchfaceSize.width + 4 * Constants.watchfaceInsets.x,
    height: Constants.watchfaceSize.height + 4 * Constants.watchfaceInsets.y)

let watchBody = UIView()
watchBody.backgroundColor = .black
watchBody.layer.cornerRadius = Constants.watchCornerRadius
backboard.addSubview(watchBody)
watchBody.frame = CGRect(
    x: Constants.watchfaceInsets.x,
    y: Constants.watchfaceInsets.y,
    width: Constants.watchfaceSize.width + 2 * Constants.watchfaceInsets.x,
    height: Constants.watchfaceSize.height + 2 * Constants.watchfaceInsets.y)

let gallery = WatchfaceGallery(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
watchBody.addSubview(gallery.view)
gallery.view.frame = CGRect(origin: Constants.watchfaceInsets,
                            size: Constants.watchfaceSize)

PlaygroundPage.current.liveView = backboard
