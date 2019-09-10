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
    
    // THis is called when the user checks or unchecs the button for displaying only the solutionpath, and not
    // the open/closed nodes
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
    
    // Is called when the view is loaded and I can comunicate with the view elements
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

    // is called when the user changes the speed using the slider
    @IBAction func changeSpeed(_ sender: Any) {
            if(timer.isValid){
                timer.invalidate()
                
                initiateTimer()
            }
    }
    
    
    
    @IBAction func taskSelected(_ sender: Any) {
        
        // stop the timer in case its running
        timer.invalidate()
        if let task = mazes.selectedItem?.title {
            solver?.loadNewBoard(maze: Generator.GenerateBoardFromCsv(task: task))
            graphicsView.needsDisplay = true
            graphicsView.needsResizing = true
        }
    }

    // lets the user choose algorithm
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
    
    // takes one step in the search algorithm.
    // It's used by the timer to create the animation
    func TakeOneStep() -> Bool{
        
        let didStep = solver!.step()

        graphicsView.needsDisplay = true
        
        return didStep
    }

    // starts the animation
    @IBAction func StartAnimation(_ sender: Any) {
        // stops old timer if it runs
        timer.invalidate()
        
        // reset the algorithm
        solver?.reset()
        
        // start new timer
        initiateTimer()
    }
    
    // creates a timer that creates the animation,
    // for each step it takes one step with the search algorithm
    func initiateTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: (50 - speedSlider.doubleValue) / 100, repeats: true, block: { _ in
            if(!self.TakeOneStep()){
                self.timer.invalidate()
            }
        })
    }
    
    // FInds the solution without animating it
    @IBAction func NoAnimation(_ sender: Any) {
        
        // stops the timer if its already running
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
    
    // resets the algorithm
    @IBAction func Reset(_ sender: Any) {
        solver?.reset()
        
        timer.invalidate()
        graphicsView.needsDisplay = true
    }
}

