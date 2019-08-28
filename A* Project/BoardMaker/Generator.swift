//
//  Generator.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Foundation

class Generator{
    
   static func  GenerateBoard () -> [[Int]]{
    
        let board = [
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,1,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,1,0,1,1,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,0,0,0,0,0],
        [0,0,1,1,1,1,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,0,1,1,1,1,0],
        [0,0,0,0,0,0,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,1,0,1,0,1,0],
        [0,0,1,0,1,1,1,0,1,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,1,0,1,0,0,0],
        [0,0,0,0,0,0,1,0,1,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,1,0,0,0,0,0],
        [0,0,0,0,0,0,1,0,1,0,0,0,0,0],

        ]
        
        return board
    }
    
    static func FindStart(_ board : [[Int]]) -> NSPoint{
        for x in 0...board.count - 1{
            for y in 0...board[x].count - 1{
                if(board[x][y] == -1){
                    return NSPoint(x:x, y:y)
                }
            }
        }
        return NSPoint()
    }
    
    static func FindEnd(_ board : [[Int]]) -> NSPoint{
        for x in 0...board.count - 1{
            for y in 0...board[x].count - 1{
                if(board[x][y] == -2){
                    return NSPoint(x:x, y:y)
                }
            }
        }
        
        return NSPoint()
    }
}
