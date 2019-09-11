//
//  IAlgorithm.swift
//  A* Project
//
//  Created by Truls Stenrud on 03/09/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

protocol IAlgorithm {
    var open: [Node] { get }
    var closed: [Node] { get }
    var solution: [NSPoint] { get }
    var startPos : NSPoint { get }
    var endPos : NSPoint { get }
    var boardHeight : Int { get }
    var boardWidth : Int { get }
    
    func processTarget()
    func loadNewBoard(maze: Maze)
    func reset()
    func step() -> Bool
    func execute() -> Bool
    func set(_:Int, _:Int, _:Int)
    func get(_:Int, _:Int)  -> Int
}
