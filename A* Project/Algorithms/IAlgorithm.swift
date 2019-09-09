//
//  IAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

protocol IAlgorithm {
    var maze:Maze { get }
    var open: [Node] { get }
    var closed: [Node] { get }
    var solution: [NSPoint] { get }
    
    func loadNewBoard(maze: Maze)
    func reset()
    func step() -> Bool
    func execute() -> Bool
    func set(_:Int, _:Int, _:Int)
}
