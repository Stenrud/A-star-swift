//
//  AStartInstance.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa


class AStar: SearchAlgorithm{
    
    override init(board: Maze) {
        super.init(board: board)
    }
    
    // places a childnode in Open, but keeps the list sorted
    fileprivate func placeSortedInOpen(_ childNode: Node) {
        let i = open.firstIndex { open_node -> Bool in open_node.f >= childNode.f }
        if let index = i {
            open.insert(childNode, at: index)
        }
        else{
            open.append(childNode)
        }
    }
    
    
    override func step() -> Bool{
        if(open.isEmpty || !solution.isEmpty){
            // step failed, no more steps to be taken
            return false
        }
        
        // the open nodes are sorted, so we just take the first one to expand
        let current_node = open.removeFirst()
        
        closed.append(current_node)
        
        // check if its the endPoint
        if (current_node.point == endPos){
            var path: [NSPoint] = []
            var current:Node? = current_node
            while (current != nil){
                path.append(current!.point)
                current = current!.parent
            }
            
            solution = path
            
            // returns false because step "failed", no more steps to be taken
            return false
        }
        
        var children : [NSPoint] = []
      //for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, -1), (-1, 1), (1, -1), (1, 1)]{
        for new_position in [(0, -1), (0, 1), (-1, 0), (1, 0)]{
            let childX = Int(current_node.point.x) + new_position.0
            let childY = Int(current_node.point.y) + new_position.1
            
            // checks that the coordinates are within bounds
            if(childX > maze.width - 1 || childX < 0 || childY > maze.height - 1 || childY < 0){
                continue
            }
            
            // checks that its not an obstacle
            if(maze.board[childX][childY] == -1){
                continue
            }
            
            let child = NSPoint(x: childX, y: childY)
            
            // checks if child is already closed
            if(closed.contains(where: {x -> Bool in x.point == child })){
                continue
            }
            
            children.append(child)
        }
        
        for child in children{
            
            let g = current_node.g + maze.board[Int(child.x)][Int(child.y)]
            
            var difX = abs(child.x - endPos.x)
            let difY = abs(child.y - endPos.y)
            
            // for task 5, do extra calculations for moving target
            if let dest = maze.goal_end_pos {
                let hCandidate = difX + difY
                let futureX = max(endPos.x - hCandidate / 4, dest.x)
                difX = abs(child.x - futureX)
            }
            let h =  Int(difX + difY)
            
            let i = open.firstIndex { open_node -> Bool in open_node.point == child}
            
            let childNode = Node(current_node, child, g: g, h: h)
            
            // if node is already in open, remove and replace in a sorted order, if not, just add in sorted order
            if let index = i {
                if(g < open[index].g){
                    open.remove(at: index)
                    placeSortedInOpen(childNode)
                }
            }else{
                placeSortedInOpen(childNode)
            }
            
        }
        return true
    }
    
    // runs until solution is found/not found
    override func execute() -> Bool{
        
        while step() {}
        
        return !solution.isEmpty
    }
}
