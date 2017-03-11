//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let chunky = ChunkyWatchFace()
chunky.view.frame = CGRect(x: 0, y: 0, width: 312, height: 390)

PlaygroundPage.current.liveView = chunky.view

//var helloWorldTimer = Timer.scheduledTimer(timeInterval: 1.0, target: chunky, selector: #selector(chunky.set(date:)), userInfo: nil, repeats: true)

chunky.set(date: Date())
