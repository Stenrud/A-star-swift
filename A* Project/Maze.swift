//
//  Maze.swift
//  A* Project
//
//  Created by Truls Stenrud on 09/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

class Maze{
    
    var board : [[Int]]
    var start_pos : CGPoint
    var end_pos : CGPoint
    var width = 0
    var height = 0
    
    init(board : [[Int]], start_pos : CGPoint, end_pos : CGPoint) {
        self.board = board
        self.start_pos = start_pos
        self.end_pos = end_pos
        
        confirmDImentions()
    }

    func setBoard(board : [[Int]]){
        self.board = board
        
        confirmDImentions()
    }
    
    private func confirmDImentions(){
        width = board.count
        height = board[0].count
        
        if(board.contains(where: {$0.count != height})){
            fatalError("Board isn't rectangular")
        }
    }
    
}
