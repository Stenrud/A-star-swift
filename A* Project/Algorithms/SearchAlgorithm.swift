//
//  SearchAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class SearchAlgorithm: IAlgorithm {
    
    let board : [[Int]]
    let start_node : Node
    let end : NSPoint
    let boardWidth : Int
    let boardHeight : Int
    
    var open: [Node] = []
    var closed: [Node] = []
    var solution: [NSPoint] = []
    
    init(board: [[Int]], start: NSPoint, end: NSPoint) {
        self.board = board
        start_node = Node(nil, start, g: 0)
        self.end = end
        open.append(start_node)
        boardWidth = board.count
        boardHeight = board[0].count
    }
    
    func step() -> Bool {
        fatalError("Must override")
    }
    
    func execute() -> Bool {
        fatalError("Must override")
    }
}
