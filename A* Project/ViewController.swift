//
//  ViewController.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var graphicsView: GraphicsView!
    @IBOutlet weak var mazes: NSPopUpButtonCell!
    @IBOutlet weak var speedSlider: NSSliderCell!
    
    var solver: AStarInstance?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let map = Generator.GenerateBoard()
        
        mazes.removeAllItems()
        mazes.addItem(withTitle: "board-1-1")
        mazes.addItem(withTitle: "board-1-2")
        mazes.addItem(withTitle: "board-1-3")
        mazes.addItem(withTitle: "board-1-4")
        mazes.addItem(withTitle: "board-2-1")
        mazes.addItem(withTitle: "board-2-2")
        mazes.addItem(withTitle: "board-2-3")
        mazes.addItem(withTitle: "board-2-4")

        
        if let file = mazes.selectedItem?.title {
            solver = AStarInstance(board: Generator.GenerateBoard2(file: file))
        }
        graphicsView.loadAStar(solver!)
        // Do any additional setup after loading the view.
    }

    @IBAction func changeSpeed(_ sender: Any) {
        
            if(timer.isValid){
                timer.invalidate()
                
                timer = Timer.scheduledTimer(withTimeInterval: speedSlider.doubleValue / 100, repeats: true, block: { _     in
                    if(!self.TakeOneStep()){
                        self.timer.invalidate()
                    }
                })
            }
    }
    
    @IBAction func MazeSelected(_ sender: Any) {
        
        timer.invalidate()
        if let file = mazes.selectedItem?.title {
            solver?.loadNewBoard(board: Generator.GenerateBoard2(file: file))
            graphicsView.needsDisplay = true
        }
    }
    
    func TakeOneStep() -> Bool{
        
        let didStep = solver!.step()

        graphicsView.needsDisplay = true
        
        return didStep
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        
        }
    }

    @IBAction func ShowAnimation(_ sender: Any) {
        timer.invalidate()
        solver?.reset()

        timer = Timer.scheduledTimer(withTimeInterval: speedSlider.doubleValue / 100, repeats: true, block: { _ in
            if(!self.TakeOneStep()){
                self.timer.invalidate()
            }
        })
    }
    
    @IBAction func NoAnimation(_ sender: Any) {
        timer.invalidate()
        
        if let algo = solver{
            if(algo.execute()){
                graphicsView.needsDisplay = true
            }
            else{
                print("Didn't fint result, should not happen")
            }
        }
        else{
            print("No Algorithm initiated")
        }
        
    }
    
    @IBAction func Reset(_ sender: Any) {
        
        solver?.reset()
        
        timer.invalidate()
        graphicsView.needsDisplay = true
    }
}

