//
//  SearchAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class SearchAlgorithm: IAlgorithm {
    func set(_ x: Int, _ y : Int, _ newValue : Int) {
        maze.board[x][y] = newValue
        solution.removeAll()
    }
    
    
    var maze : Maze
    var start_node : Node
    
    var open: [Node] = []
    var closed: [Node] = []
    var solution: [NSPoint] = []
    
    init(board: Maze) {
        self.maze = board
        start_node = Node(nil, board.start_pos)
        open.append(start_node)
    }
    
    func loadNewBoard(maze: Maze){
        open.removeAll()
        closed.removeAll()
        solution.removeAll()
        
        self.maze = maze
        start_node = Node(nil, maze.start_pos)
        open.append(start_node)
    }
    
    func reset(){
        open.removeAll()
        closed.removeAll()
        solution.removeAll()
        
        open.append(start_node)
    }
    
    func step() -> Bool {
        fatalError("Must override")
    }
    
    func execute() -> Bool {
        fatalError("Must override")
    }
}
