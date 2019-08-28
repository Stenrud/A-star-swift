//
//  GraphivsView.swift
//  A* Project
//
//  Created by Truls Stenrud on 27/08/2019.
//  Copyright © 2019 Truls Stenrud. All rights reserved.
//

import Cocoa

var number = 1

class GraphicsView : NSView{
    
    var map: [[Character]] = []
    var solution: [NSPoint] = []
    var algo: AStarInstance?
    
    var numberToColor = [
        "#" : NSColor.black,
        "A" : NSColor.yellow,
        "B" : NSColor.yellow,
        "." : NSColor.white,
        "r" : NSColor.brown,
        "g" : NSColor.green,
        "f" : NSColor.orange,
        "m" : NSColor.gray,
        "w" : NSColor.blue
    ]
    
    func loadMap(_ map: [[Character]]){
        
        if map.isEmpty{
            print("tried to set empty map")
        }
        
        self.map = map
    }
    
    func loadAStar(_ algo: AStarInstance){
        self.algo = algo;
    }
    
    func presentSolution (_ solution : [NSPoint]){
        self.solution = solution
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        if map.isEmpty{
            return
        }
        
        let pixelWidth = bounds.width / CGFloat(map.count)
        let pixelHeight = bounds.height / CGFloat(map[0].count)
        
        for x in 0...map.count - 1{
            
            for y in 0...map[x].count - 1{
                
                numberToColor[String(map[x][y])]?.setFill()
                NSRect(x: CGFloat(x)*pixelWidth, y: CGFloat(y)*pixelHeight, width: pixelWidth, height: pixelHeight).fill()
                
            }
        }
        
        NSColor.green.setFill()
        for point in algo!.open{
            NSRect(x: (point.point.x * pixelWidth) + 5, y: (point.point.y * pixelHeight) + 5, width: pixelWidth - 10, height: pixelHeight - 10).fill()
        }
        
        NSColor.red.setFill()
        for point in algo!.closed{
            NSRect(x: (point.point.x * pixelWidth) + 5, y: (point.point.y * pixelHeight) + 5, width: pixelWidth - 10, height: pixelHeight - 10).fill()
        }
        
        NSColor.yellow.setFill()
        for point in solution{
            NSRect(x: point.x * pixelWidth, y: point.y * pixelHeight, width: pixelWidth, height: pixelHeight).fill()
        }
        
        //NSColor.white.setFill()
        //dirtyRect.fill()
    }
}
