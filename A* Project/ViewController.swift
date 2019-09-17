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
    @IBOutlet weak var speedSlider: NSSliderCell!
    @IBOutlet weak var speedStepper: NSStepper!
    @IBOutlet weak var speedText: NSTextField!
    
    var solver: IAlgorithm?
    var timer = Timer()
    
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
        speedText.stringValue = speedStepper.stringValue
    }
    @IBAction func changeSpeed(_ sender: Any) {
            if(timer.isValid){
                timer.invalidate()
                
                initiateTimer()
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
        timer.invalidate()
    }
    
    func TakeOneStep() -> Bool{
        return graphicsView.step()
    }

    @IBAction func StartAnimation(_ sender: Any) {
        initiateTimer()
    }
    
    func initiateTimer(){
        graphicsView.initiateAlgorithm(nameOfAlgo: algorithms.selectedItem!.title)
        timer = Timer.scheduledTimer(withTimeInterval: (50 - speedSlider.doubleValue) / 100, repeats: true, block: { _ in
            for _ in 1...self.speedStepper.intValue{
                if(!self.TakeOneStep()){
                    self.timer.invalidate()
                    break
                }
            }
        })
    }
    
    @IBAction func NoAnimation(_ sender: Any) {
        timer.invalidate()
        graphicsView.reset()
        
        graphicsView.initiateAlgorithm(nameOfAlgo: algorithms.selectedItem!.title)
        graphicsView.execute()
        
    }
    
    @IBAction func Reset(_ sender: Any) {
        timer.invalidate()
        graphicsView.reset()
    }
}

