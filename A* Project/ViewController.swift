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
    
    var solver: IAlgorithm?
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

        algorithms.removeAllItems()
        algorithms.addItem(withTitle: aStar)
        algorithms.addItem(withTitle: dijkstra)
        algorithms.addItem(withTitle: bfs)
       
        if let file = mazes.selectedItem?.title {
            solver = AStar(board: Generator.GenerateBoard2(file: file))
        }
        graphicsView.loadAlgorithm(solver!)
        // Do any additional setup after loading the view.
    }

    @IBAction func changeSpeed(_ sender: Any) {
        
            if(timer.isValid){
                timer.invalidate()
                
                timer = Timer.scheduledTimer(withTimeInterval: speedSlider.doubleValue / 100, repeats: true, block: {_ in
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
    
    @IBAction func AlgorithmSelected(_ sender: Any) {

        guard let algo = graphicsView.algo else{
            return
        }
        
        
        if(algorithms.titleOfSelectedItem == dijkstra){
            timer.invalidate()
            solver = Dijkstra(board: algo.board)
            graphicsView.loadAlgorithm(solver!)
            graphicsView.needsDisplay = true
        }
        else if(algorithms.titleOfSelectedItem == aStar){
            timer.invalidate()
            solver = AStar(board: algo.board)
            graphicsView.loadAlgorithm(solver!)
            graphicsView.needsDisplay = true
        }
        else if(algorithms.titleOfSelectedItem == bfs){
            timer.invalidate()
            solver = Bfs(board: algo.board)
            graphicsView.loadAlgorithm(solver!)
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

