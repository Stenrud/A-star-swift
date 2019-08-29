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
    
    func loadAStar(_ algo: AStarInstance){
        self.algo = algo;
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        guard let aStar = algo else{
            return
        }
        let map = aStar.board
        
        let pixelSize = min(bounds.width / CGFloat(map.count), bounds.height / CGFloat(map[0].count))
        
        let offsetX = bounds.width / 2.0 - CGFloat(map.count) * pixelSize / 2
        let offsetY = bounds.height / 2.0 - CGFloat(map[0].count) * pixelSize / 2
        
        for x in 0...map.count - 1{
            
            for y in 0...map[x].count - 1{
                
                numberToColor[String(map[x][y])]?.setFill()
                NSRect(x: CGFloat(x)*pixelSize + offsetX, y: CGFloat(y)*pixelSize + offsetY, width: pixelSize, height: pixelSize).fill()
                
            }
        }
        
        func drawRect(x: CGFloat, y:CGFloat, size: CGFloat){
            
            let pixelOffset = pixelSize * (1 - size)
            
            NSRect(x: offsetX + x * pixelSize + pixelOffset / 2, y: offsetY + y * pixelSize + pixelOffset / 2, width: pixelSize - pixelOffset, height: pixelSize - pixelOffset).fill()
        }
        
        NSColor.green.setFill()
        for point in aStar.open{
            //NSRect(x: offsetX + (point.point.x * pixelSize) + 5, y: offsetY + (point.point.y * pixelSize) + 5, width: pixelSize - 10, height: pixelSize - 10).fill()
            drawRect(x: point.point.x, y: point.point.y, size: 0.5)
        }
        
        NSColor.red.setFill()
        for point in aStar.closed{
            //NSRect(x: offsetX + (point.point.x * pixelSize) + 5, y: offsetY + (point.point.y * pixelSize) + 5, width: pixelSize - 10, height: pixelSize - 10).fill()
            drawRect(x: point.point.x, y: point.point.y, size: 0.5)
        }
        
        NSColor.yellow.setFill()
        for point in aStar.solution{
            //NSRect(x: offsetX + point.x * pixelSize, y: offsetY + point.y * pixelSize, width: pixelSize, height: pixelSize).fill()
            
            drawRect(x: point.x, y: point.y, size: 0.5)
        }
        
        
        //NSColor.white.setFill()
        //dirtyRect.fill()
    }
    
    
}
