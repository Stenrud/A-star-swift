//
//  SearchAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class SearchAlgorithm: IAlgorithm {
    
    var board:[[Character]]
    var start: NSPoint
    var end: NSPoint
    var start_node: Node
    var end_node: Node
    
    
    var open: [Node] = []
    var closed: [Node] = []
    var solution: [NSPoint] = []
    
    init(board: [[Character]]) {
        self.board = board
        self.start = Generator.FindStart(board)
        self.end = Generator.FindEnd(board)
        start_node = Node(nil, start)
        end_node = Node(nil, end)
        open.append(start_node)
    }
    
    func loadNewBoard(board: [[Character]]){
        
        open.removeAll()
        closed.removeAll()
        solution.removeAll()
        
        self.board = board
        self.start = Generator.FindStart(board)
        self.end = Generator.FindEnd(board)
        start_node = Node(nil, start)
        end_node = Node(nil, end)
        
        open.append(start_node)
    }
    
    func reset(){
        open.removeAll()
        closed.removeAll()
        solution.removeAll()
        
        open.append(start_node)
    }
    
    func convert(_ char: Character) -> Int{
        switch char {
        case "w":
            return 100
        case "m":
            return 50
        case "f":
            return 10
        case "g":
            return 5
        case "r":
            return 1
        case "B":
            return 0
        case "A":
            return 0
        case "#":
            return -1
        default:
            return 0
        }
    }
    
    func step() -> Bool {
        fatalError("Must override")
    }
    
    func execute() -> Bool {
        fatalError("Must override")
    }
}
