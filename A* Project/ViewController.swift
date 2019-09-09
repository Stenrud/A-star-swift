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
    @IBOutlet weak var showOnlySolutionCheckBox: NSButton!
    
    
    var solver: IAlgorithm?
    var timer = Timer()
    
    @IBAction func onShowOnlySolutionChanged(_ sender: Any) {
        switch(showOnlySolutionCheckBox.state){
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
       
        if let file = mazes.selectedItem?.title {
            solver = AStar(board: Generator.GenerateBoardFromCsv(task: file))
        }
        
        graphicsView.loadAlgorithm(solver!)
    }

    @IBAction func changeSpeed(_ sender: Any) {
        
            if(timer.isValid){
                timer.invalidate()
                
                initiateTimer()
            }
    }
    
    @IBAction func MazeSelected(_ sender: Any) {
        
        timer.invalidate()
        if let task = mazes.selectedItem?.title {
            solver?.loadNewBoard(maze: Generator.GenerateBoardFromCsv(task: task))
            graphicsView.needsDisplay = true
            graphicsView.needsResizing = true
        }
    }
    
    @IBAction func AlgorithmSelected(_ sender: Any) {

        guard let algo = graphicsView.algo else{
            return
        }
        
        
        if(algorithms.titleOfSelectedItem == dijkstra){
            timer.invalidate()
            solver = Dijkstra(board: algo.maze)
            graphicsView.loadAlgorithm(solver!)
        }
        else if(algorithms.titleOfSelectedItem == aStar){
            timer.invalidate()
            solver = AStar(board: algo.maze)
            graphicsView.loadAlgorithm(solver!)
        }
        else if(algorithms.titleOfSelectedItem == bfs){
            timer.invalidate()
            solver = Bfs(board: algo.maze)
            graphicsView.loadAlgorithm(solver!)
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

        initiateTimer()
    }
    
    func initiateTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: (50 - speedSlider.doubleValue) / 100, repeats: true, block: { _ in
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

