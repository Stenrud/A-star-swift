//
//  AStartInstance.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa


class AStarInstance{
    
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
    
    func step() -> Bool{
        if(open.isEmpty || !solution.isEmpty){
            return false
        }

        var current_node = open[0]
        var current_index = 0
        
        for (i, item) in open.enumerated().reversed(){
            
            if(item.f < current_node.f){
                current_node = item
                current_index = i
            }
        }
        
        open.remove(at: current_index)
        closed.append(current_node)
        
        if (current_node.point == end_node.point){
            var path: [NSPoint] = []
            var current:Node? = current_node
            while (current != nil){
                path.append(current!.point)
                current = current!.parent
            }
            solution = path
            
            return false
        }
        
        var children : [Node] = []
//        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]{
        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0)]{
            let nodeX = Int(current_node.point.x) + new_position.0
            let nodeY = Int(current_node.point.y) + new_position.1
            
            if(nodeX > board.count - 1 || nodeX < 0 || nodeY > board[nodeX].count - 1 || nodeY < 0){
                continue
            }
            
            if(board[nodeX][nodeY] == "#"){
                continue
            }
            
            let new_node = Node(current_node, NSPoint(x:nodeX, y:nodeY))
            
            children.append(new_node)
        }
        
        for child in children{
            
            if(closed.contains(where: {x -> Bool in x.point == child.point })){
                continue
            }
            
            child.g = current_node.g + convert(board[Int(child.point.x)][Int(child.point.y)])
            let a = abs(child.point.x - end_node.point.x)
            let b = abs(child.point.y - end_node.point.y)
            child.h =  Int(a + b)
            child.f = child.g + child.h
            
            for (i, open_cell) in open.enumerated(){
                if(open_cell.point == child.point){
                    if(open_cell.g > child.g){
                        open[i] = child
                    }
                    break
                }
            }
            
            let i = open.firstIndex { open_node -> Bool in open_node.point == child.point}
            
            if let index = i{
                if(child.g < open[index].g){
                    open[index] = child
                }
            }else{
                open.append(child)
            }
            
        }
        return true
    }
    
    func execute() -> Bool{
        
        while step() {}
        
        return !solution.isEmpty
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
}
