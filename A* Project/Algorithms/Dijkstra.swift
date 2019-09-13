//
//  AStartInstance.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa


class Dijkstra: SearchAlgorithm {
    
    
    override init(board: Maze) {
        super.init(board: board)
    }
    
    override func step() -> Bool{
        if(open.isEmpty || !solution.isEmpty){
            return false
        }
        
        let current_node = open.removeFirst()
        
        closed.append(current_node)
        
        if (current_node.point == endPos){
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
            let childX = Int(current_node.point.x) + new_position.0
            let childY = Int(current_node.point.y) + new_position.1
            
            if(childX > maze.width - 1 || childX < 0 || childY > maze.height - 1 || childY < 0){
                continue
            }
            
            if(maze.board[childX][childY] == -1){
                continue
            }
            
            children.append(NSPoint(x:childX, y:childY))
        }
        
        for child in children{
            
            if(closed.contains(where: {x -> Bool in x.point == child })){
                continue
            }
            
            let g = current_node.g + maze.board[Int(child.x)][Int(child.y)]

            let i = open.firstIndex { open_node -> Bool in open_node.point == child}
            
            let childNode = Node(current_node, child, g: g)
            
            // replace if node already exist, otherwise add to the back
            if let index = i {
                if(g < open[index].g){
                    open[index] = childNode
                }
            }else{
                let i = open.firstIndex { open_node -> Bool in open_node.f >= childNode.f }
                if let index = i {
                    open.insert(childNode, at: index)
                }
                else{
                    open.append(childNode)
                }
            }
            
        }
        return true
    }
    
    override func execute() -> Bool{
        
        while step() {}
        
        return !solution.isEmpty
    }
}
