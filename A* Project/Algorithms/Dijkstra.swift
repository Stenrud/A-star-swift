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
        
        var current_node = open[0]
        var current_index = 0
        
        for (i, item) in open.enumerated(){
            if(item.g < current_node.g){
                current_node = item
                current_index = i
            }
        }
        
        open.remove(at: current_index)
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
        
        var children : [Node] = []
        //        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]{
        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0)]{
            let nodeX = Int(current_node.point.x) + new_position.0
            let nodeY = Int(current_node.point.y) + new_position.1
            
            if(nodeX > maze.board.count - 1 || nodeX < 0 || nodeY > maze.board[nodeX].count - 1 || nodeY < 0){
                continue
            }
            
            if(maze.board[nodeX][nodeY] == -1){
                continue
            }
            
            let new_node = Node(current_node, NSPoint(x:nodeX, y:nodeY))
            
            children.append(new_node)
        }
        
        for child in children{
            
            if(closed.contains(where: {x -> Bool in x.point == child.point })){
                continue
            }
            
            child.g = current_node.g + maze.board[Int(child.point.x)][Int(child.point.y)]
            
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
    
    override func execute() -> Bool{
        
        while step() {}
        
        return !solution.isEmpty
    }
}
