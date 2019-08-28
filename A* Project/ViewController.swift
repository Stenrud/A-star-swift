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
    
    var board : [[Character]] = []
    var solver: AStarInstance?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let map = Generator.GenerateBoard()
        
        board = Generator.GenerateBoard2()
        solver = AStarInstance(board: board)
        graphicsView.loadMap(board)
        graphicsView.loadAStar(solver!)

        
        // Do any additional setup after loading the view.
    }

    func TakeOneStep(){
        let path = solver!.step()
        
        if(path != nil)
        {
            graphicsView.solution = path!
            timer.invalidate()
        }
        graphicsView.needsDisplay = true
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        
        }
    }

    @IBAction func ShowAnimation(_ sender: Any) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.TakeOneStep()
        })
        
        //var solution = solver!.execute()
        //graphicsView.solution = solution
        //graphicsView.needsDisplay = true
    }
    
    @IBAction func NoAnimation(_ sender: Any) {
        let solution = solver!.execute()
        
        if(!solution.isEmpty){
            graphicsView.solution = solution
            graphicsView.needsDisplay = true
        }

    }
    
    @IBAction func Reset(_ sender: Any) {
        solver = AStarInstance(board: board)
        
        graphicsView.loadAStar(solver!)
        graphicsView.solution = []
        timer.invalidate()
        graphicsView.needsDisplay = true
    }
}

