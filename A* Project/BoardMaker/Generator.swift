//
//  Generator.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Foundation

class Generator{

    static func  GenerateBoard2 (file: String) -> [[Character]]{
        
        let path = Bundle.main.path(forResource: file, ofType: "txt")
        
        var data = ""
        do{
            data = try String(contentsOfFile: path!)
        } catch{}
        
        print(data)

        let board = data.split(separator: "\u{000A}").map {Array($0)}
        
        var arr = [[Character]](repeating: [Character](repeating: "0", count: board.count), count: board[0].count)
        
        for (indexX, row) in board.enumerated(){
            for(indexY, value) in row.enumerated(){
                arr[indexY][arr[indexY].count - 1 - indexX] = value
            }
        }
        
        return arr
    }
    
    static func FindStart(_ board : [[Character]]) -> NSPoint{
        for x in 0...board.count - 1{
            for y in 0...board[x].count - 1{
                if(board[x][y] == "A"){
                    return NSPoint(x:x, y:y)
                }
            }
        }
        return NSPoint()
    }
    
    static func FindEnd(_ board : [[Character]]) -> NSPoint{
        for x in 0...board.count - 1{
            for y in 0...board[x].count - 1{
                if(board[x][y] == "B"){
                    return NSPoint(x:x, y:y)
                }
            }
        }
        
        return NSPoint()
    }
}
