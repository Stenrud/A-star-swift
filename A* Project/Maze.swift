//
//  Maze.swift
//  A* Project
//
//  Created by Truls Stenrud on 09/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class Maze{
    
    private(set) var board : [[Int]]
    let start_pos : CGPoint
    let end_pos : CGPoint
    let goal_end_pos : CGPoint?
    let width : Int
    let height : Int
    
    
    init(board : [[Int]], start_pos : CGPoint, end_pos : CGPoint, goal_end_pos : CGPoint? = nil) {
        self.board = board
        self.start_pos = start_pos
        self.end_pos = end_pos
        self.goal_end_pos = goal_end_pos
        
        width = board.count
        height = board[0].count
        
        if(board.contains(where: {$0.count != height})){
            fatalError("Board isn't rectangular")
        }
    }
    
    func set(x: Int, y: Int, value: Int){
        board[x][y] = value
    }
}
