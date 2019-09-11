//
//  SearchAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class SearchAlgorithm: IAlgorithm {
    
    func get(_ x:Int, _ y:Int) -> Int {
        return maze.board[x][y]
    }
    
    func set(_ x: Int, _ y : Int, _ newValue : Int) {
        maze.set(x: x, y: y, value: newValue)
        solution.removeAll()
    }
    
    internal var maze : Maze
    var start_node : Node
    
    var open: [Node] = []
    var closed: [Node] = []
    var solution: [NSPoint] = []
    var endPos: NSPoint
    var startPos : NSPoint { get { return maze.start_pos }}
    var boardWidth : Int { get { return maze.width }}
    var boardHeight : Int { get { return maze.height }}
    
    init(board: Maze) {
        self.maze = board
        start_node = Node(nil, board.start_pos)
        open.append(start_node)
        endPos = maze.end_pos
    }
    
    var tickCount = 0
    func processTarget(){
        tickCount += 1
        guard let goal_target = maze.goal_end_pos, tickCount % 4 == 0 else{
            return
        }
        
        if(endPos != goal_target){
            endPos.x -= 1
        }
    }
    
    func loadNewBoard(maze: Maze){
        open.removeAll()
        closed.removeAll()
        solution.removeAll()
        endPos = maze.end_pos
        self.maze = maze
        start_node = Node(nil, maze.start_pos)
        open.append(start_node)
    }
    
    func reset(){
        open.removeAll()
        closed.removeAll()
        solution.removeAll()
        tickCount = 0
        endPos = maze.end_pos

        open.append(start_node)
    }
    
    func step() -> Bool {
        fatalError("Must override")
    }
    
    func execute() -> Bool {
        fatalError("Must override")
    }
}
