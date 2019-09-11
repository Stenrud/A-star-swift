//
//  Generator.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Foundation

let a = [
    "Task1" : "Samfundet_map_1",
    "Task2" : "Samfundet_map_1",
    "Task3" : "Samfundet_map_2",
    "Task4" : "Samfundet_map_Edgar_full",
    "Task5" : "Samfundet_map_2",
]

let startPos = [
    "Task1" : CGPoint(x:27, y:18),
    "Task2" : CGPoint(x:40, y:32),
    "Task3" : CGPoint(x:28, y:32),
    "Task4" : CGPoint(x:28, y:32),
    "Task5" : CGPoint(x:14, y:18)
]

let endPos = [
    "Task1" : CGPoint(x:40, y:32),
    "Task2" : CGPoint(x:8, y:5),
    "Task3" : CGPoint(x:6, y:32),
    "Task4" : CGPoint(x:6, y:32),
    "Task5" : CGPoint(x:6, y:32)
]

class Generator{

    static func  GenerateBoard2 (file: String) -> [[Character]]{
        
        let path = Bundle.main.path(forResource: file, ofType: "csv")
        
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
    
    static func  GenerateBoardFromCsv (task: String) -> Maze{
        
        let path = Bundle.main.path(forResource: a[task], ofType: "csv")
        
        var data = ""
        do{
            data = try String(contentsOfFile: path!)
        } catch{}
        
        print(data)
        
        let board = data.components(separatedBy: "\u{000A}")
            .filter{$0.count > 0}
            .map {$0.components(separatedBy: ",")
            .map{Int($0)!}}
        
        var arr = [[Int]](repeating: [Int](repeating: 0, count: board.count), count: board[0].count)

        for (indexX, row) in board.enumerated(){
            for(indexY, value) in row.enumerated(){
                arr[indexY][arr[indexY].count - 1 - indexX] = value
            }
        }

        print(board)
        let start = transform(startPos[task]!, board)
        let end = transform(endPos[task]!, board)
        
        if(task == "Task5"){
            return Maze(board: arr, start_pos: start, end_pos: end, goal_end_pos: transform(CGPoint(x:6, y:7), board))
        }
        
        return Maze(board: arr, start_pos: start, end_pos: end)
    }
    
    static func transform(_ point: CGPoint, _ board :[[Int]]) -> CGPoint{
        let x = point.y
        let y = CGFloat(board.count) - CGFloat(1) - point.x
        
        return CGPoint(x: x, y: y)
    }
    
    static func GetFiles() -> [String]{
        return [
//            "board-1-1",
//            "board-1-2",
//            "board-1-3",
//            "board-1-4",
//            "board-2-1",
//            "board-2-2",
//            "board-2-3",
//            "board-2-4",
            "Task1",
            "Task2",
            "Task3",
            "Task4",
            "Task5"
            ]
        
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
