//
//  Node.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Foundation


class Node
{
    let parent : Node?
    let point : NSPoint
    
    let g: Int
    let h: Int
    let f: Int
    
    init(_ parent: Node?, _ point :NSPoint, g: Int, h:Int = 0){
        self.parent = parent
        self.point = point
        self.g = g
        self.h = h
        f = g + h
    }
    
}
