//
//  AStartInstance.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa


class AStarInstance{
    
    var board:[[Int]]
    var start: NSPoint
    var end: NSPoint
    var start_node: Node
    var end_node: Node
    
    var open: [Node] = []
    var closed: [Node] = []
    
    
    init(board: [[Int]], start: NSPoint, end: NSPoint) {
        self.board = board
        self.start = start
        self.end = end
        start_node = Node(nil, start)
        end_node = Node(nil, end)
        open.append(start_node)
    }
    
    
    func step() -> [NSPoint]?{
        if(open.isEmpty){
            return nil
        }

        var current_node = open[0]
        var current_index = 0
        
        for i in 0...open.count - 1{
            let item = open[i]
            
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
            return path
        }
        
        var children : [Node] = []
        
        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]{
            let nodeX = Int(current_node.point.x) + new_position.0
            let nodeY = Int(current_node.point.y) + new_position.1
            
            if(nodeX > board.count - 1 || nodeX < 0 || nodeY > board[nodeX].count - 1 || nodeY < 0){
                continue
            }
            
            if(board[nodeX][nodeY] != 0){
                continue
            }
            
            let new_node = Node(current_node, NSPoint(x:nodeX, y:nodeY))
            
            children.append(new_node)
        }
        
        for child in children{
            
            if(closed.contains(where: {x -> Bool in
                return x.point == child.point
            })){
                continue
            }
            /*
             for closed_child in closed{
             if(child.point == closed_child.point){
             continue
             }*/
            
            child.g = current_node.g + 1
            let a = pow(child.point.x - end_node.point.x, 2.0)
            let b = pow(child.point.y - end_node.point.y, 2.0)
            child.h =  Int(a + b)
            child.f = child.g + child.h
            
            /*
             for open_node in open{
             if(child.point == open_node.point && child.g > open_node.g){
             continue
             }
             }*/
            
            if(open.contains(where: { x -> Bool in
                return x.point == child.point
            }))
                
            {
                continue
            }
            open.append(child)
        }
        return nil
    }
    
    func execute() -> [NSPoint]{
        while open.count > 0 {
            var current_node = open[0]
            var current_index = 0
            
            for i in 0...open.count - 1{
                let item = open[i]
                
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
                return path
            }
            
            var children : [Node] = []
            
            for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]{
                let nodeX = Int(current_node.point.x) + new_position.0
                let nodeY = Int(current_node.point.y) + new_position.1
                
                if(nodeX > board.count - 1 || nodeX < 0 || nodeY > board[nodeX].count - 1 || nodeY < 0){
                    continue
                }
                
                if(board[nodeX][nodeY] != 0){
                    continue
                }
                
                let new_node = Node(current_node, NSPoint(x:nodeX, y:nodeY))
                
                children.append(new_node)
            }
            
            for child in children{
                
                if(closed.contains(where: {x -> Bool in
                    return x.point == child.point
                })){
                    continue
                }
                /*
                 for closed_child in closed{
                 if(child.point == closed_child.point){
                 continue
                 }*/
                
                child.g = current_node.g + 1
                let a = pow(child.point.x - end_node.point.x, 2.0)
                let b = pow(child.point.y - end_node.point.y, 2.0)
                child.h =  Int(a + b)
                child.f = child.g + child.h
                
                /*
                 for open_node in open{
                 if(child.point == open_node.point && child.g > open_node.g){
                 continue
                 }
                 }*/
                
                if(open.contains(where: { x -> Bool in
                    return x.point == child.point
                }))
                    
                {
                    continue
                }
                open.append(child)
            }
        }
        return []
    }

    
}
