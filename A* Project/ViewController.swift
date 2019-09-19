//
//  ViewController.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let aStar = String(describing: AStar.self)
    let dijkstra = String(describing: Dijkstra.self)
    let bfs = String(describing: Bfs.self)
    
    
    @IBOutlet weak var graphicsView: GraphicsView!
    @IBOutlet weak var mazes: NSPopUpButtonCell!
    @IBOutlet weak var algorithms: NSPopUpButtonCell!
    @IBOutlet weak var speedText: NSTextField!
    
    var solver: IAlgorithm?
    
    @IBAction func onShowOnlySolutionChanged(_ sender: Any) {
        guard let button = sender as? NSButton else{
            return
        }
        
        switch(button.state){
        case .off:
            graphicsView.showOnlySolution = false
            break
        case .on:
            graphicsView.showOnlySolution = true
            break
        default:
            break
        }
        
        graphicsView.needsDisplay = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mazes.removeAllItems()
        mazes.addItems(withTitles: Generator.GetFiles())
        
        algorithms.removeAllItems()
        algorithms.addItem(withTitle: aStar)
        algorithms.addItem(withTitle: dijkstra)
        algorithms.addItem(withTitle: bfs)
    }

    @IBAction func speedStepperChanged(_ sender: Any) {
        if let stepper = sender as? NSStepper{
            speedText.stringValue = stepper.stringValue
            graphicsView.setIterationsPerFrame(stepper.integerValue)
        }
    }
    
    @IBAction func changeSpeed(_ sender: Any) {
        if let slider = sender as? NSSlider {
            graphicsView.setFrameSpeed(slider.doubleValue)
        }

    }
    
    
    @IBAction func taskSelected(_ sender: Any) {
    
//        timer.invalidate()
//        if let task = mazes.selectedItem?.title {
//            graphicsView.needsDisplay = true
//            graphicsView.needsResizing = true
//        }
    }

    @IBAction func AlgorithmSelected(_ sender: Any) {
        graphicsView.reset()
    }

    @IBAction func StartAnimation(_ sender: Any) {
        if let title = algorithms.selectedItem?.title{
            graphicsView.startAnimation(title)
        }
    }
    
    @IBAction func NoAnimation(_ sender: Any) {
        if let title = algorithms.selectedItem?.title{
            graphicsView.execute(title)
        }
    }
    
    @IBAction func Reset(_ sender: Any) {
        graphicsView.reset()
    }
}

