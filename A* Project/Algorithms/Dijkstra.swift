//
//  AStartInstance.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa


class Dijkstra: SearchAlgorithm {
    
    
    override init(board: [[Int]], start: NSPoint, end: NSPoint) {
        super.init(board: board, start: start, end: end)
    }
    
    override func step() -> Bool{
        if(open.isEmpty || !solution.isEmpty){
            return false
        }
        
        let current_node = open.popLast()!
        
        closed.append(current_node)
        
        if (current_node.point == end){
            var path: [NSPoint] = []
            var current:Node? = current_node
            while (current != nil){
                path.append(current!.point)
                current = current!.parent
            }
            
            solution = path
            
            return false
        }
        
        var children : [NSPoint] = []
        //        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]{
        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0)]{
            let nodeX = Int(current_node.point.x) + new_position.0
            let nodeY = Int(current_node.point.y) + new_position.1
            
            if(nodeX > boardWidth - 1 || nodeX < 0 || nodeY > boardHeight - 1 || nodeY < 0){
                continue
            }
            
            if(board[nodeX][nodeY] == -1){
                continue
            }
            
            let newPoint = NSPoint(x:nodeX, y:nodeY)
            
            if(closed.contains(where: {x -> Bool in x.point == newPoint })){
                continue
            }
            
            children.append(newPoint)
        }
        
        for child in children{
            
            let g = current_node.g + board[Int(child.x)][Int(child.y)]
          
            
            //print(open.map{c -> Int in c.f})
            
            let i = open.lastIndex { node -> Bool in node.point == child }
            
            if let i = i{
                if open[i].g > g{
                    //print("Remove at ", i)
                    open.remove(at: i)
                }
                else{
                    continue
                }
            }
            let newNode = Node(current_node, child, g: g)
            let newI = (open.lastIndex { node -> Bool in node.f >= newNode.f })
            
            if let newI = newI{
                //print("Insert ", newNode.f, " at ", newI + 1)
                open.insert(newNode, at: newI + 1)
            }
            else{
                open.insert(newNode, at: 0)
            }
            
        }
        return true
    }
    
    override func execute() -> Bool{
        
        while step() {}
        
        return !solution.isEmpty
    }
}
