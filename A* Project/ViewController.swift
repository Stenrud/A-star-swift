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
    
    var board : [[Int]] = []
    var solver: AStarInstance?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let map = Generator.GenerateBoard()
        
        board = Generator.GenerateBoard()
        solver = AStarInstance(board: board, start: NSPoint(x: 1, y: 1), end: NSPoint(x: 15, y: 12))
        graphicsView.loadMap(board)
        graphicsView.loadAStar(solver!)

        
        // Do any additional setup after loading the view.
    }

    func test(){
        solver!.step()
        graphicsView.needsDisplay = true
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        
        }
    }

    @IBAction func sayHello(_ sender: Any) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.test()
        })
        
        //var solution = solver!.execute()
        //graphicsView.solution = solution
        //graphicsView.needsDisplay = true
    }
    
    
    func drawSomething(){
       
    }
    
}

