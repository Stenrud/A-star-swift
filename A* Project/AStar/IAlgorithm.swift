//
//  IAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

protocol IAlgorithm {
    var board:[[Character]] { get set}
    var open: [Node] { get }
    var closed: [Node] { get }
    var solution: [NSPoint] { get }
    
    func loadNewBoard(board: [[Character]])
    func reset()
    func step() -> Bool
    func execute() -> Bool
}
