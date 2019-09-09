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
    
    var g = 0
    var h = 0
    var f = 0
    
    init(_ parent: Node?, _ point :NSPoint){
        self.parent = parent
        self.point = point
    }
    
}
